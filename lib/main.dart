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

import 'bodyWidgetManager.dart' as bodyWidgetManager;

void main() async {
  //일진일기 달력 초기화
  await initializeDateFormatting();

  runApp(
      MaterialApp(
        theme: style.theme,
        home : MyApp(),
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var appBarTitle = ['만세력', '일진일기'];
  int _nowMainTap = 0;
  bool _isShowSettingPage = false;

  ShowSettingPage(){ //  설정 페이지 온오프
    setState(() {
      _isShowSettingPage = !_isShowSettingPage;
    });
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
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: Text(appBarTitle[_nowMainTap]),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: (){
                ShowSettingPage();
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
              child: Icon(Icons.settings, size: 20, color:Colors.white),
            ),
          ),

        ],
        elevation: 0.0, //Drop Shadow, 붕 떠 있는 느낌의 수치
      ),
      body:bodyWidgetManager.BodyWidgetManager(nowMainTap: _nowMainTap, isShowSettingPage: _isShowSettingPage, setSettingPage: ShowSettingPage),
    );
  }
}