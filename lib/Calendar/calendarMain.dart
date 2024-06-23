import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_calendar_pc/main.dart';
import '../style.dart' as style;
import '../../findGanji.dart' as findGanji;
import 'mainCalendarInquireResult.dart' as mainCalendarInquireResult;
import '../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import '../CalendarResult/calendarResultBirthTextWidget.dart' as calendarResultBirthTextWidget;  //이름과 생년월일
import 'MainCalendarChange/mainCalendarChange.dart' as mainCalendarChange;
import 'MainCalendarSaveList/mainCalendarSaveList.dart' as mainCalendarSaveList;
import 'mainCalendarRecentList.dart' as mainCalendarRecentList;
import 'package:provider/provider.dart';
import 'MainCalendarSaveList/mainCalendarSaveListOption.dart' as mainCalendarSaveListOption;

class CalendarMain extends StatefulWidget {
  const CalendarMain({super.key, required this.isEditSetting, required this.pageNum, required this.saveSuccess, required this.loadSuccess, required this.getNowPageNum,
    required this.setNowPageName, required this.setSideOptionLayerWidget, required this.setSideOptionWidget, required this.refreshMapPersonLengthAndSort,
    required this.refreshMapRecentPersonLength, required this.refreshListMapGroupLength, required this.refreshGroupName, required this.setGroupMemoWidget, required this.getGroupTempMemo, required this.setGroupSaveDateAfterSave});

  final bool isEditSetting;
  final int pageNum;
  final saveSuccess, loadSuccess;
  final getNowPageNum;
  final setNowPageName;
  final setSideOptionLayerWidget, setSideOptionWidget;
  final refreshMapPersonLengthAndSort, refreshMapRecentPersonLength, refreshListMapGroupLength, refreshGroupName;
  final setGroupMemoWidget, getGroupTempMemo, setGroupSaveDateAfterSave;

  @override
  State<CalendarMain> createState() => _CalendarMainState();
}

class _CalendarMainState extends State<CalendarMain> {
  List<Map> listKey = [];

  int unlimitedCalendarNum = 1; //달력 번호 무제한으로 매기는 변수

  List<Widget> listCalendarWidget = [];

  ScrollController pageRowController = ScrollController();

  bool isEditSetting = false;
  bool isEditWorldGroupMemo = false;

  Offset? newCalendarOffset;

  TextEditingController pageNameController = TextEditingController();

  ShowDialogMessage(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      //barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  ShowSnackBar(String text){
    SnackBar snackBar = SnackBar(
      content: Text(text, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
      backgroundColor: style.colorMainBlue,//Colors.white,
      //style.colorMainBlue,
      shape: StadiumBorder(),
      duration: Duration(milliseconds: style.snackBarDuration),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: 20,
          left: (MediaQuery.of(context).size.width - style.UIButtonWidth) * 0.5,
          right: (MediaQuery.of(context).size.width - style.UIButtonWidth) * 0.5),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  AddCalendarWidget(bool isLeft, dynamic listGroupMap){  //위젯 추가
    if(listKey.length == 8){
      ShowSnackBar('만세력은 최대 8개까지만\n동시에 사용할 수 있습니다');
    } else {
      setState(() {
        Map mapNumAndKey = {'widgetNum': unlimitedCalendarNum, 'globalKey': GlobalKey<_CalendarWidget>()};
        if (isLeft == true) {
          //왼쪽 추가
          listKey.add(mapNumAndKey);
          listCalendarWidget.insert(0, CalendarWidget(key: mapNumAndKey['globalKey'], closeWidget: CloseCalendarWidget, widgetNum: mapNumAndKey['widgetNum'], nowWidgetCount: listKey.length - 1,
                  isEditSetting: isEditSetting, getCalendarWidgetCount: GetCalendarWidgetCount, loadPersonData: listGroupMap, setSideOptionLayerWidget: widget.setSideOptionLayerWidget,
              setSideOptionWidget: widget.setSideOptionWidget, refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort, refreshMapRecentPersonLength: widget.refreshMapRecentPersonLength,
              ));
        } else {
          //오른쪽 추가
          listKey.add(mapNumAndKey);
          listCalendarWidget.add(CalendarWidget( key: mapNumAndKey['globalKey'], closeWidget: CloseCalendarWidget, widgetNum: mapNumAndKey['widgetNum'], nowWidgetCount: listKey.length - 1,
              isEditSetting: isEditSetting, getCalendarWidgetCount: GetCalendarWidgetCount, loadPersonData: listGroupMap, setSideOptionLayerWidget: widget.setSideOptionLayerWidget,
              setSideOptionWidget: widget.setSideOptionWidget, refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort, refreshMapRecentPersonLength: widget.refreshMapRecentPersonLength,
              ));
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            PageScrollToEdge(false);
          });
        }
        unlimitedCalendarNum++;
        for (int i = 0; i < listKey.length; i++) {
          listKey[i]['globalKey'].currentState?.SetWidgetWidth(listCalendarWidget.length - 1, fromMain: true);
        }
      });
    }
  }

  int GetCalendarWidgetCount(){
    return (listCalendarWidget.length - 1);
  }

  CloseCalendarWidget(int widgetNum){ //위젯 끄기
    if(listCalendarWidget.length == 1){
      return;
    }

    setState(() {
      for(int i = 0; i < listKey.length; i++){
        if(listKey[i]['widgetNum'] == widgetNum){
          for(int j = 0; j < listCalendarWidget.length; j++){
            if(listCalendarWidget[j].key == listKey[i]['globalKey']){
              listCalendarWidget.removeAt(j);
              listKey.removeAt(i);
              break;
            }
          }
          break;
        }
      }

      for(int i = 0; i < listKey.length; i++){
        listKey[i]['globalKey'].currentState?.SetWidgetWidth(listCalendarWidget.length - 1, fromMain : true);
      }
    });
  }

