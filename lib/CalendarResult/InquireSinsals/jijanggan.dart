import 'package:flutter/material.dart';
import '../../style.dart' as style;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class Jijanggan{  //지장간 계산해주는 클래스
  List<String> list6chin = ['비견','겁재','식신','상관','편재','정재','편관','정관','편인','정인'];

  String FindYugchin(int _cheonganNum, int _ilganNum){
    String yugchin = '';

    if(_ilganNum % 2 == 0){ //양일간
      yugchin = list6chin[(_cheonganNum - _ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
    }
    else{ //음일간
      yugchin = list6chin[((_cheonganNum % 2 == 1? _cheonganNum:(_cheonganNum + 2)) - _ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
    }

    return yugchin;
  }

  String GetJijangganString(int _jijiNum, int _ilganNum, bool isAllShow){
    String jijanggan = '';
    int saveDataNum =((personalDataManager.calendarData % 100000000000) / 10000000000).floor();
    bool isOnlyJijanggan = false;
    bool isWithYugchin = false;
    bool isWithDay = false;
    if(saveDataNum == 1){
      isOnlyJijanggan = true;
    }
    if(saveDataNum == 3 || saveDataNum == 7){
      isWithYugchin = true;
    }
    if(saveDataNum == 5 || saveDataNum == 7){
      isWithDay = true;
    }

    String line0 = '', line1 = '', line2 = '';

    switch(_jijiNum){
      case 0:{  //자
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][8]}${style.stringCheongan[style.uemYangStringTypeNum][9]}';
        } else {
          if(isWithYugchin == true || isAllShow == true){
            line0 = ' ${FindYugchin(8, _ilganNum)}';
            line1 = ' ${FindYugchin(9, _ilganNum)}';
          }
          if(isWithDay == true || isAllShow == true){
            line0 = line0 + ' 10';
            line1 = line1 + ' 20';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][8]}$line0\n-\n${style.stringCheongan[style.uemYangStringTypeNum][9]}$line1';
        }
        break;
      }
      case 1:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][9]}${style.stringCheongan[style.uemYangStringTypeNum][7]}${style.stringCheongan[style.uemYangStringTypeNum][5]}';
        } else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(9, _ilganNum)}';
            line1 = ' ${FindYugchin(7, _ilganNum)}';
            line2 = ' ${FindYugchin(5, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 9';
            line1 = line1 + ' 3';
            line2 = line2 + ' 18';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][9]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][7]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][5]}$line2';
        }
        break;
      }
      case 2:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}${style.stringCheongan[style.uemYangStringTypeNum][2]}${style.stringCheongan[style.uemYangStringTypeNum][0]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(4, _ilganNum)}';
            line1 = ' ${FindYugchin(2, _ilganNum)}';
            line2 = ' ${FindYugchin(0, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 7';
            line1 = line1 + ' 7';
            line2 = line2 + ' 16';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][2]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][0]}$line2';
        }
        break;
      }
      case 3:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][0]}${style.stringCheongan[style.uemYangStringTypeNum][9]}';
        } else {
          if(isWithYugchin == true || isAllShow == true){
            line0 = ' ${FindYugchin(0, _ilganNum)}';
            line1 = ' ${FindYugchin(9, _ilganNum)}';
          }
          if(isWithDay == true || isAllShow == true){
            line0 = line0 + ' 10';
            line1 = line1 + ' 20';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][0]}$line0\n-\n${style.stringCheongan[style.uemYangStringTypeNum][9]}$line1';
        }
        break;
      }
      case 4:{ //진
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][1]}${style.stringCheongan[style.uemYangStringTypeNum][9]}${style.stringCheongan[style.uemYangStringTypeNum][4]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(1, _ilganNum)}';
            line1 = ' ${FindYugchin(9, _ilganNum)}';
            line2 = ' ${FindYugchin(4, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 9';
            line1 = line1 + ' 3';
            line2 = line2 + ' 18';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][1]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][9]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][4]}$line2';
        }
        break;
      }
      case 5:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}${style.stringCheongan[style.uemYangStringTypeNum][6]}${style.stringCheongan[style.uemYangStringTypeNum][2]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(4, _ilganNum)}';
            line1 = ' ${FindYugchin(6, _ilganNum)}';
            line2 = ' ${FindYugchin(2, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 7';
            line1 = line1 + ' 7';
            line2 = line2 + ' 16';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][6]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][2]}$line2';
        }
        break;
      }
      case 6:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][2]}${style.stringCheongan[style.uemYangStringTypeNum][5]}${style.stringCheongan[style.uemYangStringTypeNum][3]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(2, _ilganNum)}';
            line1 = ' ${FindYugchin(5, _ilganNum)}';
            line2 = ' ${FindYugchin(3, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 10';
            line1 = line1 + ' 10';
            line2 = line2 + ' 11';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][2]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][5]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][3]}$line2';
        }
        break;
      }
      case 7:{  //미
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][3]}${style.stringCheongan[style.uemYangStringTypeNum][1]}${style.stringCheongan[style.uemYangStringTypeNum][5]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(3, _ilganNum)}';
            line1 = ' ${FindYugchin(1, _ilganNum)}';
            line2 = ' ${FindYugchin(5, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 9';
            line1 = line1 + ' 3';
            line2 = line2 + ' 18';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][3]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][1]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][5]}$line2';
        }
        break;
      }
      case 8:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}${style.stringCheongan[style.uemYangStringTypeNum][8]}${style.stringCheongan[style.uemYangStringTypeNum][6]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(4, _ilganNum)}';
            line1 = ' ${FindYugchin(8, _ilganNum)}';
            line2 = ' ${FindYugchin(6, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 7';
            line1 = line1 + ' 7';
            line2 = line2 + ' 16';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][8]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][6]}$line2';
        }
        break;
      }
      case 9:{  //유
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][6]}${style.stringCheongan[style.uemYangStringTypeNum][7]}';
        } else {
          if(isWithYugchin == true || isAllShow == true){
            line0 = ' ${FindYugchin(6, _ilganNum)}';
            line1 = ' ${FindYugchin(7, _ilganNum)}';
          }
          if(isWithDay == true || isAllShow == true){
            line0 = line0 + ' 10';
            line1 = line1 + ' 20';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][6]}$line0\n-\n${style.stringCheongan[style.uemYangStringTypeNum][7]}$line1';
        }
        break;
      }
      case 10:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][7]}${style.stringCheongan[style.uemYangStringTypeNum][3]}${style.stringCheongan[style.uemYangStringTypeNum][4]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(7, _ilganNum)}';
            line1 = ' ${FindYugchin(3, _ilganNum)}';
            line2 = ' ${FindYugchin(4, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 9';
            line1 = line1 + ' 3';
            line2 = line2 + ' 18';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][7]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][3]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][4]}$line2';
        }
        break;
      }
      case 11:{
        if(isOnlyJijanggan == true && isAllShow == false){
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}${style.stringCheongan[style.uemYangStringTypeNum][0]}${style.stringCheongan[style.uemYangStringTypeNum][8]}';
        }  else {
          if (isWithYugchin == true || isAllShow == true) {
            line0 = ' ${FindYugchin(4, _ilganNum)}';
            line1 = ' ${FindYugchin(0, _ilganNum)}';
            line2 = ' ${FindYugchin(8, _ilganNum)}';
          }
          if (isWithDay == true || isAllShow == true) {
            line0 = line0 + ' 7';
            line1 = line1 + ' 7';
            line2 = line2 + ' 16';
          }
          jijanggan = '${style.stringCheongan[style.uemYangStringTypeNum][4]}$line0\n${style.stringCheongan[style.uemYangStringTypeNum][0]}$line1\n${style.stringCheongan[style.uemYangStringTypeNum][8]}$line2';
        }
        break;
      }
    }

    return jijanggan;
  }

  List<Widget> GetJijangganWidget(BuildContext context, List<int> _listPaljaData, bool isAllShow, double widgetWidth){
    List<Widget> listJijangganWidget = [];
    List<String> listCheonganYugchin = [];

    int divideVal = (_listPaljaData.length / 2).floor();

    listCheonganYugchin.add(GetJijangganString(_listPaljaData[1], _listPaljaData[4], isAllShow));
    listCheonganYugchin.add(GetJijangganString(_listPaljaData[3], _listPaljaData[4], isAllShow));
    listCheonganYugchin.add(GetJijangganString(_listPaljaData[5], _listPaljaData[4], isAllShow));
    if(_listPaljaData[7] != -2){
      listCheonganYugchin.add(GetJijangganString(_listPaljaData[7], _listPaljaData[4], isAllShow));
    }
    else{
      listCheonganYugchin.add('${style.emptySinsalText}\n${style.emptySinsalText}\n${style.emptySinsalText}');
    }
    if(_listPaljaData.length > 8){
      listCheonganYugchin.add(GetJijangganString(_listPaljaData[9], _listPaljaData[4], isAllShow));
    }
    if(_listPaljaData.length > 10){
      listCheonganYugchin.add(GetJijangganString(_listPaljaData[11], _listPaljaData[4], isAllShow));
    }

    if(_listPaljaData.length > 10){
      listJijangganWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),child: Text(listCheonganYugchin[5], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))),
      ));
    }
    if(_listPaljaData.length > 8){
      listJijangganWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),child: Text(listCheonganYugchin[4], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))),
      ));
    }

    listJijangganWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),child: Text(listCheonganYugchin[3], style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))),
    ));
    listJijangganWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),child: Text(listCheonganYugchin[2], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))),
    ));
    listJijangganWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: SingleChildScrollView(scrollDirection: Axis.horizontal,
    physics: ClampingScrollPhysics(),child: Text(listCheonganYugchin[1], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))),
    ));
    listJijangganWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: Text(listCheonganYugchin[0], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))),
    ));

    return listJijangganWidget;
  }

  GetJijanggan(BuildContext context, Color containerColor, List<int> _listPaljaData, bool isAllShow, bool isLastWidget, double widgetWidth){

    List<Widget> listJijangganWidget = GetJijangganWidget(context, _listPaljaData, isAllShow, widgetWidth);

    return Container(
      width: (widgetWidth - (style.UIMarginLeft * 2)),
      height: style.UIBoxLineHeight + style.UIBoxLineAddHeight * 2,
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
        children: listJijangganWidget,
      ),
    );
  }
}