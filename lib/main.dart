import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bodyWidgetManager.dart';
import 'package:desktop_window/desktop_window.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'findGanji.dart' as findGangi;
import 'SaveData/saveDataManager.dart' as saveDataManager;
import 'Settings/personalDataManager.dart' as personalDataManager;
import 'Settings/settingManagerWidget.dart' as settingManagerWidget;
import 'Calendar/MainCalendarSaveList/mainCalendarGroupSaveList.dart' as mainCalendarGroupSaveList;
import 'Calendar/MainCalendarSaveList/mainCalendarGroupSaveListOption.dart' as mainCalendarGroupSaveListOption;
import 'Calendar/MainCalendarChange/mainCalendarChange.dart' as mainCalendarChange;
import 'Calendar/MainCalendarSaveList/mainCalendarSaveList.dart' as mainCalendarSaveList;
import 'Calendar/mainCalendarRecentList.dart' as mainCalendarRecentList;
import 'Diary/IljinDiaryManager.dart' as iljinDiaryManager;
import 'revealWindowClass.dart' as revealWindowClass;
import 'Help/HelpManagerWidget.dart' as helpManagerWidget;

import 'package:provider/provider.dart';
import 'bodyWidgetManager.dart' as bodyWidgetManager;
import 'package:window_size/window_size.dart';

class Store extends ChangeNotifier {
  bool isEditSetting = false;
  bool isGroupLoad = false;
  bool isEditWorldCalendarMemo = false;
  bool isEditWorldGroupPersonCount = false;

  SetEditSetting(){
    isEditSetting = !isEditSetting;
    notifyListeners();
  }

  SetEditWorldCalendarMemo(){ //명식 메모 수정했을 때 동기화
    isEditWorldCalendarMemo = !isEditWorldCalendarMemo;
    notifyListeners();
  }
  SetEditWorldGroupPersonCount(){
    isEditWorldGroupPersonCount = !isEditWorldGroupPersonCount;
    notifyListeners();
  }

  bool isEditWorldGroupName = false;
  DateTime groupNameSaveDate = DateTime.utc(3000);
  SetEditWorldGroupName(DateTime groupSaveDate){
    isEditWorldGroupName = !isEditWorldGroupName;
    groupNameSaveDate = groupSaveDate;
    notifyListeners();
  }
  ResetEditWorldGroupName(){
    groupNameSaveDate = DateTime.utc(3000);
  }

  bool isEditWorldPersonName = false;
  DateTime personNameSaveDate = DateTime.utc(3000);
  String personPrevName = '';
  String personNowName = '';
  int personBirthData = -1;
  SetEditWorldPersonName(String prevName, String nowName, int birthData, DateTime personSaveDate){  //명식 이름 수정했을 때 동기화
    isEditWorldPersonName = !isEditWorldPersonName;
    personNameSaveDate = personSaveDate;
    personPrevName = prevName;
    personNowName = nowName;
    personBirthData= birthData;
    notifyListeners();
  }
  ResetEditWorldPersonName(){
    personNameSaveDate = DateTime.utc(3000);
    personPrevName = '';
    personNowName = '';
    personBirthData = -1;
  }

  bool isEditWorldGroupMemo = false;
  DateTime groupMemoSaveDate = DateTime.utc(3000);
  int targetGroupMemoPageNum = -1;
  SetEditWorldGroupMemo(DateTime groupSaveDate, int num){
    isEditWorldGroupMemo = !isEditWorldGroupMemo;
    groupMemoSaveDate = groupSaveDate;
    targetGroupMemoPageNum = num;
    notifyListeners();
  }
  ResetEditWorldGroupMemo(){
    groupMemoSaveDate = DateTime.utc(3000);
    targetGroupMemoPageNum = -1;
  }

