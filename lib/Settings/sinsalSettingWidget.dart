import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;

class SinsalSettingWidget extends StatefulWidget {
  const SinsalSettingWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<SinsalSettingWidget> createState() => _SinsalSettingState();
}

//만세력 보기 설정
class _SinsalSettingState extends State<SinsalSettingWidget> {
  int isShowGongmangNum = 0; //0:안보여줌, 1:한 줄로 알려줌, 2:찾아줌
  bool isShowYearGongmang = false, isShowDayGongmang = false, isShowRocGongmang = false;
  List<String> gongmangInfoString = ['공망을 표시하지 않습니다', '연공망과 일공망을 표시합니다', '선택한 공망을 해당하는 곳에 표시합니다'];
  double gongmangContainerHeight = 0;
  Image gongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment gongmangAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowSibisinsal = 0; //0:안보여줌, 1:왕지가 있어야 보여줌, 2: 왕지가 없어도 보여줌
  Image sibisinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment sibisinsalAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowEtc = 0;
  double etcSinsalContainerHeight = 0;
  Image etcSinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment etcSinsalAlign = Alignment.centerLeft;  //스위치 동그라미 정렬
  bool isShowCheonuel = false, isShowMunchang = false, isShowBaecho = false, isShowGuegang = false, isShowHyeonchim = false, isShowYangin = false;

  double widgetWidth = 0;
  double widgetHeight = 0;

