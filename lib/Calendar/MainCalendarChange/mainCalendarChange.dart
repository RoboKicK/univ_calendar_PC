import 'dart:ui';

import 'package:flutter/material.dart';
import 'mainCalendarFindGanjiChange.dart' as mainCalendarFindGanjiChange;
import '../../style.dart' as style;

class MainCalendarChange extends StatefulWidget {
  const MainCalendarChange({super.key, required this.SetInquireInfo, required this.SetCalendarResultWidget});

  final SetInquireInfo;
  final SetCalendarResultWidget;
  @override
  State<MainCalendarChange> createState() => _MainCalendarChangeState();
}

class _MainCalendarChangeState extends State<MainCalendarChange> {
  double exampleBoxSize = 124; //116;

  double cheonganMarjinVal = 0;
  double jijiMarjinVal = 0;

  BoxDecoration ohengDeco = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(style.textFiledRadius));
  BoxDecoration ohengDecoSteel = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(style.textFiledRadius));

  int nowButtonNum = 0;
  int showCheonganOrJiji = 0;
  double buttonPaddingVal = 4; //10;
  double unknownPaddingVal = 15;

  Color baseColor = Colors.black38;

  List<Color> _listOhengBoxColor = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  List<Color> _listOhengTextColor = [style.colorBlack, style.colorBlack, style.colorBlack, style.colorBlack, style.colorBlack, style.colorBlack];
  List<String> _listOhengText = ['-', '-', '-', '-', '-', '-'];
  List<Color> _listSelectedBoxColor = [style.colorMainBlue, Colors.black38, Colors.black38, Colors.black38, Colors.black38, Colors.black38];
  List<double> _listButtonPaddingVal = [0, 0, 0, 0, 0, 0]; // = [16, 16, 16, 16, 16, 16];
  List<int> _listSelectedButtonNum = [-2, -2, -2, -2, -2, -2];

  List<List<int>> listGanjiChangeResult = [];
  List<Container> listGanjiChangeResultButton = [];

  //선택할 오행 버튼을 눌럿을 때
  TapButton(int buttonNum) {
    if (buttonNum == nowButtonNum) return;

    if (buttonNum == 0 || buttonNum == 3) {
      //천간을 선택함
      showCheonganOrJiji = 0;
    } else {
      showCheonganOrJiji = 1;
    }

    _listSelectedBoxColor[nowButtonNum] = Colors.transparent;
    _listSelectedBoxColor[buttonNum] = style.colorMainBlue;

    nowButtonNum = buttonNum;
  }

  //보기에서 오행 버튼을 선택했을 때
  TapExampleButton(int buttonNum) {
    if (nowButtonNum == 0 || nowButtonNum == 3) {
      //천간 선택할 때
      _listOhengBoxColor[nowButtonNum] = style.SetOhengColor(true, buttonNum); //박스 컬러 변경

      if (buttonNum == 6 || buttonNum == 7) //텍스트 컬러 변경
        _listOhengTextColor[nowButtonNum] = style.colorBlack;
      else
        _listOhengTextColor[nowButtonNum] = Colors.white;

      _listOhengText[nowButtonNum] = style.stringCheongan[style.uemYangStringTypeNum][buttonNum];
    } else {
      //지지 선택할 때
      _listOhengBoxColor[nowButtonNum] = style.SetOhengColor(false, buttonNum); //박스 컬러 변경

      if (buttonNum == 8 || buttonNum == 9) //텍스트 컬러 변경
        _listOhengTextColor[nowButtonNum] = style.colorBlack;
      else
        _listOhengTextColor[nowButtonNum] = Colors.white;

      _listOhengText[nowButtonNum] = style.stringJiji[style.uemYangStringTypeNum][buttonNum];
    }

    _listButtonPaddingVal[nowButtonNum] = buttonPaddingVal;

    _listSelectedButtonNum[nowButtonNum] = buttonNum;
    if (nowButtonNum < 5) {
      TapButton(nowButtonNum + 1);
    }
  }

  //시지 모름 버튼
  UnknownSiji() {
    _listOhengBoxColor[5] = Colors.white;
    _listOhengTextColor[5] = style.colorBlack;
    _listOhengText[5] = '?';
    _listButtonPaddingVal[5] = 0; //unknownPaddingVal;
    _listSelectedButtonNum[5] = -2;
  }

  ResetAll() {
    for (int i = 0; i < 6; i++) {
      _listOhengBoxColor[i] = Colors.white;
      _listOhengTextColor[i] = style.colorBlack;
      _listOhengText[i] = '-';
      _listButtonPaddingVal[i] = 0;
      _listSelectedButtonNum[i] = -2;
      if (i == 0)
        _listSelectedBoxColor[i] = style.colorMainBlue;
      else
        _listSelectedBoxColor[i] = baseColor;
    }

    showCheonganOrJiji = 0;
    nowButtonNum = 0;

    listGanjiChangeResult.clear();
    listGanjiChangeResultButton.clear();
  } //초기화 버튼

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

  bool InquireConditionChecker() {
    //모두 선택했는지 확인
    if (_listSelectedButtonNum[0] == -2) {
      ShowDialogMessage('연간을 선택해주세요');
      return false;
    } else if (_listSelectedButtonNum[1] == -2) {
      ShowDialogMessage('연지를 선택해주세요');
      return false;
    } else if (_listSelectedButtonNum[2] == -2) {
      ShowDialogMessage('월지를 선택해주세요');
      return false;
    } else if (_listSelectedButtonNum[3] == -2) {
      ShowDialogMessage('일간을 선택해주세요');
      return false;
    } else if (_listSelectedButtonNum[4] == -2) {
      ShowDialogMessage('일지를 선택해주세요');
      return false;
    }

    //음양을 같게 선택했는지 확인
    for (int i = 0; i < 4; i = i + 3) {
      if (_listSelectedButtonNum[i] % 2 == 0) {
        //천간을 양으로 선택했을 때
        if (_listSelectedButtonNum[i + 1] % 2 != 0) {
          //지지가 양이 아니면
          if (i == 0) {
            ShowDialogMessage('연주를 올바르게 선택해주세요');
          } else {
            ShowDialogMessage('일주를 올바르게 선택해주세요');
          }
          return false;
        }
      } else {
        //천간을 음으로 선택했을 때
        if (_listSelectedButtonNum[i + 1] % 2 != 1) {
          if (i == 0) {
            ShowDialogMessage('연주를 올바르게 선택해주세요');
          } else {
            ShowDialogMessage('일주를 올바르게 선택해주세요');
          }
          return false;
        }
      }
    }

    return true;
  }

  SetGanjiChangeResultButtons() {
    listGanjiChangeResult.clear();
    listGanjiChangeResult = mainCalendarFindGanjiChange.MainCalendarFindGanjiChange().FindGanjiChange(_listSelectedButtonNum);

    if (listGanjiChangeResult.length == 0) {
      ShowDialogMessage('조회 결과가 없습니다');
      listGanjiChangeResultButton.clear();
      return;
    }

    double containerHeight;

    listGanjiChangeResultButton.clear();
    for (int i = 0; i < listGanjiChangeResult.length; i++) {
      if (i == 0) {
        containerHeight = style.UIButtonPaddingTop;
      } else {
        containerHeight = style.UIMarginTop;
      }
      listGanjiChangeResultButton.add(
        Container(
          //조회 버튼
          width: style.UIButtonWidth,
          height: style.fullSizeButtonHeight,
          margin: EdgeInsets.only(top: containerHeight),
          decoration: BoxDecoration(
            color: style.colorMainBlue,
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          child: TextButton(
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Text(
              GetGanjiChangeResultButtonText(listGanjiChangeResult[i]),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    //title: Text('성별을 선택해 주세요'),
                    content: Text('성별을 선택해 주세요', textAlign: TextAlign.center),
                    buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.SetInquireInfo('이름 없음', true, 0, listGanjiChangeResult[i][0], listGanjiChangeResult[i][1], listGanjiChangeResult[i][2], listGanjiChangeResult[i][3],
                              listGanjiChangeResult[i][4], '', '');
                          widget.SetCalendarResultWidget();
                        },
                        child: Text('남자'),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.SetInquireInfo('이름 없음', false, 0, listGanjiChangeResult[i][0], listGanjiChangeResult[i][1], listGanjiChangeResult[i][2], listGanjiChangeResult[i][3],
                                listGanjiChangeResult[i][4], '', '');
                            widget.SetCalendarResultWidget();
                          },
                          child: Text('여자')),
                    ],
                  ),
                );
              });
            },
          ),
        ),
      );
    }
  }

  String GetGanjiChangeResultButtonText(List<int> listBirth) {
    String text = '';

    text = '${listBirth[0]}년 ${listBirth[1]}월 ${listBirth[2]}일 ';
    if (listBirth[3] == -2) {
      text = text + '시간 모름';
    } else {
      text = text + style.stringJiji[style.uemYangStringTypeNum][((((listBirth[3] + ((listBirth[4] + 30) / 60)) / 2).floor()) % style.stringJiji[0].length).floor()] + '시';
    }

    return text;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: style.UIButtonWidth,
                height: style.UIBoxLineHeight,
                margin: EdgeInsets.only(top: style.UIMarginTopTop),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('시', style: Theme.of(context).textTheme.titleSmall),
                    Text('일', style: Theme.of(context).textTheme.titleSmall),
                    Text('월', style: Theme.of(context).textTheme.titleSmall),
                    Text('연', style: Theme.of(context).textTheme.titleSmall),
                  ],
                )), //연월일시
            Container(
                width: style.UIButtonWidth,
                height: style.UIPaljaBoxHeight,
                decoration: BoxDecoration(
                  color: style.colorBoxGray1,
                ),
                child: Column(
                  children: [
                    Row(
                      //천간
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          //시지 모름 버튼
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight + style.UIOhengMarginTop * 1.4 + style.UIOhengMarginTop,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: style.fullSizeButtonHeight * 0.8,
                            height: style.fullSizeButtonHeight * 0.8,
                            decoration: BoxDecoration(
                              boxShadow: [style.uiDeunSeunShadow],
                              color: style.colorBlack,
                              borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorBlack,
                                padding: EdgeInsets.all(0),
                              ),
                              child: Align(alignment: Alignment.center, child: Text('?', style: TextStyle(fontSize: 20, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  UnknownSiji();
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 1.4, top: style.UIOhengMarginTop),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            border: Border.all(width: 2, color: _listSelectedBoxColor[3]), //style.colorMainBlue),
                            color: _listOhengBoxColor[3],
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _listOhengBoxColor[3],
                              padding: EdgeInsets.only(bottom: _listButtonPaddingVal[3]),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(_listOhengText[3], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: _listOhengTextColor[3]))),
                            onPressed: () {
                              setState(() {
                                TapButton(3);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                        ), //여백
                        Container(
                          //연간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 1.4, top: style.UIOhengMarginTop),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            border: Border.all(width: 2, color: _listSelectedBoxColor[0]), //style.colorMainBlue),
                            color: _listOhengBoxColor[0],
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _listOhengBoxColor[0],
                              padding: EdgeInsets.only(bottom: _listButtonPaddingVal[0]),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(_listOhengText[0], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: _listOhengTextColor[0]))),
                            onPressed: () {
                              setState(() {
                                TapButton(0);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          //시지
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop), //* 1.4),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            border: Border.all(width: 2, color: _listSelectedBoxColor[5]), //style.colorMainBlue),
                            color: _listOhengBoxColor[5],
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _listOhengBoxColor[5],
                              padding: EdgeInsets.only(bottom: _listButtonPaddingVal[5]),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(_listOhengText[5], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: _listOhengTextColor[5]))),
                            onPressed: () {
                              setState(() {
                                TapButton(5);
                              });
                            },
                          ),
                        ),
                        Container(
                          //일지
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop), //* 1.4),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            border: Border.all(width: 2, color: _listSelectedBoxColor[4]), //style.colorMainBlue),
                            color: _listOhengBoxColor[4],
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _listOhengBoxColor[4],
                              padding: EdgeInsets.only(bottom: _listButtonPaddingVal[4]),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(_listOhengText[4], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: _listOhengTextColor[4]))),
                            onPressed: () {
                              setState(() {
                                TapButton(4);
                              });
                            },
                          ),
                        ),
                        Container(
                          //월지
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop), //* 1.4),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            border: Border.all(width: 2, color: _listSelectedBoxColor[2]), //style.colorMainBlue),
                            color: _listOhengBoxColor[2],
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _listOhengBoxColor[2],
                              padding: EdgeInsets.only(bottom: _listButtonPaddingVal[2]),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(_listOhengText[2], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: _listOhengTextColor[2]))),
                            onPressed: () {
                              setState(() {
                                TapButton(2);
                              });
                            },
                          ),
                        ),
                        Container(
                          //연지
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop), //* 1.4),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            border: Border.all(width: 2, color: _listSelectedBoxColor[1]), //style.colorMainBlue),
                            color: _listOhengBoxColor[1],
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _listOhengBoxColor[1],
                              padding: EdgeInsets.only(bottom: _listButtonPaddingVal[1]),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(_listOhengText[1], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: _listOhengTextColor[1]))),
                            onPressed: () {
                              setState(() {
                                TapButton(1);
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )), //천간,지지 버튼
            Container(
                width: style.UIButtonWidth,
                height: exampleBoxSize,
                //margin: EdgeInsets.only(left: style.UIMarginLeft),
                decoration: BoxDecoration(
                  color: style.colorBoxGray0,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(style.textFiledRadius), bottomRight: Radius.circular(style.textFiledRadius)),
                ),
                child: Column(
                  children: [
                    [
                      Row(
                        //천간
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop, left: cheonganMarjinVal),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorGreen,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorGreen,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][0], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(0);
                                });
                              },
                            ),
                          ),
                          Container(
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorGreen,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorGreen,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][1], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(1);
                                });
                              },
                            ),
                          ),
                          Container(
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorRed,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorRed,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][2], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(2);
                                });
                              },
                            ),
                          ),
                          Container(
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorRed,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorRed,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][3], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(3);
                                });
                              },
                            ),
                          ),
                          Container(
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop, right: cheonganMarjinVal),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorYellow,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorYellow,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][4], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(4);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                          //지지
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: style.fullSizeButtonHeight,
                              height: style.fullSizeButtonHeight,
                              margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop, left: jijiMarjinVal),
                              decoration: BoxDecoration(
                                boxShadow: [style.uiOhengShadow],
                                color: style.colorBlack,
                                borderRadius: BorderRadius.circular(style.textFiledRadius),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: style.colorBlack,
                                  padding: EdgeInsets.only(bottom: buttonPaddingVal),
                                ),
                                child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][0], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                                onPressed: () {
                                  setState(() {
                                    TapExampleButton(0);
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: style.fullSizeButtonHeight,
                              height: style.fullSizeButtonHeight,
                              margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                              decoration: BoxDecoration(
                                boxShadow: [style.uiOhengShadow],
                                color: style.colorYellow,
                                borderRadius: BorderRadius.circular(style.textFiledRadius),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: style.colorYellow,
                                  padding: EdgeInsets.only(bottom: buttonPaddingVal),
                                ),
                                child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][1], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                                onPressed: () {
                                  setState(() {
                                    TapExampleButton(1);
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: style.fullSizeButtonHeight,
                              height: style.fullSizeButtonHeight,
                              margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                              decoration: BoxDecoration(
                                boxShadow: [style.uiOhengShadow],
                                color: style.colorGreen,
                                borderRadius: BorderRadius.circular(style.textFiledRadius),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: style.colorGreen,
                                  padding: EdgeInsets.only(bottom: buttonPaddingVal),
                                ),
                                child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][2], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                                onPressed: () {
                                  setState(() {
                                    TapExampleButton(2);
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: style.fullSizeButtonHeight,
                              height: style.fullSizeButtonHeight,
                              margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                              decoration: BoxDecoration(
                                boxShadow: [style.uiOhengShadow],
                                color: style.colorGreen,
                                borderRadius: BorderRadius.circular(style.textFiledRadius),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: style.colorGreen,
                                  padding: EdgeInsets.only(bottom: buttonPaddingVal),
                                ),
                                child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][3], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                                onPressed: () {
                                  setState(() {
                                    TapExampleButton(3);
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: style.fullSizeButtonHeight,
                              height: style.fullSizeButtonHeight,
                              margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                              decoration: BoxDecoration(
                                boxShadow: [style.uiOhengShadow],
                                color: style.colorYellow,
                                borderRadius: BorderRadius.circular(style.textFiledRadius),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: style.colorYellow,
                                  padding: EdgeInsets.only(bottom: buttonPaddingVal),
                                ),
                                child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][4], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                                onPressed: () {
                                  setState(() {
                                    TapExampleButton(4);
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: style.fullSizeButtonHeight,
                              height: style.fullSizeButtonHeight,
                              margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop, right: jijiMarjinVal),
                              decoration: BoxDecoration(
                                boxShadow: [style.uiOhengShadow],
                                color: style.colorRed,
                                borderRadius: BorderRadius.circular(style.textFiledRadius),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: style.colorRed,
                                  padding: EdgeInsets.only(bottom: buttonPaddingVal),
                                ),
                                child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][5], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                                onPressed: () {
                                  setState(() {
                                    TapExampleButton(5);
                                  });
                                },
                              ),
                            ),
                          ]),
                    ][showCheonganOrJiji],
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            //일간
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop, left: cheonganMarjinVal),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorYellow,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorYellow,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][5], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(5);
                                });
                              },
                            ),
                          ),
                          Container(
                            //일간
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][6], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: style.colorBlack))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(6);
                                });
                              },
                            ),
                          ),
                          Container(
                            //일간
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][7], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: style.colorBlack))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(7);
                                });
                              },
                            ),
                          ),
                          Container(
                            //일간
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorBlack,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorBlack,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][8], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(8);
                                });
                              },
                            ),
                          ),
                          Container(
                            //일간
                            width: style.fullSizeButtonHeight,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop, right: cheonganMarjinVal),
                            decoration: BoxDecoration(
                              boxShadow: [style.uiOhengShadow],
                              color: style.colorBlack,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: style.colorBlack,
                                padding: EdgeInsets.only(bottom: buttonPaddingVal),
                              ),
                              child: Align(alignment: Alignment.center, child: Text(style.stringCheongan[style.uemYangStringTypeNum][9], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                              onPressed: () {
                                setState(() {
                                  TapExampleButton(9);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop, left: jijiMarjinVal),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            color: style.colorRed,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: style.colorRed,
                              padding: EdgeInsets.only(bottom: buttonPaddingVal),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][6], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                            onPressed: () {
                              setState(() {
                                TapExampleButton(6);
                              });
                            },
                          ),
                        ),
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            color: style.colorYellow,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
        foregroundColor: style.colorYellow,
                              padding: EdgeInsets.only(bottom: buttonPaddingVal),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][7], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                            onPressed: () {
                              setState(() {
                                TapExampleButton(7);
                              });
                            },
                          ),
                        ),
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
        foregroundColor: Colors.white,
                              padding: EdgeInsets.only(bottom: buttonPaddingVal),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][8], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: style.colorBlack))),
                            onPressed: () {
                              setState(() {
                                TapExampleButton(8);
                              });
                            },
                          ),
                        ),
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
        foregroundColor: Colors.white,
                              padding: EdgeInsets.only(bottom: buttonPaddingVal),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][9], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: style.colorBlack))),
                            onPressed: () {
                              setState(() {
                                TapExampleButton(9);
                              });
                            },
                          ),
                        ),
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            color: style.colorYellow,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
        foregroundColor: style.colorYellow,
                              padding: EdgeInsets.only(bottom: buttonPaddingVal),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][10], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                            onPressed: () {
                              setState(() {
                                TapExampleButton(10);
                              });
                            },
                          ),
                        ),
                        Container(
                          //일간
                          width: style.fullSizeButtonHeight,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.7, top: style.UIOhengMarginTop, right: jijiMarjinVal),
                          decoration: BoxDecoration(
                            boxShadow: [style.uiOhengShadow],
                            color: style.colorBlack,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                            foregroundColor: style.colorBlack,
                              padding: EdgeInsets.only(bottom: buttonPaddingVal),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(style.stringJiji[style.uemYangStringTypeNum][11], style: TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: Colors.white))),
                            onPressed: () {
                              setState(() {
                                TapExampleButton(11);
                              });
                            },
                          ),
                        ),
                      ]),
                    ][showCheonganOrJiji],
                  ],
                )), //보기 버튼들
            /*Container(
              height:resultBoxHeight,
            ), //여백
             */
            Column(
              children: listGanjiChangeResultButton,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //조회 버튼
                  width: style.UIButtonWidth - style.fullSizeButtonHeight - style.UIMarginTop,
                  height: style.fullSizeButtonHeight,
                  margin: EdgeInsets.only(top: style.UIButtonPaddingTop, bottom: style.UIButtonPaddingTop),
                  decoration: BoxDecoration(
                    color: style.colorMainBlue,
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: TextButton(
                    style:TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    ),
                    child: Text(
                      '조회',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        if (InquireConditionChecker() == true) {
                          SetGanjiChangeResultButtons();
                        }
                      });
                    },
                  ),
                ),
                Container(
                  //리셋 버튼
                  width: style.fullSizeButtonHeight,
                  height: style.fullSizeButtonHeight,
                  margin: EdgeInsets.only(left: style.UIMarginLeft, top: style.UIButtonPaddingTop, bottom: style.UIButtonPaddingTop),
                  decoration: BoxDecoration(
                    color: style.colorMainBlue,
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: ElevatedButton(
                    style:  ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                      overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                      elevation: MaterialStatePropertyAll(0),
                    ),
                    child:Icon(Icons.recycling),
                    onPressed: () {
                      setState(() {
                        ResetAll();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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