  PageScrollToEdge(bool isLeft){
    if(isLeft == true) {
      pageRowController.animateTo(
        pageRowController.position.minScrollExtent,
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
      );
    } else {

      pageRowController.animateTo(
        pageRowController.position.maxScrollExtent,
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  bool GroupDataInqureChecker(){
    int listMapGroupIndex = saveDataManager.FindListMapGroupIndex(context.watch<Store>().nowPageName, context.watch<Store>().targetGroupSaveDateTime);
    if(listMapGroupIndex != -1){
      WidgetsBinding.instance!.addPostFrameCallback((_){
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: Text('이미 묶음이 저장되어 있습니다', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall),
            buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0),
            actions: [
              ElevatedButton(
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                  SaveGroupData(coverwrite: true, mapGroupIndex: listMapGroupIndex);
                },
                child: Text('덮어쓰기'),
              ),
              ElevatedButton(
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    SaveGroupData();
                  },
                  child: Text('따로 저장')
              ),
              ElevatedButton(
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.saveSuccess();
                  },
                  child: Text('취소')
              ),
            ],
          ),
        );
      });

      return false;
    } else {
      return true;
    }
  }
  //그룹 저장
  SaveGroupData({bool coverwrite = false, int mapGroupIndex = 0}){
    int targetPersonCount = 0;
    List<Map> listGroupMap = [];
    DateTime groupSaveDate = DateTime.now();
    for(int i = 0; i < listKey.length; i++){
      if(listKey[i]['globalKey'].currentState?.nowState == 1){
        targetPersonCount++;
      }
    }

    pageNameController.text = context.read<Store>().nowPageName;
    DateTime coverwriteDateTime = context.read<Store>().targetGroupSaveDateTime;

    WidgetsBinding.instance!.addPostFrameCallback((_){
      if(targetPersonCount > 1){
        if(coverwrite == true){ //덮어쓰기
          for(int i = 0; i < listKey.length; i++){
            if(listKey[i]['globalKey'].currentState?.nowState == 1){
              listGroupMap.add(listKey[i]['globalKey'].currentState?.ReportPersonData());
              if(listKey[i]['globalKey'].currentState?.nowState == 1 && listGroupMap.last['saveDate'] == DateTime.utc(3000)){
                listGroupMap.last['saveDate'] = groupSaveDate;
                listKey[i]['globalKey'].currentState?.personSaveDate = groupSaveDate;
              }
            }
          }
          listGroupMap.insert(0,{'groupName':context.read<Store>().nowPageName, 'saveDate':coverwriteDateTime, 'memo':saveDataManager.listMapGroup[mapGroupIndex][0]['memo']});
          saveDataManager.listMapGroup[mapGroupIndex] = listGroupMap;
          saveDataManager.SaveGroupFile();
          setState(() {
            context.read<Store>().SetEditWorldGroupPersonCount();
            widget.refreshListMapGroupLength();
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              content: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorBlack),
                      maxLength: 10,
                      cursorColor: style.colorBlack,
                      autofocus: true,
                      controller: pageNameController,
                      onEditingComplete: () {
                        Navigator.of(context).pop();
                        if(widget.getGroupTempMemo() != ''){
                          AskSaveGroupMemo(listGroupMap);
                        } else {
                          String groupName = pageNameController.text;
                          if(groupName == ''){
                            groupName = '이름 없는 묶음';
                          }
                          for(int i = 0; i < listKey.length; i++){
                            if(listKey[i]['globalKey'].currentState?.nowState == 1){
                              listGroupMap.add(listKey[i]['globalKey'].currentState?.ReportPersonData());
                              if(listKey[i]['globalKey'].currentState?.nowState == 1 && listGroupMap.last['saveDate'] == DateTime.utc(3000)){
                                listGroupMap.last['saveDate'] = groupSaveDate;
                                listKey[i]['globalKey'].currentState?.personSaveDate = groupSaveDate;
                              }
                            }
                          }
                          setState(() {
                            widget.setNowPageName(groupName, isFromCalendarMain:true);
                            listGroupMap.insert(0,{'groupName':groupName, 'saveDate':groupSaveDate});
                            saveDataManager.SaveGroupData2(listGroupMap);
                            widget.refreshListMapGroupLength();
                            widget.setGroupSaveDateAfterSave(groupSaveDate);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: '명식 묶음을 저장합니다', labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: style.colorBlack, height: -0.4),
                        hintText: '묶음 이름', hintStyle:  TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorGrey),
                        counterText:'',
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(width:2, color:style.colorDarkGrey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(widget.getGroupTempMemo() !=  ''){
                      AskSaveGroupMemo(listGroupMap);
                    } else {
                      String groupName = pageNameController.text;
                      if(groupName == ''){
                        groupName = '이름 없는 묶음';
                      }
                      for(int i = 0; i < listKey.length; i++){
                        if(listKey[i]['globalKey'].currentState?.nowState == 1){
                          listGroupMap.add(listKey[i]['globalKey'].currentState?.ReportPersonData());
                          if(listKey[i]['globalKey'].currentState?.nowState == 1 && listGroupMap.last['saveDate'] == DateTime.utc(3000)){
                            listGroupMap.last['saveDate'] = groupSaveDate;
                            listKey[i]['globalKey'].currentState?.personSaveDate = groupSaveDate;
                          }
                        }
                      }
                      setState(() {
                        widget.setNowPageName(groupName, isFromCalendarMain:true);
                        listGroupMap.insert(0,{'groupName':groupName, 'saveDate':groupSaveDate});
                        saveDataManager.SaveGroupData2(listGroupMap);
                        widget.refreshListMapGroupLength();
                        widget.setGroupSaveDateAfterSave(groupSaveDate);
                      });
                    }
                  },
                  child: Text('저장'),
                ),
                ElevatedButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소')),
              ],
            ),
          );
        }
      }
      else {
        ShowSnackBar('묶음 저장은 명식이 2개 이상이어야 합니다');
      }
    });
    //저장 후 정리
    widget.saveSuccess();
  }
  //그룹 저장할 때 메모까지 저장하기
  AskSaveGroupMemo(List<Map> listGroupMap){
    WidgetsBinding.instance!.addPostFrameCallback((_){
      showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Text('메모장의 내용을 저장하시겠습니까?', style:TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorBlack)),
        buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0),
        actions: [
          ElevatedButton(
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
            onPressed: () {
              Navigator.of(context).pop();
              String groupName = pageNameController.text;
              if(groupName == ''){
                groupName = '이름 없음';
              }
              widget.setNowPageName(groupName);
              setState(() {
                DateTime groupSaveDate = DateTime.now();
                listGroupMap.insert(0,{'groupName':groupName, 'saveDate':groupSaveDate});
                saveDataManager.SaveGroupData2(listGroupMap, memo: widget.getGroupTempMemo());
                widget.refreshListMapGroupLength();
                widget.setGroupSaveDateAfterSave(groupSaveDate);
              });
            },
            child: Text('네'),
          ),
          ElevatedButton(
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
            onPressed: () {
              Navigator.of(context).pop();
              String groupName = pageNameController.text;
              if(groupName == ''){
                groupName = '이름 없음';
              }
              widget.setNowPageName(groupName);
              setState(() {
                DateTime groupSaveDate = DateTime.now();
                listGroupMap.insert(0,{'groupName':groupName, 'saveDate':groupSaveDate});
                saveDataManager.SaveGroupData2(listGroupMap);
                widget.refreshListMapGroupLength();
                widget.setGroupSaveDateAfterSave(groupSaveDate);
              });
            },
            child: Text('아니오'),
          ),
          ElevatedButton(
              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소')),
        ],
      ),
    );
    });
  }
  //그룹 메모 열기
  SetGroupMemoWidget(){
    List<dynamic> listPerson = [];
    for (int i = 0; i < listKey.length; i++) {
      if (listKey[i]['globalKey'].currentState?.nowState == 1) {
        listPerson.add(listKey[i]['globalKey'].currentState?.ReportPersonData());
      }
    }
    if(listPerson.isNotEmpty) {
      widget.setGroupMemoWidget(listPerson, false);
    }
    isEditWorldGroupMemo = context.watch<Store>().isEditWorldGroupMemo;
  }

  @override
  void initState() {
    super.initState();
    isEditSetting = widget.isEditSetting;
  }

  @override
  void didChangeDependencies(){
    //init 후
    // 그룹 로드라면
    if(context.watch<Store>().targetGroupLoadPageNum == widget.pageNum) {
      List<dynamic> listGroupMap = [];
      listGroupMap = saveDataManager.listMapGroup[context.watch<Store>().targetGroupLoadIndex];

     for (int i = 1; i < listGroupMap.length; i++) {
       if (listKey.length < i) {
         AddCalendarWidget(false, listGroupMap[i]);
       }
     }
      //로드 후 정리
      widget.loadSuccess();
    }
    else {  //초기화라면
      if(listKey.length == 0) {
        AddCalendarWidget(false, {});
      }
    }

    //단일 명식 불러오기 감시 함수
    if(context.watch<Store>().personInquireInfo['targetName'] != '-1234' && widget.pageNum == widget.getNowPageNum()){
      if(listKey.length >= 8){
        context.watch<Store>().ResetPersonInquireInfo();
        WidgetsBinding.instance!.addPostFrameCallback((_){
          ShowSnackBar('만세력은 최대 8개까지만\n동시에 사용할 수 있습니다');
        });
      } else {
        AddCalendarWidget(false, {});
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    setState(() { //설정 바꿈 실시간 반영
      if(isEditSetting != widget.isEditSetting){
        for(int i = 0; i < listKey.length; i++){
          if(listKey[i]['globalKey'].currentState?.nowState == 1){
            listKey[i]['globalKey'].currentState?.SetCalendarResultWidget();
          }
        }
        isEditSetting = widget.isEditSetting;
      }
    });

    //그룹 저장 감시 함수
    if(context.watch<Store>().targetGroupSavePageNum == widget.pageNum){
      if(GroupDataInqureChecker() == true) {
        SaveGroupData();  //그룹 저장
      }
    }

    //그룹 메모 감시 함수
    if(isEditWorldGroupMemo != context.watch<Store>().isEditWorldGroupMemo && context.watch<Store>().targetGroupMemoPageNum == widget.pageNum){  //그룹 메모 변동 시 온오프
      SetGroupMemoWidget();
    } else if(isEditWorldGroupMemo != context.watch<Store>().isEditWorldGroupMemo){
      isEditWorldGroupMemo = context.watch<Store>().isEditWorldGroupMemo;
    }

    return Container(
        height: MediaQuery.of(context).size.height - style.appBarHeight,
        color: style.colorBlack,//colorDarkGrey,
        child:Stack(
          alignment: Alignment.center,
          children: [
            ScrollConfiguration(
              behavior: MyCustomScrollBehavior().copyWith(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                controller: pageRowController,
                child: Row(
                  children: [
                    Container(width:style.marginContainerWidth),  //왼쪽 마진
                   Container(
                     child: Row(children: listCalendarWidget),   //만세력들
                     //width: listCalendarWidget.length * 100,
                     //height: 400,
                     //child: ReorderableListView.builder(
                     //  onReorder: (oldIndex, newIndex){
                     //  },
                     //  itemCount: listCalendarWidget.length,
                     //  itemBuilder: (context, index){
                     //    return ListTile(title: Icon(Icons.ac_unit),key: Key('$index'), trailing: ReorderableDragStartListener(
                     //      index:index, child:listCalendarWidget[index],
                     //    ),);
                     //  },
                     //),
                   ),
                    Container(width:style.marginContainerWidth),  //오른쪽 마진
                  ],//GetWidget(),
                ),
              ),
            ),
            Container(  //위젯 추가 버튼
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - style.appBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 20,
                    height: 40,
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
                        boxShadow: <BoxShadow>[BoxShadow(
                          color: style.colorBlack,
                          blurRadius: 2.0,
                          offset: Offset.zero,
                          blurStyle: BlurStyle.normal,
                          spreadRadius: 0.4,
                        )
                        ]
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        AddCalendarWidget(true, {});
                        PageScrollToEdge(true);
                      },
                      child: Text('+', style: TextStyle(color:Colors.white)),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),backgroundColor: style.colorMainBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius))
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 40,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
                        boxShadow: <BoxShadow>[BoxShadow(
                          color: style.colorBlack,
                          blurRadius: 2.0,
                          offset: Offset.zero,
                          blurStyle: BlurStyle.normal,
                          spreadRadius: 0.4,
                        )
                        ]
                    ),
                    child: ElevatedButton(
                        onPressed: (){
                          AddCalendarWidget(false, {});
                        },
                        child: Text('+', style: TextStyle(color:Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),backgroundColor: style.colorMainBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius))),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}

