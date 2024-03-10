import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;

class DeunSeunSettingWidget extends StatefulWidget {
  const DeunSeunSettingWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<DeunSeunSettingWidget> createState() => _DeunSeunSettingState();
}

class _DeunSeunSettingState extends State<DeunSeunSettingWidget> {
  int isShowGanjiNum = 0; //0:안보여줌, 1:보여줌
  List<String> ganjiInfoString = ['대운, 세운을 간지로 추가하지 않습니다', '대운, 세운을 누르면 시주 왼쪽에 간지로 추가합니다', '간지로 추가하고 합충형파를 표시합니다'];
  Image ganjiButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment ganjiAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowYugchin = 0; //0:안보여줌, 1:보여줌
  Image yugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment yugchinAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowSibiunseong = 0; //0:안보여줌, 1:보여줌
  Image sibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment sibiunseongAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowSinsal = 0; //0:안보여줌, 1:보여줌
  Image sinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment sinsalAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowGongmang = 0; //0:안보여줌, 1:보여줌
  bool isShowYearGongmang = false, isShowDayGongmang = false, isShowRocGongmang = false;
  double gongmangContainerHeight = 0;
  Image gongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment gongmangAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowOld = 0; //0:안보여줌, 1:보여줌
  Image oldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment oldAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowWolun = 0; //0:안보여줌, 1:보여줌
  Image wolunButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment wolunAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  double widgetWidth = 0;
  double widgetHeight = 0;

