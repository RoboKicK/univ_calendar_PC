import 'package:flutter/material.dart';
import '../style.dart' as style;
import '../Settings/personalDataManager.dart' as personalDataManager;

class CalendarOptionDrawer extends StatefulWidget {
  const CalendarOptionDrawer({super.key, required this.SetDrawerOption, required this.habChungNum, required this.yugchinNum,
    required this.jijangganNum, required this.sibiunseongNum, required this.gongmangNum, required this.sinsalNum,
    required this.deunSeunYugchinNum, required this.deunSeunSibiunseongNum, required this.deunSeunSinsalNum, required this.deunSeunGongmangNum, required this.deunSeunOldNum,
    required this.manOldNum, required this.uemYangSignNum, required this.koreanGanjiNum});

  final SetDrawerOption;
  final int habChungNum, yugchinNum, jijangganNum, sibiunseongNum, gongmangNum, sinsalNum;
  final int deunSeunYugchinNum, deunSeunSibiunseongNum, deunSeunSinsalNum, deunSeunGongmangNum, deunSeunOldNum;
  final int manOldNum, uemYangSignNum, koreanGanjiNum;

  @override
  State<CalendarOptionDrawer> createState() => _CalendarOptionDrawerState();
}


class _CalendarOptionDrawerState extends State<CalendarOptionDrawer> {

  int isShowHabChungNum = 0; //0:안보여줌, 1:보여줌
  Image habChungButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment habChungAlign = Alignment.centerLeft;  //스위치 동그라미 정렬
  List<String> listHabChungInfoString = ['모두 끕니다', '설정값으로 표시합니다', '모두 표시합니다'];

  int isShowYugchin = 0;
  Image yugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment yugchinAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowJijangganNum = 0; //0:안보여줌, 1:보여줌
  Image jijangganButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment jijangganAlign = Alignment.centerLeft;  //스위치 동그라미 정렬
  //List<String> listJijangganInfoString = ['모두 끕니다', '설정값으로 표시합니다', '모두 표시합니다'];

  int isShowSibiunseong = 0;
  Image sibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment sibiunseongAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowGongmangNum = 0; //0:안보여줌, 1:보여줌
  Image gongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment gongmangAlign = Alignment.centerLeft;  //스위치 동그라미 정렬
  //List<String> listGongmangInfoString = ['모두 끕니다', '설정값으로 표시합니다', '모두 표시합니다'];

  int isShowSinsalNum = 0; //0:안보여줌, 1:보여줌
  Image sinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment sinsalAlign = Alignment.centerLeft;  //스위치 동그라미 정렬
  List<String> listSinsalInfoString = ['모두 끕니다', '설정값으로 표시합니다', '십이신살과 주요 신살을 표시합니다'];