//마우스로 횡스크롤
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}


//여기부터는 달력 위젯
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key, required this.closeWidget, required this.widgetNum, required this.nowWidgetCount, required this.isEditSetting, required this.getCalendarWidgetCount,
    required this.loadPersonData, required this.setSideOptionLayerWidget, required this.setSideOptionWidget, required this.refreshMapPersonLengthAndSort,
    required this.refreshMapRecentPersonLength,
});

  final int widgetNum, nowWidgetCount;
  final closeWidget;
  final bool isEditSetting;
  final getCalendarWidgetCount;
  final dynamic loadPersonData;
  final setSideOptionLayerWidget, setSideOptionWidget;
  final refreshMapPersonLengthAndSort, refreshMapRecentPersonLength;

  @override
  State<CalendarWidget> createState() => _CalendarWidget();
}

enum Gender { Male, Female, None }

class _CalendarWidget extends State<CalendarWidget> {
  int widgetNum = 0;

  Gender? gender = Gender.None;
  int genderState = 3;

  var popUpVal = ['간지 선택 ▼', '23:30~01:30 子시', '01:30~03:30 丑시', '03:30~05:30 寅시', '05:30~07:30 卯시', '07:30~09:30 辰시', '09:30~11:30 巳시', '11:30~13:30 午시', '13:30~15:30 未시', '15:30~17:30 申시', '17:30~19:30 酉시', '19:30~21:30 戌시', '21:30~23:30 亥시'];
  var popUpSelect = '간지 선택 ▼', popUpSelect0 = '간지 선택 ▼', popUpSelect1 = '간지 선택 ▼';

  ShowDialogMessage(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      //barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  String targetName = '';
  int targetBirthYear = 0;
  int targetBirthMonth = 0;
  int targetBirthDay = 0;
  int targetBirthHour = 0; //시간 모름일 때는 30로 조회한다
  int targetBirthMin = 0;
  int uemYangType = 0; //0: 양력, 1:음력 평달, 2:음력 윤달
  bool isUemryoc = false;

  bool isYundal = false;
  bool genderVal = true;
  bool passVal = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  String seasonMessageDate = ''; //절입시간 안내할 때 중복 방지용 변수

  String infoText = '생년월일 8자를 입력해 주세요(ex. 1987 01 31)\n'
      '태어난 시간을 4자로 입력해 주세요(ex. 07 05)\n'
      '태어난 시간을 모를 경우 빈칸으로 두세요\n'
      '1901년 이전 명식은 절입시간 오차 가능성이 있습니다';

  bool isShowPersonalBirth = true;
  bool isOnFromGroupData = false; //명식 묶음으로 켜지면 true로 바뀌면서 더이상 안 켜지게 함

  SeasonDayMessage() {
    //절입시간이 있는 날인지 알려줌
    if (birthController.text.length == 10 && seasonMessageDate != birthController.text) {
      seasonMessageDate = birthController.text;

      int _year = int.parse(birthController.text.substring(0, 4));
      if (_year < 1901) {
        return;
      }
      int _month = int.parse(birthController.text.substring(5, 7));
      int _day = int.parse(birthController.text.substring(8, 10));

      if (isUemryoc == false) {
        int seasonData = findGanji.listSeasonData[_year - findGanji.stanYear][_month - 1];
        if ((seasonData / 10000).floor() == _day) {
          ShowDialogMessage('양력 ${_year}년 ${_month}월 ${_day}일은\n절입시간(${seasonData.toString().substring(1, 3)}:${seasonData.toString().substring(3, 5)})이 적용되는 날입니다\n생시를 정확히 입력해 주세요');
        }
      } else {
        List<int> listSolBirth = findGanji.LunarToSolar(_year, _month, _day, isYundal);

        int seasonData = findGanji.listSeasonData[listSolBirth[0] - findGanji.stanYear][listSolBirth[1]];

        if ((seasonData / 10000).floor() == listSolBirth[2]) {
          if (isYundal == false) {
            ShowDialogMessage(
                '음력 ${_year}년 ${_month}월 ${_day}일은\n절입시간(${seasonData.toString().substring(1, 3)}:${seasonData.toString().substring(3, 5)})이 적용되는 날입니다\n생시를 정확히 입력해 주세요');
          }
          else{
            ShowDialogMessage(
                '음력 ${_year}년 ${_month}월 ${_day}일은\n절입시간(${seasonData.toString().substring(1, 3)}:${seasonData.toString().substring(3, 5)})이 적용되는 날입니다\n생시를 정확히 입력해 주세요');
          }
        }
      }
    }
  } //절입시간 있는 날 알려줌

  bool BirthDayErrorChecker(int year, int month, int day) {
    //연도
    if (year > 2050) {
      ShowDialogMessage('2050년 이후는 조회할 수 없습니다');
      return false;
    }
    if(year == 2050 && month == 12 && day > 6){
      ShowDialogMessage('2050년 12월 6일 이후는 조회할 수 없습니다');
      return false;
    }
    if (year < 0) {
      ShowDialogMessage('기원전 생일은 조회할 수 없습니다');
      return false;
    }
    if (isUemryoc == true && year < 1901) {
      ShowDialogMessage('음력은 1901년부터 조회할 수 있습니다');
      return false;
    }
    //생월
    if (month < 1 || month > 12) {
      ShowDialogMessage('생월을 정확히 입력해 주세요');
      return false;
    }
    if (isUemryoc == true && isYundal == true) {
      if (findGanji.listLunNday[year - findGanji.stanYear][(month - 1) * 2 + 1] == 0) {
        ShowDialogMessage('음력 ${year}년은 윤${month}월이 없습니다');
        return false;
      }
    }
    //생일
    if (day < 1 || day > 31) {
      ShowDialogMessage('생일을 정확히 입력해 주세요');
      return false;
    }
    if (isUemryoc == false) {
      //양력일 때
      if (day > findGanji.listSolNday[month - 1]) {
        //
        ShowDialogMessage('양력 ${month}월은 ${day}일이 없습니다');
        return false;
      }
    }
    else {
      //음력일 때
      if (isYundal == false && findGanji.listLunNday[year - findGanji.stanYear][(month - 1) * 2] < day) {
        ShowDialogMessage('음력 ${month}월은 ${day}일이 없습니다');
        return false;
      } else if (isYundal == true && findGanji.listLunNday[year - findGanji.stanYear][(month - 1) * 2 + 1] < day) {
        ShowDialogMessage('음력 윤${month}월은 ${day}일이 없습니다');
        return false;
      }
    }

    return true;
  }

  bool BirthHourErrorChecker(int hour, int min) {
    if (hour > 23) {
      ShowDialogMessage('태어난 시간을 정확히 입력해주세요');
      return false;
    }
    if (min > 59) {
      ShowDialogMessage('태어난 분을 정확히 입력해주세요');
      return false;
    }

    return true;
  }

  int GanjiSelect(int targetPopUpSelect) {  // 0: popUpSelect, 1: popUpSelect0, 2: popUpSelect1
    int count = 1;

    String popUpText = '';
    popUpText = popUpSelect;

    while (count < popUpVal.length) {
      if (popUpText == popUpVal[count]) {
        break;
      } else {
        count++;
      }
    }
    return (count - 1) * 2;
  }

  ResetAll(){
    //0:모두, 1:명식1, 2:명식2
    setState(() {
      gender = Gender.None;
      genderState = 3;
      SetGenderRadioButtonColor(gender);
      popUpSelect = '간지 선택 ▼';

      isUemryoc = false;
      isYundal = false;

      nameController.text = '';
      birthController.text = '';
      hourController.text = '';
      gender = Gender.None;
      genderState = 3;

      popUpSelect0 = '간지 선택 ▼';

      targetName = '';
      targetBirthYear = 0;
      targetBirthMonth = 0;
      targetBirthDay = 0;
      targetBirthHour = 0;
      targetBirthMin = 0;
      uemYangType = 0;

      isYundal = false;
      genderVal = true;
      passVal = false;
      memoController.text = '';
    });
  }

  bool InqureChecker(bool isInquire) {
    //조회 전에 입력 잘 했는지 확인 isInquire = false 명식교체,true 조회
    if(nameController.text.length == 0 && gender == Gender.None && birthController.text.length == 0 && hourController.text.length == 0){
      targetName = '오늘';
      genderVal = true;
      uemYangType = 0;
      targetBirthYear = DateTime.now().year;
      targetBirthMonth = DateTime.now().month;
      targetBirthDay = DateTime.now().day;
      targetBirthHour = DateTime.now().hour;
      targetBirthMin = DateTime.now().minute;
      return true;
    }


    if (gender == Gender.None) {
      ShowDialogMessage('성별을 선택해 주세요');
      return false;
    }
    if (birthController.text.length != 10) {
      ShowDialogMessage('생년월일을 모두 입력해 주세요\n형식 : 1987 01 31');
      return false;
    }

    int _targetBirthYear = int.parse(birthController.text.substring(0, 4));
    int _targetBirthMonth = int.parse(birthController.text.substring(5, 7));
    int _targetBirthDay = int.parse(birthController.text.substring(8, 10));

    if (_targetBirthYear < 1901) {
      //아직 1900년 이전은 조회가 안돼요!
      ShowDialogMessage('1901년 이전은 아직 조회가 안됩니다');
      return false;
    }

    if (BirthDayErrorChecker(_targetBirthYear, _targetBirthMonth, _targetBirthDay) == false) {
      return false;
    }

    int _targetBirthHour = 0, _targetBirthMin = 0;
    if (hourController.text.length == 0) {
      //시간모름일 때
      if (popUpSelect == popUpVal[0]) {
        _targetBirthHour = 30; //시간 모름일 때는 30로 정함
        _targetBirthMin = 30; //분도 30로 정함
      }
    } else if (hourController.text.length == 5) {
      _targetBirthHour = int.parse(hourController.text.substring(0, 2));
      _targetBirthMin = int.parse(hourController.text.substring(3, 5));
      if (BirthHourErrorChecker(_targetBirthHour, _targetBirthMin) == false) {
        return false;
      }
    } else {
      ShowDialogMessage('태어난 시간을 정확히 입력해주세요\n형식 : 07 05');
      return false;
    }

    int _uemYangType = 0;
    if (isUemryoc == true) {
      if (isYundal == false) {
        _uemYangType = 1;
      } else {
        _uemYangType = 2;
      }
    }

    bool _genderVal = true;
    if (gender == Gender.Male) {
      _genderVal = true;
    } else {
      _genderVal = false;
    }

    String _targetName = '';
    if (nameController.text == '') {
      _targetName = '이름 없음';
    } else {
      _targetName = nameController.text;
    }

    targetName = _targetName;
    //gender = gender;
    genderVal = _genderVal;
    uemYangType = _uemYangType;
    targetBirthYear = _targetBirthYear;
    targetBirthMonth = _targetBirthMonth;
    targetBirthDay = _targetBirthDay;
    targetBirthHour = _targetBirthHour;
    targetBirthMin = _targetBirthMin;

    if(hourController.text.length == 0 && popUpSelect != popUpVal[0]) {
      targetBirthHour = GanjiSelect(0);
      targetBirthMin = 30;
    }

    return true;
  }

  SetYangrocUemryoc(bool isUemYangryoc, bool onOff){
    if(isUemYangryoc == true){  //음력양력 눌렀을 때
      isUemryoc = onOff;
      if(onOff == true){  //음력 켤 때
        uemYangType = 1;
      } else {
        uemYangType = 0;
        isYundal = false;
      }
    } else {  //윤달 눌렀을 때
      if(onOff == true){
        isUemryoc = true;
      }
      isYundal = onOff;
      uemYangType = 2;
    }
  }

  BoxDecoration? personButtonDeco0, personButtonDeco1; //명식 버튼 박스 데코레이션
  BoxDecoration? personListButtonDeco0, personListButtonDeco1; //명식 버튼 안의 불러오기 버튼 박스 데코레이션
  BoxDecoration selectedPersonBoxDeco = BoxDecoration(
    color: style.colorMainBlue,
    borderRadius: BorderRadius.circular(style.textFiledRadius),
  );
  BoxDecoration noneSelectedPersonBoxDeco = BoxDecoration(
    color: style.colorGrey,
    border: Border.all(color: Colors.white, width: 4),
    borderRadius: BorderRadius.circular(style.textFiledRadius),
  );
  BoxDecoration selectedPersonBoxListButtonDeco = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
  );
  BoxDecoration nonSelectedPersonBoxListButtonDeco = BoxDecoration(
    color: style.colorGrey,
    borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
  );
  Color? personListButtonColor0, personListButtonColor1;

