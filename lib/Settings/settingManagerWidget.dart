import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;
import '../findGanji.dart' as findGanji;
import 'userDataWidget.dart' as userDataWidget;
import 'wordSettingWidget.dart' as wordSettingWidget;
import 'calendarSettingWidget.dart' as calendarSettingWidget;
import 'sinsalSettingWidget.dart' as sinsalSettingWidget;
import 'deunSeunSettingWidget.dart' as deunSeunSettingWidget;
import 'etcSettingWidget.dart' as etcSettingWidget;
import 'themeSettingWidget.dart' as themeSettingWidget;
import 'dataManageWidget.dart' as dataManageWidget;
import 'shareSettingValWidget.dart' as shareSettingValWidget;
import 'resetSettingWidget.dart' as resetSettingWidget;

class SettingManagerWidget extends StatefulWidget {
  const SettingManagerWidget({super.key, required this.setSettingPage, required this.reloadSetting, required this. refreshMapPersonLengthAndSort, required this.refreshListMapGroupLength,
    required this.directGoPageNum, required this.refreshDiaryUserData, required this.refreshMapRecentLength, required this.refreshMapDiaryLength, required this.RevealWindow});

  final setSettingPage;
  final reloadSetting;
  final int directGoPageNum;
  final RevealWindow;

  final refreshMapPersonLengthAndSort, refreshListMapGroupLength, refreshDiaryUserData, refreshMapRecentLength, refreshMapDiaryLength;

  @override
  State<SettingManagerWidget> createState() => _SettingManagerState();
}

enum Gender { Male, Female, None }

enum BirthCalendar { Yang, Uem, None }

//설졍 메인탭
class _SettingManagerState extends State<SettingManagerWidget> {
  double settingTextContainerHeight = 24;
  double settingButtonContainerHeight = 26;

  int koreanGanji = 0;

  bool isEditSetting = false;

