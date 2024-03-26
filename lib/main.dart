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
          listPageWidget.insert(0,bodyWidgetManager.BodyWidgetManager(key: GlobalKey(), pageNum: uniquePageNum, saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess));
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
          listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key: GlobalKey(), pageNum: uniquePageNum, saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess));
        }
        nowPageCount++;
      } else {
        ShowSnackBar('페이지는 9개를 넘을 수 없습니다');
      }
    });
  }

  ShowSnackBar(String text){
    SnackBar snackBar = SnackBar(
      content: Text(text, style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
      backgroundColor: Colors.white,
      //style.colorMainBlue,
      shape: StadiumBorder(),
      duration: Duration(milliseconds: 600),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: 20,
          left: (MediaQuery.of(context).size.width - style.UIButtonWidth) * 0.5,
          right: (MediaQuery.of(context).size.width - style.UIButtonWidth) * 0.5),
    );

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
          listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[i], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess));
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
          listPageWidget.insert(num,bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[num], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess));
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
      listPageWidget.add(bodyWidgetManager.BodyWidgetManager(key:GlobalKey(), pageNum: listUniquePageNum[i], saveSuccess: GroupSaveSuccess, loadSuccess: GroupLoadSuccess));
    }
    for(int i = 0; i < listPageNameController.length; i++){
      //listPageNameController[i].text = listPageName[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: style.appBarHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(  //루시아원만세력, 설정 버튼
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
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
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
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
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
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
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
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
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
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.settings, size: 20, color:Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(  //페이지
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
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.add_circle, size: 20, color: Colors.white),
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
                              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
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
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.add_circle, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                  //[
                  //  Container(),
                  //  Row(
                  //    children: listPageSelectButton
                  //  ),
                  //  Container(),
                  //],
                ),
              ],
            ),
          ),
          Stack(
            children:[
              IndexedStack(
                index: nowPageNum,
                children: listPageWidget,
              ),
              Container(
                //color:Colors.yellow,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - style.appBarHeight,
                alignment: Alignment.center,
                child: settingWidget,
              ),
              Container(
                //color:Colors.yellow,
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