  MaterialStateColor? genderColorMale, genderColorFemale;

  double widgetWidth = 1200;
  int nowWidgetCount = 0;

  Widget closeButtonWidget = SizedBox(width: 50,height: 50,);
  Widget backButtonWidget = SizedBox.shrink();
  Widget saveButtonWidget = SizedBox(width: 50,height: 50,);
  Widget memoButtonWidget = SizedBox(width: 50,height: 50,);
  Widget chooseDayButtonWidget = SizedBox(width: 50,height: 50,);
  Widget calendarResultWidget = SizedBox.shrink();
  Widget calendarBirthTextWidget = SizedBox.shrink();
  Widget calendarMemoWidget = SizedBox.shrink();

  TextEditingController calendarMemoController = TextEditingController();
  double calendarMemoWidgetHeight = 0;
  ScrollController calendarMemoScrollController = ScrollController();
  bool isChangedCalendarMemo = false; //단일 명식에서 메모 변동
  bool isEditWorldCalendarMemo = false;  //프로젝트 전체에서 메모 변동
  bool isEditWorldPersonName = false;

  int nowState = 0; //0:만세력 입력화면, 1:만세력 조회화면
  int prevState = 0;
  bool isEditSetting = false;

  FocusNode maleFocusNode = FocusNode();
  FocusNode femaleFocusNode = FocusNode();
  FocusNode birthTextFocusNode = FocusNode();
  FocusNode birthHourTextFocusNode = FocusNode();

  DateTime personSaveDate = DateTime.utc(3000);
  //String personDataNum = '';

  int nowUnderLine = 0;
  var nowCalendarHeadLine = 0;
  List<Text> listCalendarTexts = [];
  var underLineOpacity = [1.0,0.0,0.0,0.0];
  List<String> calendarHeadLineTitle = ['조회하기', '간지변환', '저장목록', '최근목록'];
  List<Color> listCalendarTextColor = [Colors.white, style.colorGrey, style.colorGrey, style.colorGrey];

  bool isShowChooseDayButtons = false;
  Color chooseDayButtonColor = Colors.white;

  bool isChangeUemYangBirthType = false;

  double appBarHeight = 40;


  //그룹 저장할 때 명식 정보 보냄
  Map ReportPersonData(){
    //Map personData = {'name': targetName, 'gender':genderVal, 'uemYang': uemYangType, 'birthYear':targetBirthYear, 'birthMonth':targetBirthMonth,
    //  'birthDay':targetBirthDay, 'birthHour':targetBirthHour, 'birthMin':targetBirthMin, 'memo':personMemo};

    Map personData = {'name': targetName, 'birthData': saveDataManager.ConvertToBirthData(genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin),
      'saveDate':personSaveDate,
      'memo':calendarMemoController.text};

    return personData;
  }

  //SetMarkIcon(){  //주의! 아이콘 저장 순서 때문에 조건문과 반대로 되어있음
  //  setState(() {
  //      if(personDataNum != ''){
  //        if(saveDataManager.mapPerson[int.parse(personDataNum.substring(1,4))]['mark'] == true){
  //          markIcon = Icons.check_circle_outline;
  //        }
  //        else{
  //          markIcon = Icons.check_circle;
  //        }
  //      }
  //      else{
  //        if(saveDataManager.mapPerson.last['mark'] == true){
  //          markIcon = Icons.check_circle_outline;
  //        }
  //        else{
  //          markIcon = Icons.check_circle;
  //        }
  //      }
  //  });
  //}

  //위젯 가로 크기 정하기
  SetWidgetWidth(int widgetCount, {bool fromMain = false}){
    if(fromMain == true) {
      nowWidgetCount = widgetCount;
    }
    setState(() {
      if (nowWidgetCount == 0) {
        widgetWidth = 450;//960;//MediaQuery.of(context).size.width - 60 - 8; //1200;
      } else {
          widgetWidth = 450;
      }
        //if (nowWidgetCount == 1) {
        //  widgetWidth = 440;//((MediaQuery.of(context).size.width - 60) * 0.5) - 8; //596;
        //} else if (nowWidgetCount == 2) {
        //  widgetWidth = widgetWidth = ((MediaQuery.of(context).size.width - 60) * 0.33333333) - 8; //596;//440; //394.4;
        //} else {
        //  widgetWidth = widgetWidth = ((MediaQuery.of(context).size.width - 60) * 0.25) - 8;//440; //394.4;
        //}

        //if(widgetWidth < 440){
        //  widgetWidth = 440;
        //}

      SetWidgetCloseButton(nowWidgetCount);
      if(prevState == 1 && nowState == 1){
        SetCalendarResultWidget();
    } else {
        prevState = 1;
      }
    });
  }