  String GetNameText(String text){
    String nameText = '';
    int textLengthLimit = 10;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        break;
      }
      if(i+1 > text.length){
        break;
      }
      if(i > textLengthLimit){
        nameText = nameText+'..';
        break;
      }
      nameText = nameText + text.substring(i, i+1);
    }
    return nameText;
  }
  Text GetIlganText(int ilganNum){
    var textColor = style.SetOhengColor(true, ilganNum);
    return Text(style.stringCheongan[koreanGanji][ilganNum],
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: textColor, height: 1.1));
  }
  Text GetIljiText(int iljiNum){
    var textColor = style.SetOhengColor(false, iljiNum);
    return Text(style.stringJiji[koreanGanji][iljiNum],
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: textColor, height: 1.1));
  }

  Widget GetUserNameAndIljuTextWidget() {
    if (personalDataManager.mapUserData['name'] == null) {
      return Text('사용자 정보를 입력해 주세요',
          style: style.settingText0);
    } else {
      return Row(children: [
        Container(
            height: settingButtonContainerHeight,
            //color:Colors.green,
            child:Text("${GetNameText(personalDataManager.mapUserData['name'])}", style: style.settingText0)
        ),
        Text("(${personalDataManager.mapUserData['gender'] == true ? '남' : '여'}) ", style: style.settingText0),
        GetIlganText(personalDataManager.mapUserData['listPaljaData'][4]),
        GetIljiText(personalDataManager.mapUserData['listPaljaData'][5]),
        //Text("${personalDataManager.mapUserData['name']}",
        //    style: Theme.of(context).textTheme.labelMedium),
        //Text(
        //    "(${personalDataManager.mapUserData['gender'] == true ? '남' : '여'})",
        //    style: Theme.of(context).textTheme.titleSmall),
        //Text(
        //    " ${editingBirthDay.substring(0, 4)}.${editingBirthDay.substring(5, 7)}.${editingBirthDay.substring(8, 10)}",
        //    style: Theme.of(context).textTheme.labelMedium),
        //Text("${uemYangText}", style: Theme.of(context).textTheme.titleSmall),
        //Text(" ${birthTimeText}",
        //    style: Theme.of(context).textTheme.labelMedium),
      ]);
    }
  }

  Widget GetUserDataText() {
    if (personalDataManager.mapUserData['name'] != null){
      String uemYangText = '';
      if (personalDataManager.mapUserData['uemYang'] == 0) {
        uemYangText = '(양력)';
      } else if (personalDataManager.mapUserData['uemYang'] == 1) {
        uemYangText = '(음력)';
      } else {
        uemYangText = '(음력 윤달)';
      }
      String birthTimeText = '';
      if (personalDataManager.mapUserData['birthHour'] == 30) {
        birthTimeText = '시간 모름';
      } else {
        if (personalDataManager.mapUserData['birthHour'] < 10) {
          birthTimeText = '0${personalDataManager.mapUserData['birthHour']}';
        } else {
          birthTimeText = '${personalDataManager.mapUserData['birthHour']}';
        }

        if (personalDataManager.mapUserData['birthMin'] < 10) {
          birthTimeText = birthTimeText +
              ':0${personalDataManager.mapUserData['birthMin']}';
        } else {
          birthTimeText =
              birthTimeText + ':${personalDataManager.mapUserData['birthMin']}';
        }

        //썸머타임 조회
        if(personalDataManager.mapUserData['uemYang'] == 0) {
          if (findGanji.CheckSummerTime(personalDataManager.mapUserData['birthYear'], personalDataManager.mapUserData['birthMonth'], personalDataManager.mapUserData['birthDay'], personalDataManager.mapUserData['birthHour'], personalDataManager.mapUserData['birthMin']) == true) {
            birthTimeText = birthTimeText + ' (써머타임 -60분)';
          }
        } else {
          List<int> listYangBirth = findGanji.LunarToSolar(personalDataManager.mapUserData['birthYear'], personalDataManager.mapUserData['birthMonth'], personalDataManager.mapUserData['birthDay'], personalDataManager.mapUserData['uemYang'] == 1? false:true);
          if(findGanji.CheckSummerTime(listYangBirth[0], listYangBirth[1], listYangBirth[2], personalDataManager.mapUserData['birthHour'], personalDataManager.mapUserData['birthMin']) == true)
            birthTimeText = birthTimeText + ' (서머타임 -60분)';
        }
      }

      return Row(children: [
        Container(
            height: settingButtonContainerHeight,
          child:Text("${personalDataManager.mapUserData['birthYear']}년 ${personalDataManager.mapUserData['birthMonth']}월 ${personalDataManager.mapUserData['birthDay']}일", style: style.settingText0)),
        Container(
            height: settingButtonContainerHeight,
            child:Text("${uemYangText}", style: style.settingText0)),
        Container(
            height: settingButtonContainerHeight,
           child:Text(" ${birthTimeText}", style: style.settingText0)),
      ]);
    } else {
      return SizedBox.shrink();
    }
  }

  double widgetWidth = 500;
  double widgetHeight = 560+46+56;  //기본 사이즈 + 설정 공유 + 테마

  Widget nextPage = SizedBox.shrink();
  Widget backSpaceButton = SizedBox.shrink();

  Widget mainPage = SizedBox.shrink();
  Widget nowPage = SizedBox.shrink();

  SetNextPageWidget(int num, {bool isDirectGo = false}){ //0:처음으로, 1:사용자 설정, 2:단어, 3:만세력, 4:대운세운, 5:신살, 6:기타, 7:테마, 8:저장목록, 9:설정 공유
    setState(() {
      switch(num){
        case 0: {
          nextPage = SizedBox.shrink();
        }
        case 1: {
          nextPage = userDataWidget.UserDataWidget(diaryFirstSet: null, widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting, refreshDiaryUserData: widget.refreshDiaryUserData);
        }
        case 2: {
          nextPage = wordSettingWidget.WordSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
        }
        case 3: {
          nextPage = calendarSettingWidget.CalendarSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
        }
        case 4: {
          nextPage = deunSeunSettingWidget.DeunSeunSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
        }
        case 5: {
          nextPage = sinsalSettingWidget.SinsalSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
        }
        case 6: {
          nextPage = etcSettingWidget.EtcSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
        }
        case 7: {
          nextPage = themeSettingWidget.ThemeSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting, RevealWindow: widget.RevealWindow);
        }
        case 8: {
          nextPage = dataManageWidget.DataManageWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort, refreshListMapGroupLength: widget.refreshListMapGroupLength,);
        }
        case 9: {
          nextPage = shareSettingValWidget.ShareSettingValWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
        }
        case 10: {
          nextPage = resetSettingWidget.ResetSettingWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting, refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort,
            refreshListMapGroupLength: widget.refreshListMapGroupLength, refreshMapRecentLength: widget.refreshMapRecentLength, refreshMapDiaryLength: widget.refreshMapDiaryLength, refreshDiaryUserData: widget.refreshDiaryUserData,);
        }
      }
      if(num == 0){
        SetBackSpaceButtonWidget(false);
        koreanGanji = ((personalDataManager.etcData % 1000) / 100).floor() - 1;

        mainPage = Container(
          width: widgetWidth,
          height: widgetHeight,
          margin: EdgeInsets.only(top: 8, bottom:8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(  //사용자 카테고리 텍스트
                    height: settingTextContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(left: style.UIMarginLeft, top:style.UIMarginTopTop-8),
                    child: Text("개인 설정", style: style.settingInfoText0),  //"사용자"
                  ),
                  Container(  //사용자 버튼
                    height: settingButtonContainerHeight*2,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo,left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(1);
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent),
                              foregroundColor: style.colorBackGround,
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Column(
                            children: [
                              Container(
                                height: settingButtonContainerHeight,//style.saveDataNameLineHeight,
                                //color:Colors.yellow,
                                //padding: EdgeInsets.only(top: 6),
                                child: GetUserNameAndIljuTextWidget(),//GetUserDataText()
                              ),
                              Container(
                                  height: settingButtonContainerHeight,//style.saveDataNameLineHeight,
                                  //color:Colors.yellow,
                                  //padding: EdgeInsets.only(top: 6),
                                  child: GetUserDataText()
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                /*
                Container(  //테마
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop,left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(7);
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent),
                              foregroundColor: style.colorBackGround,
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('테마',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  */
                  Container(
                    //만세력 카테고리 텍스트
                    height: settingTextContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop,left: style.UIMarginLeft),
                    child: Text("만세력",
                        style: style.settingInfoText0),
                  ),
                  Container(
                    //단어 설정 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo,left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(2);
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.transparent),
                              foregroundColor: style.colorBackGround,
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('단어 설정',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //만세력 보기 설정 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(3);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('만세력',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  //Container(
                  //  //궁합 보기 설정 버튼
                  //  height: settingButtonContainerHeight,
                  //  width: (MediaQuery.of(context).size.width -
                  //      (style.UIMarginLeft * 2)),
                  //  margin: EdgeInsets.only(top: style.SettingMarginTop),
                  //  child: Stack(
                  //    children: [
                  //      OutlinedButton(
                  //        onPressed: () {},
                  //        style: OutlinedButton.styleFrom(
                  //            foregroundColor: style.colorBackGround,
                  //            side: BorderSide(color: Colors.transparent),
                  //            padding: EdgeInsets.only(left: 0),
                  //            fixedSize: Size.fromWidth(
                  //                MediaQuery.of(context).size.width -
                  //                    (style.UIMarginLeft * 2)),
                  //            alignment: Alignment.centerLeft),
                  //        child: Text('궁합',
                  //            style: style.settingText0),
                  //      ),
                  //    ],
                  //  ),
                  //),
                  Container(  //대운세운 보기 설정 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(4);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('대운과 세운',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  Container(  //신살 보기 설정 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(5);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('신살',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  Container(  //기타 설정 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(6);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('기타',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //데이터 전송 카테고리 텍스트
                    height: settingTextContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                    child: Text("데이터",
                        style: style.settingInfoText0),
                  ),
                  Container(  //저장 목록 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo, left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(8);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('저장 목록',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  Container(  //설정 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(9);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('설정 공유',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                  Container(  //초기화 버튼
                    height: settingButtonContainerHeight,
                    width: widgetWidth,
                    margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft, bottom: style.UIMarginTopTop),
                    child: Stack(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            SetNextPageWidget(10);
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: style.colorBackGround,
                              side: BorderSide(color: Colors.transparent),
                              padding: EdgeInsets.only(left: 0),
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width -
                                      (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerLeft),
                          child: Text('데이터 초기화',
                              style: style.settingText0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        nowPage = mainPage;
      } else {
        if(isDirectGo == false) {
          SetBackSpaceButtonWidget(true);
        }
        nowPage = nextPage;
      }
    });
  }

  SetBackSpaceButtonWidget(bool onOff){
    if(onOff == true){
      backSpaceButton =
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(left:10, top:12),
            child: ElevatedButton(
              onPressed: () {
                SetNextPageWidget(0);
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent),
              child: Icon(Icons.arrow_back, color:Colors.white),//Text('←', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          );
    } else {
      backSpaceButton = SizedBox.shrink();
    }
  }

  @override
  initState(){
    super.initState();

    koreanGanji = ((personalDataManager.etcData % 1000) / 100).floor() - 1;
  }

  @override
  void didChangeDependencies() {

    mainPage = Container(
      width: widgetWidth,
      height: widgetHeight,
      margin: EdgeInsets.only(top: 8, bottom:8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(style.textFiledRadius),
      ),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(  //사용자 카테고리 텍스트
                height: settingTextContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(left: style.UIMarginLeft, top:style.UIMarginTopTop - 8),
                child: Text("개인 설정", style: style.settingInfoText0),  //"사용자"
              ),
              Container(  //사용자 버튼
                height: settingButtonContainerHeight*2,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo,left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(1);
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.transparent),
                          foregroundColor: style.colorBackGround,
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Column(
                        children: [
                          Container(
                              height: settingButtonContainerHeight,//style.saveDataNameLineHeight,
                              //color:Colors.yellow,
                              //padding: EdgeInsets.only(top: 6),
                              child: GetUserNameAndIljuTextWidget(),//GetUserDataText()
                          ),
                          Container(
                            height: settingButtonContainerHeight,//style.saveDataNameLineHeight,
                            //color:Colors.yellow,
                            //padding: EdgeInsets.only(top: 6),
                            child: GetUserDataText()
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*
              Container(  //테마
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop,left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(7);
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.transparent),
                          foregroundColor: style.colorBackGround,
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('테마',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              */
              Container(
                //만세력 카테고리 텍스트
                height: settingTextContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop,left: style.UIMarginLeft),
                child: Text("만세력",
                    style: style.settingInfoText0),
              ),
              Container(
                //단어 설정 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo,left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(2);
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.transparent),
                          foregroundColor: style.colorBackGround,
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('단어 설정',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              Container(
                //만세력 보기 설정 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(3);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('만세력',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              //Container(
              //  //궁합 보기 설정 버튼
              //  height: settingButtonContainerHeight,
              //  width: (MediaQuery.of(context).size.width -
              //      (style.UIMarginLeft * 2)),
              //  margin: EdgeInsets.only(top: style.SettingMarginTop),
              //  child: Stack(
              //    children: [
              //      OutlinedButton(
              //        onPressed: () {},
              //        style: OutlinedButton.styleFrom(
              //            foregroundColor: style.colorBackGround,
              //            side: BorderSide(color: Colors.transparent),
              //            padding: EdgeInsets.only(left: 0),
              //            fixedSize: Size.fromWidth(
              //                MediaQuery.of(context).size.width -
              //                    (style.UIMarginLeft * 2)),
              //            alignment: Alignment.centerLeft),
              //        child: Text('궁합',
              //            style: style.settingText0),
              //      ),
              //    ],
              //  ),
              //),
              Container(  //대운세운 보기 설정 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(4);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('대운과 세운',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              Container(  //신살 보기 설정 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(5);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('신살',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              Container(  //기타 설정 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(6);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('기타',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              Container(
                //데이터 전송 카테고리 텍스트
                height: settingTextContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                child: Text("데이터",
                    style: style.settingInfoText0),
              ),
              Container(  //저장 목록 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo, left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(8);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('저장 목록',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              Container(  //설정 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(9);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('설정 공유',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
              Container(  //초기화 버튼
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTop, left: style.UIMarginLeft, bottom: style.UIMarginTopTop - 8),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        SetNextPageWidget(10);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('데이터 초기화',
                          style: style.settingText0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if(widget.directGoPageNum == 0) {
      nowPage = mainPage;
    } else {
      SetNextPageWidget(widget.directGoPageNum, isDirectGo: true);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height - style.appBarHeight <= 560){
      widgetHeight = MediaQuery.of(context).size.height - 120;
    }

    return Container(
      width: widgetWidth,
      height: widgetHeight,
      decoration: BoxDecoration(
        color: style.colorBackGround.withOpacity(0.98),
        borderRadius: BorderRadius.circular(style.textFiledRadius),
      ),
      child: Stack(
        children:
        [
          nowPage,
          Container(
            width: widgetWidth,
            height: widgetHeight,
            child: Container(  //끄기 버튼
                width: widgetWidth,
                height: style.UIMarginTopTop,
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backSpaceButton,
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(top: 12,right:10),
                      child: ElevatedButton(
                        onPressed: () {
                          if(widget.directGoPageNum == 0) {
                            widget.setSettingPage();
                          } else {
                            widget.setSettingPage(isCompulsionClose:true);
                          }
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}

class BirthSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 4 ||
        newValue.selection.baseOffset == 7) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}

class HourSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 2) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
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