  int isShowDeunSeunYugchin = 0;
  Image deunSeunYugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment deunSeunYugchinAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowDeunSeunSibiunseong = 0;
  Image deunSeunSibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment deunSeunSibiunseongAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowDeunSeunSibisinsal = 0;
  Image deunSeunSibisinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment deunSeunSibisinsalAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowDeunSeunGongmangNum = 0; //0:안보여줌, 1:보여줌
  Image deunSeunGongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment deunSeunGongmangAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowSeunOld = 0; //0:안보여줌, 1:보여줌
  Image seunOldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment seunOldAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowManOld = 0; //0:안보여줌, 1:보여줌
  Image manOldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment manOldAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowUemyangSign = 0; //0:안보여줌, 1:보여줌
  Image uemyangSignButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment uemyangSignAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowKoreanGanjiNum = 0; //0:안보여줌, 1:보여줌
  Image koreanGanjiButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment koreanGanjiAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  SetHabChung({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowHabChungNum = (isShowHabChungNum + 1) % 3;
    });
      widget.SetDrawerOption(0, isShowHabChungNum);
    }

    if(isShowHabChungNum == 0){
      habChungAlign = Alignment.centerLeft;
      habChungButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowHabChungNum == 1){
      habChungAlign = Alignment.center;
      habChungButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }else if(isShowHabChungNum == 2){
      habChungAlign = Alignment.centerRight;
      habChungButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetYugchin({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
      isShowYugchin = (isShowYugchin + 1) % 2;
    });
      widget.SetDrawerOption(1, isShowYugchin);}


    if(isShowYugchin == 0){
      yugchinAlign = Alignment.centerLeft;
      yugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      yugchinAlign = Alignment.centerRight;
      yugchinButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetJijanggan({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowJijangganNum = (isShowJijangganNum + 1) % 3;
      });
      widget.SetDrawerOption(2, isShowJijangganNum);
    }

    if(isShowJijangganNum == 0){
      jijangganAlign = Alignment.centerLeft;
      jijangganButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowJijangganNum == 1){
      jijangganAlign = Alignment.center;
      jijangganButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }else if(isShowJijangganNum == 2){
      jijangganAlign = Alignment.centerRight;
      jijangganButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetSibiunseong({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowSibiunseong = (isShowSibiunseong + 1) % 2;
      });
      widget.SetDrawerOption(3, isShowSibiunseong);}


    if(isShowSibiunseong == 0){
      sibiunseongAlign = Alignment.centerLeft;
      sibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      sibiunseongAlign = Alignment.centerRight;
      sibiunseongButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetGongmang({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowGongmangNum = (isShowGongmangNum + 1) % 3;
      });
      widget.SetDrawerOption(4, isShowGongmangNum);
    }

    if(isShowGongmangNum == 0){
      gongmangAlign = Alignment.centerLeft;
      gongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowGongmangNum == 1){
      gongmangAlign = Alignment.center;
      gongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }else if(isShowGongmangNum == 2){
      gongmangAlign = Alignment.centerRight;
      gongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetSinsal({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowSinsalNum = (isShowSinsalNum + 1) % 3;
      });
      widget.SetDrawerOption(5, isShowSinsalNum);
    }

    if(isShowSinsalNum == 0){
      sinsalAlign = Alignment.centerLeft;
      sinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowSinsalNum == 1){
      sinsalAlign = Alignment.center;
      sinsalButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }else if(isShowSinsalNum == 2){
      sinsalAlign = Alignment.centerRight;
      sinsalButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetDeunSeunYugchin({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowDeunSeunYugchin = (isShowDeunSeunYugchin + 1) % 2;
      });
      widget.SetDrawerOption(6, isShowDeunSeunYugchin);}


    if(isShowDeunSeunYugchin == 0){
      deunSeunYugchinAlign = Alignment.centerLeft;
      deunSeunYugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      deunSeunYugchinAlign = Alignment.centerRight;
      deunSeunYugchinButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetDeunSeunSibiunseong({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowDeunSeunSibiunseong = (isShowDeunSeunSibiunseong + 1) % 2;
      });
      widget.SetDrawerOption(7, isShowDeunSeunSibiunseong);}


    if(isShowDeunSeunSibiunseong == 0){
      deunSeunSibiunseongAlign = Alignment.centerLeft;
      deunSeunSibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      deunSeunSibiunseongAlign = Alignment.centerRight;
      deunSeunSibiunseongButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetDeunSeunSibisinsal({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowDeunSeunSibisinsal = (isShowDeunSeunSibisinsal + 1) % 2;
      });
      widget.SetDrawerOption(8, isShowDeunSeunSibisinsal);}


    if(isShowDeunSeunSibisinsal == 0){
      deunSeunSibisinsalAlign = Alignment.centerLeft;
      deunSeunSibisinsalButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      deunSeunSibisinsalAlign = Alignment.centerRight;
      deunSeunSibisinsalButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetDeunSeunGongmang({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowDeunSeunGongmangNum = (isShowDeunSeunGongmangNum + 1) % 3;
      });
      widget.SetDrawerOption(9, isShowDeunSeunGongmangNum);
    }

    if(isShowDeunSeunGongmangNum == 0){
      deunSeunGongmangAlign = Alignment.centerLeft;
      deunSeunGongmangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowDeunSeunGongmangNum == 1){
      deunSeunGongmangAlign = Alignment.center;
      deunSeunGongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }else if(isShowDeunSeunGongmangNum == 2){
      deunSeunGongmangAlign = Alignment.centerRight;
      deunSeunGongmangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetSeunOld({bool isSwitch = true}){
    if(isSwitch == true)  {
      if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){
        int hideDataNum =((personalDataManager.etcData % 100000) / 10000).floor();
        if(hideDataNum == 2 || hideDataNum == 3 || hideDataNum == 6 || hideDataNum == 7){
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
          return;
        }
      }

      setState(() {
        isShowSeunOld = (isShowSeunOld + 1) % 2;
      });
      widget.SetDrawerOption(10, isShowSeunOld);}


    if(isShowSeunOld == 0){
      seunOldAlign = Alignment.centerLeft;
      seunOldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      seunOldAlign = Alignment.centerRight;
      seunOldButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetManOld({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowManOld = (isShowManOld + 1) % 2;
      });
      widget.SetDrawerOption(11, isShowManOld);}

    if(isShowManOld == 0){
      manOldAlign = Alignment.centerLeft;
      manOldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      manOldAlign = Alignment.centerRight;
      manOldButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetUemyangSign({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowUemyangSign = (isShowUemyangSign + 1) % 2;
      });
      widget.SetDrawerOption(12, isShowUemyangSign);}

    if(isShowUemyangSign == 0){
      uemyangSignAlign = Alignment.centerLeft;
      uemyangSignButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      uemyangSignAlign = Alignment.centerRight;
      uemyangSignButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetKoreanGanji({bool isSwitch = true}){
    if(isSwitch == true)  {
      setState(() {
        isShowKoreanGanjiNum = (isShowKoreanGanjiNum + 1) % 2;
      });
      widget.SetDrawerOption(13, isShowKoreanGanjiNum);}

    if(isShowKoreanGanjiNum == 0){
      koreanGanjiAlign = Alignment.centerLeft;
      koreanGanjiButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      koreanGanjiAlign = Alignment.centerRight;
      koreanGanjiButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  @override
  void initState() {
    super.initState();

    isShowHabChungNum = widget.habChungNum; //0:안보여줌, 1:보여줌
    SetHabChung(isSwitch : false);
    isShowYugchin = widget.yugchinNum;
    SetYugchin(isSwitch : false);
    isShowJijangganNum = widget.jijangganNum;
    SetJijanggan(isSwitch : false);
    isShowSibiunseong = widget.sibiunseongNum;
    SetSibiunseong(isSwitch : false);
    isShowGongmangNum = widget.gongmangNum;
    SetGongmang(isSwitch : false);
    isShowSinsalNum = widget.sinsalNum;
    SetSinsal(isSwitch : false);

    isShowDeunSeunYugchin = widget.deunSeunYugchinNum;
    SetDeunSeunYugchin(isSwitch : false);
    isShowDeunSeunSibiunseong = widget.deunSeunSibiunseongNum;
    SetDeunSeunSibiunseong(isSwitch : false);
    isShowDeunSeunSibisinsal = widget.deunSeunSinsalNum;
    SetDeunSeunSibisinsal(isSwitch : false);
    isShowDeunSeunGongmangNum = widget.deunSeunGongmangNum;
    SetDeunSeunGongmang(isSwitch : false);
    isShowSeunOld = widget.deunSeunOldNum;
    SetSeunOld(isSwitch : false);

    isShowManOld = widget.manOldNum;
    SetManOld(isSwitch : false);
    isShowUemyangSign = widget.uemYangSignNum;
    SetUemyangSign(isSwitch : false);
    isShowKoreanGanjiNum = widget.koreanGanjiNum;
    SetKoreanGanji(isSwitch : false);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(  //정렬용 컨테이너
                width: (MediaQuery.of(context).size.width / 2),
                height: 1,
              ),
              Container(  //카테고리 제목
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),//containerWidth,
                height: 40,
                margin: EdgeInsets.only(top: style.UIMarginTopTop),
                child: Text("만세력", style: TextStyle(
                  color : Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                ),),
              Container(  //합충형파
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowHabChungNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              alignment: Alignment.center,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(  //천간 합충극 스위치 버튼
                              width: 34,
                              child: AnimatedAlign(
                                alignment: habChungAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: habChungButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("합충형파", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetHabChung();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //합충형파 설명
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                height: style.resultDrawerInfoLineHeight,
                //alignment: Alignment.topLeft,
                //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Text(listHabChungInfoString[isShowHabChungNum], style: style.settingInfoText0, key: ValueKey<int>(isShowHabChungNum),
                ),
              ),
              Container(  //육친
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowYugchin == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
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
                    Text("육친", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetYugchin();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //지장간
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: style.saveDataMemoLineHeight,
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedCrossFade(
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
                              crossFadeState: isShowJijangganNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              alignment: Alignment.center,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(  //천간 합충극 스위치 버튼
                              width: 34,
                              child: AnimatedAlign(
                                alignment: jijangganAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: jijangganButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("지장간", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetJijanggan();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //지장간 설명
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                height: style.resultDrawerInfoLineHeight,
                //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Text(listHabChungInfoString[isShowJijangganNum], style: style.settingInfoText0, key: ValueKey<int>(isShowJijangganNum),
                ),
              ),
              Container(  //십이운성
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                      onPressed: (){SetSibiunseong();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //공망
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: style.saveDataMemoLineHeight,
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedCrossFade(
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
                              crossFadeState: isShowGongmangNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
                      onPressed: (){SetGongmang();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //공망 설명
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                height: style.resultDrawerInfoLineHeight,
                //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Text(listHabChungInfoString[isShowGongmangNum], style: style.settingInfoText0, key: ValueKey<int>(isShowGongmangNum),
                ),
              ),
              Container(  //신살
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: style.saveDataMemoLineHeight,
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedCrossFade(
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
                              crossFadeState: isShowSinsalNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              alignment: Alignment.center,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(  //천간 합충극 스위치 버튼
                              width: 34,
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
                    Text("신살", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetSinsal();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //신살 설명
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                height: style.resultDrawerInfoLineHeight*1.8,
                //color:Colors.green,
                //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Text(listSinsalInfoString[isShowSinsalNum], style: style.settingInfoText0, key: ValueKey<int>(isShowSinsalNum),
                ),
              ),
              Container(  //카테고리 제목
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),//containerWidth,
                height: 40,
                margin: EdgeInsets.only(top: style.UIMarginTopTop - (style.resultDrawerInfoLineHeight * 0.8)),
                child: Text("대운과 세운", style: TextStyle(
                  color : Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                ),),
              Container(  //대운세운 육친
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowDeunSeunYugchin == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: deunSeunYugchinAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: deunSeunYugchinButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("육친", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetDeunSeunYugchin();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //대운세운 십이운성
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowDeunSeunSibiunseong == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: deunSeunSibiunseongAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: deunSeunSibiunseongButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("십이운성", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetDeunSeunSibiunseong();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //대운세운 십이신살
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowDeunSeunSibisinsal == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: deunSeunSibisinsalAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: deunSeunSibisinsalButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("십이신살", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetDeunSeunSibisinsal();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //대운세운 공망
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: style.saveDataMemoLineHeight,
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedCrossFade(
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
                              crossFadeState: isShowDeunSeunGongmangNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              alignment: Alignment.center,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(  //천간 합충극 스위치 버튼
                              width: 34,
                              child: AnimatedAlign(
                                alignment: deunSeunGongmangAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: deunSeunGongmangButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("공망", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetDeunSeunGongmang();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //공망 설명
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                height: style.resultDrawerInfoLineHeight,
                //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Text(listHabChungInfoString[isShowDeunSeunGongmangNum], style: style.settingInfoText0, key: ValueKey<int>(isShowDeunSeunGongmangNum),
                ),
              ),
              Container(  //세운 나이
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowSeunOld == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: seunOldAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: seunOldButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("세운 나이", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetSeunOld();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //카테고리 제목
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),//containerWidth,
                height: 40,
                margin: EdgeInsets.only(top: style.UIMarginTopTop),
                child: Text("기타", style: TextStyle(
                  color : Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                ),),
              Container(  //만 나이
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowManOld == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: manOldAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: manOldButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("만 나이", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetManOld();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //음양 표시
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowUemyangSign == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: uemyangSignAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: uemyangSignButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("간지 음양 표시", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetUemyangSign();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
              Container(  //한글화
                height: style.saveDataMemoLineHeight,
                width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop, bottom: style.UIMarginTopTop),
                child: Stack(
                  children: [
                    Container(
                      height: style.saveDataMemoLineHeight,
                      width: ((MediaQuery.of(context).size.width / 2) - (style.UIMarginLeft * 2)),
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
                              crossFadeState: isShowKoreanGanjiNum == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                            Container(
                              width: 26,
                              child: AnimatedAlign(
                                alignment: koreanGanjiAlign,
                                duration: Duration(milliseconds: 130),
                                curve: Curves.easeIn,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  child: koreanGanjiButtonImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("간지 한글화", style: style.settingText0),
                    ElevatedButton( //천간 합충극 스위치 버튼
                      onPressed: (){SetKoreanGanji();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
