import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;

class WordSettingWidget extends StatefulWidget {
  const WordSettingWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<WordSettingWidget> createState() => _WordSettingState();
}

enum IlganText {Ilgan, Bonwon, Asin }
enum YugchinText {Yugchin, Yugsin, Sibseong}
enum MyeongsicText { Myeongsic, Wonguc}

//사용자 설정
class _WordSettingState extends State<WordSettingWidget> {

  IlganText? ilganText;// = IlganText.Ilgan;
  YugchinText? yugchinText;// = YugchinText.Yugchin;
  MyeongsicText? myeongsicText;

  int isSameGeuc = 1;
  Alignment geucAlign = Alignment.centerRight;  //스위치 동그라미 정렬
  Image geucButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지

  int isSameHab = 1;
  Alignment habAlign = Alignment.centerRight;  //스위치 동그라미 정렬
  Image habButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지

  double widgetWidth = 0;
  double widgetHeight = 0;

  SetGeuc({bool isSwitch = true}){  //육친 보여줌
    if(isSwitch == true) {
      setState(() {
        isSameGeuc = (isSameGeuc + 1) % 2;
      });
      personalDataManager.SaveWordData('geukChung', isSameGeuc + 1);
    }
    if(isSameGeuc == 0){
      geucAlign = Alignment.centerLeft;
      geucButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      geucAlign = Alignment.centerRight;
      geucButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetHab({bool isSwitch = true}){  //육친 보여줌
    if(isSwitch == true) {
      setState(() {
        isSameHab = (isSameHab + 1) % 2;
      });
      personalDataManager.SaveWordData('hab', isSameHab + 1);
    }
    if(isSameHab == 0){
      habAlign = Alignment.centerLeft;
      habButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      habAlign = Alignment.centerRight;
      habButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  @override
  initState(){
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    if (personalDataManager.mapWordData['ilGan'] case 0) {
        ilganText = IlganText.Ilgan;
    } else if (personalDataManager.mapWordData['ilGan'] case 1) {
        ilganText = IlganText.Bonwon;
    } else if (personalDataManager.mapWordData['ilGan'] case 2) {
        ilganText = IlganText.Asin;
    }

    if (personalDataManager.mapWordData['yugChin'] case 0) {
      yugchinText = YugchinText.Yugchin;
    } else if (personalDataManager.mapWordData['yugChin'] case 1) {
      yugchinText = YugchinText.Yugsin;
    } else if (personalDataManager.mapWordData['yugChin'] case 2) {
      yugchinText = YugchinText.Sibseong;
    }

    if (personalDataManager.mapWordData['myeongSic'] case 0) {
      myeongsicText = MyeongsicText.Myeongsic;
    } else if (personalDataManager.mapWordData['myeongSic'] case 1) {
      myeongsicText = MyeongsicText.Wonguc;
    }

    if(personalDataManager.mapWordData['geukChung'] != null){
      isSameGeuc = personalDataManager.mapWordData['geukChung'] - 1;
    }
    SetGeuc(isSwitch : false);

    if(personalDataManager.mapWordData['hab'] != null){
      isSameHab = personalDataManager.mapWordData['hab'] - 1;
    }
    SetHab(isSwitch : false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widgetWidth,//MediaQuery.of(context).size.width,
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
            child:Text('단어 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    children: [
                      Container( //일간 이름
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        //color:Colors.green,
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom),
                              child: Text("일간 ",
                                  style: style.settingText0),
                            ),
                            Radio<IlganText>(
                              //남자 버튼
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: IlganText.Ilgan,
                                groupValue: ilganText,
                                fillColor: ilganText == IlganText.Ilgan? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (IlganText? value) {
                                  setState(() {
                                    ilganText = value;
                                    personalDataManager.SaveWordData('ilGan', 0);widget.reloadSetting();
                                  });
                                }),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom, left: style.SettingDisWithRadioButton),
                              child: Text("본원 ",
                                  style: style.settingText0),
                            ),
                            Radio<IlganText>(
                              //여자 버튼
                                visualDensity: const VisualDensity(
                                  horizontal:
                                  VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: IlganText.Bonwon,
                                groupValue: ilganText,
                                fillColor: ilganText == IlganText.Bonwon? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (IlganText? value) {
                                  setState(() {
                                    ilganText = value;
                                    personalDataManager.SaveWordData('ilGan', 1);widget.reloadSetting();
                                  });
                                }),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom, left: style.SettingDisWithRadioButton),
                              child: Text("아신 ",
                                  style: style.settingText0),
                            ),
                            Radio<IlganText>(
                              //여자 버튼
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: IlganText.Asin,
                                groupValue: ilganText,
                                fillColor: ilganText == IlganText.Asin? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (IlganText? value) {
                                  setState(() {
                                    ilganText = value;
                                    personalDataManager.SaveWordData('ilGan', 2);widget.reloadSetting();
                                  });
                                }),
                          ],
                        ),
                      ),
                      Container(  //일간 이름 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        //color:Colors.yellow,
                        margin: EdgeInsets.only(bottom:style.SettingMarginTopWithInfo),
                        child: Text("일간을 표시하는 방법을 선택합니다", style: style.settingInfoText0),
                      ),
                      Container( //육친 이름
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom),
                              child: Text("육친 ",
                                  style: style.settingText0),
                            ),
                            Radio<YugchinText>(
                              //남자 버튼
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: YugchinText.Yugchin,
                                groupValue: yugchinText,
                                fillColor: yugchinText == YugchinText.Yugchin? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (YugchinText? value) {
                                  setState(() {
                                    yugchinText = value;
                                    personalDataManager.SaveWordData('yugChin', 0);widget.reloadSetting();
                                  });
                                }),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom, left: style.SettingDisWithRadioButton),
                              child: Text("육신 ",
                                  style: style.settingText0),
                            ),
                            Radio<YugchinText>(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: YugchinText.Yugsin,
                                groupValue: yugchinText,
                                fillColor: yugchinText == YugchinText.Yugsin? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (YugchinText? value) {
                                  setState(() {
                                    yugchinText = value;
                                    personalDataManager.SaveWordData('yugChin', 1);widget.reloadSetting();
                                  });
                                }),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom, left: style.SettingDisWithRadioButton),
                              child: Text("십성 ",
                                  style: style.settingText0),
                            ),
                            Radio<YugchinText>(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: YugchinText.Sibseong,
                                groupValue: yugchinText,
                                fillColor: yugchinText == YugchinText.Sibseong? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (YugchinText? value) {
                                  setState(() {
                                    yugchinText = value;
                                    personalDataManager.SaveWordData('yugChin', 2);widget.reloadSetting();
                                  });
                                }),
                          ],
                        ),
                      ),
                      Container(  //육친 이름 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom:style.SettingMarginTopWithInfo),
                        child: Text("육친, 육신 또는 십성을 표시하는 방법을 선택합니다", style: style.settingInfoText0),
                      ),
                      Container( //명식 이름
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(top: style.UIMarginTop),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom),
                              child: Text("명식 ",
                                  style: style.settingText0),
                            ),
                            Radio<MyeongsicText>(
                              //남자 버튼
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: MyeongsicText.Myeongsic,
                                groupValue: myeongsicText,
                                fillColor: myeongsicText == MyeongsicText.Myeongsic? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (MyeongsicText? value) {
                                  setState(() {
                                    myeongsicText = value;
                                    personalDataManager.SaveWordData('myeongSic', 0);
                                  });
                                }),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: style.UIPaddingBottom, left: style.SettingDisWithRadioButton),
                              child: Text("원국 ",
                                  style: style.settingText0),
                            ),
                            Radio<MyeongsicText>(
                              //여자 버튼
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: MyeongsicText.Wonguc,
                                groupValue: myeongsicText,
                                fillColor: myeongsicText == MyeongsicText.Wonguc? WidgetStateColor.resolveWith((states) => style.colorMainBlue) : WidgetStateColor.resolveWith((states) => style.colorGrey),
                                splashRadius: 16,
                                hoverColor: Colors.white.withOpacity(0.1),
                                focusColor: Colors.white.withOpacity(0.1),
                                onChanged: (MyeongsicText? value) {
                                  setState(() {
                                    myeongsicText = value;
                                    personalDataManager.SaveWordData('myeongSic', 1);
                                  });
                                }),
                          ],
                        ),
                      ),
                      Container(  //명식 이름 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom:style.SettingMarginTopWithInfo),
                        child: Text("명식 또는 원국을 표시하는 방법을 선택합니다", style: style.settingInfoText0),
                      ),
                      Container(  //천간극
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
                                      crossFadeState: isSameGeuc == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(  //천간 합충극 스위치 버튼
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: geucAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: geucButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("천간의 극을 충으로 표시합니다", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetGeuc();widget.reloadSetting();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(overlayColor: Colors.transparent, splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //천간극 이름 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom:style.SettingMarginTopWithInfo),
                        child: Text("천간의 충과 극을 모두 충으로 표시합니다", style: style.settingInfoText0),
                      ),
                      Container(  //합
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
                                      crossFadeState: isSameHab == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(  //천간 합충극 스위치 버튼
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: habAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: habButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("지지합 단순화", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetHab();widget.reloadSetting();}, child: Container(width:(MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(overlayColor: Colors.transparent, splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //천간극 이름 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom:style.SettingMarginTopWithInfo),
                        child: Text("지지의 방합, 삼합, 육합을 모두 합으로 표시합니다", style: style.settingInfoText0),
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
