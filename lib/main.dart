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

import 'package:provider/provider.dart';
import 'bodyWidgetManager.dart' as bodyWidgetManager;
import 'package:window_size/window_size.dart';

class Store extends ChangeNotifier {
  bool isEditSetting = false;
  SetEditSetting(){
    isEditSetting = !isEditSetting;
    notifyListeners();
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
  int _nowMainTap = 0;
  bool _isShowSettingPage = false;

  int nowPageNum = 0;
  double calendarButtonSize = 16;
  double nowCalendarButtonSize = 20;
  List<Color> listCalendarButtonColor = [style.colorMainBlue,Colors.white,Colors.white,Colors.white,Colors.white];
  List<double> listCalendarButtonSize = [20,16,16,16,16];

  int clearPageNum = -1;

  ShowSettingPage(){ //  설정 페이지 온오프
    setState(() {
      _isShowSettingPage = !_isShowSettingPage;
    });
  }

  SetNowCalendarNum(int num){
    if(nowPageNum == num){
      return;
    }
    setState(() {
      listCalendarButtonSize[nowPageNum] = calendarButtonSize;
      listCalendarButtonColor[nowPageNum] = Colors.white;
      nowPageNum = num;
      listCalendarButtonColor[nowPageNum] = style.colorMainBlue;
      listCalendarButtonSize[nowPageNum] = nowCalendarButtonSize;
    });
  }

  SetClearPageNum({int num = -1}){
    if(num == -1){
      clearPageNum  = -1;
    } else {
      String snackBarString = '';
      if (num == -2) {
        setState(() {
          clearPageNum = -2;
          SetNowCalendarNum(0);
          snackBarString = '모든 페이지를 비웠습니다';
        });
      } else {
        setState(() {
          clearPageNum = nowPageNum;
          snackBarString = '현재 페이지를 비웠습니다';
        });
      }

      SnackBar snackBar = SnackBar(
        content: Text(snackBarString, style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
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
  }

  @override initState(){
    super.initState();
    findGangi.FindGanjiData();
    saveDataManager.SetFileDirectoryPath();
    personalDataManager.SetFileDirectoryPath();
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
              children: [
                Row(  //루시아원만세력, 설정 버튼
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(  //페이지 버튼
                      children: [
                        Container(  //저장
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){

                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                            child: Icon(Icons.save, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //복사
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){

                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                            child: Icon(Icons.copy, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //한 페이지 비우기
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              SetClearPageNum(num: nowPageNum);
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                            child: Icon(Icons.clear, size: 20, color:Colors.white),
                          ),
                        ),
                        Container(  //모든 페이지 비우기
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(left: 00),
                          child: ElevatedButton(
                            onPressed: (){
                              SetClearPageNum(num: -2);
                            },
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                            child: Icon(Icons.clear, size: 20, color:Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Container(  //설정 버튼
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(right: 00),
                      child: ElevatedButton(
                        onPressed: (){
                          ShowSettingPage();
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
                        child: Icon(Icons.settings, size: 20, color:Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
          bodyWidgetManager.BodyWidgetManager(nowMainTap: _nowMainTap, isShowSettingPage: _isShowSettingPage, setSettingPage: ShowSettingPage, nowCalendarNum: nowPageNum, clearPageNum: clearPageNum,
          setClearPageNum: SetClearPageNum),
        ],
      ),
    );
  }
}




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