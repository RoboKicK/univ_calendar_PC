import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;
import '../findGanji.dart' as findGanji;
import '../CalendarResult/InquireSinsals/yugchinWidget.dart' as yugchinWidget;

class ThemeSettingWidget extends StatefulWidget {
  const ThemeSettingWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<ThemeSettingWidget> createState() => ThemeSettingState();
}

enum ThemeType { Basic, LuciaBear }

class ThemeSettingState extends State<ThemeSettingWidget> {

  double widgetWidth = 0;
  double widgetHeight = 0;

  List<int> listPaljaData = [];

  int isShowDrawerKoreanGanji = 0;

  ThemeType? themeType = ThemeType.Basic;

  List<Color> listContainerColor = [style.colorBoxGray0, style.colorBoxGray1];  //[밝은, 어두운]
  List<Color> listOhengTextColor0 = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
  List<String> listOhengText0 = ['','','','','','','',''];

  Widget GetSajuTitle(Color containerColor){
    return Container(
      width:  (450 - (style.UIMarginLeft * 2)),
      height: style.UIBoxLineHeight,
      margin: EdgeInsets.only(top: style.UIMarginTop),
      decoration: BoxDecoration(
          color: containerColor,
          boxShadow: [
            BoxShadow(
              color: containerColor,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('시주', style: Theme.of(context).textTheme.titleSmall),
          Text('일주', style: Theme.of(context).textTheme.titleSmall),
          Text('월주', style: Theme.of(context).textTheme.titleSmall),
          Text('연주', style: Theme.of(context).textTheme.titleSmall),
        ]
      ),
    );
  }

  Widget GetYugchinWidget(bool isCheongan, List<int> listPalja){
      if(isCheongan == true){
        return yugchinWidget.YugchinWidget(containerColor: listContainerColor[0], listPaljaData: listPalja, stanIlganNum: listPalja[4], isManseryoc:true, isCheongan: true, isLastWidget: false, widgetWidth: 450);
      } else {
        return yugchinWidget.YugchinWidget(containerColor: listContainerColor[0], listPaljaData: listPalja, stanIlganNum: listPalja[4], isManseryoc:true, isCheongan: false, isLastWidget: true, widgetWidth: 450);
      }
  }

  Color SetOhengColor(bool isCheongan, int num, Color white, Color red, Color yellow, Color green, Color black){  //오행 박스 컬러
    if(isCheongan == true){
      if(num < 2 && num != -2){
        return green;}
      else if(num >= 2 && num < 4){
        return red;}
      else if(num >= 4 && num < 6){
        return yellow;}
      else if((num >= 6 && num < 8) || num == -2){
        return white;}
      else if(num >= 8){
        return black;}
    }
    else{
      if(num == 0 || num == 11){
        return black;}
      else if(num == 1 || num == 4 || num == 7 || num == 10){
        return yellow;}
      else if(num >= 2 && num < 4){
        return green;}
      else if(num >= 5 && num < 7){
        return red;}
      else if((num >= 8 && num < 10) || num == -2){
        return white;}
    }

    return Colors.white;
  }

  SetOhengTextColor(){
    for(int i = 0; i < 8; i++){ //오행 박스와 텍스트 컬러, 텍스트 초기화
      if(i % 2 == 0){ //천간이면
        if(listPaljaData[i] == 6 || listPaljaData[i] == 7 || listPaljaData[i] == -2){
          listOhengTextColor0[i] = style.colorBlack;
        }
        else{
          listOhengTextColor0[i] = Colors.white;
        }
        listOhengText0[i] = style.stringCheongan[isShowDrawerKoreanGanji][listPaljaData[i]];
      }
      else{ //지지면
        if(listPaljaData[i] == 8 || listPaljaData[i] == 9 || listPaljaData[i] == -2){
          listOhengTextColor0[i] = style.colorBlack;
        }
        else{
          listOhengTextColor0[i] = Colors.white;
        }
        listOhengText0[i] = style.stringJiji[isShowDrawerKoreanGanji][listPaljaData[i]];
      }
    }
  }

  Widget GetPaljaWidget(Color white, Color red, Color yellow, Color green, Color black){
    return Container(
        width: (450 - (style.UIMarginLeft * 2)),
        height: 156,
        //padding: EdgeInsets.only(top:widget.isLastWidget==false?0:2),
        decoration: BoxDecoration(color: listContainerColor[1],
            border: Border(bottom: BorderSide(width: 2, color:style.colorGrey), top: BorderSide(width:2, color:style.colorGrey)),
            boxShadow: [
              BoxShadow(
                color: listContainerColor[1],
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(  //시간
                  width: style.fullSizeButtonHeight * 1.25,
                  height: style.fullSizeButtonHeight * 1.25,
                  margin: EdgeInsets.only(bottom: 6, top: 10),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: SetOhengColor(true, listPaljaData[6], white, red, yellow, green, black),
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(style.stringCheongan[isShowDrawerKoreanGanji][listPaljaData[6]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[6]))),
                ),
                Container(  //일간
                  width: style.fullSizeButtonHeight * 1.25,
                  height: style.fullSizeButtonHeight * 1.25,
                  margin: EdgeInsets.only(bottom: 6, top: 10),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: SetOhengColor(true, listPaljaData[4], white, red, yellow, green, black),
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(style.stringCheongan[isShowDrawerKoreanGanji][listPaljaData[4]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[4]))),
                ),
                Container(  //월간
                  width: style.fullSizeButtonHeight * 1.25,
                  height: style.fullSizeButtonHeight * 1.25,
                  margin: EdgeInsets.only(bottom: 6, top: 10),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: SetOhengColor(true, listPaljaData[2], white, red, yellow, green, black),
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(style.stringCheongan[isShowDrawerKoreanGanji][listPaljaData[2]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[2]))),
                ),
                Container(  //연간
                  width: style.fullSizeButtonHeight * 1.25,
                  height: style.fullSizeButtonHeight * 1.25,
                  margin: EdgeInsets.only(bottom: 6, top: 10),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: SetOhengColor(true, listPaljaData[0], white, red, yellow, green, black),
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(style.stringCheongan[isShowDrawerKoreanGanji][listPaljaData[0]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[0]))),
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(  //시지
                    width: style.fullSizeButtonHeight * 1.25,
                    height: style.fullSizeButtonHeight * 1.25,
                    margin: EdgeInsets.only(bottom: 10, top: 6),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: SetOhengColor(false, listPaljaData[7], white, red, yellow, green, black),
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(style.stringJiji[isShowDrawerKoreanGanji][listPaljaData[7]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[7]))),
                  ),
                  Container(  //일지
                    width: style.fullSizeButtonHeight * 1.25,
                    height: style.fullSizeButtonHeight * 1.25,
                    margin: EdgeInsets.only(bottom: 10, top: 6),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: SetOhengColor(false, listPaljaData[5], white, red, yellow, green, black),
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(style.stringJiji[isShowDrawerKoreanGanji][listPaljaData[5]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[5]))),
                  ),
                  Container(  //월지
                    width: style.fullSizeButtonHeight * 1.25,
                    height: style.fullSizeButtonHeight * 1.25,
                    margin: EdgeInsets.only(bottom: 10, top: 6),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: SetOhengColor(false, listPaljaData[3], white, red, yellow, green, black),
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(style.stringJiji[isShowDrawerKoreanGanji][listPaljaData[3]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[3]))),
                  ),
                  Container(  //연지
                    width: style.fullSizeButtonHeight * 1.25,
                    height: style.fullSizeButtonHeight * 1.25,
                    margin: EdgeInsets.only(bottom: 10, top: 6),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: SetOhengColor(false, listPaljaData[1], white, red, yellow, green, black),
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(style.stringJiji[isShowDrawerKoreanGanji][listPaljaData[1]], style:TextStyle(fontSize: 30, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[1]))),
                  )
                ]
            ),
          ],
        )
    );
  }



  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    listPaljaData = findGanji.InquireGanji(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    print(DateTime.now());

    if(((personalDataManager.etcData % 1000) / 100).floor() == 2){
      isShowDrawerKoreanGanji = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    SetOhengTextColor();

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
            child:Text('테마', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
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
                    Container(  //베이직
                      width: widget.widgetWidth - style.UIMarginLeft * 2,
                      decoration: BoxDecoration(
                        color: style.colorBlack,
                        borderRadius: BorderRadius.circular(style.textFiledRadius),),
                      child: ElevatedButton(
                        onPressed: (){
                          setState(() {
                            themeType = ThemeType.Basic;
                          });
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent),
                        child: Column(
                          children: [
                            Container(
                                width:  450,
                                height: 276,
                                margin: EdgeInsets.only(top: style.UIMarginTop),
                                decoration: BoxDecoration(
                                  color: style.colorBackGround,
                                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                                ),
                                child: Column(
                                  children: [
                                    GetSajuTitle(style.colorMainBlue),
                                    GetYugchinWidget(true, listPaljaData),
                                    GetPaljaWidget(Colors.white, Color(0xffff4500), Color(0xffffb020), Color(0xff32cd32), Color(0xff373737)),
                                    GetYugchinWidget(false, listPaljaData),
                                  ],
                                )
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(top:style.UIMarginTop * 0.2, bottom: style.UIMarginTop * 0.2),
                              child: Radio<ThemeType>(//버튼
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  value: ThemeType.Basic,
                                  groupValue: themeType,
                                  fillColor: themeType == ThemeType.Basic? MaterialStateColor.resolveWith((states) => style.colorMainBlue) : MaterialStateColor.resolveWith((states) => style.colorGrey),
                                  splashRadius: 16,
                                  hoverColor: Colors.white.withOpacity(0.1),
                                  focusColor: Colors.white.withOpacity(0.1),
                                  onChanged: (ThemeType? value) {

                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(  //곰돌이
                      width: widget.widgetWidth - style.UIMarginLeft * 2,
                      margin: EdgeInsets.only(top: style.UIMarginTop),
                      decoration: BoxDecoration(
                        color: style.colorBlack,
                        borderRadius: BorderRadius.circular(style.textFiledRadius),),
                      child: ElevatedButton(
                        onPressed: (){
                          setState(() {
                            themeType = ThemeType.LuciaBear;
                          });
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent),
                        child: Column(
                          children: [
                            Container(
                                width:  450,
                                height: 276,
                                margin: EdgeInsets.only(top: style.UIMarginTop),
                                decoration: BoxDecoration(
                                  color: style.colorBackGround,
                                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                                ),
                                child: Column(
                                  children: [
                                    GetSajuTitle(style.colorMainBlue),
                                    GetYugchinWidget(true, listPaljaData),
                                    GetPaljaWidget(Colors.white, Color(0xffff4500), Color(0xffffb020), Color(0xff32cd32), Color(0xff373737)),
                                    GetYugchinWidget(false, listPaljaData),

                                  ],
                                )
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(top:style.UIMarginTop * 0.2, bottom: style.UIMarginTop * 0.2),
                              child: Radio<ThemeType>(//버튼
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  value: ThemeType.LuciaBear,
                                  groupValue: themeType,
                                  fillColor: themeType == ThemeType.LuciaBear? MaterialStateColor.resolveWith((states) => style.colorMainBlue) : MaterialStateColor.resolveWith((states) => style.colorGrey),
                                  splashRadius: 16,
                                  hoverColor: Colors.white.withOpacity(0.1),
                                  focusColor: Colors.white.withOpacity(0.1),
                                  onChanged: (ThemeType? value) {
                                    setState(() {
                                      themeType = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(  //정렬용 컨테이너
                      width: widgetWidth,
                      height: style.UIMarginTop,
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