  SetGanji({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowGanjiNum = (isShowGanjiNum + 1) % 3;
      personalDataManager.SaveDeunSeunData(1, isShowGanjiNum + 1);
    });}

    if(isShowGanjiNum == 0){
      ganjiAlign = Alignment.centerLeft;
      ganjiButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowGanjiNum == 1){
      ganjiAlign = Alignment.center;
      ganjiButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    } else if(isShowGanjiNum == 2){
    ganjiAlign = Alignment.centerRight;
    ganjiButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetYugchin({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowYugchin = (isShowYugchin + 1) % 2;
      personalDataManager.SaveDeunSeunData(10, isShowYugchin + 1);
      print(personalDataManager.deunSeunData);
    });}

    if(isShowYugchin == 0){
      yugchinAlign = Alignment.centerLeft;
      yugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      yugchinAlign = Alignment.centerRight;
      yugchinButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetSibiunseong({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowSibiunseong = (isShowSibiunseong + 1) % 2;
      personalDataManager.SaveDeunSeunData(100, isShowSibiunseong + 1);
    });}

    if(isShowSibiunseong == 0){
      sibiunseongAlign = Alignment.centerLeft;
      sibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      sibiunseongAlign = Alignment.centerRight;
      sibiunseongButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetSinsal({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowSinsal = (isShowSinsal + 1) % 2;
      personalDataManager.SaveDeunSeunData(1000, isShowSinsal + 1);
    });}

    if(isShowSinsal == 0){
      sinsalAlign = Alignment.centerLeft;
      sinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      sinsalAlign = Alignment.centerRight;
      sinsalButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetGongmang({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowGongmang = (isShowGongmang + 1) % 2;
    });
    }

    if(isShowGongmang == 0){
      gongmangContainerHeight = 0;
      gongmangAlign = Alignment.centerLeft;
      gongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      gongmangContainerHeight = style.saveDataMemoLineHeight * 2.5;
      gongmangAlign = Alignment.centerRight;
      gongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SaveGongmangData(){
    if(isShowGongmang == 0){
      personalDataManager.SaveDeunSeunData(10000, 9);
    }
    else{
      int dataNum = 0;
      if(isShowYearGongmang == true){
        dataNum = dataNum + 1;}
      if(isShowDayGongmang == true){
        dataNum = dataNum + 2;}
      if(isShowRocGongmang == true){
        dataNum = dataNum + 4;}
      if(dataNum == 0){
        dataNum = 9;
      }
      personalDataManager.SaveDeunSeunData(10000, dataNum);
    }
  }

  SetOld({bool isSwitch = true}){  //세운에 나이 보이기
    if(isSwitch == true)
    {setState(() {
      if(isShowOld == 0){
        int personalDataHideNum =  ((personalDataManager.etcData % 100000) / 10000).floor();
        if(((personalDataManager.etcData % 10000) / 1000).floor() != 1 && (personalDataHideNum == 2|| personalDataHideNum == 3|| personalDataHideNum == 6 || personalDataHideNum == 7)){
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('인적사항 숨김으로 인해\n적용할 수 없습니다', textAlign: TextAlign.center,
                ),
              );
            },
          );
        }
        else {
          isShowOld = (isShowOld + 1) % 2;
          personalDataManager.SaveDeunSeunData(100000, isShowOld + 1);
        }
      } else {
        isShowOld = (isShowOld + 1) % 2;
        personalDataManager.SaveDeunSeunData(100000, isShowOld + 1);
      }
    });}

    if(isShowOld == 0){
      oldAlign = Alignment.centerLeft;
      oldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      oldAlign = Alignment.centerRight;
      oldButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetWolun({bool isSwitch = true}){  //세운에 나이 보이기
    if(isSwitch == true)
    {setState(() {
      isShowWolun = (isShowWolun + 1) % 2;
      personalDataManager.SaveDeunSeunData(1000000, isShowWolun + 1);
    });}

    if(isShowWolun == 0){
      wolunAlign = Alignment.centerLeft;
      wolunButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      wolunAlign = Alignment.centerRight;
      wolunButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetAllShow(bool isAllShow){
    if(isAllShow == true){
      isShowGanjiNum = 2;
      isShowYugchin = 1;
      isShowSibiunseong = 1;
      isShowSinsal = 1;
      isShowGongmang = 1;
      isShowOld = 1;
      isShowWolun = 1;
    }
    else{ //모두 끄기
      isShowGanjiNum = 0; //0:안보여줌, 1:보여줌
      isShowYugchin = 0;
      isShowSibiunseong = 0;
      isShowSinsal = 0;
      isShowGongmang = 0;
      isShowOld = 0;
      isShowWolun = 0;
    }

    isShowYearGongmang = isAllShow;
    isShowDayGongmang = isAllShow;
    isShowRocGongmang = isAllShow;

    SetGanji(isSwitch: false);
    SetYugchin(isSwitch: false);
    SetSibiunseong(isSwitch: false);
    SetSinsal(isSwitch: false);
    SetGongmang(isSwitch: false);
    SetOld(isSwitch: false);
    SetWolun(isSwitch: false);

    personalDataManager.SaveDeunSeunData(0, isAllShow == false? 1 : 2, isAll:true);
  }

  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    int dataNum = personalDataManager.deunSeunData;

    int tempNum = dataNum % 10;
    isShowGanjiNum = (dataNum % 10) - 1;
    SetGanji(isSwitch : false);

    tempNum = ((dataNum % 100) / 10).floor(); //십이신살
    isShowYugchin = tempNum - 1;
    SetYugchin(isSwitch : false);

    tempNum = ((dataNum % 1000) / 100).floor(); //십이신살
    isShowSibiunseong = tempNum - 1;
    SetSibiunseong(isSwitch : false);

    tempNum = ((dataNum % 10000) / 1000).floor(); //십이신살
    isShowSinsal = tempNum - 1;
    SetSinsal(isSwitch : false);

    tempNum = ((dataNum % 100000) / 10000).floor(); //공망
    if(tempNum == 9){
      isShowGongmang = 0;
      isShowYearGongmang = false;
      isShowDayGongmang = false;
      isShowRocGongmang = false;
    } else {
      isShowGongmang = 1;

      if(tempNum == 1 || tempNum == 3 || tempNum == 5 || tempNum == 7){
        isShowYearGongmang = true;
      } else {
        isShowYearGongmang = false;
      }
      if(tempNum == 2 || tempNum == 3 || tempNum == 6 || tempNum == 7){
        isShowDayGongmang = true;
      } else {
        isShowDayGongmang = false;
      }
      if(tempNum == 4 || tempNum == 5 || tempNum == 6 || tempNum == 7){
        isShowRocGongmang = true;
      } else {isShowRocGongmang = false;}
    }
    SetGongmang(isSwitch : false);

    tempNum = ((dataNum % 1000000) / 100000).floor(); //나이
    isShowOld = tempNum - 1;
    SetOld(isSwitch : false);

    tempNum = ((dataNum % 10000000) / 1000000).floor(); //월운
    isShowWolun = tempNum - 1;
    SetWolun(isSwitch : false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widgetWidth,//widgetWidth,
        height: widgetHeight,
        decoration: BoxDecoration(
          color: style.colorBackGround,
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: style.UIButtonWidth,
              height: style.fullSizeButtonHeight,
              alignment: Alignment.center,
              child:Text('대운과 세운', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(  //정렬용 컨테이너
                        width: widgetWidth,
                        height: 1,
                      ),
                      Row(  //모두 켜기 끄기 버튼
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: (widgetWidth / 2) - (style.UIMarginLeft * 1.5),
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(right: style.UIMarginLeft * 0.5,top: style.SettingMarginTopWithInfo1),
                            decoration: BoxDecoration(
                              color: style.colorBlack,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                                style: ButtonStyle(
                                  //splashFactory: NoSplash.splashFactory,
                                  overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '모두 켜기',
                                  style: style.settingButtonTextStyle0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    SetAllShow(true);widget.reloadSetting();
                                  });
                                }),
                          ),
                          Container(
                            width: (widgetWidth / 2) - (style.UIMarginLeft * 1.5),
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(left: style.UIMarginLeft * 0.5,top: style.SettingMarginTopWithInfo1),
                            decoration: BoxDecoration(
                              color: style.colorBlack,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: TextButton(
                                style: ButtonStyle(
                                  //splashFactory: NoSplash.splashFactory,
                                  overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '모두 끄기',
                                  style: style.settingButtonTextStyle0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    SetAllShow(false);widget.reloadSetting();
                                  });
                                }),
                          ),
                        ],
                      ),
                      Container(  //간지 추가
                        height: style.saveDataMemoLineHeight,
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        margin: EdgeInsets.only(top: style.UIMarginTopTop),
                        child: Stack(
                          children: [
                            Container(
                              height: style.saveDataMemoLineHeight,
                              width: (widgetWidth - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: style.saveDataMemoLineHeight,
                                width: 40,
                                child: Stack( //천간 합충극 스위치
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedCrossFade(  //천간 합충극 스위치 배경
                                      duration: Duration(milliseconds: 130),
                                      firstChild: Container(
                                        width: 40,
                                        height: 20,
                                        child: Image.asset('assets/SwitchGray1.png', width: 40, height: 20),
                                      ),
                                      secondChild: Container(
                                        width: 40,
                                        height: 20,
                                        child: Image.asset('assets/SwitchWhite1.png', width: 40, height: 20),
                                      ),
                                      crossFadeState: isShowGanjiNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(  //천간 합충극 스위치 버튼
                                      width: 34,
                                      child: AnimatedAlign(
                                        alignment: ganjiAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: ganjiButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("간지 추가", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetGanji();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //간지추가 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo1),
                        child: Text(ganjiInfoString[isShowGanjiNum], style: style.settingInfoText0, key: ValueKey<int>(isShowGanjiNum),
                        ),
                      ),
                      Container(  //육친
                        height: style.saveDataMemoLineHeight,
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Stack(
                          children: [
                            Container(
                              height: style.saveDataMemoLineHeight,
                              width: (widgetWidth - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: style.saveDataMemoLineHeight,
                                width: 32,
                                child: Stack( //육합 스위치
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedCrossFade(  //천간 합충극 스위치 배경
                                      duration: Duration(milliseconds: 130),
                                      firstChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchWhite0.png', width: 32, height: 20),
                                      ),
                                      secondChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchGray0.png', width: 32, height: 20),
                                      ),
                                      crossFadeState: isShowYugchin == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(  //천간 합충극 스위치 버튼
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: yugchinAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: yugchinButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(personalDataManager.GetYugchinText(), style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetYugchin();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //십이운성
                        height: style.saveDataMemoLineHeight,
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Stack(
                          children: [
                            Container(
                              height: style.saveDataMemoLineHeight,
                              width: (widgetWidth - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: style.saveDataMemoLineHeight,
                                width: 32,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedCrossFade(
                                      duration: Duration(milliseconds: 130),
                                      firstChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchWhite0.png', width: 32, height: 20),
                                      ),
                                      secondChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchGray0.png', width: 32, height: 20),
                                      ),
                                      crossFadeState: isShowSibiunseong == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: sibiunseongAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: sibiunseongButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("십이운성", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetSibiunseong();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //십이신살
                        height: style.saveDataMemoLineHeight,
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Stack(
                          children: [
                            Container(
                              height: style.saveDataMemoLineHeight,
                              width: (widgetWidth - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: style.saveDataMemoLineHeight,
                                width: 32,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedCrossFade(
                                      duration: Duration(milliseconds: 130),
                                      firstChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchWhite0.png', width: 32, height: 20),
                                      ),
                                      secondChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchGray0.png', width: 32, height: 20),
                                      ),
                                      crossFadeState: isShowSinsal == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: sinsalAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: sinsalButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("십이신살", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetSinsal();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //공망
                        height: style.saveDataMemoLineHeight,
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Stack(
                          children: [
                            Container(
                              height: style.saveDataMemoLineHeight,
                              width: (widgetWidth - (style.UIMarginLeft * 2)),
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: style.saveDataMemoLineHeight,
                                width: 32,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedCrossFade(  //천간 합충극 스위치 배경
                                      duration: Duration(milliseconds: 130),
                                      firstChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchWhite0.png', width: 32, height: 20),
                                      ),
                                      secondChild: Container(
                                        width: 32,
                                        height: 20,
                                        child: Image.asset('assets/SwitchGray0.png', width: 32, height: 20),
                                      ),
                                      crossFadeState: isShowGongmang == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(  //천간 합충극 스위치 버튼
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: gongmangAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: gongmangButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("공망", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetGongmang(); SaveGongmangData();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          AnimatedOpacity(  //천간 합충극 옵션들
                            opacity: isShowGongmang == 1 ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 130),
                            child: Column(
                              children: [
                                Container(  //정렬용 컨테이너
                                  width: widgetWidth,
                                  height: 1,
                                ),
                                Container(  //천간 합충극 옵션 버튼들
                                  width: (widgetWidth - (style.UIMarginLeft * 2)),
                                  height: style.saveDataMemoLineHeight,
                                  margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: style.UIMarginLeft,
                                        height: 1,
                                      ),
                                      Text("연공망 ", style: style.settingText0,),
                                      Checkbox(
                                        value: isShowYearGongmang,
                                        onChanged: (value) {
                                          setState(() {
                                            isShowYearGongmang = value!;widget.reloadSetting();
                                          });
                                          SaveGongmangData();
                                        },
                                      ),
                                      SizedBox(width:20),
                                      Text("일공망 ", style: style.settingText0,),
                                      Checkbox(
                                        value: isShowDayGongmang,
                                        onChanged: (value) {
                                          setState(() {
                                            isShowDayGongmang = value!;widget.reloadSetting();
                                          });
                                          SaveGongmangData();
                                        },
                                      ),
                                      SizedBox(width:20),
                                      Text("록공망 ", style: style.settingText0,),
                                      Checkbox(
                                        value: isShowRocGongmang,
                                        onChanged: (value) {
                                          setState(() {
                                            isShowRocGongmang = value!;widget.reloadSetting();
                                          });
                                          SaveGongmangData();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (widgetWidth - (style.UIMarginLeft * 2)),
                                  height: style.saveDataMemoLineHeight,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: style.UIMarginLeft,
                                        height: 1,
                                      ),
                                      Text("표시할 공망을 선택해 주세요", style: style.settingInfoText0,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              AnimatedContainer(  //천간 합충극 옵션 버튼 열림 박스
                                duration: Duration(milliseconds: 170),
                                width: widgetWidth,
                                height: gongmangContainerHeight,
                                curve: Curves.fastOutSlowIn,
                              ),
                              Container(  //나이
                                height: style.saveDataMemoLineHeight,
                                width: (widgetWidth - (style.UIMarginLeft * 2)),
                                margin: EdgeInsets.only(top: style.UIMarginTop),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: style.saveDataMemoLineHeight,
                                      width: (widgetWidth - (style.UIMarginLeft * 2)),
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: style.saveDataMemoLineHeight,
                                        width: 32,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            AnimatedCrossFade(
                                              duration: Duration(milliseconds: 130),
                                              firstChild: Container(
                                                width: 32,
                                                height: 20,
                                                child: Image.asset('assets/SwitchWhite0.png', width: 32, height: 20),
                                              ),
                                              secondChild: Container(
                                                width: 32,
                                                height: 20,
                                                child: Image.asset('assets/SwitchGray0.png', width: 32, height: 20),
                                              ),
                                              crossFadeState: isShowOld == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                              alignment: Alignment.center,
                                              firstCurve: Curves.easeIn,
                                              secondCurve: Curves.easeIn,
                                            ),
                                            Container(
                                              width: 26,
                                              child: AnimatedAlign(
                                                alignment: oldAlign,
                                                duration: Duration(milliseconds: 130),
                                                curve: Curves.easeIn,
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  child: oldButtonImage,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("세운에 나이 표시", style: style.settingText0),
                                    ElevatedButton( //천간 합충극 스위치 버튼
                                      onPressed: (){SetOld();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                                  ],
                                ),
                              ),
                              Container(  //월운
                                height: style.saveDataMemoLineHeight,
                                width: (widgetWidth - (style.UIMarginLeft * 2)),
                                margin: EdgeInsets.only(top: style.UIMarginTop, bottom: style.SettingMarginTopWithInfo),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: style.saveDataMemoLineHeight,
                                      width: (widgetWidth - (style.UIMarginLeft * 2)),
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: style.saveDataMemoLineHeight,
                                        width: 32,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            AnimatedCrossFade(
                                              duration: Duration(milliseconds: 130),
                                              firstChild: Container(
                                                width: 32,
                                                height: 20,
                                                child: Image.asset('assets/SwitchWhite0.png', width: 32, height: 20),
                                              ),
                                              secondChild: Container(
                                                width: 32,
                                                height: 20,
                                                child: Image.asset('assets/SwitchGray0.png', width: 32, height: 20),
                                              ),
                                              crossFadeState: isShowWolun == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                              alignment: Alignment.center,
                                              firstCurve: Curves.easeIn,
                                              secondCurve: Curves.easeIn,
                                            ),
                                            Container(
                                              width: 26,
                                              child: AnimatedAlign(
                                                alignment: wolunAlign,
                                                duration: Duration(milliseconds: 130),
                                                curve: Curves.easeIn,
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  child: wolunButtonImage,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("월운", style: style.settingText0),
                                    ElevatedButton( //천간 합충극 스위치 버튼
                                      onPressed: (){SetWolun();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                                  ],
                                ),
                              ),
                            ],
                          ),]
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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