  int targetGroupSavePageNum = -1;
  DateTime targetGroupSaveDateTime = DateTime.utc(3000);
  SetTargetGroupSavePageNum(int num, DateTime saveDate){
    targetGroupSavePageNum = num;
    targetGroupSaveDateTime = saveDate;
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
  SetPersonInquireInfo(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, String memo, DateTime saveDate){
    personInquireInfo['targetName'] = name;
    personInquireInfo['genderVal'] = gender;
    personInquireInfo['uemYangType'] = uemYang;
    personInquireInfo['targetBirthYear'] = birthYear;
    personInquireInfo['targetBirthMonth'] = birthMonth;
    personInquireInfo['targetBirthDay'] = birthDay;
    personInquireInfo['targetBirthHour'] = birthHour;
    personInquireInfo['targetBirthMin'] = birthMin;
    personInquireInfo['personMemo'] = memo;
    personInquireInfo['personSaveDate'] = saveDate;


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

    setWindowMinSize(const Size(1180, 660));

  }

  //windowManager.waitUntilReadyToShow(windowOptions, () async {
  //  await windowManager.show();
  //  await windowManager.focus();
  //});

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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin{

  var appBarTitle = ['  루시아 원 만세력 - 베타 테스트 버전', '  일진일기'];
  bool _isShowSettingPage = false;
  bool _isShowHelpPage = false;

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
  List<String> listPageName = ['묶음 1','묶음 2','묶음 3','묶음 4','묶음 5','묶음 6','묶음 7','묶음 8','묶음 9'];  //페이지 이름
  List<String> listPageNameController = ['','','','','','','','',''];
  List<String> listPageMemo = ['','','','','','','','',''];
  List<DateTime> listPageSaveDate = [DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000),DateTime.utc(3000)];
  TextEditingController pageNameController = TextEditingController();
  String nowPageName = '';
  int uniquePageNum = 2;

  Widget settingWidget = SizedBox.shrink();
  Widget groupLoadWidget = SizedBox.shrink();
  String groupTempMemo = '';
  Widget helpWidget = SizedBox.shrink();

  bool isShowSideLayer = false;
  bool isShowSideOptionLayer = false;
  bool isShowTempMemoNote = false;

  int nowUnderLine = 0;
  var nowCalendarHeadLine = 0;
  List<Text> listCalendarTexts = [];
  var underLineOpacity = [1.0,0.0,0.0,0.0];
  List<String> calendarHeadLineTitle = ['저장목록', '최근목록', '묶음목록', '간지변환'];
  List<Color> listCalendarTextColor = [Colors.white, style.colorGrey, style.colorGrey, style.colorGrey];

  List<Widget> listSideLayerWidget = [];
  Widget sideOptionLayerWidget = SizedBox.shrink();

  bool isLoadPersonData = false;

  int mapPersonLength = 0;
  int mapRecentPersonLength = 0;
  int listMapGroupLength = 0;
  int mapDiaryLength = 0;
  bool isRegiedUserData = false;

  int nowSideLayerNum = 0;

  Color groupMemoButtonEffectColor = Colors.transparent;
  Color diaryButtonEffectColor = Colors.transparent;
  Color sideLayerButtonEffectColor = Colors.transparent;
  Color settingButtonEffectColor = Colors.transparent;
  Color helpButtonEffectColor = Colors.transparent;

  revealWindowClass.RevealWindowClass revealWindowClassWidget = revealWindowClass.RevealWindowClass();

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

  //설정 페이지 온오프
  ShowSettingPage({isCompulsionClose = false}){
    setState(() {
      if(isCompulsionClose == true){
        _isShowSettingPage = false;
      } else {
        _isShowSettingPage = !_isShowSettingPage;
      }
      if(_isShowSettingPage == false){
        SetSettingWidget(false);
      }
    });
  }

  //페이지 이름 편집 및 저장
  SetNowPageName(String text, {bool isFromCalendarMain = false}){  //페이지 이름 텍스트 필드로 바꿀 때 사용
    //nowPageName = listPageName[nowPageNum];
    String storeNowPageName = '';

    if(isFromCalendarMain == false) {
      storeNowPageName = listPageNameController[nowPageNum];
    } else {
      storeNowPageName = text;
      setState(() {
        pageNameController.text = text;
      });
    }
    nowPageName = storeNowPageName;
    context.read<Store>().SetNowPageName(storeNowPageName);
  }

  //현재 페이지 선택
  SetNowCalendarNum(int num){
    if(nowPageNum == num){
      setState(() {
        SetNowPageName(listPageNameController[nowPageNum]);
        pageNameController.text = nowPageName;
      });
      return;
    }
    setState(() {
      listCalendarButtonSize[nowPageNum] = calendarButtonSize;
      listCalendarButtonColor[nowPageNum] = Colors.white;
      nowPageNum = num;
      listCalendarButtonColor[nowPageNum] = style.colorMainBlue;
      listCalendarButtonSize[nowPageNum] = nowCalendarButtonSize;
      SetNowPageName(listPageNameController[nowPageNum]);
      pageNameController.text = nowPageName;
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
          listPageWidget.insert(0,bodyWidgetManager.BodyWidgetManager(key: GlobalKey(), pageNum: uniquePageNum, saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum,
              setNowPageName: SetNowPageName, setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,
              refreshMapRecentPersonLength: RefreshRecentPersonLength, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName,
              setGroupMemoWidget: SetGroupMemoWidget, getGroupTempMemo: GetGroupTempMemo, setGroupSaveDateAfterSave: SetGroupSaveDateAfterSave, RevealWindow: RevealWindow,));
          SetNowCalendarNum(nowPageNum + 1);
          for(int i = nowPageCount - 1; i > 0; i--){
            if(listPageNameController[i - 1] != ''){
              listPageNameController[i] = listPageNameController[i - 1];
              listPageNameController[i - 1] = '';
            }
            if(listPageSaveDate[i - 1] != DateTime.utc(3000)){
              listPageSaveDate[i] = listPageSaveDate[i - 1];
              listPageSaveDate[i - 1] = DateTime.utc(3000);
            }
          }
          SetNowPageName(listPageName[nowPageNum]);
        } else {
          listCalendarButtonColor.add(Colors.white);
          listCalendarButtonSize.add(16);
          listUniquePageNum.add(uniquePageNum);
          listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key: GlobalKey(), pageNum: uniquePageNum, saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum,
              setNowPageName: SetNowPageName, setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,
              refreshMapRecentPersonLength: RefreshRecentPersonLength, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName,
              setGroupMemoWidget: SetGroupMemoWidget, getGroupTempMemo: GetGroupTempMemo, setGroupSaveDateAfterSave: SetGroupSaveDateAfterSave, RevealWindow: RevealWindow,));
        }
        nowPageCount++;
      } else {
        ShowSnackBar('묶음은 9개까지 사용 가능합니다');
      }
    });
  }

  //페이지 비우기
  SetClearPageNum(int num){
    if (num == 30) {  //모두 지우기
      setState(() {
        listPageWidget.clear();
        listCalendarButtonColor.clear();
        listCalendarButtonSize.clear();
        listUniquePageNum.clear();
        listCalendarButtonColor = [style.colorMainBlue,Colors.white,Colors.white];
        listCalendarButtonSize = [20,16,16];
        listUniquePageNum = [0,1,2];
        for(int i = 0; i < firstPageCount; i++){
          listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[i], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum,
              setNowPageName: SetNowPageName, setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,
              refreshMapRecentPersonLength: RefreshRecentPersonLength, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName,
              setGroupMemoWidget: SetGroupMemoWidget, getGroupTempMemo: GetGroupTempMemo, setGroupSaveDateAfterSave: SetGroupSaveDateAfterSave, RevealWindow: RevealWindow,));
        }
        nowPageNum = 0;
        nowPageCount = firstPageCount;
        pageNameController.text = '';
        for(int i = 0; i < listPageNameController.length; i++){
          listPageNameController[i] = '';
          listPageSaveDate[i] = DateTime.utc(3000);
        }

        SetNowCalendarNum(0);
        ShowSnackBar('모든 묶음을 비웠습니다');
      });
    } else {
      setState(() {
        listPageWidget.removeAt(num);
        listUniquePageNum.removeAt(num);

        if(nowPageCount == 3){  //페이지 3개뿐일 때
          uniquePageNum++;
          listUniquePageNum.insert(num, uniquePageNum);
          listPageWidget.insert(num,bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[num], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum,
              setNowPageName: SetNowPageName, setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,
              refreshMapRecentPersonLength: RefreshRecentPersonLength, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName,
              setGroupMemoWidget: SetGroupMemoWidget, getGroupTempMemo: GetGroupTempMemo, setGroupSaveDateAfterSave: SetGroupSaveDateAfterSave, RevealWindow: RevealWindow,));
          for(int i = 0; i < 3; i++){
            listPageNameController[i] = '';
            listPageSaveDate[i] = DateTime.utc(3000);
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
            listPageNameController[i] = listPageNameController[i+1];
            listPageSaveDate[i] = listPageSaveDate[i+1];
          }
          listPageNameController.last = '';
          listPageSaveDate.last = DateTime.utc(3000);
          SetNowPageName(listPageName[num]);
          nowPageCount--;
        }

        ShowSnackBar('현재 묶음을 비웠습니다');
      });
    }
  }

  //설정 위젯 보이기 안보이기
  SetSettingWidget(bool isShow, {int directGoPageNum = 0}){
    if(isShow == true){
      setState(() {
        settingWidget = TapRegion(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 6,
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: settingManagerWidget.SettingManagerWidget(setSettingPage: ShowSettingPage, reloadSetting: ReloadSetting, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,
              refreshListMapGroupLength: RefreshListMapGroupLength, directGoPageNum: directGoPageNum, refreshDiaryUserData: RefreshDiaryUserData, refreshMapRecentLength: RefreshRecentPersonLength,
            refreshMapDiaryLength: RefreshMapDiaryLength, RevealWindow: RevealWindow,),
          ),
        );
      });
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

  //메모 바뀜 감시자
  ReloadWorldMemo(){
    setState(() {
      context.read<Store>().SetEditWorldCalendarMemo();
    });
  }

  //그룹 저장 신호 주기
  GroupDataSave(){
    setState(() {
      context.read<Store>().SetTargetGroupSavePageNum(listUniquePageNum[nowPageNum], listPageSaveDate[nowPageNum]);
    });
  }
  //그룹 저장 후 정리
  GroupSaveSuccess(){
    context.read<Store>().SetTargetGroupSavePageNum(-1, DateTime.utc(3000));
  }
  //그룹 불러오기
  GroupDataLoad(int groupIndex){
    if(nowPageCount == limitPageCount){ //최대 페이지
      ShowSnackBar('묶음은 9개까지 사용 가능합니다\묶음 하나를 비워주세요');
    } else {
      setState(() {
        AddPage(false);
        SetNowCalendarNum(nowPageCount - 1);
        listPageNameController[nowPageNum] = saveDataManager.listMapGroup[groupIndex][0]['groupName'];
        SetNowPageName(saveDataManager.listMapGroup[groupIndex][0]['groupName']);
        SetNowCalendarNum(nowPageNum);
        listPageSaveDate[nowPageNum] = saveDataManager.listMapGroup[groupIndex][0]['saveDate'];
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
          child: mainCalendarGroupSaveList.MainCalendarGroupSaveList(groupDataLoad: GroupDataLoad, setGroupLoadWidget: SetGroupLoadWidget, setSideOptionLayerWidget: SetSideOptionLayerWidget,
              setSideOptionWidget: SetSideOptionWidget, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName, saveGroupTempMemo: SaveGroupTempMemo),
        ),
      );
    } else {
      setState(() {
        groupLoadWidget = SizedBox.shrink();
      });
    }
  }
  //그룹 이름 수정 반영하기
  RefreshGroupName(DateTime saveDate, String groupName){
    for(int i = 0; i < listPageSaveDate.length; i++){
      if(listPageSaveDate[i] == saveDate){
        listPageNameController[i] = groupName;
        if(i == nowPageNum){
          pageNameController.text = groupName;
        }
      }
    }
  }
  //그룹 메모 작동
  SetGroupMemoWidget(List<dynamic> listGroupPerson, bool isTempMemoNote){
    if(isTempMemoNote == false){
      if(isShowSideOptionLayer == true && isShowTempMemoNote == false){
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          SetSideOptionLayerWidget(false);
        });
      } else {
        listGroupPerson.insert(0, {'groupName':nowPageName, 'saveDate':listPageSaveDate[nowPageNum], 'memo':saveDataManager.listMapGroup[saveDataManager.FindListMapGroupIndex(nowPageName, listPageSaveDate[nowPageNum])][0]['memo']});
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          SetSideOptionLayerWidget(true);
          SetSideOptionWidget(Container(
            width: style.UIButtonWidth + 30,
            height: MediaQuery.of(context).size.height - style.appBarHeight,
            child: mainCalendarGroupSaveListOption.MainCalendarGroupSaveListOption(
                listMapGroup: listGroupPerson,
                refreshListMapGroupLength: RefreshListMapGroupLength,
                closeOption: SetSideOptionLayerWidget,
                refreshGroupName: RefreshGroupName,
                isMemoOpen: true,
                saveGroupTempMemo: SaveGroupTempMemo,
                key: UniqueKey()),
          ));
        });
      }
    } else {

      if(listGroupPerson.length == 0 && isShowTempMemoNote == true){
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          SetSideOptionLayerWidget(false);
        });
      } else {
        listGroupPerson.insert(0, {'groupName': '메모장', 'saveDate':DateTime.utc(3000), 'memo':groupTempMemo});
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          SetSideOptionLayerWidget(true, isShowTempMemo: true);
          SetSideOptionWidget(Container(
            width: style.UIButtonWidth + 30,
            height: MediaQuery.of(context).size.height - style.appBarHeight,
            child: mainCalendarGroupSaveListOption.MainCalendarGroupSaveListOption(
                listMapGroup: listGroupPerson,
                refreshListMapGroupLength: RefreshListMapGroupLength,
                closeOption: SetSideOptionLayerWidget,
                refreshGroupName: RefreshGroupName,
                isMemoOpen: true,
                saveGroupTempMemo: SaveGroupTempMemo,
                key: UniqueKey()),
          ));
        });
      }
    }

   //if(isTempMemoNote == true && listGroupPerson[0]['groupName'] == '메모장' && listGroupPerson[0]['saveDate'] == DateTime.utc(3000) && isShowSideOptionLayer == true){
   //  WidgetsBinding.instance!.addPostFrameCallback((_) {
   //    SetSideOptionLayerWidget(false);
   //  });
   //} else {
   //  //if(isTempMemoNote == false && listGroupPerson[0]['groupName'] == nowPageName && )
   //  WidgetsBinding.instance!.addPostFrameCallback((_) {
   //    SetSideOptionLayerWidget(true);
   //    SetSideOptionWidget(Container(
   //      width: style.UIButtonWidth + 30,
   //      height: MediaQuery.of(context).size.height - style.appBarHeight,
   //      child: mainCalendarGroupSaveListOption.MainCalendarGroupSaveListOption(
   //          listMapGroup: listGroupPerson,
   //          refreshListMapGroupLength: RefreshListMapGroupLength,
   //          closeOption: SetSideOptionLayerWidget,
   //          refreshGroupName: RefreshGroupName,
   //          isMemoOpen: true,
   //          saveGroupTempMemo: SaveGroupTempMemo,
   //          key: UniqueKey()),
   //    ));
   //  });
   //}
  }
  //그룹 메모 저장
  SaveGroupTempMemo(String text){
    groupTempMemo = text;
  }
  //그룹 메모 반환
  GetGroupTempMemo(){
    return groupTempMemo;
  }
  //그룹 저장 후 저장일자 적용
  SetGroupSaveDateAfterSave(DateTime groupSaveDate){
    listPageSaveDate[nowPageNum] = groupSaveDate;
  }

  //사이드 레이어 온오프
  SetSideLayerWidget(int targetSideLayerNum, {bool isRefreshUserData = false}){

    if(isRefreshUserData == true && isShowSideLayer == true && nowSideLayerNum == targetSideLayerNum){
      isShowSideLayer = true;
    } else {
      if (isShowSideLayer == false || targetSideLayerNum == nowSideLayerNum) {
        isShowSideLayer = !isShowSideLayer;
      }
    }
    nowSideLayerNum = targetSideLayerNum;
  }
  //현재 보고있는 페이지 번호 전송
  int SendNowPageNum(){
    return listUniquePageNum[nowPageNum];
  }

  //사이드 옵션 레이어 온오프
  SetSideOptionLayerWidget(bool onOff, {bool isShowTempMemo = false}){
    setState(() {
      isShowTempMemoNote = isShowTempMemo;
      if(onOff == true){
        isShowSideOptionLayer = true;
      } else {
        isShowSideOptionLayer = false;
        sideOptionLayerWidget = SizedBox.shrink();
      }
    });
  }
  //사이드 옵션 위젯 설정
  SetSideOptionWidget(Widget _widget, {bool isCompulsionOn = false}){
    setState(() {
      sideOptionLayerWidget = _widget;
      if(isCompulsionOn == true){
        SetSideOptionLayerWidget(true);
      }
      rebuildAllChildren(context);
    });
  }

  //헤드라인 눌렀을 때
  HeadLineButtonAction(int buttonNum) {
    setState(() {
      if(buttonNum == nowCalendarHeadLine){
        return;
      }

      listCalendarTextColor[nowCalendarHeadLine] = style.colorGrey;
      listCalendarTexts[nowCalendarHeadLine] = Text(calendarHeadLineTitle[nowCalendarHeadLine], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[nowCalendarHeadLine]));
      listCalendarTextColor[buttonNum] = Colors.white;
      listCalendarTexts[buttonNum] = Text(calendarHeadLineTitle[buttonNum], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[buttonNum]));

      underLineOpacity[nowCalendarHeadLine] = 0.0;
      underLineOpacity[buttonNum] = 1.0;

      nowCalendarHeadLine = buttonNum;

      //if(buttonNum == 1 || buttonNum == 3){
      //  SetSideOptionLayerWidget(false);
      //}
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

  //저장목록 실시간 갱신
  RefreshMapPersonLengthAndSort(){
    setState(() {
      mapPersonLength = saveDataManager.mapPerson.length;
      saveDataManager.SortMapPerson(-1);
    });
  }

  //최근목록 실시간 갱신
  RefreshRecentPersonLength(){
    WidgetsBinding.instance!.addPostFrameCallback((_){
      setState(() {
        mapRecentPersonLength = saveDataManager.mapRecentPerson.length;
      });
    });
  }

  //그룹목록 실시간 갱신
  RefreshListMapGroupLength(){
    WidgetsBinding.instance!.addPostFrameCallback((_){
      setState(() {
        listMapGroupLength = saveDataManager.listMapGroup.length;
      });
    });
  }

  //일기목록 실시간 갱신
  RefreshMapDiaryLength(){
    WidgetsBinding.instance!.addPostFrameCallback((_){
      setState(() {
        mapDiaryLength = saveDataManager.mapDiary.length;
      });
    });
  }

  //일진일기 사용자 등록 실시간 갱신
  RefreshDiaryUserData({bool setOnlyRegiedUserData = false}){
    print(setOnlyRegiedUserData);
    setState(() {
      if(setOnlyRegiedUserData == true){
        isRegiedUserData = false;
        if(nowSideLayerNum == 1){
          isShowSideLayer = false;
        }
      } else {
        if (personalDataManager.mapUserData.isNotEmpty) {
          isRegiedUserData = true;
          SetSideLayerWidget(1, isRefreshUserData: true);
        }
      }
    });
  }

  //인포윈도우 온오프
  RevealWindow(bool gender, int ganjiPosNum, bool cheongan, int ganjiNum, int sajuNum, String yugchinString, int sibiunseongNum) {
    setState(() {
      //revealWindowWidget = revealWindow.RevealWindow(gender: gender, ganjiPosNum: ganjiPosNum, cheongan: cheongan, sajuNum: sajuNum, ganjiNum: ganjiNum, yugchinNum: yugchinNum, sibiunseongNum: sibiunseongNum);
      revealWindowClassWidget.GetRevealWindow(gender, ganjiPosNum, cheongan, ganjiNum, sajuNum, yugchinString, sibiunseongNum);
    });
  }

  //인포윈도우 갱신
  SetStateRevealWindow(){
    setState(() {
      revealWindowClassWidget.revealWidget;
    });
  }

  //도움말 설정 위젯 보이기 안 보이기
  SetHelpWidget(bool isShow){
    if(isShow == true){
      setState(() {
        helpWidget = TapRegion(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 6,
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: helpManagerWidget.HelpManagerWidget(showHelpPage: ShowHelpPage),
          ),
        );
      });
    } else {
      helpWidget = SizedBox.shrink();
    }
  }

  //도움말 페이지 온오프
  ShowHelpPage({isCompulsionClose = false}){
    setState(() {
      if(isCompulsionClose == true){
        _isShowHelpPage = false;
      } else {
        _isShowHelpPage = !_isShowHelpPage;
      }
      if(_isShowHelpPage == false){
        SetHelpWidget(false);
      }
    });
  }


  @override initState(){
    super.initState();

    findGangi.FindGanjiData();
    saveDataManager.SetFileDirectoryPath();
    personalDataManager.SetFileDirectoryPath();

    for(int i = 0; i < firstPageCount; i++) {
      listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[i], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess, getNowPageNum: SendNowPageNum,
          setNowPageName: SetNowPageName, setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,
          refreshMapRecentPersonLength: RefreshRecentPersonLength, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName,
        setGroupMemoWidget: SetGroupMemoWidget, getGroupTempMemo: GetGroupTempMemo, setGroupSaveDateAfterSave: SetGroupSaveDateAfterSave, RevealWindow: RevealWindow,));
    }

    saveDataManager.snackBar = ShowSnackBar;

    listCalendarTexts.add(Text(calendarHeadLineTitle[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[0]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[1], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[1]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[2], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[2]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[3], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[3]), ));

    mapPersonLength = saveDataManager.mapPerson.length;
    mapRecentPersonLength = saveDataManager.mapRecentPerson.length;

    WidgetsBinding.instance!.addPostFrameCallback((_){
      if(DateTime.now().year > 2025 || (DateTime.now().month == 12 && DateTime.now().day > 30))
      {
        Future.delayed(const Duration(milliseconds: 3000), () {
          exit(0);
        });
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('테스트 기한이 만료되었으므로\n프로그램이 종료됩니다', textAlign: TextAlign.center,),
            );
          },
        );
      }
    });

    revealWindowClassWidget.Init(SetStateRevealWindow);
  }

  @override void didChangeDependencies() {

    //DesktopWindow.toggleFullScreen();
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    listSideLayerWidget = [ //사이드 목록 위젯
      Container(
        width: style.UIButtonWidth+38,//2,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarSaveList.MainCalendarSaveList(setSideOptionLayerWidget: SetSideOptionLayerWidget, setSideOptionWidget: SetSideOptionWidget, mapPersonLength: mapPersonLength, refreshMapPersonLengthAndSort: RefreshMapPersonLengthAndSort,),
      ),
      Container(
        width: style.UIButtonWidth+38,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarRecentList.MainCalendarRecentList(),
      ),
      Container(
        width: style.UIButtonWidth+38,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: mainCalendarGroupSaveList.MainCalendarGroupSaveList(groupDataLoad: GroupDataLoad, setGroupLoadWidget: SetGroupLoadWidget, setSideOptionLayerWidget: SetSideOptionLayerWidget,
            setSideOptionWidget: SetSideOptionWidget, refreshListMapGroupLength: RefreshListMapGroupLength, refreshGroupName: RefreshGroupName, saveGroupTempMemo: SaveGroupTempMemo,),
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
                    Row(  //묶음, 페이지 버튼
                      children: [
                        Container(  //묶음(group) 저장
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                GroupDataSave();
                                rebuildAllChildren(context);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                            child: Icon(Icons.save, size: style.appbarIconSize*1.1, color:Colors.white),
                          ),
                        ),
                        Container(  //묶음(group) 메모
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                if(listPageSaveDate[nowPageNum] != DateTime.utc(3000)){
                                  context.read<Store>().SetEditWorldGroupMemo(listPageSaveDate[nowPageNum], listUniquePageNum[nowPageNum]);  //calendarMain에서 읽는다
                                } else {
                                  ShowSnackBar('묶음 메모를 사용하려면\n${style.myeongsicString} 묶음을 먼저 불러와야 합니다');
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                            child: SvgPicture.asset('assets/memo_icon.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                          ),
                        ),
                        Container(
                          width:2,
                          height: style.appBarHeight * 0.3,
                          color:style.colorDarkGrey,
                        ),
                        Container(  //한 페이지 비우기
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: (){
                              SetClearPageNum(nowPageNum);
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                            child: Icon(Icons.clear, size: style.appbarIconSize*1.3, color:Colors.white),
                          ),
                        ),
                        Container(  //모든 페이지 비우기
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              SetClearPageNum(30);
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                            child: SvgPicture.asset('assets/close_all_icon.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                          ),
                        ),
                        Container(  //페이지 이름
                          width: 250,
                          height: style.appBarHeight - 14,
                          margin: EdgeInsets.only(left:6),
                          decoration: BoxDecoration(
                            border: Border.all(color:style.colorDarkGrey.withOpacity(0.3), width:1),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.only(top:0, bottom:8),
                          child: TextField(
                            cursorColor: Colors.white,
                            maxLength: 10,
                            controller: pageNameController,
                            style: Theme.of(context).textTheme.headlineSmall,
                            decoration:InputDecoration(
                              contentPadding: EdgeInsets.only(bottom:12),
                                counterText:"",
                                border: InputBorder.none,
                                prefix: Text('   '),
                                hintText: listPageName[nowPageNum],
                                hintStyle: Theme.of(context).textTheme.headlineSmall),
                            onChanged: (value){
                              setState(() {
                                listPageNameController[nowPageNum] = value;
                                SetNowPageName(value);
                              });
                            },
                            onEditingComplete: (){
                              setState(() {
                                saveDataManager.SaveEditedGroupNameWithoutPrevGroupName(listPageSaveDate[nowPageNum], pageNameController.text);
                                RefreshListMapGroupLength();
                              });

                              nowPageName = pageNameController.text;
                              listPageNameController[nowPageNum] = pageNameController.text;
                              RefreshGroupName(listPageSaveDate[nowPageNum], listPageNameController[nowPageNum]);
                              context.read<Store>().SetEditWorldGroupName(listPageSaveDate[nowPageNum]);
                            },
                          ),
                        ),
                        //Container(  //테스트 버튼1
                        //  width: 40,
                        //  height: style.appBarHeight,
                        //  margin: EdgeInsets.only(left: 00),
                        //  child: ElevatedButton(
                        //    onPressed: (){
                        //      print(MediaQuery.of(context).size.width);
                        //      print(MediaQuery.of(context).size.height);
                        //    },
                        //    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        //        foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        //    child: Icon(Icons.accessibility_sharp, size: 20, color:Colors.white),
                        //  ),
                        //),
                        //Container(  //테스트 버튼2
                        //  width: 40,
                        //  height: style.appBarHeight,
                        //  margin: EdgeInsets.only(left: 00),
                        //  child: ElevatedButton(
                        //    onPressed: (){
                        //      saveDataManager.ClearListMapGroup();
                        //    },
                        //    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        //        foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        //    child: Icon(Icons.accessibility_sharp, size: 20, color:Colors.white),
                        //  ),
                        //),
                      ],
                    ),
                    Row(
                      children: [
                        Container(  //묶음(group) 메모장
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isShowTempMemoNote == true? style.colorBlack : groupMemoButtonEffectColor,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: ElevatedButton(
                            onHover: (hover){
                              setState(() {
                                if(hover == true){
                                  groupMemoButtonEffectColor = style.colorBlack.withOpacity(0.6);
                                } else {
                                  groupMemoButtonEffectColor = Colors.transparent;
                                }
                              });
                            },
                            onPressed: (){
                              setState(() {
                                List<dynamic> listPerson = [];
                                SetGroupMemoWidget(listPerson, true);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,),
                            child: SvgPicture.asset('assets/memo_icon.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                          ),
                        ),
                        Container(
                          width:2,
                          height: style.appBarHeight * 0.3,
                          color:style.colorDarkGrey,
                        ),
                        Container(  //일진일기
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(left: 10, right:2),
                          decoration: BoxDecoration(
                            color: (nowSideLayerNum == 1 && isShowSideLayer == true)? style.colorBlack : diaryButtonEffectColor,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: ElevatedButton(
                            onHover: (hover){
                              setState(() {
                                if(hover == true){
                                  diaryButtonEffectColor = style.colorBlack.withOpacity(0.6);
                                } else {
                                  diaryButtonEffectColor = Colors.transparent;
                                }
                              });
                            },
                            onPressed: (){
                              setState(() {
                                SetSideLayerWidget(1);
                                  //List<dynamic> listPerson = [];
                                  //SetGroupMemoWidget(listPerson, false, true);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,),
                            child: SvgPicture.asset('assets/diary_navi_icon.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                          ),
                        ),
                        Container(  //저장목록들, 간지변환 버튼
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: (nowSideLayerNum == 0 && isShowSideLayer == true)? style.colorBlack : sideLayerButtonEffectColor,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: ElevatedButton(
                            onHover: (hover){
                              setState(() {
                                if(hover == true){
                                  sideLayerButtonEffectColor = style.colorBlack.withOpacity(0.6);
                                } else {
                                  sideLayerButtonEffectColor = Colors.transparent;
                                }
                              });
                            },
                            onPressed: (){
                              setState(() {
                                SetSideLayerWidget(0);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,),
                            child: SvgPicture.asset('assets/burger_icon.svg', width: style.appbarIconSize*0.8, height: style.appbarIconSize*0.8),
                          ),
                        ),
                        Container(
                          width:2,
                          height: style.appBarHeight * 0.3,
                          color:style.colorDarkGrey,
                        ),
                        Container(  //설정 버튼
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          margin: EdgeInsets.only(left: 10, right:2),
                          decoration: BoxDecoration(
                            color: _isShowSettingPage == true? style.colorBlack : settingButtonEffectColor,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: ElevatedButton(
                            onHover: (hover){
                              setState(() {
                                if(hover == true){
                                  settingButtonEffectColor = style.colorBlack.withOpacity(0.6);
                                } else {
                                  settingButtonEffectColor = Colors.transparent;
                                }
                              });
                            },
                            onPressed: (){
                              _isShowSettingPage = !_isShowSettingPage;
                              setState(() {
                                if(_isShowHelpPage == true){
                                  _isShowHelpPage = false;
                                  SetHelpWidget(_isShowHelpPage);
                                }
                                SetSettingWidget(_isShowSettingPage);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,),
                            child: SvgPicture.asset('assets/setting_navi_icon_select.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                          ),
                        ),
                        Container(  //도움말 버튼
                          width: 40,
                          height: style.appBarHeight * 0.8,
                          //margin: EdgeInsets.only(right:40),
                          padding: EdgeInsets.only(bottom:4),
                          decoration: BoxDecoration(
                            color: _isShowHelpPage == true? style.colorBlack : helpButtonEffectColor,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: ElevatedButton(
                            onHover: (hover){
                              setState(() {
                                if(hover == true){
                                  helpButtonEffectColor = style.colorBlack.withOpacity(0.6);
                                } else {
                                  helpButtonEffectColor = Colors.transparent;
                                }
                              });
                            },
                            onPressed: (){
                              _isShowHelpPage = !_isShowHelpPage;
                              setState(() {
                                if(_isShowSettingPage == true){
                                  _isShowSettingPage = false;
                                  SetSettingWidget(_isShowSettingPage);
                                }
                                SetHelpWidget(_isShowHelpPage);
                              });
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,),
                            child: Text('?', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, fontFamily: 'NotoSans-Regular', height:1),),//SvgPicture.asset('assets/setting_navi_icon_select.svg', width: style.appbarIconSize, height: style.appbarIconSize),
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
                      height: 20,
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
                    child: Container(
                      child: Stack(
                        children: [
                          IndexedStack( //메인 페이지
                            index: nowPageNum,
                            children: listPageWidget,
                          ),
                          Container(  //인포윈도우 위젯
                            height: MediaQuery.of(context).size.height - style.appBarHeight,
                            alignment: Alignment.bottomRight,
                            child: revealWindowClassWidget.revealWidget,//revealWindowWidget,//groupLoadWidget,
                          ),
                        ]
                      ),
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
                      firstChild: [
                        Column(
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
                                        style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: WidgetStateProperty.all(Colors.transparent),
                                            padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                                        child:listCalendarTexts[0],
                                        onPressed:(){HeadLineButtonAction(0);})
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
                            alignment: Alignment.topCenter,
                          ),
                        ],
                      ),
                        iljinDiaryManager.Iljindiarymanager(isRegiedUserData: isRegiedUserData, SetSettingWidget: SetSettingWidget, SetSideOptionWidget: SetSideOptionWidget, CloseOption: SetSideOptionLayerWidget, RevealWindow: RevealWindow,),
                      ]
                      [nowSideLayerNum],
                      secondChild:Container(
                        width:0,
                        height: MediaQuery.of(context).size.height - style.appBarHeight,
                      ),
                      crossFadeState: isShowSideLayer == true? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
              Container(  //도움말 위젯
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - style.appBarHeight,
                alignment: Alignment.center,
                child: helpWidget,
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