import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'findGanji.dart' as findGangi;
import 'SaveData/saveDataManager.dart' as saveDataManager;
import 'Settings/personalDataManager.dart' as personalDataManager;
import 'Settings/settingManagerWidget.dart' as settingManagerWidget;
import 'Calendar/MainCalendarSaveList/mainCalendarGroupSaveList.dart' as mainCalendarGroupSaveList;
import 'Calendar/MainCalendarChange/mainCalendarChange.dart' as mainCalendarChange;
import 'Calendar/MainCalendarSaveList/mainCalendarSaveList.dart' as mainCalendarSaveList;
import 'Calendar/mainCalendarRecentList.dart' as mainCalendarRecentList;

import 'package:provider/provider.dart';
import 'bodyWidgetManager.dart' as bodyWidgetManager;
import 'package:window_size/window_size.dart';

class Store extends ChangeNotifier {
  bool isEditSetting = false;
  bool isGroupLoad = false;

  SetEditSetting(){
    isEditSetting = !isEditSetting;
    notifyListeners();
  }

  int targetGroupSavePageNum = -1;
  SetTargetGroupSavePageNum(int num){
    targetGroupSavePageNum = num;
  }

  int targetGroupLoadPageNum = -1;
  SetTargetGroupLoadPageNum(int num){
    targetGroupLoadPageNum = num;
  }

  int targetGroupLoadIndex = -1;
  SetTargetGroupLoadIndex(int num){
    targetGroupLoadIndex = num;
  }

  String nowPageName = '';
  SetNowPageName(String text){
    nowPageName = text;
  }

  Map personInquireInfo = {'targetName':'-1234'};
  SetPersonInquireInfo(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, String memo, String saveDataNum){
    personInquireInfo['targetName'] = name;
    personInquireInfo['genderVal'] = gender;
    personInquireInfo['uemYangType'] = uemYang;
    personInquireInfo['targetBirthYear'] = birthYear;
    personInquireInfo['targetBirthMonth'] = birthMonth;
    personInquireInfo['targetBirthDay'] = birthDay;
    personInquireInfo['targetBirthHour'] = birthHour;
    personInquireInfo['targetBirthMin'] = birthMin;
    personInquireInfo['personMemo'] = memo;
    personInquireInfo['personDataNum'] = saveDataNum;

    notifyListeners();
  }
  ResetPersonInquireInfo(){
    personInquireInfo['targetName'] = '-1234';
  }
}