  //위젯 닫기 버튼 설정
  SetWidgetCloseButton(int widgetCount){
    if(widgetCount == 0){
      closeButtonWidget = SizedBox(width: 50,height: 50,);
    } else {
      closeButtonWidget = Container(
        width: 40,
        height: appBarHeight,
        margin: EdgeInsets.only(top:0, right:4),
        child:
        ElevatedButton(
          onPressed: (){
            widget.closeWidget(widgetNum);
          },
          child: Icon(Icons.close, color: Colors.white),//Text('×', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),Icon(Icons.close),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
        ),
      );
    }
  }

  //뒤로가기 버튼 설정
  SetWidgetBackButton(){
    if(nowState == 0){
      backButtonWidget = SizedBox.shrink();
    } else {
      backButtonWidget = Container(
        width: 40,
        height: appBarHeight,
        margin: EdgeInsets.only(top:0, left:4),
        alignment: Alignment.center,
        child:
        ElevatedButton(
          onPressed: (){
            BackButtonAction();
          },
          child: Icon(Icons.arrow_back, color:Colors.white),//Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
        ),
      );
    }
  }

  //저장 버튼 설정
  SetWidgetSaveButton(){
    if(nowState == 1){
      saveButtonWidget = Container(
        width: 40,
        height: appBarHeight,
        padding: EdgeInsets.only(top:4),
        margin: EdgeInsets.only(top:0),//, right:10),
        child:
        ElevatedButton(
          onPressed: (){
            bool isSamePerson = saveDataManager.SavePersonIsSameChecker(targetName, genderVal==true? '남':'여', uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, ShowSameCheckerMessage);
            if(isSamePerson == true){
              if(personSaveDate == DateTime.utc(3000)) {
                personSaveDate = DateTime.now();
              }
              saveDataManager.SavePersonData2(targetName, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, personSaveDate, calendarMemoController.text);
              widget.refreshMapPersonLengthAndSort();
            }
          },
          child: Icon(Icons.save, color:Colors.white),//Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
        ),
      );
    } else {
      saveButtonWidget = SizedBox(width: 50,height: 50,);
    }
  }

  //메모 버튼 설정
  SetWidgetMemoButton(){
    if(nowState == 1){
      if(calendarMemoWidgetHeight == 0) {
        memoButtonWidget = Container(
          width: 40,
          height: appBarHeight,
          padding: EdgeInsets.only(top: 4),
          margin: EdgeInsets.only(top: 0),
          //, right:10),
          child: ElevatedButton(
            onPressed: () {
              MemoButtonAction();
            },
            child: Icon(Icons.chat, color: Colors.white), //Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
          ),
        );
      } else {
        memoButtonWidget = Container(
          width: 40,
          height: appBarHeight,
          padding: EdgeInsets.only(top: 4),
          margin: EdgeInsets.only(top: 0),
          //, right:10),
          child: ElevatedButton(
            onPressed: () {
              MemoButtonAction();
            },
            child: Icon(Icons.chat, color: style.colorMainBlue), //Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
          ),
        );
      }
    } else {
      memoButtonWidget = SizedBox(width: 50,height: 50,);
      calendarMemoWidget = SizedBox.shrink();
    }
  }

