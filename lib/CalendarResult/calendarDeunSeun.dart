import 'dart:ui';

import 'package:flutter/material.dart';
import '../../style.dart' as style;
import 'InquireSinsals/yugchinClass.dart' as yugchinClass;
import 'InquireSinsals/sibiunseong.dart' as sibiunseong;
import 'InquireSinsals/MinorSinsals/sibiSinsal.dart' as sibiSinsal;
import '../../findGanji.dart' as findGanji;
import '../Settings/personalDataManager.dart' as personalDataManager;

class CalendarDeunSeun extends StatefulWidget {
  const CalendarDeunSeun({super.key, required this.gender0, required this.birthYear0, required this.birthMonth0, required this.birthDay0, required this.birthHour0, required this.birthMin0,
    required this.listPaljaData0, required this.yearGongmangNum, required this.dayGongmangNum,
  required this.isShowDrawerDeunSeunYugchin, required this.isShowDrawerDeunSeunSibiunseong, required this.isShowDrawerDeunSeunSibisinsal, required this.isShowDrawerDeunSeunGongmang, required this.isShowDrawerDeunSeunOld, required this.lastDeunSeunWidgetNum,
  required this.deunContainerColorNum, required this.seunContainerColorNum, required this.isShowDrawerManOld, required this.isShowDrawerKoreanGanji, required this.personNum, required this.setPersonPaljaData, required this.widgetWidth, required this.isOneWidget});

  final bool gender0;
  final int birthYear0, birthMonth0, birthDay0, birthHour0, birthMin0;
  final List<int> listPaljaData0;
  final int yearGongmangNum, dayGongmangNum;
  final int isShowDrawerDeunSeunYugchin, isShowDrawerDeunSeunSibiunseong, isShowDrawerDeunSeunSibisinsal, isShowDrawerDeunSeunGongmang, isShowDrawerDeunSeunOld;
  final int lastDeunSeunWidgetNum;
  final int deunContainerColorNum, seunContainerColorNum;
  final int isShowDrawerManOld, isShowDrawerKoreanGanji;
  final int personNum;
  final setPersonPaljaData; //대운세운 누르면 팔자에 추가함
  final double widgetWidth;
  final bool isOneWidget;

  @override
  State<CalendarDeunSeun> createState() => _CalendarDeunSeunState();
}

class _CalendarDeunSeunState extends State<CalendarDeunSeun> {
  List<int> listDeunCheongan0 = [];
  List<int> listDeunJiji0 = [];
  List<Color> listCheonganBoxColor0 = [];
  List<Color> listCheonganTextColor0 = [];
  List<Color> listJijiBoxColor0 = [];
  List<Color> listJijiTextColor0 = [];

  List<Color> listContainerColor = [style.colorBoxGray0, style.colorBoxGray1];
  int containerColorNum = 1;

  List<Color> listDeunsuColor0 = []; //천간 지지 선택은 같으니까 리스트 하나로 관리

  int deunStart0 = -1;
  int nowDeunNum0 = 0;
  int birthYear0 = 0;

  List<String> listDeunGongmangString = [];
  int deunGongmangTopCount = 0;
  double deunGongmangContainerHeight = style.UIBoxLineHeight;

  //여기부터 세운
  List<int> listSeunYear0 = [0,0,0,0,0,0,0,0,0,0];
  List<int> listSeunCheongan0 = [0,0,0,0,0,0,0,0,0,0];
  List<int> listSeunJiji0 = [0,0,0,0,0,0,0,0,0,0];

  List<Color> listSeunCheonganBoxColor0 = [];
  List<Color> listSeunCheonganTextColor0 = [];
  List<Color> listSeunJijiBoxColor0 = [];
  List<Color> listSeunJijiTextColor0 = [];

  int seunContainerColorNum = 1;

  List<Color> listSeunsuColor0 = []; //천간 지지 선택은 같으니까 리스트 하나로 관리

  int nowSeunNum0 = 0;
  int nowSeunYear = 0;

  List<String> listSeunGongmangString = [];
  int seunGongmangTopCount = 0;
  double seunGongmangContainerHeight = style.UIBoxLineHeight;

  //여기부터 월운
  List<int> listWolunCheongan0 = [0,0,0,0,0,0,0,0,0,0,0,0];
  List<Color> listWolunCheonganBoxColor0 = [];
  List<Color> listWolunCheonganTextColor0 = [];
  List<Color> listWolunWolunBoxColor0 = [];
  List<Color> listWolunWolunTextColor0 = [];
  List<Color> listWolunJijiBoxColor0 = [];
  List<Color> listWolunJijiTextColor0 = [];

  int wolunContainerColorNum = 1;

  List<String> listWolunGongmangString = [];
  int wolunGongmangTopCount = 0;
  double wolunGongmangContainerHeight = style.UIBoxLineHeight;

  double buttonPaddingVal = 4;

  bool isHideOld = false;

  bool isAddDeunToPalja = false;
  bool isAddSeunToPalja = false;

  double widgetWidth = 0;