void main() async {
  //일진일기 달력 초기화
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('루시아 원 만세력');
    //setWindowMaxSize(const Size(max_width, max_height));
    setWindowMinSize(Size(1280, 720));
  }
  runApp(
      ChangeNotifierProvider(
        create: (c) => Store(),
        child: MaterialApp(
          theme: style.theme,
          home : MyApp(),
        ),
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  var appBarTitle = ['  루시아 원 만세력', '  일진일기'];
  int _nowMainTap = 0;  //만세력, 일진일기 구분
  bool _isShowSettingPage = false;

  int nowPageNum = 0;
  double calendarButtonSize = 16;
  double nowCalendarButtonSize = 20;
  List<Color> listCalendarButtonColor = [style.colorMainBlue,Colors.white,Colors.white];
  List<double> listCalendarButtonSize = [20,16,16];

  List<Widget> listPageWidget = [];
  int firstPageCount = 3;
  int limitPageCount = 9;
  int nowPageCount = 3;
  List<Widget> listPageSelectButton = [];
  List<int> listUniquePageNum = [0,1,2];
  List<String> listPageName = ['페이지 1','페이지 2','페이지 3','페이지 4','페이지 5','페이지 6','페이지 7','페이지 8','페이지 9'];
  List<TextEditingController> listPageNameController = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  String nowPageName = '페이지 1';
  int uniquePageNum = 2;

  Widget settingWidget = SizedBox.shrink();
  Widget groupLoadWidget = SizedBox.shrink();

  bool isShowSideLayer = false;
  bool isShowSideOptionLayer = false;

  int nowUnderLine = 0;
  var nowCalendarHeadLine = 0;
  List<Text> listCalendarTexts = [];
  var underLineOpacity = [1.0,0.0,0.0,0.0];
  List<String> calendarHeadLineTitle = ['저장목록', '최근목록', '그룹목록', '간지변환'];
  List<Color> listCalendarTextColor = [Colors.white, style.colorGrey, style.colorGrey, style.colorGrey];

  List<Widget> listSideLayerWidget = [];
  Widget sideOptionLayerWidget = SizedBox.shrink();

  bool isLoadPersonData = false;

  //설정 페이지 온오프
  ShowSettingPage(){
    setState(() {
      _isShowSettingPage = !_isShowSettingPage;
      if(_isShowSettingPage == false){
        SetSettingWidget(false);
      }
    });
  }

  //현재 페이지 이름 저장
  SetNowPageName(String text){
    nowPageName = listPageName[nowPageNum];
    String storeNowPageName = '';
    if(listPageNameController[nowPageNum].text == '') {
      storeNowPageName = nowPageName;
    } else {
      storeNowPageName = listPageNameController[nowPageNum].text;
    }
    context.read<Store>().SetNowPageName(storeNowPageName);
  }

  //현재 페이지 선택
  SetNowCalendarNum(int num){
    if(nowPageNum == num){
      setState(() {
        SetNowPageName(listPageName[nowPageNum]);
      });
      return;
    }
    setState(() {
      listCalendarButtonSize[nowPageNum] = calendarButtonSize;
      listCalendarButtonColor[nowPageNum] = Colors.white;
      nowPageNum = num;
      listCalendarButtonColor[nowPageNum] = style.colorMainBlue;
      listCalendarButtonSize[nowPageNum] = nowCalendarButtonSize;
      SetNowPageName(listPageName[nowPageNum]);
    });
  }

  //페이지 추가
  AddPage(bool isLeft){
    setState(() {
      if(nowPageCount != limitPageCount) {
        uniquePageNum++;
        if(isLeft == true){
          listCalendarButtonColor.insert(0,Colors.white);
          listCalendarButtonSize.insert(0,16);
          listUniquePageNum.insert(0, uniquePageNum);
          listPageWidget.insert(0,bodyWidgetManager.BodyWidgetManager(key: GlobalKey(), pageNum: uniquePageNum, saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum));
          SetNowCalendarNum(nowPageNum + 1);
          for(int i = nowPageCount - 1; i > 0; i--){
            if(listPageNameController[i - 1].text != ''){
              listPageNameController[i].text = listPageNameController[i - 1].text;
              listPageNameController[i - 1].text = '';
            }
          }
          SetNowPageName(listPageName[nowPageNum]);
        } else {
          listCalendarButtonColor.add(Colors.white);
          listCalendarButtonSize.add(16);
          listUniquePageNum.add(uniquePageNum);
          listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key: GlobalKey(), pageNum: uniquePageNum, saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum, ));
        }
        nowPageCount++;
      } else {
        ShowSnackBar('페이지는 9개까지 사용 가능합니다');
      }
    });
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

  //페이지 비우기
  SetClearPageNum(int num){
    if (num == -2) {  //모두 지우기
      setState(() {
        listPageWidget.clear();
        listCalendarButtonColor.clear();
        listCalendarButtonSize.clear();
        listUniquePageNum.clear();
        listCalendarButtonColor = [style.colorMainBlue,Colors.white,Colors.white];
        listCalendarButtonSize = [20,16,16];
        listUniquePageNum = [0,1,2];
        for(int i = 0; i < firstPageCount; i++){
          listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[i], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum));
        }
        nowPageNum = 0;
        nowPageCount = firstPageCount;

        for(int i = 0; i < listPageNameController.length; i++){
          listPageNameController[i].text = '';
        }

        SetNowCalendarNum(0);
        ShowSnackBar('모든 페이지를 비웠습니다');
      });
    } else {
      setState(() {
        listPageWidget.removeAt(num);
        listUniquePageNum.removeAt(num);

        if(nowPageCount == 3){  //페이지 3개뿐일 때
          uniquePageNum++;
          listUniquePageNum.insert(num, uniquePageNum);
          listPageWidget.insert(num,bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[num], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum));
          for(int i = 0; i < 3; i++){
            listPageNameController[i].text = '';
          }
          SetNowPageName(listPageName[num]);
        } else {
          if(num == 0){ //첫번째 페이지 비우기
            SetNowCalendarNum(0);
          } else {
            SetNowCalendarNum(nowPageNum - 1);
          }

          listCalendarButtonColor.removeLast();
          listCalendarButtonSize.removeLast();

          for(int i = num; i < listPageNameController.length - 1; i++){
            listPageNameController[i].text = listPageNameController[i+1].text;
          }
          listPageNameController.last.text = '';
          SetNowPageName(listPageName[num]);
          nowPageCount--;
        }

        ShowSnackBar('현재 페이지를 비웠습니다');
      });
    }
  }

  //설정 위젯 보이기 안보이기
  SetSettingWidget(bool isShow){
    if(isShow == true){
      settingWidget = TapRegion(
        onTapOutside: (click) {
          ShowSettingPage();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 6,
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0.1),
          child: settingManagerWidget.SettingManagerWidget(setSettingPage: ShowSettingPage, reloadSetting: ReloadSetting),
        ),
      );
    } else {
      settingWidget = SizedBox.shrink();
    }
  }

  //설정 바뀜 감시자
  ReloadSetting(){
    setState(() {
      context.read<Store>().SetEditSetting();//isEditSetting = !context.watch<Store>().isEditSetting;
      for(int i = 0; i < 3; i++){
        //  listCalendarKey[i].currentState?.isEditSetting = isEditSetting;
      }
    });
  }

  //그룹 저장 신고 주기
  GroupDataSave(){
    setState(() {
      context.read<Store>().SetTargetGroupSavePageNum(listUniquePageNum[nowPageNum]);
    });
  }
  //그룹 저장 후 정리
  GroupSaveSuccess(){
    context.read<Store>().SetTargetGroupSavePageNum(-1);
  }
  //그룹 불러오기
  GroupDataLoad(int groupIndex){
    if(nowPageCount == limitPageCount){ //최대 페이지
      ShowSnackBar('페이지는 9개까지 사용 가능합니다\n페이지 하나를 비워주세요');
    } else {
      setState(() {
        AddPage(false);
        SetNowCalendarNum(nowPageCount - 1);
        listPageNameController[nowPageNum].text = saveDataManager.listMapGroup[groupIndex].last['groupName'];
        SetNowPageName(saveDataManager.listMapGroup[groupIndex].last['groupName']);
        context.read<Store>().SetTargetGroupLoadIndex(groupIndex);
        context.read<Store>().SetTargetGroupLoadPageNum(uniquePageNum);
      });
    }
  }
  //그룹 불러오기 후 정리
  GroupLoadSuccess(){
    context.read<Store>().SetTargetGroupLoadPageNum(-1);
  }
  //그룸 불러오기 위젯 보이기 안보이기
  SetGroupLoadWidget(bool isShow){
    if(isShow == true){
      groupLoadWidget = TapRegion(
        onTapOutside: (click) {
          setState(() {
            SetGroupLoadWidget(false);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 6,
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0.1),
          child: mainCalendarGroupSaveList.MainCalendarGroupSaveList(groupDataLoad: GroupDataLoad, setGroupLoadWidget: SetGroupLoadWidget),
        ),
      );
    } else {
      setState(() {
        groupLoadWidget = SizedBox.shrink();
      });
    }
  }

  //사이드 레이어 온오프
  SetSideLayerWidget(){
    isShowSideLayer = !isShowSideLayer;
  }
  //현재 보고있는 페이지 번호 전송
  int SendNowPageNum(){
    return listUniquePageNum[nowPageNum];
  }

  //사이드 옵션 레이어 온오프
  SetSideOptionLayerWidget(bool onOff){
    setState(() {
      if(onOff == true){
        isShowSideOptionLayer = true;
      } else {
        isShowSideOptionLayer = false;
        sideOptionLayerWidget = SizedBox.shrink();
      }
    });
  }
  //사이드 옵션 위젯 설정
  SetSideOptionWidget(Widget _widget){
    setState(() {
      sideOptionLayerWidget = _widget;
      rebuildAllChildren(context);
    });
  }

  //헤드라인 눌렀을 때
  HeadLineButtonAction(int buttonNum) {
    setState(() {
      if(buttonNum == nowCalendarHeadLine){
        return;
      }

      listCalendarTexts[nowCalendarHeadLine] = Text(calendarHeadLineTitle[nowCalendarHeadLine], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorGrey));
      listCalendarTexts[buttonNum] = Text(calendarHeadLineTitle[buttonNum], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white));

      underLineOpacity[nowCalendarHeadLine] = 0.0;
      underLineOpacity[buttonNum] = 1.0;

      nowCalendarHeadLine = buttonNum;

      if(buttonNum == 1 || buttonNum == 3){
        SetSideOptionLayerWidget(false);
      }
    });
  }

  //위젯 다시 그리기
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override initState(){
    super.initState();
    findGangi.FindGanjiData();
    saveDataManager.SetFileDirectoryPath();
    personalDataManager.SetFileDirectoryPath();

    for(int i = 0; i < firstPageCount; i++) {
      listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[i], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum));
    }

    saveDataManager.snackBar = ShowSnackBar;

    listCalendarTexts.add(Text(calendarHeadLineTitle[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[0]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[1], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[1]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[2], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[2]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[3], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[3]), ));

  }

  @override
  Widget build(BuildContext context) {

    listSideLayerWidget = [
      Container(
        width: style.UIButtonWidth+2,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarSaveList.MainCalendarSaveList(setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget),
      ),
      Container(
        width: style.UIButtonWidth+2,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarRecentList.MainCalendarRecentList(),
      ),
      Container(
        width: style.UIButtonWidth+2,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarGroupSaveList.MainCalendarGroupSaveList(groupDataLoad: GroupDataLoad, setGroupLoadWidget: SetGroupLoadWidget),
      ),
      Container(
        width: style.UIButtonWidth+2,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarChange.MainCalendarChange(),
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          Container(  //각종 버튼 줄 - 앱바
            width: MediaQuery.of(context).size.width,
            height: style.appBarHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(  //페이지버튼들, 설정 버튼
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(  //페이지 버튼
                      children: [
                        Container(  //묶음(group) 저장
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                GroupDataSave();
                                rebuildAllChildren(context);
                              });
                            },

                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.save, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //묶음(group) 불러오기
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                SetGroupLoadWidget(true);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.save, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //한 페이지 비우기
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              SetClearPageNum(nowPageNum);
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.clear, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //모든 페이지 비우기
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              SetClearPageNum(-2);
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.clear, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //페이지 이름
                          width: 250,
                          height: style.appBarHeight - 14,
                          margin: EdgeInsets.zero,
                          color: Colors.black,
                          padding: EdgeInsets.only(top:0, bottom:0),
                          child: TextField(
                            cursorColor: Colors.white,
                            maxLength: 10,
                            controller: listPageNameController[nowPageNum],
                            style: Theme.of(context).textTheme.headlineSmall,
                            decoration:InputDecoration(
                              contentPadding: EdgeInsets.only(bottom:12),
                                counterText:"",
                                border: InputBorder.none,
                                prefix: Text('   '),
                                hintText: nowPageName,
                                hintStyle: Theme.of(context).textTheme.headlineSmall),
                            onChanged: (value){
                              setState(() {
                                listPageNameController[nowPageNum].text = value;
                                SetNowPageName(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(  //저장목록들, 간지변환 버튼
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(right: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                rebuildAllChildren(context);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.settings, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //저장목록들, 간지변환 버튼
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(right: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                SetSideLayerWidget();
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.settings, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //설정 버튼
                          width: 40,
                          height: style.appBarHeight,
                          margin: EdgeInsets.only(right: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              _isShowSettingPage = !_isShowSettingPage;
                              setState(() {
                                SetSettingWidget(_isShowSettingPage);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                            child: Icon(Icons.settings, size: 20, color:Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(  //페이지 관리 버튼들
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      margin: EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: (){
                          AddPage(true);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Icon(Icons.add_circle, size: 20, color: Colors.white ),
                      ),
                    ),
                    Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(nowPageCount, (i){
                          return Container(
                            width: 20,
                            height: style.appBarHeight,
                            alignment: Alignment.center,
                            child:  ElevatedButton(
                              onPressed: (){
                                SetNowCalendarNum(i);
                              },
                              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                  foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                              child: Icon(Icons.circle, size: listCalendarButtonSize[i], color:listCalendarButtonColor[i]),
                            ),
                          );
                        })
                    ),
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      margin: EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: (){
                          AddPage(false);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Icon(Icons.add_circle, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children:[
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: IndexedStack( //메인 페이지
                      index: nowPageNum,
                      children: listPageWidget,
                    ),
                  ),
                  AnimatedContainer(  //사이드 메모, 정보 위젯
                    duration: Duration(milliseconds: 300),
                    width: isShowSideOptionLayer? style.UIButtonWidth + 40 : 0,
                    height: MediaQuery.of(context).size.height - style.appBarHeight,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255,28,28,28),
                      border: isShowSideOptionLayer? Border(top:BorderSide(color: style.colorBlack, width: 2), left:BorderSide(color: style.colorBlack, width: 2)) : Border.all(color: Colors.transparent, width:0),
                    ),
                    alignment: Alignment.center,
                    curve: Curves.easeOut,
                    child: sideOptionLayerWidget,
                  ),
                  AnimatedContainer(  //사이드 명식 불러오기 위젯
                    duration: Duration(milliseconds: 300),
                      width: isShowSideLayer? style.UIButtonWidth + 40 : 0,
                      height: MediaQuery.of(context).size.height - style.appBarHeight,
                      decoration: BoxDecoration(
                        color: style.colorBackGround,
                        border: isShowSideLayer? Border(top:BorderSide(color: style.colorBlack, width: 2), left:BorderSide(color: style.colorBlack, width: 2)) : Border.all(width:0),
                      ),
                    alignment: Alignment.center,
                    curve: Curves.easeOut,
                    child: AnimatedCrossFade(  //사이드 명식 차일드
                      duration: Duration(milliseconds: 300),
                      firstChild: Column(
                        children: [
                          Container(
                            width: style.UIButtonWidth,
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.only(top: style.UIMarginTop),
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
                          IndexedStack(
                            index: nowCalendarHeadLine,
                            children: listSideLayerWidget,
                          )
                        ],
                      ),
                      secondChild:Container(
                        width:0,
                        height: MediaQuery.of(context).size.height - style.appBarHeight,
                      ),
                      crossFadeState: isShowSideLayer? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      alignment: Alignment.topCenter,
                      firstCurve: Curves.easeOut,
                      secondCurve: Curves.easeOut,
                    )
                    ),
                ],
              ),
              Container(  //설정 위젯
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - style.appBarHeight,
                alignment: Alignment.center,
                child: settingWidget,
              ),
              Container(  //그룹 불러오기 위젯
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - style.appBarHeight,
                alignment: Alignment.center,
                child: groupLoadWidget,
              ),
            ]
          )
          //bodyWidgetManager.BodyWidgetManager(nowMainTap: _nowMainTap, isShowSettingPage: _isShowSettingPage, setSettingPage: ShowSettingPage, nowCalendarNum: nowPageNum, clearPageNum: clearPageNum,
          //setClearPageNum: SetClearPageNum),
        ],
      ),
    );
  }
}


/*
[
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      alignment: Alignment.center,
                      child:  ElevatedButton(
                        onPressed: (){
                          SetNowCalendarNum(0);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.circle, size: listCalendarButtonSize[0], color:listCalendarButtonColor[0]),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      alignment: Alignment.center,
                      child:  ElevatedButton(
                        onPressed: (){
                          SetNowCalendarNum(1);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.circle, size: listCalendarButtonSize[1], color:listCalendarButtonColor[1]),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      alignment: Alignment.center,
                      child:  ElevatedButton(
                        onPressed: (){
                          SetNowCalendarNum(2);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.circle, size: listCalendarButtonSize[2], color:listCalendarButtonColor[2]),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      alignment: Alignment.center,
                      child:  ElevatedButton(
                        onPressed: (){
                          SetNowCalendarNum(3);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.circle, size: listCalendarButtonSize[3], color:listCalendarButtonColor[3]),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: style.appBarHeight,
                      alignment: Alignment.center,
                      child:  ElevatedButton(
                        onPressed: (){
                          SetNowCalendarNum(4);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.circle, size: listCalendarButtonSize[4], color:listCalendarButtonColor[4]),
                      ),
                    ),
                  ]
                  */




//appBar: AppBar(
//  toolbarHeight: style.appBarHeight,
//  //centerTitle: true,
//  title: Transform(
//    transform: Matrix4.translationValues(0.0, 0.0, 0.0),
//    child: Text(appBarTitle[_nowMainTap]),
//  ),
//  actions: [
//    Container(
//      width: 40,
//      height: 40,
//      margin: EdgeInsets.only(right: 20),
//      child: ElevatedButton(
//        onPressed: (){
//          ShowSettingPage();
//        },
//        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
//        child: Icon(Icons.settings, size: 20, color:Colors.white),
//      ),
//    ),
//  ],
//  elevation: 0.0, //Drop Shadow, 붕 떠 있는 느낌의 수치
//),