  //메모 버튼 기능
  MemoButtonAction(){
    setState(() {
      calendarMemoWidgetHeight == 0? calendarMemoWidgetHeight = 110 : calendarMemoWidgetHeight = 0;

      if(calendarMemoWidgetHeight == 0){
        calendarMemoWidget = SizedBox.shrink();
      } else {
        calendarMemoWidget = Focus(
          onFocusChange: (focus){
            if(personSaveDate != DateTime.utc(3000) && isChangedCalendarMemo == true) {
              saveDataManager.SavePersonDataMemo2(targetName, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin,
                  personSaveDate, calendarMemoController.text);
              isChangedCalendarMemo = false;
              context.read<Store>().SetEditWorldCalendarMemo();
            }
          },
          child: Container(
            width: (widgetWidth - (style.UIMarginLeft * 2)),
            height: calendarMemoWidgetHeight,
            color: style.colorBackGround,
            child: Container(
              width: (widgetWidth - (style.UIMarginLeft * 2)),
              height: calendarMemoWidgetHeight,
              margin: EdgeInsets.only(top: 4, bottom: 8),
              decoration: BoxDecoration(
                color: style.colorNavy,
                borderRadius: BorderRadius.circular(style.textFiledRadius),
              ),
              child: TextField(
                autofocus: true,
                controller: calendarMemoController,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.white,
                maxLines: null,
                style: Theme.of(context).textTheme.labelLarge,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 10, left: 14, bottom: 10),
                  counterText: "",
                  hintText: '메모',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  isChangedCalendarMemo = true;
                },
              ),
            ),
          ),
        );
      }
      SetWidgetMemoButton();

      calendarResultWidget = mainCalendarInquireResult.MainCalendarInquireResult(
          name: targetName, gender: genderVal, uemYang: uemYangType, birthYear: targetBirthYear, birthMonth: targetBirthMonth,
          birthDay: targetBirthDay, birthHour: targetBirthHour, birthMin: targetBirthMin, saveDate: DateTime.utc(3000), widgetWidth: widgetWidth, isEditSetting: isEditSetting, isShowChooseDayButtons : isShowChooseDayButtons,
          setWidgetCalendarResultBirthTextFromChooseDayMode: SetWidgetCalendarResultBirthTextFromChooseDayMode, setUemYangBirthType: SetUemYangBirthType,
          refreshMapRecentPersonLength: widget.refreshMapRecentPersonLength, calendarMemoWidgetHeight: calendarMemoWidgetHeight);
    });
  }

  //즐겨찾기 버튼 설정
  /*
  SetWidgetMarkButton(){
    if(nowState == 1){
      if(isSaved == 0){
        markButtonWidget = Container(
          width: 40,
          child: AnimatedOpacity(  //즐겨찾기 버튼
            opacity: isSaved == 0? 1.0 : 0.0,
            duration: Duration(milliseconds: 130),
            child: ElevatedButton(
              child: Icon(markIcon, color:Colors.white),
              onPressed: (){
                //SetMarkIcon();
                //saveDataManager.SavePersonMark(personDataNum);
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                  foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
            ),
          ),
        );
      } else {
        markButtonWidget = SizedBox(width: 50,height: 50);
      }
    } else {
      markButtonWidget = SizedBox(width: 50,height: 50);
    }
  }*/

  //택일모드 버튼 설정
  SetWidgetChooseDayButton(){
    if(nowState == 1){
      if(isShowChooseDayButtons == false){
        chooseDayButtonWidget = Container(
          width: 40,
          padding: EdgeInsets.only(top:4),
          child: ElevatedButton(
            child: Icon(Icons.calendar_month, color:Colors.white),
            onPressed: (){
              if(uemYangType != 0){// != 0 || (uemYangType == 0 && isChangeUemYangBirthType == true)){
                ShowDialogMessage('택일 모드는 양력 명식만 가능합니다');
                //ShowDialogMessage('양력 명식으로 전환됩니다');//SetUemYangBirthType();
              } else {
                setState(() {
                  isShowChooseDayButtons = !isShowChooseDayButtons;
                  SetWidgetChooseDayButton();
                  calendarResultWidget = mainCalendarInquireResult.MainCalendarInquireResult(
                      name: targetName, gender: genderVal, uemYang: uemYangType, birthYear: targetBirthYear, birthMonth: targetBirthMonth,
                      birthDay: targetBirthDay, birthHour: targetBirthHour, birthMin: targetBirthMin, saveDate: DateTime.utc(3000), widgetWidth: widgetWidth, isEditSetting: isEditSetting, isShowChooseDayButtons : isShowChooseDayButtons,
                    setWidgetCalendarResultBirthTextFromChooseDayMode: SetWidgetCalendarResultBirthTextFromChooseDayMode, setUemYangBirthType: SetUemYangBirthType,
                    refreshMapRecentPersonLength: widget.refreshMapRecentPersonLength, calendarMemoWidgetHeight: calendarMemoWidgetHeight);
                });
              }
            },
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
          ),
        );
      } else {
        chooseDayButtonWidget = Container(
          width: 40,
          padding: EdgeInsets.only(top:4),
          child: ElevatedButton(
            child: Icon(Icons.calendar_month, color:style.colorMainBlue),
            onPressed: (){
              setState(() {
                isShowChooseDayButtons = !isShowChooseDayButtons;
                SetWidgetChooseDayButton();
                calendarResultWidget = mainCalendarInquireResult.MainCalendarInquireResult(
                    name: targetName, gender: genderVal, uemYang: uemYangType, birthYear: targetBirthYear, birthMonth: targetBirthMonth,
                    birthDay: targetBirthDay, birthHour: targetBirthHour, birthMin: targetBirthMin, saveDate: DateTime.utc(3000), widgetWidth: widgetWidth, isEditSetting: isEditSetting, isShowChooseDayButtons : isShowChooseDayButtons,
                  setWidgetCalendarResultBirthTextFromChooseDayMode: SetWidgetCalendarResultBirthTextFromChooseDayMode, setUemYangBirthType: SetUemYangBirthType,
                    refreshMapRecentPersonLength: widget.refreshMapRecentPersonLength, calendarMemoWidgetHeight: calendarMemoWidgetHeight);
              });
            },
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
          ),
        );
      }
    } else {
      chooseDayButtonWidget = SizedBox(width: 50,height: 50);
    }
  }

  ShowSameCheckerMessage(String birth, String name, bool gender, int uemYangType, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('이미 같은 명식이 저장되어 있습니다\n그래도 저장하시겠습니까?'),
          content: Text(birth, textAlign: TextAlign.center),
          buttonPadding: EdgeInsets.only(left:20, right:20, top:0),
          actions: [
            ElevatedButton(
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                onPressed: (){
                  personSaveDate = DateTime.now();
                  saveDataManager.SavePersonData2(targetName, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, personSaveDate, calendarMemoController.text);
                  Navigator.pop(context);
                },
                child: Text('저장')),
            ElevatedButton(
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('취소')),
          ],
        ));
  }

  //뒤로가기 버튼 기능
  BackButtonAction(){
    if(nowState == 1){  //만세력 조회 화면이면 최초 화면으로 간다
      setState(() {
        nowState = 0;
        calendarResultWidget = SizedBox.shrink();

        //personDataNum = '';
        personSaveDate = DateTime.utc(3000);
        isShowChooseDayButtons = false;
        isChangeUemYangBirthType = false;

        memoController.text = calendarMemoController.text;
        calendarMemoWidgetHeight = 0;

        SetWidgetCalendarResultBirthText();
        SetWidgetSaveButton();
        SetWidgetBackButton();
        //SetWidgetMarkButton();
        SetWidgetChooseDayButton();
        SetWidgetMemoButton();
      });
    }
  }

  //만세력 명식의 이름 위젯 설정
  SetWidgetCalendarResultBirthText(){
    if(nowState == 0){
      calendarBirthTextWidget = SizedBox.shrink();
    } else if(nowState == 1){
      calendarBirthTextWidget = calendarResultBirthTextWidget.CalendarResultBirthTextWidget(
          name: targetName,
          gender: genderVal ? '남' : '여',
          uemYang: uemYangType,
          birthYear: targetBirthYear,
          birthMonth: targetBirthMonth,
          birthDay: targetBirthDay,
          birthHour: targetBirthHour,
          birthMin: targetBirthMin,
          isShowDrawerManOld: 0,
        widgetWidth: widgetWidth,
        isOneWidget: (widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false,
        isEditSetting: isEditSetting,
        setTargetName: SetTargetName,
        setUemYangBirthType: SetUemYangBirthType,
        refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort,
      );//isShowDrawerManOld);
    }
  }

  //택일모드에서 명식 생년월일 수정
  SetWidgetCalendarResultBirthTextFromChooseDayMode(int year, int month, int day, int hour, int min){

    targetBirthYear = year;
    targetBirthMonth = month;
    targetBirthDay = day;
    targetBirthHour = hour;
    targetBirthMin = min;

    setState(() {
      calendarBirthTextWidget = calendarResultBirthTextWidget.CalendarResultBirthTextWidget(
          name: targetName,
          gender: genderVal ? '남' : '여',
          uemYang: 0,
          birthYear: targetBirthYear,
          birthMonth: targetBirthMonth,
          birthDay: targetBirthDay,
          birthHour: targetBirthHour,
          birthMin: targetBirthMin,
          isShowDrawerManOld: 0,
          widgetWidth: widgetWidth,
          isOneWidget: (widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false,
          isEditSetting: isEditSetting,
          setTargetName: SetTargetName,
        setUemYangBirthType: SetUemYangBirthType,
        refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort,
      );
    });
  }

  SetGenderRadioButtonColor(Gender? button) {
    if (button == Gender.Male) {
      genderColorMale = MaterialStateColor.resolveWith((states) => style.colorMainBlue);
      genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorGrey);
    } else if (button == Gender.Female) {
      genderColorMale = MaterialStateColor.resolveWith((states) => style.colorGrey);
      genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorMainBlue);
    } else {
      genderColorMale = MaterialStateColor.resolveWith((states) => style.colorGrey);
      genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorGrey);
    }
  }

  //만세력 조회 화면 생성
  SetCalendarResultWidget(){
    nowState = 1;
    setState(() {
      isEditSetting = !isEditSetting;
      double _widgetWidth = widgetWidth;

      //if(isWithSave == true){
      //  personDataNum = saveDataManager.mapPerson.last['num'];
      //}

      calendarResultWidget = mainCalendarInquireResult.MainCalendarInquireResult(
        name: targetName, gender: genderVal, uemYang: uemYangType, birthYear: targetBirthYear, birthMonth: targetBirthMonth,
        birthDay: targetBirthDay, birthHour: targetBirthHour, birthMin: targetBirthMin, saveDate: personSaveDate, widgetWidth: _widgetWidth, isEditSetting: isEditSetting, isShowChooseDayButtons : isShowChooseDayButtons,
          setWidgetCalendarResultBirthTextFromChooseDayMode: SetWidgetCalendarResultBirthTextFromChooseDayMode, setUemYangBirthType: SetUemYangBirthType,
          refreshMapRecentPersonLength: widget.refreshMapRecentPersonLength, calendarMemoWidgetHeight: calendarMemoWidgetHeight,);
      SetWidgetBackButton();
      SetWidgetSaveButton();
      SetWidgetCalendarResultBirthText();
      SetWidgetChooseDayButton();
      SetWidgetMemoButton();

      //if (personDataNum != '') {
      //  isSaved = 0;
//
      //  if (saveDataManager.mapPerson[int.parse(personDataNum.substring(1, 4))]['mark'] == true) {
      //    markIcon = Icons.check_circle;
      //  } else {
      //    markIcon = Icons.check_circle_outline;
      //  }
      //}
    });
  }

  //다른 위젯에서 조회 정보 입력
  SetInquireInfo(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, DateTime saveDate, String memo){
    targetName = name;
    genderVal = gender;
    uemYangType = uemYang;
    targetBirthYear = birthYear;
    targetBirthMonth = birthMonth;
    targetBirthDay = birthDay;
    targetBirthHour = birthHour;
    targetBirthMin = birthMin;
    personSaveDate = saveDate;
    calendarMemoController.text = memo;
  }

  //명식 이름 변경
  SetTargetName(String name){
    if(personSaveDate != DateTime.utc(3000)){
      saveDataManager.SaveEditedPersonData2(targetName, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, personSaveDate,
        name, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);

      context.read<Store>().SetEditWorldPersonName(targetName, name, saveDataManager.ConvertToBirthData(genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin), personSaveDate);

      SetWidgetCalendarResultBirthText();

      widget.refreshMapRecentPersonLength();
    }

    targetName = name;
  }

  //음력 양력 생일 변경
  SetUemYangBirthType(){
    if(isChangeUemYangBirthType == false){
      if(uemYangType == 0){
        List<int> listUemBirth = findGanji.SolarToLunar(targetBirthYear, targetBirthMonth, targetBirthDay);

        setState(() {
          calendarBirthTextWidget = calendarResultBirthTextWidget.CalendarResultBirthTextWidget(
              name: targetName,
              gender: genderVal ? '남' : '여',
              uemYang: listUemBirth[3] == 0? 1 : 2,
              birthYear: listUemBirth[0],
              birthMonth: listUemBirth[1],
              birthDay: listUemBirth[2],
              birthHour: targetBirthHour,
              birthMin: targetBirthMin,
              isShowDrawerManOld: 0,
              widgetWidth: widgetWidth,
              isOneWidget: (widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false,
              isEditSetting: isEditSetting,
              setTargetName: SetTargetName,
            setUemYangBirthType: SetUemYangBirthType,
            refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort,
          );
        });
      } else {
        List<int> listYangBirth = findGanji.LunarToSolar(targetBirthYear, targetBirthMonth, targetBirthDay, uemYangType == 1? false : true);

        setState(() {
          calendarBirthTextWidget = calendarResultBirthTextWidget.CalendarResultBirthTextWidget(
              name: targetName,
              gender: genderVal ? '남' : '여',
              uemYang: 0,
              birthYear: listYangBirth[0],
              birthMonth: listYangBirth[1],
              birthDay: listYangBirth[2],
              birthHour: targetBirthHour,
              birthMin: targetBirthMin,
              isShowDrawerManOld: 0,
              widgetWidth: widgetWidth,
              isOneWidget: (widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false,
              isEditSetting: isEditSetting,
              setTargetName: SetTargetName,
            setUemYangBirthType: SetUemYangBirthType,
            refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort,
          );
        });
      }
    } else {
      setState(() {
        calendarBirthTextWidget = calendarResultBirthTextWidget.CalendarResultBirthTextWidget(
            name: targetName,
            gender: genderVal ? '남' : '여',
            uemYang: uemYangType,
            birthYear: targetBirthYear,
            birthMonth: targetBirthMonth,
            birthDay: targetBirthDay,
            birthHour: targetBirthHour,
            birthMin: targetBirthMin,
            isShowDrawerManOld: 0,
            widgetWidth: widgetWidth,
            isOneWidget: (widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false,
            isEditSetting: isEditSetting,
            setTargetName: SetTargetName,
            setUemYangBirthType: SetUemYangBirthType,
          refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort,
        );
      });
    }

    isChangeUemYangBirthType = !isChangeUemYangBirthType;
  }

  @override
  void initState() {
    super.initState();
    genderColorMale = MaterialStateColor.resolveWith((states) => style.colorGrey);
    genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorGrey);

    widgetNum = widget.widgetNum;
    nowWidgetCount = widget.getCalendarWidgetCount();
    isEditSetting = widget.isEditSetting;

    calendarMemoController.text = memoController.text;
  }

  @override void didChangeDependencies() {  //initState 끝나고 실행됨

    SetWidgetWidth(widget.nowWidgetCount);

      //그룹 명식 불러오기 처리
      if (widget.loadPersonData.length != 0 && isOnFromGroupData == false) {
        SetInquireInfo(
            widget.loadPersonData['name'],
            ((widget.loadPersonData['birthData'] / 10000000000000) % 10).floor() == 1? true:false,
            ((widget.loadPersonData['birthData'] / 1000000000000) % 10).floor(),
            ((widget.loadPersonData['birthData'] / 100000000) % 10000).floor(),
            ((widget.loadPersonData['birthData'] / 1000000 ) % 100).floor(),
            ((widget.loadPersonData['birthData'] / 10000 ) % 100).floor(),
            ((widget.loadPersonData['birthData'] / 100 ) % 100).floor(),
            widget.loadPersonData['birthData'] % 100,
            widget.loadPersonData['saveDate'],
            widget.loadPersonData['memo']??''
        );
        SetCalendarResultWidget();
        isOnFromGroupData = true;
      } else {}

      //단일 명식 불러오기 처리
      if (context.watch<Store>().personInquireInfo['targetName'] != '-1234') {
        Map personInquireInfo = context.watch<Store>().personInquireInfo;

        targetName = personInquireInfo['targetName'];
        genderVal = personInquireInfo['genderVal'];
        uemYangType = personInquireInfo['uemYangType'];
        targetBirthYear = personInquireInfo['targetBirthYear'];
        targetBirthMonth = personInquireInfo['targetBirthMonth'];
        targetBirthDay = personInquireInfo['targetBirthDay'];
        targetBirthHour = personInquireInfo['targetBirthHour'];
        targetBirthMin = personInquireInfo['targetBirthMin'];
        calendarMemoController.text = personInquireInfo['personMemo'];
        personSaveDate = personInquireInfo['personSaveDate'];

        SetCalendarResultWidget();

        context.watch<Store>().ResetPersonInquireInfo();
      }

    super.didChangeDependencies();
  }

  @override
  void deactivate() { //위젯 꺼질 때 실행됨

    super.deactivate();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    nowWidgetCount = widget.getCalendarWidgetCount();

    if(isEditWorldCalendarMemo != context.watch<Store>().isEditWorldCalendarMemo){  //명식 메모 변동 시 실시간 동기화
      if(personSaveDate != DateTime.utc(3000)){
        int personIndex = saveDataManager.FindMapPersonIndex(targetName, saveDataManager.ConvertToBirthData(genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin), personSaveDate);
        if(personIndex != -1 && calendarMemoController.text != saveDataManager.mapPerson[personIndex]['memo']){
          calendarMemoController.text = saveDataManager.mapPerson[personIndex]['memo'];
        }
        List<List<int>> listGroupPersonIndex = saveDataManager.FindListMapGroupPersonIndex(targetName, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, personSaveDate);
        if(listGroupPersonIndex.isNotEmpty) {
          calendarMemoController.text = saveDataManager.listMapGroup[listGroupPersonIndex[0][0]][listGroupPersonIndex[0][1]]['memo'];
        }
      }
      isEditWorldCalendarMemo = context.watch<Store>().isEditWorldCalendarMemo;
    }
    if(isEditWorldPersonName != context.watch<Store>().isEditWorldPersonName){  //명식 메모 변동 시 실시간 동기화
      if(targetName == context.watch<Store>().personPrevName && personSaveDate == context.watch<Store>().personNameSaveDate &&
          saveDataManager.ConvertToBirthData(genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin) == context.watch<Store>().personBirthData){
        setState(() {
          targetName = context.watch<Store>().personNowName;
          SetWidgetCalendarResultBirthText();
        });
      }
      isEditWorldPersonName = context.watch<Store>().isEditWorldPersonName;
    }

    return Container(
      width: widgetWidth,
      margin: EdgeInsets.only(left:4, right:4, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: style.colorBackGround,
          borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius))
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Stack(
            children: [ //뒤로 버튼과 닫기 버튼
              Container(
                width: widgetWidth,
                height: appBarHeight,
                //color: Colors.yellow,
                padding: EdgeInsets.only(top:4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backButtonWidget, //뒤로가기
                    closeButtonWidget,  //닫기버튼
                  ],
                ),
              ),
              //명식정보와 기능 버튼
              Container(
                width: widgetWidth,
                height: appBarHeight,
                //color: Colors.yellow,
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Container(  //생년월일
                    //  //color:Colors.green,
                    //  width: widgetWidth - 180,
                    //  height: 50,
                    //  margin: EdgeInsets.only(left:50),
                    //  child: calendarBirthTextWidget,
                    //),
                    saveButtonWidget,
                    memoButtonWidget,
                    chooseDayButtonWidget,
                    //Container(  //테스트 버튼
                    //  width:10, height:10, child:ElevatedButton(onPressed: (){}, child:Text('X'),),
                    //),
                    //markButtonWidget,
                    //[
                    //  Container(  //메모 버튼
                    //    width: 40,
                    //    height: appBarHeight,
                    //    padding: EdgeInsets.only(top:4),
                    //    child: AnimatedOpacity( //메모 아이콘
                    //      opacity: isSaved == 0? 1.0 : 0.0,
                    //      duration: Duration(milliseconds: 130),
                    //      child: ElevatedButton(
                    //        child: Icon(Icons.chat, color:Colors.white),
                    //        onPressed: (){
                    //          widget.setSideOptionLayerWidget(true);
                    //          widget.setSideOptionWidget(Container(
                    //            width: style.UIButtonWidth + 30,
                    //            height: MediaQuery.of(context).size.height - style.appBarHeight,
                    //            child: mainCalendarSaveListOption.MainCalendarSaveListOption(name0: targetName, gender0: genderVal, uemYang0: uemYangType,
                    //                birthYear0: targetBirthYear, birthMonth0: targetBirthMonth,
                    //                birthDay0: targetBirthDay, birthHour0: targetBirthHour, birthMin0: targetBirthMin,
                    //                memo:saveDataManager.mapPerson[saveDataManager.FindMapPersonIndex(targetName, saveDataManager.ConvertToBirthData(genderVal, uemYangType, targetBirthYear,
                    //                    targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin), personSaveDate)]['memo']??'', saveDate: personSaveDate,
                    //                closeOption: widget.setSideOptionLayerWidget, goToEditMemo: true, key:UniqueKey()),
                    //          ));
                    //        },
                    //        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                    //            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                    //      ),
                    //    ),
                    //  ),
                    //  saveButtonWidget,
                    //][isSaved], //저장버튼
                    SizedBox(
                      width:42,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children:[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //이름
                    width: style.UIButtonWidth,
                    height: style.fullSizeButtonHeight,
                    margin: EdgeInsets.only(top: 8),//style.UIMarginTopTop),
                    decoration: BoxDecoration(
                      //border: Border.all(color: focusBoxColorNum == 0? style.colorMainBlue:Colors.transparent, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                      color: style.colorNavy,
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Row(
                      children: [
                        Container(
                          //이름 텍스트필드
                          width: style.UIButtonWidth * 0.55, //MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextField(
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.white,
                            maxLength: 10,
                            onEditingComplete:() {
                              FocusScope.of(context).requestFocus(maleFocusNode);
                            },
                            style: Theme.of(context).textTheme.labelLarge,
                            decoration: InputDecoration(counterText: "", border: InputBorder.none, prefix: Text('    '), hintText: '이름', hintStyle: Theme.of(context).textTheme.labelSmall,),
                          ),
                        ),
                        Container(
                          width: style.UIButtonWidth * 0.45,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Radio<Gender>(//남자 버튼
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  value: Gender.Male,
                                  focusNode: maleFocusNode,
                                  groupValue: gender,
                                  fillColor: genderColorMale,
                                  splashRadius: 16,
                                  hoverColor: Colors.white.withOpacity(0.1),
                                  focusColor: Colors.white.withOpacity(0.1),
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      genderState = 0;
                                      gender = value;
                                      SetGenderRadioButtonColor(value);
                                      FocusScope.of(context).requestFocus(birthTextFocusNode);
                                    });
                                  }),
                              Container(
                                padding: EdgeInsets.only(bottom: 4),//style.UIPaddingBottom),
                                margin: EdgeInsets.only(left: 4, right: 4),
                                child: Text("남자 ", style: Theme.of(context).textTheme.labelMedium),
                              ),
                              Radio<Gender>(
                                //여자 버튼
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  value: Gender.Female,
                                  groupValue: gender,
                                  fillColor: genderColorFemale,
                                  focusNode: femaleFocusNode,
                                  splashRadius: 16,
                                  hoverColor: Colors.white.withOpacity(0.1),
                                  focusColor: Colors.white.withOpacity(0.1),
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      genderState = 1;
                                      gender = value;
                                      SetGenderRadioButtonColor(value);
                                      FocusScope.of(context).requestFocus(birthTextFocusNode);
                                    });
                                  }),
                              Container(
                                padding: EdgeInsets.only(bottom: 4),//style.UIPaddingBottom),
                                margin: EdgeInsets.only(right: style.UIMarginLeft, left: 4),
                                child: Text("여자 ", style: Theme.of(context).textTheme.labelMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), //이름
                  Container(
                    //생년월일
                    width: style.UIButtonWidth,
                    height: style.fullSizeButtonHeight,
                    margin: EdgeInsets.only(top: style.UIMarginTop),
                    decoration: BoxDecoration(
                      color: style.colorNavy,
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: style.UIButtonWidth * 0.55, //MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextField(
                            obscureText: isShowPersonalBirth == false? true : false,
                            focusNode: birthTextFocusNode,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: birthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                              BirthSpacer(),
                            ],
                            cursorColor: Colors.white,
                            maxLength: 10,
                            style: Theme.of(context).textTheme.labelLarge,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              prefix: Text('    '),
                              hintText: '생년월일', // (${DateFormat('yyyy MM dd').format(DateTime.now())})',
                              hintStyle: Theme.of(context).textTheme.labelSmall,),
                            onChanged: (text) {
                              setState(() {
                                SeasonDayMessage();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: style.UIButtonWidth * 0.45,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 32,
                                height: 50,
                                child: Checkbox(
                                  value: isUemryoc,
                                  onChanged: (value) {
                                    setState(() {
                                      SetYangrocUemryoc(true, value!);
                                      SeasonDayMessage();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 4),//style.UIPaddingBottom),
                                //margin: EdgeInsets.only(right: marginVal),
                                child: Text("음력 ", style: Theme.of(context).textTheme.labelMedium),
                              ),
                              SizedBox(
                                width: 32,
                                height: 50,
                                child: Checkbox(
                                  value: isYundal,
                                  onChanged: (value) {
                                    setState(() {
                                      SetYangrocUemryoc(false, value!);
                                      SeasonDayMessage();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 4),//style.UIPaddingBottom),
                                margin: EdgeInsets.only(right: style.UIMarginLeft),
                                child: Text("윤달 ", style: Theme.of(context).textTheme.labelMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), //생년월일
                  Container(
                    //시간
                    width: style.UIButtonWidth,
                    height: style.fullSizeButtonHeight,
                    margin: EdgeInsets.only(top: style.UIMarginTop),
                    decoration: BoxDecoration(
                      color: style.colorNavy,
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: style.UIButtonWidth * 0.5,
                          height: 50,
                          child: TextField(
                            focusNode: birthHourTextFocusNode,
                            obscureText: isShowPersonalBirth == false? true : false,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: hourController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                              HourSpacer(),
                            ],
                            cursorColor: Colors.white,
                            maxLength: 5,
                            style: Theme.of(context).textTheme.labelLarge,
                            decoration: InputDecoration(counterText: "", border: InputBorder.none, prefix: Text('    '), hintText: '태어난 시간', hintStyle: Theme.of(context).textTheme.labelSmall,),
                            onEditingComplete: () {
                              if (InqureChecker(true) == true) {
                                SetCalendarResultWidget();
                              }
                            },
                            onChanged: (text) {
                              setState(() {
                                if (popUpSelect != popUpVal[0]) {
                                  popUpSelect = popUpVal[0];
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          //간지 선택 버튼
                          width: style.UIButtonWidth * 0.5,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(bottom: 4),//style.UIPaddingBottom),
                                  margin: EdgeInsets.only(right: style.UIMarginLeft - 6),
                                  child: DropdownButton<String>(
                                      value: popUpSelect,
                                      style: Theme.of(context).textTheme.labelMedium,
                                      menuMaxHeight: MediaQuery.of(context).size.height,
                                      iconSize: 0.0,
                                      underline: SizedBox.shrink(),
                                      dropdownColor: Colors.black, //style.colorMainBlue,//colorBackGround,
                                      items: popUpVal
                                          .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Container(
                                          child: Text(value),
                                          width: style.UIButtonWidth * 0.4, //135
                                          alignment: Alignment.center,
                                        ),
                                      ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          popUpSelect = value as String;
                                          hourController.clear();
                                        });
                                      })),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), //시간
                  ScrollConfiguration(
                    behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: style.UIButtonWidth,
                        height: style.fullSizeButtonHeight * 5,
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        decoration: BoxDecoration(
                          color: style.colorBlack,
                          borderRadius: BorderRadius.circular(style.textFiledRadius),
                        ),
                        child: TextField(
                          //focusNode: birthHourTextFocusNode,
                          obscureText: isShowPersonalBirth == false? true : false,
                          controller: memoController,
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          maxLines: null,
                          style: Theme.of(context).textTheme.labelLarge,
                          decoration:InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(top: 18, left: 14, bottom:18),
                            counterText:"",
                            hintText: '메모',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            border: InputBorder.none,),
                          onChanged: (text) {
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ),
                  ), //메모
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //조회버튼
                        width: style.UIButtonWidth - style.fullSizeButtonHeight - style.UIMarginTop,
                        height: style.fullSizeButtonHeight,
                        margin: EdgeInsets.only(top: style.UIButtonPaddingTop),
                        decoration: BoxDecoration(
                          color: style.colorMainBlue,
                          borderRadius: BorderRadius.circular(style.textFiledRadius),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            '조회',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          onPressed: () {
                            if (InqureChecker(true) == true) {
                              SetCalendarResultWidget();
                              calendarMemoController.text = memoController.text;
                            }

                            return;
                          },
                        ),
                      ),
                      Container(
                        //리셋 버튼
                        width: style.fullSizeButtonHeight,
                        height: style.fullSizeButtonHeight,
                        margin: EdgeInsets.only(left: style.UIMarginLeft, top: style.UIButtonPaddingTop),
                        decoration: BoxDecoration(
                          color: style.colorMainBlue,
                          borderRadius: BorderRadius.circular(style.textFiledRadius),
                        ),
                        child:  ElevatedButton(
                          style:  ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(style.colorMainBlue),
                            padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                            //overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                            elevation: MaterialStatePropertyAll(0),
                          ),
                          child:Icon(Icons.recycling,),
                          onPressed: () {
                            setState(() {
                              ResetAll();
                            });
                          },
                        ),
                      ),
                    ],
                  ), //조회 버튼
                  Container(
                    //단일 조회 안내문
                    width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                    //margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.all(style.UIMarginLeft),
                    //height: style.fullSizeButtonHeight * 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                      //border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      '',//infoText,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  calendarBirthTextWidget,  //생년월일
                  calendarMemoWidget, //메모
                  Container(
                    height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 46 - calendarMemoWidgetHeight,
                      child: calendarResultWidget //팔자
                  ),
                ],
              )
            ]
          ),
        ],
      ),
    );
  }
}

class BirthSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 4 || newValue.selection.baseOffset == 7) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(text: newText, selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}

class HourSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 2) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(text: newText, selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}


/*

                  Container(
                    width: style.UIButtonWidth,
                    height: style.headLineHeight,
                    child: Row(  //헤드라인 글자
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Container(
                            height: style.headLineHeight,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[0])))),
                            child: TextButton(
                                style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                                child:listCalendarTexts[0]
                                , onPressed:(){HeadLineButtonAction(0);})
                        ),
                        Container(
                            height: style.headLineHeight,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[1])))),
                            child:TextButton(
                                style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                                child:listCalendarTexts[1]
                                , onPressed:(){HeadLineButtonAction(1);})
                        ),
                        Container(
                            height: style.headLineHeight,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[2])))),
                            child:TextButton(
                                style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                                child:listCalendarTexts[2]
                                , onPressed:(){HeadLineButtonAction(2);})
                        ),
                        Container(
                            height: style.headLineHeight,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[3])))),
                            child:TextButton(
                                style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                                child:listCalendarTexts[3]
                                , onPressed:(){HeadLineButtonAction(3);})
                        )],
                    ),
                  ),
 */