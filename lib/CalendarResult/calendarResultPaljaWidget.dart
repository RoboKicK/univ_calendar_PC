import 'package:flutter/material.dart';
import '../../style.dart' as style;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class CalendarResultPaljaWidget extends StatefulWidget {
  const CalendarResultPaljaWidget({super.key, required this.containerColor, required this.listPaljaData, required this.isShowDrawerUemyangSign, required this.isShowDrawerKoreanGanji, required this.isLastWidget, required this.widgetWidth, required this.isShowChooseDayButtons});

  final Color containerColor;
  final List<int> listPaljaData;
  final bool isLastWidget;
  final int isShowDrawerUemyangSign, isShowDrawerKoreanGanji;
  final double widgetWidth;
  final bool isShowChooseDayButtons;

  @override
  State<CalendarResultPaljaWidget> createState() => _CalendarResultPaljaWidgetState();
}

class _CalendarResultPaljaWidgetState extends State<CalendarResultPaljaWidget> {
  List<List<String>> listChenganString = [['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'],['갑','을','병','정','무','기','경','신','임','계']];
  List<List<String>> listJijiString = [['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'],['자','축','인','묘','진','사','오','미','신','유','술','해']];

  List<Color> listOhengBoxColor0 = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
  List<Color> listOhengTextColor0 = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
  List<String> listOhengText0 = ['','','','','','','',''];

  double buttonPaddingVal = 4;

  double uemYangBoxSize = 8;
  double uemYangSignSize = 6;
  double uemYangBoxMargin = 6;

  double paljaBoxSize = 0;
  double ganjiContainerHeight = 0;

  double ohengFontSize = 30;
  double unknownTextFontSize = 44;

  double ganjiBoxMarginBigger = 10;
  double ganjiBoxMarginSmaller = 6;

  String themeTitle = '';
  bool isSpriteTheme = false;