  SetGongmang({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true){
      setState(() {
        isShowGongmangNum = (isShowGongmangNum + 1) % 3;
        personalDataManager.SaveSinsalData(100, isShowGongmangNum + 1);
      });
    }

    if(isShowGongmangNum == 0){
      gongmangContainerHeight = 0;
      gongmangAlign = Alignment.centerLeft;
      gongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowGongmangNum == 1){
      gongmangContainerHeight = 0;
      gongmangAlign = Alignment.center;
      gongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    } else if(isShowGongmangNum == 2){
      gongmangContainerHeight = style.saveDataMemoLineHeight * 2.3;//.5;
      gongmangAlign = Alignment.centerRight;
      gongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SaveGongmangData(){
    if(isShowGongmangNum == 0){
      personalDataManager.SaveSinsalData(1, 9);
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
      personalDataManager.SaveSinsalData(1, dataNum);
    }
  }

  SetSibisinsal({bool isSwitch = true}){  //육친 보여줌
    if(isSwitch == true) {
      setState(() {
        isShowSibisinsal = (isShowSibisinsal + 1) % 2;
      });
      personalDataManager.SaveSinsalData(10, isShowSibisinsal + 1);
    }
    if(isShowSibisinsal == 0){
      sibisinsalAlign = Alignment.centerLeft;
      sibisinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      sibisinsalAlign = Alignment.centerRight;
      sibisinsalButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetEtcSinsal({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {
      setState(() {
        isShowEtc = (isShowEtc + 1) % 2;
      });
      personalDataManager.SaveEtcSinsalData(1, isShowEtc + 1);
    }

    if(isShowEtc == 0){
      etcSinsalContainerHeight = 0;
      etcSinsalAlign = Alignment.centerLeft;
      etcSinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      etcSinsalContainerHeight = style.saveDataMemoLineHeight * 2.5;
      etcSinsalAlign = Alignment.centerRight;
      etcSinsalButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SaveEtcSinsal(int typeUnit, bool val, {bool isAll = false}){
    int num = 1;
    if(val == true){
      num = 2;
    }
    if(isAll == true){
      personalDataManager.SaveEtcSinsalData(0, num, isAll: true);
      isShowCheonuel = val;
      isShowMunchang = val;
      isShowBaecho = val;
      isShowGuegang = val;
      isShowHyeonchim = val;
      isShowYangin = val;
    } else {
      personalDataManager.SaveEtcSinsalData(typeUnit, num);
    }
  }

  SetAllShow(bool isAllShow){
    if(isAllShow == true){  //모두 보기, 모두 끈 상태에서 애니메이션을 돌린다
      isShowGongmangNum = 2; //0:안보여줌, 1:보여줌
      isShowSibisinsal = 2;
      isShowEtc = 1;
    }
    else{ //모두 끄기
      isShowGongmangNum = 0; //0:안보여줌, 1:보여줌
      isShowSibisinsal = 0;
      isShowEtc = 0;
    }

    isShowYearGongmang = isAllShow;
    isShowDayGongmang = isAllShow;
    isShowRocGongmang = isAllShow;

    SetGongmang(isSwitch: false);
    SetSibisinsal(isSwitch: false);
    SetEtcSinsal(isSwitch: false);
    personalDataManager.SaveSinsalData(0, isAllShow == false? 1 : 2, isAll:true);
    SaveEtcSinsal(0, isAllShow, isAll: true);
  }

  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    int dataNum = personalDataManager.sinsalData;

    //공망
    int tempNum = dataNum % 10;
    if(tempNum == 9){
      isShowYearGongmang = false;
      isShowDayGongmang = false;
      isShowRocGongmang = false;
    }
    else{
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

    tempNum = ((dataNum % 100) / 10).floor(); //십이신살
    isShowSibisinsal = tempNum - 1;
    SetSibisinsal(isSwitch : false);

    tempNum = ((dataNum % 1000) / 100).floor(); //공망 표시 방법
    isShowGongmangNum = tempNum - 1;
    SetGongmang(isSwitch : false);

    dataNum = personalDataManager.etcSinsalData;
    //여기부터 기타 신살
    tempNum = dataNum % 10;
    isShowEtc = tempNum - 1;
    SetEtcSinsal(isSwitch : false);

    tempNum = ((dataNum % 100) / 10).floor();
    isShowCheonuel = tempNum == 1? false : true;

    tempNum = ((dataNum % 1000) / 100).floor();
    isShowMunchang = tempNum == 1? false : true;

    tempNum = ((dataNum % 10000) / 1000).floor();
    isShowBaecho = tempNum == 1? false : true;

    tempNum = ((dataNum % 100000) / 10000).floor();
    isShowGuegang = tempNum == 1? false : true;

    tempNum = ((dataNum % 1000000) / 100000).floor();
    isShowHyeonchim = tempNum == 1? false : true;

    tempNum = ((dataNum % 10000000) / 1000000).floor();
    isShowYangin = tempNum == 1? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widgetWidth,//widgetWidth,
        height: widgetHeight,
        decoration: BoxDecoration(
          //color: style.colorBackGround,
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: style.UIButtonWidth,
              height: style.fullSizeButtonHeight,
              alignment: Alignment.center,
              child:Text('신살', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
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
                      Container(
                        height: style.saveDataMemoLineHeight*0.8,
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Text("만세력에 표시할 신살의 기본값을 설정해 주세요", style: style.settingInfoText0,),
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
                                  overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
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
                                  overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
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
                      Container(  //공망
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
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedCrossFade(  //천간 합충극 스위치 배경
                                      duration: Duration(milliseconds: 130),
                                      firstChild: Container(
                                        width: 40,
                                        height: 20,
                                        child: Image.asset('assets/SwitchWhite1.png', width: 40, height: 20),
                                      ),
                                      secondChild: Container(
                                        width: 40,
                                        height: 20,
                                        child: Image.asset('assets/SwitchGray1.png', width: 40, height: 20),
                                      ),
                                      crossFadeState: isShowGongmangNum == 0? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(  //천간 합충극 스위치 버튼
                                      width: 34,
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
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),),
                          ],
                        ),
                      ),
                      Container(
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo1),
                        child: Text(gongmangInfoString[isShowGongmangNum], style: style.settingInfoText0,),
                      ),
                      Stack(
                        children: [
                          AnimatedOpacity(  //공망 옵션들
                            opacity: isShowGongmangNum == 2 ? 1.0 : 0.0,
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
                                  //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: style.UIMarginLeft,
                                        height: 1,
                                      ),
                                      Text("연공망 ", style: style.settingText0,),
                                      Checkbox(
                                        overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
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
                                        overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
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
                                        overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
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
                                        child: Stack( //스위치
                                          alignment: Alignment.center,
                                          children: [
                                            AnimatedCrossFade(  //합충극 스위치 배경
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
                                              crossFadeState: isShowSibisinsal == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                              alignment: Alignment.center,
                                              firstCurve: Curves.easeIn,
                                              secondCurve: Curves.easeIn,
                                            ),
                                            Container(  //스위치 버튼
                                              width: 26,
                                              child: AnimatedAlign(
                                                alignment: sibisinsalAlign,
                                                duration: Duration(milliseconds: 130),
                                                curve: Curves.easeIn,
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  child: sibisinsalButtonImage,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("십이신살", style: style.settingText0),
                                    ElevatedButton( //천간 합충극 스위치 버튼
                                      onPressed: (){SetSibisinsal();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),),
                                  ],
                                ),
                              ),
                              Container(  //기타 신살
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
                                              crossFadeState: isShowEtc == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                              alignment: Alignment.center,
                                              firstCurve: Curves.easeIn,
                                              secondCurve: Curves.easeIn,
                                            ),
                                            Container(  //천간 합충극 스위치 버튼
                                              width: 26,
                                              child: AnimatedAlign(
                                                alignment: etcSinsalAlign,
                                                duration: Duration(milliseconds: 130),
                                                curve: Curves.easeIn,
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  child: etcSinsalButtonImage,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("기타 신살", style: style.settingText0),
                                    ElevatedButton( //천간 합충극 스위치 버튼
                                      onPressed: (){SetEtcSinsal();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),),
                                  ],
                                ),
                              ),
                              AnimatedOpacity(  //기타 신살 옵션들
                                opacity: isShowEtc == 1 ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 130),
                                child: Column(
                                  children: [
                                    Container(  //정렬용 컨테이너
                                      width: widgetWidth,
                                      height: 1,
                                    ),
                                    Container(
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
                                          Container(
                                            width: (widgetWidth - (style.UIMarginLeft * 2)) - style.UIMarginLeft,
                                            height: style.saveDataMemoLineHeight,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("천을귀인", style: style.settingText0,),
                                                    Checkbox(
                                                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                                                      value: isShowCheonuel,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isShowCheonuel = value!;widget.reloadSetting();
                                                        });
                                                        SaveEtcSinsal(10, isShowCheonuel);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("문창귀인 ", style: style.settingText0,),
                                                    Checkbox(
                                                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                                                      value: isShowMunchang,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isShowMunchang = value!;widget.reloadSetting();
                                                        });
                                                        SaveEtcSinsal(100, isShowMunchang);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children:[
                                                    Text("백호대살 ", style: style.settingText0,),
                                                    Checkbox(
                                                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                                                      visualDensity: VisualDensity(
                                                          horizontal: VisualDensity.minimumDensity
                                                      ),
                                                      value: isShowBaecho,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isShowBaecho = value!;widget.reloadSetting();
                                                        });
                                                        SaveEtcSinsal(1000, isShowBaecho);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                          Container(
                                            width: (widgetWidth - (style.UIMarginLeft * 2)) - style.UIMarginLeft,
                                            height: style.saveDataMemoLineHeight,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("괴강살 ", style: style.settingText0,),
                                                    Checkbox(
                                                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                                                      value: isShowGuegang,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isShowGuegang = value!;widget.reloadSetting();
                                                        });
                                                        SaveEtcSinsal(10000, isShowGuegang);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("현침살 ", style: style.settingText0,),
                                                    Checkbox(
                                                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                                                      value: isShowHyeonchim,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isShowHyeonchim = value!;widget.reloadSetting();
                                                        });
                                                        SaveEtcSinsal(100000, isShowHyeonchim);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children:[
                                                    Text("양인살 ", style: style.settingText0,),
                                                    Checkbox(
                                                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                                                      visualDensity: VisualDensity(
                                                          horizontal: VisualDensity.minimumDensity
                                                      ),
                                                      value: isShowYangin,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isShowYangin = value!;widget.reloadSetting();
                                                        });
                                                        SaveEtcSinsal(1000000, isShowYangin);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: (widgetWidth - (style.UIMarginLeft * 2)),
                                      height: style.saveDataMemoLineHeight,
                                      margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: style.UIMarginLeft,
                                            height: 1,
                                          ),
                                          Text("표시할 신살을 선택해 주세요", style: style.settingInfoText0,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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

