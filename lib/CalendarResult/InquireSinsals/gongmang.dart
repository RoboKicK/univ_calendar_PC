import 'package:flutter/material.dart';
import '../../style.dart' as style;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class Gongmang{//공망 계산해주는 클래스

  String gongmangString = '';
  String rocGongMangString = '';

  double containerHeight = style.UIBoxLineHeight;

  FindGongmangNum(List<int> _listPaljaData, int personNum, SetGongmangNum){
    int count = 0;
    int num = _listPaljaData[4];

    //일공망 찾기
    while(num != 0) {
      num = (num - 1) % style.stringCheongan[0].length;
      count--;
    }
    int dayGongmangNum =((_listPaljaData[5] + count - 2) % style.stringJiji[0].length) * 100 + ((_listPaljaData[5] + count - 1) % style.stringJiji[0].length);

    //연공망 찾기
    count = 0;
    num = _listPaljaData[0];

    while(num != 0) {
      num = (num - 1) % style.stringCheongan[0].length;
      count--;
    }
    int yearGongmangNum =((_listPaljaData[1] + count - 2) % style.stringJiji[0].length) * 100 + ((_listPaljaData[1] + count - 1) % style.stringJiji[0].length);

    //록공망 찾기
    List<int> listRocGongmangNum = [];
    if(_listPaljaData[6] != 30){
      count = _listPaljaData.length - 1;
    }
    else{
      count = _listPaljaData.length - 3;
    }
    for(int i = 0; i < count; i = i + 2){
      if(_listPaljaData[i] == 8 && _listPaljaData[i + 1] == 8){ //임신 공망
        listRocGongmangNum.add(808);
      }
      if(_listPaljaData[i] == 0 && _listPaljaData[i + 1] == 4){ //갑진 공망
        listRocGongmangNum.add(4);
      }
      if(_listPaljaData[i] == 1 && _listPaljaData[i + 1] == 5){ //을사 공망
        listRocGongmangNum.add(105);
      }
      if(_listPaljaData[i] == 3 && _listPaljaData[i + 1] == 11){ //정해 공망
        listRocGongmangNum.add(311);
      }
      if(_listPaljaData[i] == 5 && _listPaljaData[i + 1] == 1){ //기축 공망
        listRocGongmangNum.add(501);
      }
      if(_listPaljaData[i] == 4 && _listPaljaData[i + 1] == 10){ //무술 공망
        listRocGongmangNum.add(410);
      }
      if(_listPaljaData[i] == 2 && _listPaljaData[i + 1] == 8){ //병신 공망
        listRocGongmangNum.add(208);
      }
      if(_listPaljaData[i] == 6 && _listPaljaData[i + 1] == 4){ //경진 공망
        listRocGongmangNum.add(604);
      }
      if(_listPaljaData[i] == 7 && _listPaljaData[i + 1] == 5){ //신사 공망
        listRocGongmangNum.add(705);
      }
      if(_listPaljaData[i] == 9 && _listPaljaData[i + 1] == 11){ //계해 공망
        listRocGongmangNum.add(911);
      }
    }

    SetGongmangNum(yearGongmangNum, dayGongmangNum, listRocGongmangNum);
  }

  List<Widget> GetGongmangWidget(BuildContext context, List<int> _listPaljaData, int yearGongmangNum, int dayGongmangNum, List<int> listRocGongmangNum, bool isAllShow, double widgetWidth){
    List<Widget> listGongmangWidget = [];

    List<String> listGongmang = SetGongmangString0(yearGongmangNum, dayGongmangNum, listRocGongmangNum, _listPaljaData, isAllShow);

    int divideVal = (_listPaljaData.length / 2).floor();

    if(_listPaljaData.length > 10){
      listGongmangWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listGongmang[5], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(_listPaljaData.length > 8){
      listGongmangWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listGongmang[4], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    listGongmangWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listGongmang[3], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listGongmangWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(listGongmang[2], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listGongmangWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(listGongmang[1], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listGongmangWidget.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(listGongmang[0], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return listGongmangWidget;
  }

  List<String> SetGongmangString0(int yearGongmangNum, int dayGongmangNum, List<int> listRocGongmangNum, List<int> _listPaljaData, bool isAllShow){
    List<int> listContainerHeightCount = [];
    List<String> listGongmangString = [];

    for(int i = 0; i < (_listPaljaData.length / 2).floor(); i++){
      listContainerHeightCount.add(0);
      listGongmangString.add('');
    }

    int count = (_listPaljaData.length / 2).floor() - 1;
    int topCount = 0;

    int saveDataNum = personalDataManager.sinsalData % 10;
    bool isShowYearGongmang = false, isShowDayGongmang = false, isShowRocGongmang = false;

    if(saveDataNum == 1 || saveDataNum == 3 || saveDataNum == 5 || saveDataNum == 7){
      isShowYearGongmang = true;
    }
    if(saveDataNum == 2 || saveDataNum == 3 || saveDataNum == 6 || saveDataNum == 7){
      isShowDayGongmang = true;
    }
    if(saveDataNum == 4 || saveDataNum == 5 || saveDataNum == 6 || saveDataNum == 7){
      isShowRocGongmang = true;
    }

      if(isShowYearGongmang == true || isAllShow == true){
        for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
          if(_listPaljaData[i] == (yearGongmangNum/100).floor() || _listPaljaData[i] == (yearGongmangNum%100).floor()){
            listGongmangString[(i / 2).floor()] = '연공망\n';
            listContainerHeightCount[(i / 2).floor()]++;
          }
        }
      }
      if(isShowDayGongmang == true || isAllShow == true){
        for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
          if(_listPaljaData[i] == (dayGongmangNum/100).floor() || _listPaljaData[i] == (dayGongmangNum%100).floor()){
            listGongmangString[(i / 2).floor()] = listGongmangString[(i / 2).floor()] +  '일공망\n';
            listContainerHeightCount[(i / 2).floor()]++;
          }
        }
      }
   // }

    if(isShowRocGongmang == true || isAllShow == true){
      for(int i = _listPaljaData.length - 2; i > 6; i = i - 2){
          bool isRocGongmang = false;
          if(_listPaljaData[i] == 8 && _listPaljaData[i + 1] == 8){ //임신 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 0 && _listPaljaData[i + 1] == 4){ //갑진 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 1 && _listPaljaData[i + 1] == 5){ //을사 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 3 && _listPaljaData[i + 1] == 11){ //정해 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 5 && _listPaljaData[i + 1] == 1){ //기축 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 4 && _listPaljaData[i + 1] == 10){ //무술 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 2 && _listPaljaData[i + 1] == 8){ //병신 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 6 && _listPaljaData[i + 1] == 4){ //경진 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 7 && _listPaljaData[i + 1] == 5){ //신사 공망
            isRocGongmang = true;
          }
          if(_listPaljaData[i] == 9 && _listPaljaData[i + 1] == 11){ //계해 공망
            isRocGongmang = true;
          }
          if(isRocGongmang == true){
            listGongmangString[(i / 2).floor()] = listGongmangString[(i / 2).floor()] +  '록공망\n';
            listContainerHeightCount[(i / 2).floor()]++;
        }
      }
      for(int i = _listPaljaData.length - 2; i > -1; i = i - 2){
        int j = 0;
        while(j < listRocGongmangNum.length){
          if(_listPaljaData[i] == (listRocGongmangNum[j]/100).floor() && _listPaljaData[i + 1] == (listRocGongmangNum[j]%100).floor()){
            listGongmangString[(i / 2).floor()] = listGongmangString[(i / 2).floor()] +  '록공망\n';
            listContainerHeightCount[(i / 2).floor()]++;
          }
          j++;
        }
      }
    }

    for(int a = count; a > -1; a--) {
      if(listContainerHeightCount[a] > topCount){
        topCount = listContainerHeightCount[a];
      }
    }
    for(int a = count; a > -1; a--) { //라인 정리
      while (listContainerHeightCount[a] < topCount) {
        listGongmangString[a] = listGongmangString[a] + 'ㅡ\n';
        listContainerHeightCount[a]++;
      }
      if(topCount == 0){
        listGongmangString[a] = 'ㅡ\n';
      }
      listGongmangString[a] = listGongmangString[a].substring(0, listGongmangString[a].length - 1);
    }
    if(topCount > 0){
      containerHeight = containerHeight + (topCount - 1) * style.UIBoxLineAddHeight;
    }
    return listGongmangString;
  }

  GetGongmang(BuildContext context, Color containerColor, List<int> _listPaljaData, int yearGongmangNum, int dayGongmangNum, List<int> listRocGongmangNum, bool isAllShow, bool isLastWidget, double widgetWidth){
    List<Widget> listGongmangWidget = GetGongmangWidget(context, _listPaljaData, yearGongmangNum, dayGongmangNum, listRocGongmangNum, isAllShow, widgetWidth);

    return Container(
      width: (widgetWidth - (style.UIMarginLeft * 2)),
      height: containerHeight,// style.UIBoxLineHeight,
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
        children: listGongmangWidget,
      ),
    );
  }
}