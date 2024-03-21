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

class SettingManagerWidget extends StatefulWidget {
  const SettingManagerWidget({super.key, required this.setSettingPage, required this.reloadSetting});

  final setSettingPage;
  final reloadSetting;

  @override
  State<SettingManagerWidget> createState() => _SettingManagerState();
}

enum Gender { Male, Female, None }

enum BirthCalendar { Yang, Uem, None }

//설졍 메인탭
class _SettingManagerState extends State<SettingManagerWidget> {
  double settingTextContainerHeight = 24;
  double settingButtonContainerHeight = 26;

  String GetNameText(String text){
    String nameText = '';
    int textLengthLimit = 6;
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

  Widget GetUserDataText() {
    if (personalDataManager.mapUserData['name'] == null) {
      return Text('사용자 정보를 입력해 주세요',
          style: style.settingText0);
    } else {
      String year = '';
      if (personalDataManager.mapUserData['birthYear'] < 10) {
        year = '000${personalDataManager.mapUserData['birthYear']}';
      } else if (personalDataManager.mapUserData['birthYear'] < 100) {
        year = '00${personalDataManager.mapUserData['birthYear']}';
      } else if (personalDataManager.mapUserData['birthYear'] < 10) {
        year = '0${personalDataManager.mapUserData['birthYear']}';
      } else {
        year = '${personalDataManager.mapUserData['birthYear']}';
      }
      String month = '';
      if (personalDataManager.mapUserData['birthMonth'] < 10) {
        month = '0${personalDataManager.mapUserData['birthMonth']}';
      } else {
        month = '${personalDataManager.mapUserData['birthMonth']}';
      }
      String day = '';
      if (personalDataManager.mapUserData['birthDay'] < 10) {
        day = '0${personalDataManager.mapUserData['birthDay']}';
      } else {
        day = '${personalDataManager.mapUserData['birthDay']}';
      }

      String editingBirthDay = '${year} ${month} ${day}';
      String uemYangText = '';
      if (personalDataManager.mapUserData['uemYang'] == 0) {
        uemYangText = '(양력)';
      } else if (personalDataManager.mapUserData['uemYang'] == 1) {
        uemYangText = '(음력)';
      } else {
        uemYangText = '(음력 윤달)';
      }
      String birthTimeText = '';
      if (personalDataManager.mapUserData['birthHour'] == -2) {
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
      }

      return Row(children: [
        Container(
            height: settingButtonContainerHeight,
            //color:Colors.green,
            child:Text("${GetNameText(personalDataManager.mapUserData['name'])}", style: style.settingText0)
        ),
        Container(
            height: settingButtonContainerHeight,
            //color:Colors.green,
            //padding:EdgeInsets.only(top:7),
            child:Text("(${personalDataManager.mapUserData['gender'] == true ? '남' : '여'})", style: style.settingText0)),
        Container(
            height: settingButtonContainerHeight,
            //alignment: Alignment.bottomCenter,
            //  color:Colors.grey,
            //padding:EdgeInsets.only(top:2),
            child:Text(" ${editingBirthDay.substring(0, 4)}.${editingBirthDay.substring(5, 7)}.${editingBirthDay.substring(8, 10)}", style: style.settingText0)),
        Container(
            height: settingButtonContainerHeight,
            //color:Colors.red,
            //padding:EdgeInsets.only(top:7),
            child:Text("${uemYangText}", style: style.settingText0)),
        Container(
            height: settingButtonContainerHeight,
            //alignment: Alignment.bottomCenter,
            //color:Colors.blue,
            //padding:EdgeInsets.only(top:personalDataManager.mapUserData['birthHour']==-2?1:2),
            child:Text(" ${birthTimeText}", style: style.settingText0)),
      ]);
    }
  }

  double widgetWidth = 600;
  double widgetHeight = 560;

  Widget nextPage = SizedBox.shrink();
  Widget backSpaceButton = SizedBox.shrink();

  Widget mainPage = SizedBox.shrink();
  Widget nowPage = SizedBox.shrink();

  SetNextPageWidget(int num){ //0:처음으로, 1:사용자 설정, 2:단어, 3:만세력, 4:대운세운, 5:신살, 6:기타
    setState(() {
      switch(num){
        case 0: {
          nextPage = SizedBox.shrink();
        }
        case 1: {
          nextPage = userDataWidget.UserDataWidget(diaryFirstSet: null, widgetWidth: widgetWidth, widgetHeight: widgetHeight, reloadSetting: widget.reloadSetting);
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
      }
      if(num == 0){
        SetBackSpaceButtonWidget(false);
        nowPage = mainPage;
      } else {
        SetBackSpaceButtonWidget(true);
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
            margin: EdgeInsets.only(left:6, top:6),
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
  }

  @override
  void didChangeDependencies() {

    mainPage = Container(width: widgetWidth,
      height: widgetHeight,
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
                margin: EdgeInsets.only(left: style.UIMarginLeft, top:style.UIMarginTopTop),
                child: Text("사용자", style: style.settingInfoText0),
              ),
              Container(  //사용자 버튼
                height: settingButtonContainerHeight,
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
                      child: Container(
                          height: settingButtonContainerHeight,//style.saveDataNameLineHeight,
                          //color:Colors.yellow,
                          //padding: EdgeInsets.only(top: 6),
                          child: GetUserDataText()
                      ),
                    ),
                  ],
                ),
              ),
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
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
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
                child: Text("데이터 전송",
                    style: style.settingInfoText0),
              ),
              Container(
                height: settingButtonContainerHeight,
                width: widgetWidth,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo, left: style.UIMarginLeft, bottom: style.UIMarginTopTop),
                child: Stack(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          foregroundColor: style.colorBackGround,
                          side: BorderSide(color: Colors.transparent),
                          padding: EdgeInsets.only(left: 0),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width -
                                  (style.UIMarginLeft * 2)),
                          alignment: Alignment.centerLeft),
                      child: Text('저장 목록 전송',
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
                      margin: EdgeInsets.only(top: 6,right:6),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.setSettingPage();
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
