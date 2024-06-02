import 'package:flutter/material.dart';
import '../../style.dart' as style;

class Sibiunseong{  //12운성 계산해주는 클래스
  List<String> list12UnseongText = ['태','양','장생','목욕','관대','건록','제왕','쇠','병','사','묘','절'];

  String Find12Unseong(int jijiNum, int ilganNum){
    int textNum = 0;

    int startNum  = 0;

    switch(ilganNum){
      case 0:{
        startNum = 3;
        break;
      }
      case 1:{
        startNum = 8;
        break;
      }
      case 2:{
        startNum = 0;
        break;
      }case 3:{
      startNum = 11;
      break;
    }case 4:{
      startNum = 0;
      break;
    }case 5:{
      startNum = 11;
      break;
    }case 6:{
      startNum = 9;
      break;
    }case 7:{
      startNum = 2;
      break;
    }case 8:{
      startNum = 6;
      break;
    }case 9:{
      startNum = 5;
      break;
    }
      default:
        break;
    }

    if(ilganNum % 2 == 0){    //양일간 순행
      textNum = (startNum + jijiNum) % list12UnseongText.length;
    }
    else {  //음일간 역행
      textNum = (startNum + (list12UnseongText.length - jijiNum) + list12UnseongText.length) % list12UnseongText.length;
    }

    return list12UnseongText[textNum];
  }

  List<Widget> Get12UnseongWidget(BuildContext context, List<int> _listPaljaData, int stanIlganNum, double widgetWidth){
    List<Widget> list12UnseongWidget = [];
    List<String> list12UnSeongString = [];

    int divideVal = (_listPaljaData.length / 2).floor();

    if(_listPaljaData[1] != 30){
      list12UnSeongString.add(Find12Unseong(_listPaljaData[1], stanIlganNum));
    } else {
      list12UnSeongString.add(style.emptySinsalText);
    }
    list12UnSeongString.add(Find12Unseong(_listPaljaData[3], stanIlganNum));
    list12UnSeongString.add(Find12Unseong(_listPaljaData[5], stanIlganNum));
    if(_listPaljaData[7] != 30){
      list12UnSeongString.add(Find12Unseong(_listPaljaData[7], stanIlganNum));
    }
    else{
      list12UnSeongString.add(style.emptySinsalText);
    }
    if(_listPaljaData.length > 8){
      list12UnSeongString.add(Find12Unseong(_listPaljaData[9], stanIlganNum));
    }
    if(_listPaljaData.length > 10){
      list12UnSeongString.add(Find12Unseong(_listPaljaData[11], stanIlganNum));
    }

    if(_listPaljaData.length > 10){
      list12UnseongWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(list12UnSeongString[5], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(_listPaljaData.length > 8){
      list12UnseongWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(list12UnSeongString[4], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }

    list12UnseongWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(list12UnSeongString[3], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    list12UnseongWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(list12UnSeongString[2], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    list12UnseongWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(list12UnSeongString[1], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    list12UnseongWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(list12UnSeongString[0], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return list12UnseongWidget;
  }

  Get12Unseong(BuildContext context, Color containerColor, List<int> _listPaljaData, int stanIlganNum, bool isLastWidget, double widgetWidth){

    List<Widget> list12UnseongWidget = Get12UnseongWidget(context, _listPaljaData, stanIlganNum, widgetWidth);

    return Container(
      width: (widgetWidth - (style.UIMarginLeft * 2)),
      height: style.UIBoxLineHeight,
      //margin: EdgeInsets.only(left: style.UIMarginLeft),
      decoration: BoxDecoration(color: containerColor,
          //border: Border(top: BorderSide(width:1, color:style.colorDarkGrey)),
        boxShadow: [
            BoxShadow(
              color: containerColor,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(isLastWidget==false? 0:style.textFiledRadius), bottomRight: Radius.circular(isLastWidget==false? 0:style.textFiledRadius))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: list12UnseongWidget,
      ),
    );
  }
}