  SetDeun(){
    birthYear0 = widget.birthYear0;

    bool isPatrol0 = true; //대운 순행인지  연간 기준으로 봄
    if((widget.gender0 == true && (widget.listPaljaData0[0] % 2) == 1) || (widget.gender0 == false && (widget.listPaljaData0[0] % 2) == 0)){
      isPatrol0 = false;
    }

    //대운 시작 나이 찾기
    if(birthYear0 > 1901){
      int leftDays = 0;
      if(isPatrol0 == true){  //순행이면
        if(birthYear0 == 1901){
          if(widget.birthDay0 == 1){
            deunStart0 = 2;
          }
          else{
            deunStart0 = 1;
          }
        }
        else{
          if(((widget.birthDay0 * 10000) + (widget.birthHour0 * 100) + widget.birthMin0) <= findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear][widget.birthMonth0 - 1]){ //태어난 달에 다음 절기가 있고 다음 절기 보다 일찍 태어났으면
            deunStart0 = (((findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear][widget.birthMonth0 - 1] / 10000).floor() - widget.birthDay0) / 3).round();
            if(deunStart0 == 0){
              deunStart0 = 1;
            }
          }
          else{   //다음 절기가 없으면 태어난 달에 없으면
            leftDays = (findGanji.listSolNday[widget.birthMonth0 - 1] - widget.birthDay0) + ((findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear + (widget.birthMonth0/12).floor()][widget.birthMonth0 % 12] / 10000).floor());
            deunStart0 = (leftDays / 3).round();
          }
        }
      }
      else{ //역행이면
        if(((widget.birthDay0 * 10000) + (widget.birthHour0 * 100) + widget.birthMin0) >= findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear][widget.birthMonth0 - 1]){ //태어난 달에 이전 절기가 있고 이전 절기 보다 늦게 태어났으면
          deunStart0 = ((widget.birthDay0 - (findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear - 1][widget.birthMonth0 - 1] / 10000).floor()) / 3).round();
          if(deunStart0 == 0){
            deunStart0 = 1;
          }
        }
        else{ //태어난 달에 이전 절기가 없고 이전 달에 이전 절기가 있으면
          if(widget.birthMonth0 == 1){ //1월에 태어났으면
            if(widget.birthYear0 == 1901){
              if(widget.birthDay0 < 3){
                deunStart0 = 8;
              }
              else{
                deunStart0 = 9;
              }
            }
            else{
              leftDays = widget.birthDay0 + findGanji.listSolNday[11] - (findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear - 1][11] / 10000).floor();
              deunStart0 = (leftDays / 3).round();
            }
          }
          else{
            leftDays = widget.birthDay0 + findGanji.listSolNday[widget.birthMonth0 - 2] - (findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear][widget.birthMonth0 - 2] / 10000).floor();
            deunStart0 = (leftDays / 3).round();
          }
        }
      }
    }

    //대운 간지 텍스트
    int count = 10;
    if(isPatrol0 == true){  //순행이면
      for(int i = 0; i < count; i++){
        listDeunCheongan0.add((widget.listPaljaData0[2] + i + 1) % style.stringCheongan[0].length);
        listDeunJiji0.add((widget.listPaljaData0[3] + i + 1) % style.stringJiji[0].length);
      }
    }
    else{
      for(int i = 0; i < count; i++){
        listDeunCheongan0.add((widget.listPaljaData0[2] - i - 1) % style.stringCheongan[0].length);
        listDeunJiji0.add((widget.listPaljaData0[3] - i - 1) % style.stringJiji[0].length);
      }
    }

    //대운 버튼 컬러, 셰도우 컬러
    for(int i = 0; i < count; i++){
      listCheonganBoxColor0.add(style.SetOhengColor(true, listDeunCheongan0[i]));
      if(listDeunCheongan0[i] == 6 || listDeunCheongan0[i] == 7){
        listCheonganTextColor0.add(style.colorBlack);
      }
      else{
        listCheonganTextColor0.add(Colors.white);
      }
      listDeunsuColor0.add(Colors.transparent);
    }
    for(int i = 0; i < count; i++){
      listJijiBoxColor0.add(style.SetOhengColor(false, listDeunJiji0[i]));
      if(listDeunJiji0[i] == 9 || listDeunJiji0[i] == 8){
        listJijiTextColor0.add(style.colorBlack);
      }
      else{
        listJijiTextColor0.add(Colors.white);
      }
    }

    int nowOld0 = DateTime.now().year - widget.birthYear0 + 1;
    count = 0;
    while(true){  //조회 했을 때 나이에 맞는 대운을 자동으로 선택함
      if(deunStart0 != -1){
        if(deunStart0 + (count * 10) >= (nowOld0 - 9) || count == 9){
          nowDeunNum0 = count;
          int hidePersonSaveDataNum = ((personalDataManager.etcData % 10000) / 1000).floor();
          int hideOldSaveDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
          //print(hidePersonSaveDataNum);
          if(hidePersonSaveDataNum == 1 || (hideOldSaveDataNum == 1 || hideOldSaveDataNum == 4 || hideOldSaveDataNum == 5)){//widget.isShowDrawerDeunSeunOld == 1){
            SetDeunButtonSelectColor(nowDeunNum0);  //선택한 대운 버튼 표시함
            //print(nowDeunNum0);
          }
          //SetSeun();
          InitSeun(); //현재 나이에 맞는 세운을 보여줌
          nowSeunNum0 = nowOld0 - (deunStart0 + (count * 10));
          if(nowSeunNum0 > 9){
            nowSeunNum0 = 9;
          }
          if(nowSeunNum0 < 0){
            nowSeunNum0 = 0;
          }
          if(hidePersonSaveDataNum == 1 || (hideOldSaveDataNum == 1 || hideOldSaveDataNum == 4 || hideOldSaveDataNum == 5)){//widget.isShowDrawerDeunSeunOld == 1){
            nowSeunYear = DateTime.now().year;
            SetSeunButtonSelectColor(nowSeunNum0);  //당해의 세운 버튼 표시함
          }

          InitWolun();
          break;
        }
        else{
          count++;
        }
      }
    }
  }

  SetDeunButtonSelectColor(int selectNum){
    listDeunsuColor0[nowDeunNum0] = Colors.transparent;
    listDeunsuColor0[selectNum] = style.colorYellow;
  }

  SetSeunButtonSelectColor(int selectNum){
    listSeunsuColor0[nowSeunNum0] = Colors.transparent;
    if(selectNum == -1){
      for(int i = 0; i < listSeunYear0.length; i++){
        if(i + (nowDeunNum0 * 10) + (widget.birthYear0 + deunStart0 - 1) == nowSeunYear){
          listSeunsuColor0[nowSeunNum0] = style.colorYellow;
        }
      }
    } else {
      listSeunsuColor0[selectNum] = style.colorYellow;
    }
  }

  Container GetDeunsuBoxAndText(int num){ //대운수
    int startDeunsu = deunStart0;
    if(widget.isShowDrawerManOld == 1){
      startDeunsu = deunStart0 - 1;
    }

    if(num == 0){
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color : listDeunsuColor0[num],
            borderRadius: BorderRadius.only(topRight: Radius.circular(style.textFiledRadius))),
        child: Text('${isHideOld == false? startDeunsu+(num * 10) : '*'}', style: Theme.of(context).textTheme.titleSmall),
      );
    }
    else if(num == 9){
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color : listDeunsuColor0[num],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius))),
        child: Text('${isHideOld == false? startDeunsu+(num * 10) : '*'}', style: Theme.of(context).textTheme.titleSmall),
      );
    }
    else{
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        color : listDeunsuColor0[num],
        child: Text('${isHideOld == false? startDeunsu+(num * 10) : '*'}', style: Theme.of(context).textTheme.titleSmall),
      );
    }
  }

  Container GetDeunYugchinBoxAndText(int deunNum, int ilganNum, bool isCheongan){ //육친
    String yugchinText = '';
    if(isCheongan == true){
      if(ilganNum % 2 == 0){ //양일간
        yugchinText = yugchinClass.YugchinClass().list6chin[(listDeunCheongan0[deunNum] - ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
      }
      else{ //음일간
        yugchinText = yugchinClass.YugchinClass().list6chin[((listDeunCheongan0[deunNum]%2 == 1? listDeunCheongan0[deunNum]:(listDeunCheongan0[deunNum]+2)) - ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
      }
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text(yugchinText, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      );
    }
    else{
      yugchinText = yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(listDeunJiji0[deunNum], ilganNum)];
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text(yugchinText, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      );
    }
  }

  Container GetDeunGanjiBoxAndText(int deunNum, bool isCheongan){
    if(isCheongan == true){
      return Container(
        width: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        height: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        padding: EdgeInsets.only(top:style.UIOhengBoxPadding2),
        margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.5, top: style.UIOhengMarginTop * 0.5),
        decoration: BoxDecoration(
          boxShadow: [style.uiDeunSeunShadow],
          color: listCheonganBoxColor0[deunNum],
          borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
        ),
        child: ElevatedButton(
            onPressed: () {
              SetDeunButtonSelectColor(deunNum);
              if(personalDataManager.deunSeunData % 10 != 1) {
                if (isAddDeunToPalja == true && deunNum == nowDeunNum0) {
                  widget.setPersonPaljaData(widget.personNum, true, [-2, -2]);
                  isAddDeunToPalja = false;
                  isAddSeunToPalja = false;
                } else {
                  widget.setPersonPaljaData(
                      widget.personNum, true, [listDeunCheongan0[deunNum], listDeunJiji0[deunNum]]); //[listDeunCheongan0[deunNum], listDeunJiji0[deunNum]]);
                  isAddDeunToPalja = true;
                  isAddSeunToPalja = false;
                }
              }
              nowDeunNum0 = deunNum;
              SetSeun();
              SetSeunButtonSelectColor(-1);
            },
          style: ElevatedButton.styleFrom(alignment: Alignment.center, splashFactory: NoSplash.splashFactory, padding:EdgeInsets.only(bottom:buttonPaddingVal),
              backgroundColor: listCheonganBoxColor0[deunNum], elevation:0.0, foregroundColor: listCheonganBoxColor0[deunNum], surfaceTintColor: Colors.transparent),
          child:Align(
              alignment: Alignment.center,
              child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][listDeunCheongan0[deunNum]], style:TextStyle(fontSize: style.UIOhengDeunFontSize, fontWeight: style.UIOhengDeunFontWeight, color: listCheonganTextColor0[deunNum]))),
        )
      );
    }
    else{
      return  Container(
        width: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        height: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        padding: EdgeInsets.only(top:style.UIOhengBoxPadding2),
        margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.5, top: style.UIOhengMarginTop * 0.5),
        decoration: BoxDecoration(
          boxShadow: [style.uiDeunSeunShadow],
          color: listJijiBoxColor0[deunNum],
          borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
        ),
        //alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () {
            SetDeunButtonSelectColor(deunNum);
            if(personalDataManager.deunSeunData % 10 != 1) {
              if(isAddDeunToPalja == true && deunNum == nowDeunNum0){
                widget.setPersonPaljaData(widget.personNum, true, [-2,-2]);
                isAddDeunToPalja = false;
              } else {
                widget.setPersonPaljaData(widget.personNum, true, [listDeunCheongan0[deunNum], listDeunJiji0[deunNum]]);//[listDeunCheongan0[deunNum], listDeunJiji0[deunNum]]);
                isAddDeunToPalja = true;
              }
            }
            nowDeunNum0 = deunNum;
            SetSeun();
            SetSeunButtonSelectColor(-1);
          },
          style: ElevatedButton.styleFrom(alignment: Alignment.center, splashFactory: NoSplash.splashFactory, padding:EdgeInsets.only(bottom:buttonPaddingVal),
              backgroundColor: listJijiBoxColor0[deunNum], elevation:0.0, foregroundColor: listJijiBoxColor0[deunNum], surfaceTintColor: Colors.transparent),
          child:Align(alignment: Alignment.center,child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][listDeunJiji0[deunNum]], style:TextStyle(fontSize: style.UIOhengDeunFontSize, fontWeight: style.UIOhengDeunFontWeight, color: listJijiTextColor0[deunNum]))),
        )
      );
    }
  }

  Container GetDeun12UnseongBoxAndText(int deunNum, int ilganNum){
    String text = sibiunseong.Sibiunseong().Find12Unseong(listDeunJiji0[deunNum], ilganNum);
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  Container GetDeun12SinsalBoxAndText(int deunNum, int yeonjiNum){
    String text = sibiSinsal.SibiSinsal().Find12Sinsal(yeonjiNum, listDeunJiji0[deunNum]);
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  SetDeunGongmangString(){
    listDeunGongmangString.clear();
    List<int> listGongmangCount = [];
    int saveData = ((personalDataManager.deunSeunData % 100000) / 10000).floor();
    for(int i = 0; i < 10; i++){
      String text = '';
      int count = 0;
      if((saveData == 1 || saveData == 3 || saveData == 5 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){ //연공망
        if(listDeunJiji0[i] == (widget.yearGongmangNum/100).floor() || listDeunJiji0[i] == (widget.yearGongmangNum%100).floor()){
          text = '연공망';
          count++;
        }
      }
      if((saveData == 2 || saveData == 3 || saveData == 6 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){
        if(listDeunJiji0[i] == (widget.dayGongmangNum/100).floor() || listDeunJiji0[i] == (widget.dayGongmangNum%100).floor()){
          if(text.isNotEmpty){
            text = '$text\n일공망';
          } else {
            text = '일공망';
          }
          count++;
        }
      }
      if((saveData == 4 || saveData == 5 || saveData == 6 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){
        bool isRocGongmang = false;
        if(listDeunCheongan0[i] == 8 && listDeunJiji0[i] == 8){ //임신 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 0 && listDeunJiji0[i] == 4){ //갑진 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 1 && listDeunJiji0[i] == 5){ //을사 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 3 && listDeunJiji0[i] == 11){ //정해 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 5 && listDeunJiji0[i] == 1){ //기축 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 4 && listDeunJiji0[i] == 10){ //무술 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 2 && listDeunJiji0[i] == 8){ //병신 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 6 && listDeunJiji0[i] == 4){ //경진 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 7 && listDeunJiji0[i] == 5){ //신사 공망
          isRocGongmang = true;
        } else if(listDeunCheongan0[i] == 9 && listDeunJiji0[i] == 11){ //계해 공망
          isRocGongmang = true;
        }
        if(isRocGongmang == true){
          if(text.isNotEmpty){
            text = '$text\n록공망';
          } else {
            text = '록공망';
          }
          count++;
        }
        if(count >= deunGongmangTopCount){
          deunGongmangTopCount = count;
        }
      }
      listDeunGongmangString.add(text);
      listGongmangCount.add(count);
    }
    for(int i = 0; i < 10; i++){
      if(listGongmangCount[i] < deunGongmangTopCount){
        int count = deunGongmangTopCount - listGongmangCount[i];
        while(count > 0){
          if(listDeunGongmangString[i].isEmpty){
            listDeunGongmangString[i] = style.emptySinsalText;
          } else {
            listDeunGongmangString[i] = '${listDeunGongmangString[i]}\n${style.emptySinsalText}';
          }
          count--;
        }
      }
    }
   }

  Container GetDeunGongmangBoxAndText(int deunNum){
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(listDeunGongmangString[deunNum], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  InitSeun(){
    int seunStart0 = 0;
    if(widget.birthMonth0 == 1 || (widget.birthMonth0 == 2 && ((widget.birthDay0 * 10000) + (widget.birthHour0 * 100) + widget.birthMin0) <= findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear][1])){ //1월 2월생이 절입시간 전에 태어났으면
      seunStart0 = deunStart0;
    }
    else{
      seunStart0 = deunStart0 - 1;
    }
    for(int i = 0; i < listSeunYear0.length; i++){
        listSeunYear0[i] = i + (nowDeunNum0 * 10) + (widget.birthYear0 + deunStart0 - 1);
        listSeunCheongan0[i] = (i + (nowDeunNum0 * 10) + seunStart0 + widget.listPaljaData0[0]) % style.stringCheongan[0].length;
        listSeunJiji0[i] = (i + (nowDeunNum0 * 10) + seunStart0 + widget.listPaljaData0[1]) % style.stringJiji[0].length;
    }
    //박스 컬러
    int count = 10;
    for(int i = 0; i < count; i++){
      listSeunCheonganBoxColor0.add(style.SetOhengColor(true, listSeunCheongan0[i]));
      if(listSeunCheongan0[i] == 6 || listSeunCheongan0[i] == 7){
        listSeunCheonganTextColor0.add(style.colorBlack);
      }
      else{
        listSeunCheonganTextColor0.add(Colors.white);
      }
      listSeunsuColor0.add(Colors.transparent);
    }
    for(int i = 0; i < count; i++){
      listSeunJijiBoxColor0.add(style.SetOhengColor(false, listSeunJiji0[i]));
      if(listSeunJiji0[i] == 9 || listSeunJiji0[i] == 8){
        listSeunJijiTextColor0.add(style.colorBlack);
      }
      else{
        listSeunJijiTextColor0.add(Colors.white);
      }
    }
  }

  SetSeun(){
    int seunStart0 = 0;
    if(widget.birthMonth0 == 1 || (widget.birthMonth0 == 2 && ((widget.birthDay0 * 10000) + (widget.birthHour0 * 100) + widget.birthMin0) <= findGanji.listSeasonData[widget.birthYear0 - findGanji.stanYear][1])){ //1월 2월생은
      seunStart0 = deunStart0;
    }
    else{
      seunStart0 = deunStart0 - 1;
    }
    setState(() {
      for(int i = 0; i < listSeunYear0.length; i++){
        listSeunYear0[i] = i + (nowDeunNum0 * 10) + (widget.birthYear0 + deunStart0 - 1);
        listSeunJiji0[i] = (i + (nowDeunNum0 * 10) + seunStart0 + widget.listPaljaData0[1]) % style.stringJiji[0].length;
      }
      //박스 컬러
      int count = 10;
      for(int i = 0; i < count; i++){
        listSeunJijiBoxColor0[i] = style.SetOhengColor(false, listSeunJiji0[i]);
        if(listSeunJiji0[i] == 9 || listSeunJiji0[i] == 8){
          listSeunJijiTextColor0[i] = style.colorBlack;
        }
        else{
          listSeunJijiTextColor0[i] = Colors.white;
        }
      }
    });;
  }

  Container GetSeunsuBoxAndText(int num){ //세운수
    if(num == 0){
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text('${isHideOld == false? listSeunYear0[num] : '*'}', style: Theme.of(context).textTheme.titleSmall),
        decoration: BoxDecoration(
            color : listSeunsuColor0[num],
            borderRadius: BorderRadius.only(topRight: Radius.circular(style.textFiledRadius))),
      );
    }
    else if(num == 9){
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text('${isHideOld == false? listSeunYear0[num] : '*'}', style: Theme.of(context).textTheme.titleSmall),
        decoration: BoxDecoration(
            color : listSeunsuColor0[num],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius))),
      );
    }
    else{
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text('${isHideOld == false? listSeunYear0[num] : '*'}', style: Theme.of(context).textTheme.titleSmall),
        color : listSeunsuColor0[num],
      );
    }
  }

  Container GetSeunOldBoxAndText(int num){
    int oldRev = 1;
    if(widget.isShowDrawerManOld == 1){
      oldRev = 0;
    }
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text('${listSeunYear0[num] - widget.birthYear0 + oldRev}세', style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Container GetSeunYugchinBoxAndText(int seunNum, int ilganNum, bool isCheongan){ //육친
    String yugchinText = '';
    if(isCheongan == true){
      if(ilganNum % 2 == 0){ //양일간
        yugchinText = yugchinClass.YugchinClass().list6chin[(listSeunCheongan0[seunNum] - ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
      }
      else{ //음일간
        yugchinText = yugchinClass.YugchinClass().list6chin[((listSeunCheongan0[seunNum]%2 == 1? listSeunCheongan0[seunNum]:(listSeunCheongan0[seunNum]+2)) - ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
      }
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text(yugchinText, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      );
    }
    else{
      yugchinText = yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(listSeunJiji0[seunNum], ilganNum)];
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text(yugchinText, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      );
    }
  }

  Container GetSeunGanjiBoxAndText(int seunNum, bool isCheongan){
    if(isCheongan == true){
      return  Container(
        width: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        height: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        padding: EdgeInsets.only(top:style.UIOhengBoxPadding2),
        margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.5, top: style.UIOhengMarginTop * 0.5),
        decoration: BoxDecoration(
          boxShadow: [style.uiDeunSeunShadow],
          color: listSeunCheonganBoxColor0[seunNum],
          borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
        ),
        //alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () {
            SetSeunButtonSelectColor(seunNum);
            if(personalDataManager.deunSeunData % 10 != 1) {
              if(isAddSeunToPalja == true && seunNum == nowSeunNum0){ //이미 선택된 세운 누르면 취소
                widget.setPersonPaljaData(widget.personNum, false, [-2,-2]);
                isAddSeunToPalja = false;
              } else { //아니면 간지 추가
                if (isAddDeunToPalja == false) {
                  widget.setPersonPaljaData(
                      widget.personNum, true, [listDeunCheongan0[nowDeunNum0], listDeunJiji0[nowDeunNum0]]); //[listDeunCheongan0[deunNum], listDeunJiji0[deunNum]]);
                  isAddDeunToPalja = true;
                }
                widget.setPersonPaljaData(widget.personNum, false, [listSeunCheongan0[seunNum], listSeunJiji0[seunNum]]);
                isAddSeunToPalja = true;
              }
            }
            nowSeunYear = (nowDeunNum0 * 10) + deunStart0 - 1 + seunNum + widget.birthYear0;
            setState(() {
              nowSeunNum0 = seunNum;
            });
            SetWolun();
          },
          style: ElevatedButton.styleFrom(alignment: Alignment.center, splashFactory: NoSplash.splashFactory, padding:EdgeInsets.only(bottom:buttonPaddingVal),
              backgroundColor: listSeunCheonganBoxColor0[seunNum], elevation:0.0, foregroundColor: listSeunCheonganBoxColor0[seunNum], surfaceTintColor: Colors.transparent),
          child:Align(alignment: Alignment.center,child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][listSeunCheongan0[seunNum]], style:TextStyle(fontSize: style.UIOhengDeunFontSize, fontWeight: style.UIOhengDeunFontWeight, color: listSeunCheonganTextColor0[seunNum]))),
        )
      );
    }
    else{
      return  Container(
        width: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        height: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
        padding: EdgeInsets.only(top:style.UIOhengBoxPadding2),
        margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.5, top: style.UIOhengMarginTop * 0.5),
        decoration: BoxDecoration(
          boxShadow: [style.uiDeunSeunShadow],
          color: listSeunJijiBoxColor0[seunNum],
          borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
        ),
        alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () {
            SetSeunButtonSelectColor(seunNum);
            if(personalDataManager.deunSeunData % 10 != 1) {
              if(isAddSeunToPalja == true && seunNum == nowSeunNum0){ //이미 선택된 세운 누르면 취소
                widget.setPersonPaljaData(widget.personNum, false, [-2,-2]);
                isAddSeunToPalja = false;
              } else { //아니면 간지 추가
                if (isAddDeunToPalja == false) {
                  widget.setPersonPaljaData(
                      widget.personNum, true, [listDeunCheongan0[nowDeunNum0], listDeunJiji0[nowDeunNum0]]); //[listDeunCheongan0[deunNum], listDeunJiji0[deunNum]]);
                  isAddDeunToPalja = true;
                }
                widget.setPersonPaljaData(widget.personNum, false, [listSeunCheongan0[seunNum], listSeunJiji0[seunNum]]);
                isAddSeunToPalja = true;
              }
            }
            nowSeunYear = (nowDeunNum0 * 10) + deunStart0 - 1 + seunNum + widget.birthYear0;
            setState(() {
              nowSeunNum0 = seunNum;
            });
            SetWolun();
          },
          style: ElevatedButton.styleFrom(alignment: Alignment.center, splashFactory: NoSplash.splashFactory, padding:EdgeInsets.only(bottom:buttonPaddingVal),
              backgroundColor: listSeunJijiBoxColor0[seunNum], elevation:0.0, foregroundColor: listSeunJijiBoxColor0[seunNum], surfaceTintColor: Colors.transparent),
          child:Align(alignment: Alignment.center,child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][listSeunJiji0[seunNum]], style:TextStyle(fontSize: style.UIOhengDeunFontSize, fontWeight: style.UIOhengDeunFontWeight, color: listSeunJijiTextColor0[seunNum]))),
        )
      );
    }
  }

  Container GetSeun12UnseongBoxAndText(int seunNum, int ilganNum){
    String text = sibiunseong.Sibiunseong().Find12Unseong(listSeunJiji0[seunNum], ilganNum);
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  Container GetSeun12SinsalBoxAndText(int seunNum, int yeonjiNum){
    String text = sibiSinsal.SibiSinsal().Find12Sinsal(yeonjiNum, listSeunJiji0[seunNum]);
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  SetSeunGongmangString(){
    listSeunGongmangString.clear();
    List<int> listGongmangCount = [];
    int saveData = ((personalDataManager.deunSeunData % 100000) / 10000).floor();
    for(int i = 0; i < 10; i++){
      String text = '';
      int count = 0;
      if((saveData == 1 || saveData == 3 || saveData == 5 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){ //연공망
        if(listSeunJiji0[i] == (widget.yearGongmangNum/100).floor() || listSeunJiji0[i] == (widget.yearGongmangNum%100).floor()){
          text = '연공망';
          count++;
        }
      }
      if((saveData == 2 || saveData == 3 || saveData == 6 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){
        if(listSeunJiji0[i] == (widget.dayGongmangNum/100).floor() || listSeunJiji0[i] == (widget.dayGongmangNum%100).floor()){
          if(text.isNotEmpty){
            text = '$text\n일공망';
          } else {
            text = '일공망';
          }
          count++;
        }
      }
      if((saveData == 4 || saveData == 5 || saveData == 6 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){
        bool isRocGongmang = false;
        if(listSeunCheongan0[i] == 8 && listSeunJiji0[i] == 8){ //임신 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 0 && listSeunJiji0[i] == 4){ //갑진 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 1 && listSeunJiji0[i] == 5){ //을사 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 3 && listSeunJiji0[i] == 11){ //정해 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 5 && listSeunJiji0[i] == 1){ //기축 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 4 && listSeunJiji0[i] == 10){ //무술 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 2 && listSeunJiji0[i] == 8){ //병신 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 6 && listSeunJiji0[i] == 4){ //경진 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 7 && listSeunJiji0[i] == 5){ //신사 공망
          isRocGongmang = true;
        } else if(listSeunCheongan0[i] == 9 && listSeunJiji0[i] == 11){ //계해 공망
          isRocGongmang = true;
        }
        if(isRocGongmang == true){
          if(text.isNotEmpty){
            text = '$text\n록공망';
          } else {
            text = '록공망';
          }
          count++;
        }
        if(count >= seunGongmangTopCount){
          seunGongmangTopCount = count;
        }
      }
      listSeunGongmangString.add(text);
      listGongmangCount.add(count);
    }
    for(int i = 0; i < 10; i++){
      if(listGongmangCount[i] < seunGongmangTopCount){
        int count = seunGongmangTopCount - listGongmangCount[i];
        while(count > 0){
          if(listSeunGongmangString[i].isEmpty){
            listSeunGongmangString[i] = style.emptySinsalText;
          } else {
            listSeunGongmangString[i] = '${listSeunGongmangString[i]}\n${style.emptySinsalText}';
          }
          count--;
        }
      }
    }
  }

  Container GetSeunGongmangBoxAndText(int seunNum){
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(listSeunGongmangString[seunNum], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  InitWolun(){
    int wolunCheonganStart = 0;

    wolunCheonganStart = ((((listSeunYear0[nowSeunNum0] - 3) % 5) * 2) + 9) % style.stringCheongan[0].length;

    for(int i = 0; i < listWolunCheongan0.length; i++){
      listWolunCheongan0[i] = (i + wolunCheonganStart) % style.stringCheongan[0].length;
    }
    //박스 컬러
    int count = 12;
    for(int i = 0; i < count; i++){
      listWolunCheonganBoxColor0.add(style.SetOhengColor(true, listWolunCheongan0[i]));
      if(listWolunCheongan0[i] == 6 || listWolunCheongan0[i] == 7){
        listWolunCheonganTextColor0.add(style.colorBlack);
      }
      else{
        listWolunCheonganTextColor0.add(Colors.white);
      }
    }
  }

  SetWolun(){
    int wolunCheonganStart = 0;

    wolunCheonganStart = ((((listSeunYear0[nowSeunNum0] - 3) % 5) * 2) + 9) % style.stringCheongan[0].length;

    setState(() {
      for(int i = 0; i < listWolunCheongan0.length; i++){
        listWolunCheongan0[i] = (i + wolunCheonganStart) % style.stringCheongan[0].length;
      }
      //박스 컬러
      int count = 12;
      for(int i = 0; i < count; i++){
        listWolunCheonganBoxColor0[i] = style.SetOhengColor(true, listWolunCheongan0[i]);
        if(listWolunCheongan0[i] == 6 || listWolunCheongan0[i] == 7){
          listWolunCheonganTextColor0[i] = style.colorBlack;
        }
        else{
          listWolunCheonganTextColor0[i] = Colors.white;
        }
      }
    });
  }

  Text GetWolunTitle(){
    containerColorNum = 1;

    if(isHideOld == false){
      int oldRev = 1;
      if(widget.isShowDrawerManOld == 1){
        oldRev = 0;
      }
      int nowOld = listSeunYear0[nowSeunNum0] - widget.birthYear0 + oldRev;

      return Text('${listSeunYear0[nowSeunNum0]}년 ${nowOld}세 월운', style: Theme.of(context).textTheme.titleSmall,  textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false));
    } else {
      return Text('월운', style: Theme.of(context).textTheme.titleSmall,  textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false));
    }
  }

  Container GetWolunWolBoxAndText(int num){
    if(nowSeunYear == DateTime.now().year && isHideOld == false){
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: DateTime.now().month == num? style.colorYellow : Colors.transparent
        ),
        child: Text('${num}월', style: DateTime.now().month == num? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodySmall),
      );
    } else {
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text('${num}월', style: Theme.of(context).textTheme.bodySmall),
      );
    }
  }

  Container GetWolunYugchinBoxAndText(int wolunNum, int ilganNum, bool isCheongan){ //육친
    String yugchinText = '';
    if(isCheongan == true){
      if(ilganNum % 2 == 0){ //양일간
        yugchinText = yugchinClass.YugchinClass().list6chin[(listWolunCheongan0[wolunNum] - ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
      }
      else{ //음일간
        yugchinText = yugchinClass.YugchinClass().list6chin[((listWolunCheongan0[wolunNum]%2 == 1? listWolunCheongan0[wolunNum]:(listWolunCheongan0[wolunNum]+2)) - ilganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length];
      }
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text(yugchinText, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      );
    }
    else{
      yugchinText = yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0((wolunNum + 1) % style.stringJiji[0].length, ilganNum)];
      return Container(
        width: widgetWidth * 0.1,
        alignment: Alignment.center,
        child: Text(yugchinText, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      );
    }
  }

  Container GetWolunGanjiBoxAndText(int wolunNum, bool isCheongan){
    if(isCheongan == true){
      return  Container(
          width: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
          height: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
          padding: EdgeInsets.only(top:style.UIOhengBoxPadding2),
          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.5, top: style.UIOhengMarginTop * 0.5),
          decoration: BoxDecoration(
            boxShadow: [style.uiDeunSeunShadow],
            color: listWolunCheonganBoxColor0[wolunNum],
            borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
          ),
          child: ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(alignment: Alignment.center, splashFactory: NoSplash.splashFactory, padding:EdgeInsets.only(bottom:buttonPaddingVal),
                backgroundColor: listWolunCheonganBoxColor0[wolunNum], elevation:0.0, foregroundColor: listWolunCheonganBoxColor0[wolunNum], surfaceTintColor: Colors.transparent),
            child:Align(alignment: Alignment.center,child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][listWolunCheongan0[wolunNum]], style:TextStyle(fontSize: style.UIOhengDeunFontSize, fontWeight: style.UIOhengDeunFontWeight, color: listWolunCheonganTextColor0[wolunNum]))),
          )
      );
    }
    else{
      bool isWhiteText = true;
      if(wolunNum == 8 || wolunNum == 7){
        isWhiteText = false;
      }
      return  Container(
          width: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
          height: style.UIPaljaDeunBoxHeight * 0.8,//(widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.08,
          padding: EdgeInsets.only(top:style.UIOhengBoxPadding2),
          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop * 0.5, top: style.UIOhengMarginTop * 0.5),
          decoration: BoxDecoration(
            boxShadow: [style.uiDeunSeunShadow],
            color: style.SetOhengColor(false, (wolunNum + 1) % style.stringJiji[0].length),
            borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
          ),
          alignment: Alignment.topCenter,
          child: ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(alignment: Alignment.center, splashFactory: NoSplash.splashFactory, padding:EdgeInsets.only(bottom:buttonPaddingVal),
                backgroundColor: style.SetOhengColor(false, (wolunNum + 1) % style.stringJiji[0].length), elevation:0.0, foregroundColor: style.SetOhengColor(false, (wolunNum + 1) % style.stringJiji[0].length), surfaceTintColor: Colors.transparent),
            child:Align(alignment: Alignment.center,child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][(wolunNum + 1) % style.stringJiji[0].length], style:TextStyle(fontSize: style.UIOhengDeunFontSize, fontWeight: style.UIOhengDeunFontWeight, color: isWhiteText == true? Colors.white : style.colorBlack))),
          )
      );
    }
  }

  Container GetWolun12UnseongBoxAndText(int wolunNum, int ilganNum){
    String text = sibiunseong.Sibiunseong().Find12Unseong((wolunNum + 1) % style.stringJiji[0].length, ilganNum);
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  SetWolunGongmangString(){
    listWolunGongmangString.clear();
    List<int> listGongmangCount = [];
    int saveData = ((personalDataManager.deunSeunData % 100000) / 10000).floor();
    for(int i = 0; i < 12; i++){
      String text = '';
      int count = 0;
      int wolunNum = (i + 1) % style.stringJiji[0].length;
      if((saveData == 1 || saveData == 3 || saveData == 5 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){ //연공망
        if(wolunNum == (widget.yearGongmangNum/100).floor() || wolunNum == (widget.yearGongmangNum%100).floor()){
          text = '연공망';
          count++;
        }
      }
      if((saveData == 2 || saveData == 3 || saveData == 6 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){
        if(wolunNum == (widget.dayGongmangNum/100).floor() || wolunNum == (widget.dayGongmangNum%100).floor()){
          if(text.isNotEmpty){
            text = '$text\n일공망';
          } else {
            text = '일공망';
          }
          count++;
        }
      }
      if((saveData == 4 || saveData == 5 || saveData == 6 || saveData == 7) || widget.isShowDrawerDeunSeunGongmang == 2){
        bool isRocGongmang = false;
        if(listWolunCheongan0[i] == 8 && wolunNum == 8){ //임신 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 0 && wolunNum == 4){ //갑진 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 1 && wolunNum == 5){ //을사 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 3 && wolunNum == 11){ //정해 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 5 && wolunNum == 1){ //기축 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 4 && wolunNum == 10){ //무술 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 2 && wolunNum == 8){ //병신 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 6 && wolunNum == 4){ //경진 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 7 && wolunNum == 5){ //신사 공망
          isRocGongmang = true;
        } else if(listWolunCheongan0[i] == 9 && wolunNum == 11){ //계해 공망
          isRocGongmang = true;
        }
        if(isRocGongmang == true){
          if(text.isNotEmpty){
            text = '$text\n록공망';
          } else {
            text = '록공망';
          }
          count++;
        }
        if(count >= wolunGongmangTopCount){
          wolunGongmangTopCount = count;
        }
      }
      listWolunGongmangString.add(text);
      listGongmangCount.add(count);
    }
    for(int i = 0; i < 12; i++){
      if(listGongmangCount[i] < wolunGongmangTopCount){
        int count = wolunGongmangTopCount - listGongmangCount[i];
        while(count > 0){
          if(listWolunGongmangString[i].isEmpty){
            listWolunGongmangString[i] = style.emptySinsalText;
          } else {
            listWolunGongmangString[i] = '${listWolunGongmangString[i]}\n${style.emptySinsalText}';
          }
          count--;
        }
      }
    }
  }

  Container GetWolunGongmangBoxAndText(int wolunNum){
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(listWolunGongmangString[wolunNum], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  Container GetWolun12SinsalBoxAndText(int wolunNum, int yeonjiNum){
    String text = sibiSinsal.SibiSinsal().Find12Sinsal(yeonjiNum, (wolunNum + 1) % style.stringJiji[0].length);
    return Container(
      width: widgetWidth * 0.1,
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    );
  }

  Widget GetDeunYugchinWidget(bool isCheongan){
    if(widget.isShowDrawerDeunSeunYugchin == 0){//((personalDataManager.deunSeunData % 100) / 10).floor() == 1 && isShowDrawerYugchin == 0) {
      return SizedBox.shrink();
    } else {
      if(isCheongan == true){
        return Container(  //천간 육친
          width: widgetWidth,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray0,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: style.colorBoxGray0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetDeunYugchinBoxAndText(9, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(8, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(7, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(6, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(5, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(4, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(3, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(2, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(1, widget.listPaljaData0[4], true),
              GetDeunYugchinBoxAndText(0, widget.listPaljaData0[4], true),
            ],
          ),
        );
      } else {
        containerColorNum = (containerColorNum + 1) % 2;
        return Container(  //지지 육친
          width: widgetWidth,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[containerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[containerColorNum],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 1? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 1? style.textFiledRadius:0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetDeunYugchinBoxAndText(9, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(8, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(7, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(6, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(5, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(4, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(3, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(2, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(1, widget.listPaljaData0[4], false),
              GetDeunYugchinBoxAndText(0, widget.listPaljaData0[4], false),
            ],
          ),
        );
      }
    }
  }

  Widget GetDeun12UnseongWidget(){
    if(widget.isShowDrawerDeunSeunSibiunseong == 0){
      return SizedBox.shrink();
    } else {
      containerColorNum = (containerColorNum + 1) % 2;
      return Container(  //12운성
        width: widgetWidth,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: listContainerColor[containerColorNum],
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
          color: listContainerColor[containerColorNum],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 2? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 2? style.textFiledRadius:0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetDeun12UnseongBoxAndText(9, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(8, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(7, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(6, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(5, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(4, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(3, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(2, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(1, widget.listPaljaData0[4]),
            GetDeun12UnseongBoxAndText(0, widget.listPaljaData0[4]),
          ],
        ),
      );
    }
  }

  Widget GetDeunGongmangWidget(){
    if(widget.isShowDrawerDeunSeunGongmang == 0){
      return SizedBox.shrink();
    } else {
      SetDeunGongmangString();
      containerColorNum = (containerColorNum + 1) % 2;
      return Container(  //공망
        width: widgetWidth,
        height: style.UIBoxLineHeight + (style.UIBoxLineAddHeight * (deunGongmangTopCount - 1)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[containerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[containerColorNum],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 3? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 3? style.textFiledRadius:0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetDeunGongmangBoxAndText(9),
            GetDeunGongmangBoxAndText(8),
            GetDeunGongmangBoxAndText(7),
            GetDeunGongmangBoxAndText(6),
            GetDeunGongmangBoxAndText(5),
            GetDeunGongmangBoxAndText(4),
            GetDeunGongmangBoxAndText(3),
            GetDeunGongmangBoxAndText(2),
            GetDeunGongmangBoxAndText(1),
            GetDeunGongmangBoxAndText(0),
          ],
        ),
      );
    }
  }

  Widget GetDeun12SinsalWidget(){
    if(widget.isShowDrawerDeunSeunSibisinsal == 0){
      return SizedBox.shrink();
    } else {
      containerColorNum = (containerColorNum + 1) % 2;
      return Container(  //12신살
        width: widgetWidth,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
            color: listContainerColor[containerColorNum],
            boxShadow: [
              BoxShadow(
                color: listContainerColor[containerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 4? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 4? style.textFiledRadius:0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetDeun12SinsalBoxAndText(9, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(8, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(7, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(6, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(5, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(4, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(3, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(2, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(1, widget.listPaljaData0[1]),
            GetDeun12SinsalBoxAndText(0, widget.listPaljaData0[1]),
          ],
        ),
      );
    }
  }

  Widget GetSeunYearWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GetSeunsuBoxAndText(9),
        GetSeunsuBoxAndText(8),
        GetSeunsuBoxAndText(7),
        GetSeunsuBoxAndText(6),
        GetSeunsuBoxAndText(5),
        GetSeunsuBoxAndText(4),
        GetSeunsuBoxAndText(3),
        GetSeunsuBoxAndText(2),
        GetSeunsuBoxAndText(1),
        GetSeunsuBoxAndText(0),
      ],
    );
  }

  Widget GetSeunOldWidget(){
    if(widget.isShowDrawerDeunSeunOld == 0 || isHideOld == true){
      return SizedBox.shrink();
    } else {
      int oldContainerColorNum = 0;
      if(widget.isShowDrawerDeunSeunYugchin == 1 && isHideOld == false){
        oldContainerColorNum = 1;
      }
      return Container(
        width: widgetWidth,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[oldContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[oldContainerColorNum],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetSeunOldBoxAndText(9),
            GetSeunOldBoxAndText(8),
            GetSeunOldBoxAndText(7),
            GetSeunOldBoxAndText(6),
            GetSeunOldBoxAndText(5),
            GetSeunOldBoxAndText(4),
            GetSeunOldBoxAndText(3),
            GetSeunOldBoxAndText(2),
            GetSeunOldBoxAndText(1),
            GetSeunOldBoxAndText(0),
          ],
        ),
      );
    }
  }

  Widget GetSeunYugchinWidget(bool isCheongan){
    if(widget.isShowDrawerDeunSeunYugchin == 0) {
      return SizedBox.shrink();
    } else {
      if(isCheongan == true){
        return Container(  //천간 육친
          width: widgetWidth,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray0,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: style.colorBoxGray0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetSeunYugchinBoxAndText(9, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(8, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(7, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(6, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(5, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(4, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(3, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(2, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(1, widget.listPaljaData0[4], true),
              GetSeunYugchinBoxAndText(0, widget.listPaljaData0[4], true),
            ],
          ),
        );
      } else {
        seunContainerColorNum = (seunContainerColorNum + 1) % 2;
        return Container(  //지지 육친
          width: widgetWidth,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: listContainerColor[seunContainerColorNum],
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0),
                ),
              ],
              color: listContainerColor[seunContainerColorNum],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 1? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 1? style.textFiledRadius:0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetSeunYugchinBoxAndText(9, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(8, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(7, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(6, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(5, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(4, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(3, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(2, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(1, widget.listPaljaData0[4], false),
              GetSeunYugchinBoxAndText(0, widget.listPaljaData0[4], false),
            ],
          ),
        );
      }
    }
  }

  Widget GetSeun12UnseongWidget(){
    if(widget.isShowDrawerDeunSeunSibiunseong == 0){
      return SizedBox.shrink();
    } else {
      seunContainerColorNum = (seunContainerColorNum + 1) % 2;
      return Container(  //12운성
        width: widgetWidth,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[seunContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[seunContainerColorNum],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 2? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 2? style.textFiledRadius:0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetSeun12UnseongBoxAndText(9, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(8, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(7, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(6, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(5, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(4, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(3, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(2, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(1, widget.listPaljaData0[4]),
            GetSeun12UnseongBoxAndText(0, widget.listPaljaData0[4]),
          ],
        ),
      );
    }
  }

  Widget GetSeunGongmangWidget(){
    if(widget.isShowDrawerDeunSeunGongmang == 0){
      return SizedBox.shrink();
    } else {
      SetSeunGongmangString();
      seunContainerColorNum = (seunContainerColorNum + 1) % 2;
      return Container(  //공망
        width: widgetWidth,
        height: style.UIBoxLineHeight + (style.UIBoxLineAddHeight * (seunGongmangTopCount - 1)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[seunContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[seunContainerColorNum],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 3? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 3? style.textFiledRadius:0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetSeunGongmangBoxAndText(9),
            GetSeunGongmangBoxAndText(8),
            GetSeunGongmangBoxAndText(7),
            GetSeunGongmangBoxAndText(6),
            GetSeunGongmangBoxAndText(5),
            GetSeunGongmangBoxAndText(4),
            GetSeunGongmangBoxAndText(3),
            GetSeunGongmangBoxAndText(2),
            GetSeunGongmangBoxAndText(1),
            GetSeunGongmangBoxAndText(0),
          ],
        ),
      );
    }
  }

  Widget GetSeun12SinsalWidget(){
    if(widget.isShowDrawerDeunSeunSibisinsal == 0){
      return SizedBox.shrink();
    } else {
      seunContainerColorNum = (seunContainerColorNum + 1) % 2;
      return Container(  //12신살
        width: widgetWidth,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
            color: listContainerColor[seunContainerColorNum],
            boxShadow: [
              BoxShadow(
                color: listContainerColor[seunContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 4? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 4? style.textFiledRadius:0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetSeun12SinsalBoxAndText(9, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(8, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(7, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(6, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(5, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(4, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(3, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(2, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(1, widget.listPaljaData0[1]),
            GetSeun12SinsalBoxAndText(0, widget.listPaljaData0[1]),
          ],
        ),
      );
    }
  }

  Widget GetWolunWolWidget(){
    int oldContainerColorNum = 0;
    if(widget.isShowDrawerDeunSeunYugchin == 1 && isHideOld == false){
      oldContainerColorNum = 1;
    }
    return Container(
        width: widgetWidth * 1.2,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: listContainerColor[oldContainerColorNum],
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
          color: listContainerColor[oldContainerColorNum],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetWolunWolBoxAndText(12),
            GetWolunWolBoxAndText(11),
            GetWolunWolBoxAndText(10),
            GetWolunWolBoxAndText(9),
            GetWolunWolBoxAndText(8),
            GetWolunWolBoxAndText(7),
            GetWolunWolBoxAndText(6),
            GetWolunWolBoxAndText(5),
            GetWolunWolBoxAndText(4),
            GetWolunWolBoxAndText(3),
            GetWolunWolBoxAndText(2),
            GetWolunWolBoxAndText(1),
          ],
        ),
      );
  }

  Widget GetWolunYugchinWidget(bool isCheongan){
    if(widget.isShowDrawerDeunSeunYugchin == 0) {
      return SizedBox.shrink();
    } else {
      if(isCheongan == true){
        return Container(  //천간 육친
          width: widgetWidth * 1.2,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray0,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: style.colorBoxGray0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetWolunYugchinBoxAndText(11, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(10, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(9, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(8, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(7, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(6, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(5, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(4, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(3, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(2, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(1, widget.listPaljaData0[4], true),
              GetWolunYugchinBoxAndText(0, widget.listPaljaData0[4], true),
            ],
          ),
        );
      } else {
        wolunContainerColorNum = (wolunContainerColorNum + 1) % 2;
        return Container(  //지지 육친
          width: widgetWidth * 1.2,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: listContainerColor[wolunContainerColorNum],
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0),
                ),
              ],
              color: listContainerColor[wolunContainerColorNum],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 1? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 1? style.textFiledRadius:0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetWolunYugchinBoxAndText(11, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(10, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(9, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(8, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(7, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(6, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(5, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(4, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(3, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(2, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(1, widget.listPaljaData0[4], false),
              GetWolunYugchinBoxAndText(0, widget.listPaljaData0[4], false),
            ],
          ),
        );
      }
    }
  }

  Widget GetWolun12UnseongWidget(){
    if(widget.isShowDrawerDeunSeunSibiunseong == 0){
      return SizedBox.shrink();
    } else {
      wolunContainerColorNum = (wolunContainerColorNum + 1) % 2;
      return Container(  //12운성
        width: widgetWidth * 1.2,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[wolunContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[wolunContainerColorNum],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 2? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 2? style.textFiledRadius:0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetWolun12UnseongBoxAndText(11, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(10, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(9, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(8, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(7, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(6, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(5, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(4, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(3, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(2, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(1, widget.listPaljaData0[4]),
            GetWolun12UnseongBoxAndText(0, widget.listPaljaData0[4]),
          ],
        ),
      );
    }
  }

  Widget GetWolunGongmangWidget(){
    if(widget.isShowDrawerDeunSeunGongmang == 0){
      return SizedBox.shrink();
    } else {
      SetWolunGongmangString();
      wolunContainerColorNum = (wolunContainerColorNum + 1) % 2;
      return Container(  //공망
        width: widgetWidth * 1.2,
        height: style.UIBoxLineHeight + (style.UIBoxLineAddHeight * (wolunGongmangTopCount - 1)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: listContainerColor[wolunContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: listContainerColor[wolunContainerColorNum],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 3? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 3? style.textFiledRadius:0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetWolunGongmangBoxAndText(11),
            GetWolunGongmangBoxAndText(10),
            GetWolunGongmangBoxAndText(9),
            GetWolunGongmangBoxAndText(8),
            GetWolunGongmangBoxAndText(7),
            GetWolunGongmangBoxAndText(6),
            GetWolunGongmangBoxAndText(5),
            GetWolunGongmangBoxAndText(4),
            GetWolunGongmangBoxAndText(3),
            GetWolunGongmangBoxAndText(2),
            GetWolunGongmangBoxAndText(1),
            GetWolunGongmangBoxAndText(0),
          ],
        ),
      );
    }
  }

  Widget GetWolun12SinsalWidget(){
    if(widget.isShowDrawerDeunSeunSibisinsal == 0){

      return SizedBox.shrink();
    } else {
      wolunContainerColorNum = (wolunContainerColorNum + 1) % 2;
      return Container(  //12신살
        width: widgetWidth * 1.2,
        height: style.UIBoxLineHeight,
        decoration: BoxDecoration(
            color: listContainerColor[wolunContainerColorNum],
            boxShadow: [
              BoxShadow(
                color: listContainerColor[wolunContainerColorNum],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 4? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 4? style.textFiledRadius:0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetWolun12SinsalBoxAndText(11, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(10, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(9, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(8, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(7, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(6, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(5, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(4, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(3, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(2, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(1, widget.listPaljaData0[1]),
            GetWolun12SinsalBoxAndText(0, widget.listPaljaData0[1]),
          ],
        ),
      );
    }
  }

  double GetWolunWidgetHeight(){
    double wolunWidgetHeight = style.UIPaljaDeunBoxHeight * 2;
    wolunWidgetHeight += style.UIBoxLineHeight; //월 표시
    if(widget.isShowDrawerDeunSeunYugchin != 0){  //육친 표시
      wolunWidgetHeight += style.UIBoxLineHeight * 2;
    }
    if(widget.isShowDrawerDeunSeunSibiunseong != 0){  //십이운성 표시
      wolunWidgetHeight += style.UIBoxLineHeight;
    }
    if(widget.isShowDrawerDeunSeunGongmang != 0){ //공망 표시
      wolunWidgetHeight += style.UIBoxLineHeight + (style.UIBoxLineAddHeight * (wolunGongmangTopCount - 1));
    }
    if(widget.isShowDrawerDeunSeunSibisinsal != 0){ //신살 표시
      wolunWidgetHeight += style.UIBoxLineHeight;
    }

    return wolunWidgetHeight;
  }
  Widget GetWolun(){
    if(((personalDataManager.deunSeunData % 10000000) / 1000000).floor() == 1){
      return SizedBox.shrink();
    } else {
      List<Widget> listWolunWidget = [];
      listWolunWidget.add(GetWolunWolWidget());
      listWolunWidget.add(GetWolunYugchinWidget(true));
      listWolunWidget.add(Container(  //월운 천간 버튼
        width: widgetWidth * 1.2,
        height: style.UIPaljaDeunBoxHeight,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width:1, color:style.colorGrey)),
          boxShadow: [
            BoxShadow(
              color: style.colorBoxGray1,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
          color: style.colorBoxGray1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GetWolunGanjiBoxAndText(11, true),
            GetWolunGanjiBoxAndText(10, true),
            GetWolunGanjiBoxAndText(9, true),
            GetWolunGanjiBoxAndText(8, true),
            GetWolunGanjiBoxAndText(7, true),
            GetWolunGanjiBoxAndText(6, true),
            GetWolunGanjiBoxAndText(5, true),
            GetWolunGanjiBoxAndText(4, true),
            GetWolunGanjiBoxAndText(3, true),
            GetWolunGanjiBoxAndText(2, true),
            GetWolunGanjiBoxAndText(1, true),
            GetWolunGanjiBoxAndText(0, true),

          ],
        ),
      ));
      listWolunWidget.add(Container(  //월운 지지 버튼
        width: widgetWidth * 1.2,
        height: style.UIPaljaDeunBoxHeight,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width:1, color:style.colorGrey)),
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray1,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: style.colorBoxGray1,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 0? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 0? style.textFiledRadius:0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetWolunGanjiBoxAndText(11, false),
            GetWolunGanjiBoxAndText(10, false),
            GetWolunGanjiBoxAndText(9, false),
            GetWolunGanjiBoxAndText(8, false),
            GetWolunGanjiBoxAndText(7, false),
            GetWolunGanjiBoxAndText(6, false),
            GetWolunGanjiBoxAndText(5, false),
            GetWolunGanjiBoxAndText(4, false),
            GetWolunGanjiBoxAndText(3, false),
            GetWolunGanjiBoxAndText(2, false),
            GetWolunGanjiBoxAndText(1, false),
            GetWolunGanjiBoxAndText(0, false),

          ],
        ),
      ));
      listWolunWidget.add(GetWolunYugchinWidget(false));
      listWolunWidget.add(GetWolun12UnseongWidget());
      listWolunWidget.add(GetWolunGongmangWidget());
      listWolunWidget.add(GetWolun12SinsalWidget());

      return Column(
        children: [
          Container(  //월운 연도와 나이
            width: widgetWidth,
            height: style.UIBoxLineHeight,
            margin: EdgeInsets.only(top: style.UIButtonPaddingTop * 0.5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: style.colorMainBlue,
                boxShadow: [
                  BoxShadow(
                    color: style.colorMainBlue,
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius))),
            child: GetWolunTitle(),
          ),
          Container(
            width: widgetWidth,
            height: GetWolunWidgetHeight(),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(style.textFiledRadius), bottomRight: Radius.circular(style.textFiledRadius))),
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                child:Column(
                  children: listWolunWidget,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState(){
    super.initState();
    if(widget.isOneWidget == false) {
      widgetWidth = (widget.widgetWidth - (style.UIMarginLeft * 2));
    }
    else {
      widgetWidth = widget.widgetWidth - style.UIMarginLeft;
    }

    SetDeun();

    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1) { //인적사항 숨김에 나이 표시되어있으면
      int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
      if (isShowPersonalDataNum == 2 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7) {
        isHideOld = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    containerColorNum = widget.deunContainerColorNum;
    seunContainerColorNum = widget.seunContainerColorNum;
    wolunContainerColorNum = widget.seunContainerColorNum;

    if(widget.isShowDrawerKoreanGanji == 1){
      buttonPaddingVal = 0; } else {
      buttonPaddingVal = 4; }

    if(widget.isOneWidget == false) {
      widgetWidth = (widget.widgetWidth - (style.UIMarginLeft * 2));
    }
    else {
      widgetWidth = widget.widgetWidth - style.UIMarginLeft;
    }

    return Column(
      children: [
        Container(  //대운수
          width: widgetWidth,
          height: style.UIBoxLineHeight,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: style.colorMainBlue,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0),
                ),
              ],
              color: style.colorMainBlue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetDeunsuBoxAndText(9),
              GetDeunsuBoxAndText(8),
              GetDeunsuBoxAndText(7),
              GetDeunsuBoxAndText(6),
              GetDeunsuBoxAndText(5),
              GetDeunsuBoxAndText(4),
              GetDeunsuBoxAndText(3),
              GetDeunsuBoxAndText(2),
              GetDeunsuBoxAndText(1),
              GetDeunsuBoxAndText(0),
            ],
          ),
        ),
        GetDeunYugchinWidget(true),
        Container(  //대운 천간 버튼
          width: widgetWidth,
          height: style.UIPaljaDeunBoxHeight,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width:1, color:style.colorGrey)),
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray1,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: style.colorBoxGray1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GetDeunGanjiBoxAndText(9, true),
              GetDeunGanjiBoxAndText(8, true),
              GetDeunGanjiBoxAndText(7, true),
              GetDeunGanjiBoxAndText(6, true),
              GetDeunGanjiBoxAndText(5, true),
              GetDeunGanjiBoxAndText(4, true),
              GetDeunGanjiBoxAndText(3, true),
              GetDeunGanjiBoxAndText(2, true),
              GetDeunGanjiBoxAndText(1, true),
              GetDeunGanjiBoxAndText(0, true),

            ],
          ),
        ),
        Container(  //대운 지지 버튼
          width: widgetWidth,
          height: style.UIPaljaDeunBoxHeight,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width:1, color:style.colorGrey)),
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray1,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            color: style.colorBoxGray1,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 0? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 0? style.textFiledRadius:0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetDeunGanjiBoxAndText(9, false),
              GetDeunGanjiBoxAndText(8, false),
              GetDeunGanjiBoxAndText(7, false),
              GetDeunGanjiBoxAndText(6, false),
              GetDeunGanjiBoxAndText(5, false),
              GetDeunGanjiBoxAndText(4, false),
              GetDeunGanjiBoxAndText(3, false),
              GetDeunGanjiBoxAndText(2, false),
              GetDeunGanjiBoxAndText(1, false),
              GetDeunGanjiBoxAndText(0, false),

            ],
          ),
        ),
        GetDeunYugchinWidget(false),
        GetDeun12UnseongWidget(),
        GetDeunGongmangWidget(),
        GetDeun12SinsalWidget(),
        //여기까지 대운
        Container(  //세운 연도
          width: widgetWidth,
          height: style.UIBoxLineHeight,
          margin: EdgeInsets.only(top: style.UIButtonPaddingTop * 0.5),
          decoration: BoxDecoration(
              color: style.colorMainBlue,
              boxShadow: [
                BoxShadow(
                  color: style.colorMainBlue,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetSeunsuBoxAndText(9),
              GetSeunsuBoxAndText(8),
              GetSeunsuBoxAndText(7),
              GetSeunsuBoxAndText(6),
              GetSeunsuBoxAndText(5),
              GetSeunsuBoxAndText(4),
              GetSeunsuBoxAndText(3),
              GetSeunsuBoxAndText(2),
              GetSeunsuBoxAndText(1),
              GetSeunsuBoxAndText(0),
            ],
          ),
        ),
        GetSeunOldWidget(),
        GetSeunYugchinWidget(true),
        Container(  //세운 천간 버튼
          width: widgetWidth,
          height: style.UIPaljaDeunBoxHeight,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width:1, color:style.colorGrey)),
            color: style.colorBoxGray1,
            boxShadow: [
              BoxShadow(
                color: style.colorBoxGray1,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GetSeunGanjiBoxAndText(9, true),
              GetSeunGanjiBoxAndText(8, true),
              GetSeunGanjiBoxAndText(7, true),
              GetSeunGanjiBoxAndText(6, true),
              GetSeunGanjiBoxAndText(5, true),
              GetSeunGanjiBoxAndText(4, true),
              GetSeunGanjiBoxAndText(3, true),
              GetSeunGanjiBoxAndText(2, true),
              GetSeunGanjiBoxAndText(1, true),
              GetSeunGanjiBoxAndText(0, true),

            ],
          ),
        ),
        Container(  //세운 지지 버튼
          width: widgetWidth,
          height: style.UIPaljaDeunBoxHeight,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width:1, color:style.colorGrey)),
              boxShadow: [
                BoxShadow(
                  color: style.colorBoxGray1,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0),
                ),
              ],
              color: style.colorBoxGray1,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.lastDeunSeunWidgetNum == 0? style.textFiledRadius:0), bottomRight: Radius.circular(widget.lastDeunSeunWidgetNum == 0? style.textFiledRadius:0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetSeunGanjiBoxAndText(9, false),
              GetSeunGanjiBoxAndText(8, false),
              GetSeunGanjiBoxAndText(7, false),
              GetSeunGanjiBoxAndText(6, false),
              GetSeunGanjiBoxAndText(5, false),
              GetSeunGanjiBoxAndText(4, false),
              GetSeunGanjiBoxAndText(3, false),
              GetSeunGanjiBoxAndText(2, false),
              GetSeunGanjiBoxAndText(1, false),
              GetSeunGanjiBoxAndText(0, false),

            ],
          ),
        ),
        GetSeunYugchinWidget(false),
        GetSeun12UnseongWidget(),
        GetSeunGongmangWidget(),
        GetSeun12SinsalWidget(),
        //여기까지 세운
        GetWolun(),
        SizedBox(height:style.UIMarginTop),
      ],
    );
  }
}

class DeunFindClass{

  List<int> FindDeun(bool gender, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, List<int> listUserPalja, int targetYear, int targetMonth, int targetDay){
    List<int> listDeun = [];

    bool isPatrol0 = true; //대운 순행인지
    if((gender == true && listUserPalja[0] % 2 == 1) || (gender == false && listUserPalja[0] % 2 == 0)){
      isPatrol0 = false;
    }
    int deunStart = 0;

    //대운 시작 나이 찾기
    if(birthYear > 1901){
      int leftDays = 0;
      if(isPatrol0 == true){  //순행이면
        if(birthYear == 1901){
          if(birthDay == 1){
            deunStart = 2;
          }
          else{
            deunStart = 1;
          }
        }
        else{
          if(((birthDay * 10000) + (birthHour * 100) + birthMin) <= findGanji.listSeasonData[birthYear - findGanji.stanYear][birthMonth - 1]){ //태어난 달에 다음 절기가 있고 다음 절기 보다 일찍 태어났으면
            deunStart = (((findGanji.listSeasonData[birthYear - findGanji.stanYear][birthMonth - 1] / 10000).floor() - birthDay) / 3).round();
            if(deunStart == 0){
              deunStart = 1;
            }
          }
          else{   //다음 절기가 없으면 태어난 달에 없으면
            leftDays = (findGanji.listSolNday[birthMonth - 1] - birthDay) + ((findGanji.listSeasonData[birthYear - findGanji.stanYear + (birthMonth/12).floor()][birthMonth % 12] / 10000).floor());
            deunStart = (leftDays / 3).round();
          }
        }
      }
      else{ //역행이면
        if(((birthDay * 10000) + (birthHour * 100) + birthMin) >= findGanji.listSeasonData[birthYear - findGanji.stanYear][birthMonth - 1]){ //태어난 달에 이전 절기가 있고 이전 절기 보다 늦게 태어났으면
          deunStart = ((birthDay - (findGanji.listSeasonData[birthYear - findGanji.stanYear - 1][birthMonth - 1] / 10000).floor()) / 3).round();
          if(deunStart == 0){
            deunStart = 1;
          }
        }
        else{ //태어난 달에 이전 절기가 없고 이전 달에 이전 절기가 있으면
          if(birthMonth == 1){ //1월에 태어났으면
            if(birthYear == 1901){
              if(birthDay < 3){
                deunStart = 8;
              }
              else{
                deunStart = 9;
              }
            }
            else{
              leftDays = birthDay + findGanji.listSolNday[11] - (findGanji.listSeasonData[birthYear - findGanji.stanYear - 1][11] / 10000).floor();
              deunStart = (leftDays / 3).round();
            }
          }
          else{
            leftDays = birthDay + findGanji.listSolNday[birthMonth - 2] - (findGanji.listSeasonData[birthYear - findGanji.stanYear][birthMonth - 2] / 10000).floor();
            deunStart = (leftDays / 3).round();
          }
        }
      }
    }

    int nowOld = targetYear - birthYear + 1;

    if(deunStart > nowOld){
      listDeun.add(-2);listDeun.add(-2);// = [-2,-2];
      return listDeun;
    } else {
      int count = 0;
      while(true){
        if(deunStart != -1){
          if(deunStart + (count * 10) >= (nowOld - 9) || count == 9){
            if(isPatrol0 == true){
              listDeun.add((listUserPalja[2]+count+1) % style.stringCheongan[0].length);
              listDeun.add((listUserPalja[3]+count+1) % style.stringJiji[0].length);
            } else {
              listDeun.add((listUserPalja[2]-count-1) % style.stringCheongan[0].length);
              listDeun.add((listUserPalja[3]-count-1) % style.stringJiji[0].length);
            }
            break;
          }
          else{
            count++;
          }
        }
      }
    }
    return listDeun;
  }
}

//마우스로 스크롤
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
  };
}