  Container GetPlajaBox(int paljaNum, int paljaIndex){
    if(paljaNum != -2){
      if(paljaIndex == 6 || paljaIndex == 0){
        return  Container(  //시간
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
          decoration: BoxDecoration(
            boxShadow: [style.uiOhengShadow],
            color: listOhengBoxColor0[paljaIndex],
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          child: Stack(
            children:[
              TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
              ),
              //TextButton.styleFrom(
              //  splashFactory: NoSplash.splashFactory,
              //  padding: EdgeInsets.only(bottom:buttonPaddingVal),
              //  surfaceTintColor: Colors.green,
              //  foregroundColor: Colors.green,
              //),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][paljaNum], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[paljaIndex]))),
              onPressed: (){

              },
            ),
              GetUemYangSign(paljaNum, true),
            ]
          ),
        );
      }
      else{
        return  Container(  //시지
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(top: ganjiBoxMarginSmaller,bottom: ganjiBoxMarginBigger),//,
          decoration: BoxDecoration(
            boxShadow: [style.uiOhengShadow],
            color: listOhengBoxColor0[paljaIndex],
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          child: Stack(
            children:[
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
                ),
                //TextButton.styleFrom(
                //  splashFactory: NoSplash.splashFactory,
                //  padding: EdgeInsets.only(bottom:buttonPaddingVal),
                //  surfaceTintColor: Colors.transparent
                //),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][paljaNum], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[paljaIndex]))),
                onPressed: (){

                },
              ),
              GetUemYangSign(paljaNum, false),
            ]
          ),
        );
      }
    }
    else{
      if(paljaIndex == 6 || paljaIndex == 0){
        return  Container(  //시간 모름일 때
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
          decoration: BoxDecoration(
            boxShadow: [style.uiOhengShadow],
            color: Colors.white,
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          alignment: Alignment.center,
          child: Text(style.unknownTimeText, style:TextStyle(fontSize: unknownTextFontSize*0.8, fontWeight: style.UIOhengFontWeight, color: style.colorBlack)),
          padding: EdgeInsets.only(bottom:10),
        );
      } else {
        return  Container(  //시간 모름일 때
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(top: ganjiBoxMarginSmaller,bottom: ganjiBoxMarginBigger),//,
          decoration: BoxDecoration(
            boxShadow: [style.uiOhengShadow],
            color: Colors.white,
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          alignment: Alignment.center,
          child: Text(style.unknownTimeText, style:TextStyle(fontSize: unknownTextFontSize*0.8, fontWeight: style.UIOhengFontWeight, color: style.colorBlack)),
          padding: EdgeInsets.only(bottom:10),
        );
      }
    }
  }
  Container GetPlajaBoxWithSprite(int paljaNum, int paljaIndex){
    if(paljaNum != -2){
      if(paljaIndex == 6 || paljaIndex == 0){
        return  Container(  //시간
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
          child: Stack(
              children:[
                Image.asset('assets/' + style.SetOhengSpriteString(true, widget.listPaljaData[paljaIndex], themeTitle)),
                Align(
                      alignment: Alignment.center,
                      child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][paljaNum], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[paljaIndex]))),
                GetUemYangSign(paljaNum, true),
              ]
          ),
        );
      }
      else{
        return  Container(  //시지
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(top: ganjiBoxMarginSmaller,bottom: ganjiBoxMarginBigger),//,
          child: Stack(
              children:[
                Image.asset('assets/' + style.SetOhengSpriteString(false, widget.listPaljaData[paljaIndex], themeTitle)),
                Align(
                      alignment: Alignment.center,
                      child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][paljaNum], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[paljaIndex]))),
                GetUemYangSign(paljaNum, false),
              ]
          ),
        );
      }
    }
    else{
      if(paljaIndex == 6 || paljaIndex == 0){
        return  Container(  //시간 모름일 때
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
          alignment: Alignment.center,
          child: Stack(
              children: [
                Image.asset('assets/' + themeTitle + 'White.png'),
                Align(
                  alignment: Alignment.center,
                    child: Text(style.unknownTimeText, style:TextStyle(fontSize: unknownTextFontSize*0.8, fontWeight: style.UIOhengFontWeight, color: style.colorBlack)))]),
          //padding: EdgeInsets.only(bottom:10),
        );
      } else {
        return  Container(  //시간 모름일 때
          width: paljaBoxSize,
          height: paljaBoxSize,
          margin: EdgeInsets.only(top: ganjiBoxMarginSmaller,bottom: ganjiBoxMarginBigger),//,
           alignment: Alignment.center,
          child: Stack(
              children: [
                Image.asset('assets/' + themeTitle + 'White.png',),
                Align(
                    alignment: Alignment.center,
                    child: Text(style.unknownTimeText, style:TextStyle(fontSize: unknownTextFontSize*0.8, fontWeight: style.UIOhengFontWeight, color: style.colorBlack)))]),
        );
      }
    }
  }

  Widget GetUemYangSign(int paljaNum, bool isCheongan){
    if(widget.isShowDrawerUemyangSign == 0){
      return SizedBox.shrink();
    } else {
      bool isUemYang = true;  //true:양
      bool isBlackSign = false;  //false:흰색
      if(isCheongan == true){
        if(paljaNum % 2 == 1){
          isUemYang = false;
        }
        if(paljaNum == 6 || paljaNum == 7){
          isBlackSign = true;
        }
      } else {
        if(paljaNum == 0 || paljaNum == 1 || paljaNum == 3 || paljaNum == 6 || paljaNum == 7 || paljaNum == 9){
          isUemYang = false;
        }
        if(paljaNum == 8 || paljaNum == 9){
          isBlackSign = true;
        }
      }
      Image signImage;
      if(isUemYang == true){
        if(isBlackSign == false){
          signImage = Image.asset('assets/yangSignWhite.png', width: uemYangBoxSize, height: uemYangBoxSize);
        } else {
          signImage = Image.asset('assets/yangSignBlack.png', width: uemYangBoxSize, height: uemYangBoxSize);
        }
      } else {
        if(isBlackSign == false){
          signImage = Image.asset('assets/uemSignWhite.png', width: uemYangBoxSize, height: uemYangBoxSize);
        } else {
          signImage = Image.asset('assets/uemSignBlack.png', width: uemYangBoxSize, height: uemYangBoxSize);
        }
      }
      return Container(
        width: uemYangBoxSize,
        height: uemYangBoxSize,
        margin: EdgeInsets.only(left: isSpriteTheme == false? uemYangBoxMargin : uemYangBoxMargin * 2, top: uemYangBoxMargin),
        child: signImage,
      );
    }
  }

  List<Widget> GetCheonganGanjiWidget(){
    List<Widget> listCheonganGanji =[];

   // SetOhengBoxAndTextColor();

    if(widget.listPaljaData.length > 10){
      listCheonganGanji.add(Container(  //대운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
        decoration: BoxDecoration(
          boxShadow: [style.uiOhengShadow],
          color: listOhengBoxColor0[10],
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        child: Stack(
          children:[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
              ),
              //TextButton.styleFrom(
              //  splashFactory: NoSplash.splashFactory,
              //  padding: EdgeInsets.only(bottom:buttonPaddingVal),
              //),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[10]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[10]))),
              onPressed: (){

              },
            ),
            GetUemYangSign(widget.listPaljaData[10], true),
          ] ,
        ),
      ));
    }

    if(widget.listPaljaData.length > 8){
      listCheonganGanji.add(Container(  //대운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
        decoration: BoxDecoration(
          boxShadow: [style.uiOhengShadow],
          color: listOhengBoxColor0[8],
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        child: Stack(
          children:[
            TextButton(
              style:ButtonStyle(
                overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
              ),
              //TextButton.styleFrom(
              //  splashFactory: NoSplash.splashFactory,
              //  padding: EdgeInsets.only(bottom:buttonPaddingVal),
              //),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[8]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[8]))),
              onPressed: (){

              },
            ),
            GetUemYangSign(widget.listPaljaData[8], true),
          ] ,
        ),
      ));
    }

    listCheonganGanji.add(GetPlajaBox(widget.listPaljaData[6], 6)); //시간
    listCheonganGanji.add(Container(  //일간
    width: paljaBoxSize,
    height: paljaBoxSize,
    margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
    decoration: BoxDecoration(
    boxShadow: [style.uiOhengShadow],
    color: listOhengBoxColor0[4],
    borderRadius: BorderRadius.circular(style.textFiledRadius),
    ),
    child: Stack(
    children:[
    TextButton(
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
    ),
    //TextButton.styleFrom(
    //splashFactory: NoSplash.splashFactory,
    //padding: EdgeInsets.only(bottom:buttonPaddingVal),
    //),
    child: Align(
    alignment: Alignment.center,
    child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[4]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[4]))),
    onPressed: (){

    },
    ),
    GetUemYangSign(widget.listPaljaData[4], true),
    ]
    ),
    ));
    listCheonganGanji.add(Container(  //월간
    width: paljaBoxSize,
    height: paljaBoxSize,
    margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
    decoration: BoxDecoration(
    boxShadow: [style.uiOhengShadow],
    color: listOhengBoxColor0[2],
    borderRadius: BorderRadius.circular(style.textFiledRadius),
    ),
    child: Stack(
    children:[
    TextButton(
    style:ButtonStyle(
      overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
    ),
    //TextButton.styleFrom(
    //splashFactory: NoSplash.splashFactory,
    //padding: EdgeInsets.only(bottom:buttonPaddingVal),
    //),
    child: Align(
    alignment: Alignment.center,
    child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[2]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[2]))),
    onPressed: (){

    },
    ),
    GetUemYangSign(widget.listPaljaData[2], true),
    ] ,
    ),
    ));
    listCheonganGanji.add(GetPlajaBox(widget.listPaljaData[0], 0)); //연간

    return listCheonganGanji;
  }
  List<Widget> GetJijiGanjiWidget(){
    List<Widget> listJijiGanji =[];

//    SetOhengBoxAndTextColor();

    if(widget.listPaljaData.length > 10){
      listJijiGanji.add(Container(  //세운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
        decoration: BoxDecoration(
          boxShadow: [style.uiOhengShadow],
          color: listOhengBoxColor0[11],
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        child: Stack(
          children:[
            TextButton(
              style:ButtonStyle(
                overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
              ),
              //TextButton.styleFrom(
              //  splashFactory: NoSplash.splashFactory,
              //  padding: EdgeInsets.only(bottom:buttonPaddingVal),
              //),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[11]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[11]))),
              onPressed: (){

              },
            ),
            GetUemYangSign(widget.listPaljaData[11], false),
          ] ,
        ),
      ));
    }

    if(widget.listPaljaData.length > 8){
      listJijiGanji.add(Container(  //대운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
        decoration: BoxDecoration(
          boxShadow: [style.uiOhengShadow],
          color: listOhengBoxColor0[9],
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        child: Stack(
          children:[
            TextButton(
              style:ButtonStyle(
                overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
              ),
              //TextButton.styleFrom(
              //  splashFactory: NoSplash.splashFactory,
              //  padding: EdgeInsets.only(bottom:buttonPaddingVal),
              //),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[9]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[9]))),
              onPressed: (){

              },
            ),
            GetUemYangSign(widget.listPaljaData[9], false),
          ] ,
        ),
      ));
    }

    listJijiGanji.add(GetPlajaBox(widget.listPaljaData[7], 7)); //시지
    listJijiGanji.add(Container(  //일지
    width: paljaBoxSize,
    height: paljaBoxSize,
    margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
    decoration: BoxDecoration(
    boxShadow: [style.uiOhengShadow],
    color: listOhengBoxColor0[5],
    borderRadius: BorderRadius.circular(style.textFiledRadius),
    ),
    child: Stack(
    children:[
    TextButton(
    style:ButtonStyle(
      overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
    ),
    //TextButton.styleFrom(
    //splashFactory: NoSplash.splashFactory,
    //padding: EdgeInsets.only(bottom:buttonPaddingVal),
    //),
    child: Align(
    alignment: Alignment.center,
    child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[5]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[5]))),
    onPressed: (){

    },
    ),
    GetUemYangSign(widget.listPaljaData[5], false),
    ],
    ),
    ));
    listJijiGanji.add(Container(  //월지
    width: paljaBoxSize,
    height: paljaBoxSize,
    margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
    decoration: BoxDecoration(
    boxShadow: [style.uiOhengShadow],
    color: listOhengBoxColor0[3],
    borderRadius: BorderRadius.circular(style.textFiledRadius),
    ),
    child: Stack(
    children: [
    TextButton(
    style:ButtonStyle(
      overlayColor: MaterialStateProperty.all(style.colorGrey.withOpacity(0.0)),
    ),
    //TextButton.styleFrom(
    //splashFactory: NoSplash.splashFactory,
    //padding: EdgeInsets.only(bottom:buttonPaddingVal),
    //),
    child: Align(
    alignment: Alignment.center,
    child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[3]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[3]))),
    onPressed: (){

    },
    ),
    GetUemYangSign(widget.listPaljaData[3], false),
    ],
    ),
    ));
    listJijiGanji.add(GetPlajaBox(widget.listPaljaData[1], 1)); //연지

    return listJijiGanji;
  }

  List<Widget> GetCheonganGanjiWidgetWithSprite(){
    List<Widget> listCheonganGanji =[];

    if(widget.listPaljaData.length > 10){
      listCheonganGanji.add(Container(  //대운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
        child: Stack(
          children:[
            Image.asset('assets/' + style.SetOhengSpriteString(true, widget.listPaljaData[10], themeTitle)),
            Align(
              alignment: Alignment.center,
              child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[10]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[10]))),
            GetUemYangSign(widget.listPaljaData[10], true),
          ] ,
        ),
      ));
    }

    if(widget.listPaljaData.length > 8){
      listCheonganGanji.add(Container(  //대운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
        child: Stack(
          children:[
            Image.asset('assets/' + style.SetOhengSpriteString(true, widget.listPaljaData[8], themeTitle)),
            Align(
                alignment: Alignment.center,
                child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[8]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[8]))),
            GetUemYangSign(widget.listPaljaData[8], true),
          ] ,
        ),
      ));
    }

    listCheonganGanji.add(GetPlajaBoxWithSprite(widget.listPaljaData[6], 6)); //시간
    listCheonganGanji.add(Container(  //일간
      width: paljaBoxSize,
      height: paljaBoxSize,
      margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
      child: Stack(
          children:[
            Image.asset('assets/' + style.SetOhengSpriteString(true, widget.listPaljaData[4], themeTitle),),
            Align(
                alignment: Alignment.center,
                child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[4]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[4]))),
            GetUemYangSign(widget.listPaljaData[4], true),
          ]
      ),
    ));
    listCheonganGanji.add(Container(  //월간
      width: paljaBoxSize,
      height: paljaBoxSize,
      margin: EdgeInsets.only(bottom: ganjiBoxMarginSmaller, top: ganjiBoxMarginBigger),
      child: Stack(
        children:[
          Image.asset('assets/' + style.SetOhengSpriteString(true, widget.listPaljaData[2], themeTitle)),
          Align(
              alignment: Alignment.center,
              child: Text(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[2]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[2]))),
          GetUemYangSign(widget.listPaljaData[2], true),
        ] ,
      ),
    ));
    listCheonganGanji.add(GetPlajaBoxWithSprite(widget.listPaljaData[0], 0)); //연간

    return listCheonganGanji;
  }
  List<Widget> GetJijiGanjiWidgetWithSprite(){
    List<Widget> listJijiGanji =[];

    if(widget.listPaljaData.length > 10){
      listJijiGanji.add(Container(  //세운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
        child: Stack(
          children:[
            Image.asset('assets/' + style.SetOhengSpriteString(false, widget.listPaljaData[11], themeTitle)),
            Align(
                alignment: Alignment.center,
                child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[11]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[11]))),
            GetUemYangSign(widget.listPaljaData[11], false),
          ] ,
        ),
      ));
    }

    if(widget.listPaljaData.length > 8){
      listJijiGanji.add(Container(  //대운
        width: paljaBoxSize,
        height: paljaBoxSize,
        margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
        child: Stack(
          children:[
            Image.asset('assets/' + style.SetOhengSpriteString(false, widget.listPaljaData[9], themeTitle)),
            Align(
                alignment: Alignment.center,
                child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[9]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[9]))),
            GetUemYangSign(widget.listPaljaData[9], false),
          ] ,
        ),
      ));
    }

    listJijiGanji.add(GetPlajaBoxWithSprite(widget.listPaljaData[7], 7)); //시지
    listJijiGanji.add(Container(  //일지
      width: paljaBoxSize,
      height: paljaBoxSize,
      margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
      child: Stack(
        children:[
          Image.asset('assets/' + style.SetOhengSpriteString(false, widget.listPaljaData[5], themeTitle)),
          Align(
              alignment: Alignment.center,
              child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[5]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[5]))),
          GetUemYangSign(widget.listPaljaData[5], false),
        ],
      ),
    ));
    listJijiGanji.add(Container(  //월지
      width: paljaBoxSize,
      height: paljaBoxSize,
      margin: EdgeInsets.only(bottom: ganjiBoxMarginBigger, top: ganjiBoxMarginSmaller),
      child: Stack(
        children: [
          Image.asset('assets/' + style.SetOhengSpriteString(false, widget.listPaljaData[3], themeTitle)),
          Align(
              alignment: Alignment.center,
              child: Text(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[3]], style:TextStyle(fontSize: ohengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor0[3]))),
          GetUemYangSign(widget.listPaljaData[3], false),
        ],
      ),
    ));
    listJijiGanji.add(GetPlajaBoxWithSprite(widget.listPaljaData[1], 1)); //연지

    return listJijiGanji;
  }

  SetOhengBoxAndTextColor(){
    for(int i = 0; i < 8; i++){ //오행 박스와 텍스트 컬러, 텍스트 초기화
      if(i % 2 == 0){ //천간이면
        listOhengBoxColor0[i] = style.SetOhengColor(true, widget.listPaljaData[i]);
        if(widget.listPaljaData[i] == 6 || widget.listPaljaData[i] == 7 || widget.listPaljaData[i] == -2){
          listOhengTextColor0[i] = style.colorBlack;
        }
        else{
          listOhengTextColor0[i] = Colors.white;
        }
        if(widget.listPaljaData[i] != -2){  //시간모름 아니면
          listOhengText0[i] = style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[i]];
        }
        else{ //시간모름이면
          listOhengText0[i] = style.unknownTimeText;
        }
      }
      else{ //지지면
        listOhengBoxColor0[i] = style.SetOhengColor(false, widget.listPaljaData[i]);
        if(widget.listPaljaData[i] == 8 || widget.listPaljaData[i] == 9 || widget.listPaljaData[i] == -2){
          listOhengTextColor0[i] = style.colorBlack;
        }
        else{
          listOhengTextColor0[i] = Colors.white;
        }
        if(widget.listPaljaData[i] != -2){  //시간모름 아니면
          listOhengText0[i] = style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[i]];
        }
        else{ //시간모름이면
          listOhengText0[i] = style.unknownTimeText;
        }
      }
    }

    if(widget.listPaljaData.length > listOhengBoxColor0.length){  //간지가 많고 컬러 리스트가 적으면 추가
      int i = listOhengBoxColor0.length;
      while(widget.listPaljaData.length > listOhengBoxColor0.length){
        if(i % 2 == 0){ //천간이면
          listOhengBoxColor0.add(style.SetOhengColor(true, widget.listPaljaData[i]));
          if(widget.listPaljaData[i] == 6 || widget.listPaljaData[i] == 7 || widget.listPaljaData[i] == -2){
            listOhengTextColor0.add(style.colorBlack);
          }
          else{
            listOhengTextColor0.add(Colors.white);
          }
          if(widget.listPaljaData[i] != -2){  //시간모름 아니면
            listOhengText0.add(style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[i]]);
          }
          else{ //시간모름이면
            listOhengText0.add(style.unknownTimeText);
          }
        }
        else{ //지지면
          listOhengBoxColor0.add(style.SetOhengColor(false, widget.listPaljaData[i]));
          if(widget.listPaljaData[i] == 8 || widget.listPaljaData[i] == 9 || widget.listPaljaData[i] == -2){
            listOhengTextColor0.add(style.colorBlack);
          }
          else{
            listOhengTextColor0.add(Colors.white);
          }
          if(widget.listPaljaData[i] != -2){  //시간모름 아니면
            listOhengText0.add(style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[i]]);
          }
          else{ //시간모름이면
            listOhengText0.add(style.unknownTimeText);
          }
        }
        i++;
      }
    }
    else if(widget.listPaljaData.length < listOhengBoxColor0.length){  //간지가 적고 컬러리스트가 많으면
      while(widget.listPaljaData.length < listOhengBoxColor0.length){
        listOhengBoxColor0.removeLast();
        listOhengText0.removeLast();
      }
    }
      int i = 8;
      while(i < listOhengBoxColor0.length){
        if(i % 2 == 0){ //천간이면
          listOhengBoxColor0[i] = style.SetOhengColor(true, widget.listPaljaData[i]);
          if(widget.listPaljaData[i] == 6 || widget.listPaljaData[i] == 7 || widget.listPaljaData[i] == -2){
            listOhengTextColor0[i] = style.colorBlack;
          }
          else{
            listOhengTextColor0[i] = Colors.white;
          }
          if(widget.listPaljaData[i] != -2){  //시간모름 아니면
            listOhengText0[i] = style.stringCheongan[widget.isShowDrawerKoreanGanji][widget.listPaljaData[i]];
          }
          else{ //시간모름이면
            listOhengText0[i] = style.unknownTimeText;
          }
        }
        else{ //지지면
          listOhengBoxColor0[i] = style.SetOhengColor(false, widget.listPaljaData[i]);
          if(widget.listPaljaData[i] == 8 || widget.listPaljaData[i] == 9 || widget.listPaljaData[i] == -2){
            listOhengTextColor0[i] = style.colorBlack;
          }
          else{
            listOhengTextColor0[i] = Colors.white;
          }
          if(widget.listPaljaData[i] != -2){  //시간모름 아니면
            listOhengText0[i] = style.stringJiji[widget.isShowDrawerKoreanGanji][widget.listPaljaData[i]];
          }
          else{ //시간모름이면
            listOhengText0[i] = style.unknownTimeText;
          }
        }
        i++;
      }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isShowDrawerKoreanGanji == 1){
      buttonPaddingVal = 0;
    } else {
      buttonPaddingVal = 4;
    }

    ganjiContainerHeight = 156;

    int themeType = ((personalDataManager.etcData % 10000000) / 1000000).floor();
    isSpriteTheme = false;
    if(themeType == 2){
      isSpriteTheme = true;
    }

    switch(themeType){
      case 2 : {
        themeTitle = 'luciaBear';
      }
    }

    if(isSpriteTheme == true){
      if(widget.listPaljaData.length < 11){
        paljaBoxSize = style.fullSizeButtonHeight * 1.4;//60
        ohengFontSize = 30;
        unknownTextFontSize = 44;
        ganjiBoxMarginBigger = 5;
        ganjiBoxMarginSmaller = 3;
      } else {
        paljaBoxSize = style.fullSizeButtonHeight * 1.2;//52
        ohengFontSize = 25;
        unknownTextFontSize = 36;
        ganjiBoxMarginBigger = 8;
        ganjiBoxMarginSmaller = 5;
      }
    } else {
      if(widget.listPaljaData.length < 11){
        paljaBoxSize = style.fullSizeButtonHeight * 1.25;//60
        ohengFontSize = 30;
        unknownTextFontSize = 44;
        ganjiBoxMarginBigger = 10;
        ganjiBoxMarginSmaller = 6;
      } else {
        paljaBoxSize = style.fullSizeButtonHeight * 1.083;//52
        ohengFontSize = 25;
        unknownTextFontSize = 36;
        ganjiBoxMarginBigger = 16;
        ganjiBoxMarginSmaller = 8;
      }
    }

    if(widget.isShowChooseDayButtons == true){
      ganjiContainerHeight = ganjiContainerHeight + (style.UIBoxLineHeight * 2);
    }

    SetOhengBoxAndTextColor();

    return Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
        height: ganjiContainerHeight,
        //padding: EdgeInsets.only(top:widget.isLastWidget==false?0:2),
        decoration: BoxDecoration(color: widget.containerColor,
            border: Border(bottom: BorderSide(width: 2, color:style.colorGrey), top: BorderSide(width:2, color:style.colorGrey)),
            boxShadow: [
              BoxShadow(
                color: widget.containerColor,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.isLastWidget==false? 0:style.textFiledRadius), bottomRight: Radius.circular(widget.isLastWidget==false? 0:style.textFiledRadius))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: isSpriteTheme == false? GetCheonganGanjiWidget() : GetCheonganGanjiWidgetWithSprite(),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: isSpriteTheme == false? GetJijiGanjiWidget() : GetJijiGanjiWidgetWithSprite(),
            ),
          ],
        )
    );
  }
}
/*
class CaledarResultPalja{
                                      //    0,  1  , 2  , 3 ,  4 , 5  , 6 , 7  , 8  , 9
  List<List<String>> listChenganString = [['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'],['갑','을','병','정','무','기','경','신','임','계']];
  //                                       '寅','卯','辰','巳','午','未','申','酉','戌','亥','子','丑'  -2
                                       //0,   1 , 2  , 3 ,  4,  5 ,  6 ,  7 , 8  , 9  ,10,  11
  List<List<String>> listJijiString = [['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'],['자','축','인','묘','진','사','오','미','신','유','술','해']];
  //                                    '庚','辛','壬','癸','甲','乙','丙','丁','戊','己'
  //                                  //'申','酉','戌','亥','子','丑','寅','卯','辰','巳','午','未'
  //      6   4 - 1 + 6

  List<Color> listOhengBoxColor = [];
  List<Color> listOhengTextColor = [];
  List<String> listOhengText = [];

  Container GetPlajaBox(int paljaNum, int paljaIndex){
    if(paljaNum != -2){
      if(paljaIndex == 6){
        return  Container(  //시간
          width: style.fullSizeButtonHeight,
          height: style.fullSizeButtonHeight,
          padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
          decoration: BoxDecoration(
            boxShadow: [style.uiOhengShadow],
            color: listOhengBoxColor[6],
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          alignment: Alignment.topCenter,
          child: Text(style.stringCheongan[paljaNum], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[paljaIndex])),
        );
      }
     else{
        return  Container(  //시간
          width: style.fullSizeButtonHeight,
          height: style.fullSizeButtonHeight,
          padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
          margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
          decoration: BoxDecoration(
            boxShadow: [style.uiOhengShadow],
            color: listOhengBoxColor[7],
            borderRadius: BorderRadius.circular(style.textFiledRadius),
          ),
          alignment: Alignment.topCenter,
          child: Text(style.stringJiji[paljaNum], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[paljaIndex])),
        );
      }
    }
    else{
      return  Container(  //시간 모름일 때
        width: style.fullSizeButtonHeight,
        height: style.fullSizeButtonHeight,
        padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
        margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
        decoration: BoxDecoration(
          boxShadow: [style.uiOhengShadow],
          color: listOhengBoxColor[6],
          borderRadius: BorderRadius.circular(style.textFiledRadius),
        ),
        alignment: Alignment.topCenter,
        child: Text(style.unknownTimeText, style:TextStyle(fontSize: 36, fontWeight: style.UIOhengFontWeight, color: style.colorBlack)),
      );
    }
  }

  GetPalja(BuildContext context, Color containerColor, var ContainerColorSwitchSetter, List<int> _listPaljaData){


    return Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
        height: style.UIPaljaBoxHeight,
        margin: EdgeInsets.only(left: style.UIMarginLeft),
        decoration: BoxDecoration(color: containerColor),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                GetPlajaBox(_listPaljaData[6], 6), //시간
                Container(  //일간
                  width: style.fullSizeButtonHeight,
                  height: style.fullSizeButtonHeight,
                  padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
                  margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: listOhengBoxColor[4],
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  alignment: Alignment.topCenter,
                  child: Text(style.stringCheongan[_listPaljaData[4]], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[4])),
                ),
                Container(  //월간
                  width: style.fullSizeButtonHeight,
                  height: style.fullSizeButtonHeight,
                  padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
                  margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: listOhengBoxColor[2],
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  alignment: Alignment.topCenter,
                  child: Text(style.stringCheongan[_listPaljaData[2]], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[2])),
                ),
                Container(  //연간
                  width: style.fullSizeButtonHeight,
                  height: style.fullSizeButtonHeight,
                  padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
                  margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop),
                  decoration: BoxDecoration(
                    boxShadow: [style.uiOhengShadow],
                    color: listOhengBoxColor[0],
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  alignment: Alignment.topCenter,
                  child: Text(style.stringCheongan[_listPaljaData[0]], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[0])),
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  GetPlajaBox(_listPaljaData[7], 7), //시지
                  Container(  //일지
                    width: style.fullSizeButtonHeight,
                    height: style.fullSizeButtonHeight,
                    padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
                    margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop * 1.4),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: listOhengBoxColor[5],
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(style.stringJiji[_listPaljaData[5]], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[5])),
                  ),
                  Container(  //월지
                    width: style.fullSizeButtonHeight,
                    height: style.fullSizeButtonHeight,
                    padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
                    margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop * 1.4),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: listOhengBoxColor[3],
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(style.stringJiji[_listPaljaData[3]], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[3])),
                  ),
                  Container(  //연지
                    width: style.fullSizeButtonHeight,
                    height: style.fullSizeButtonHeight,
                    padding: EdgeInsets.only(top:style.UIOhengBoxPadding1),
                    margin: EdgeInsets.only(bottom: style.UIOhengMarginTop, top: style.UIOhengMarginTop * 1.4),
                    decoration: BoxDecoration(
                      boxShadow: [style.uiOhengShadow],
                      color: listOhengBoxColor[1],
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(style.stringJiji[_listPaljaData[1]], style:TextStyle(fontSize: style.UIOhengFontSize, fontWeight: style.UIOhengFontWeight, color: listOhengTextColor[1])),
                  ),
                ]
            ),
          ],
        )
    );
  }
}*/