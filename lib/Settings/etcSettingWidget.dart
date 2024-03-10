import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;

class EtcSettingWidget extends StatefulWidget {
  const EtcSettingWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<EtcSettingWidget> createState() => EtcSettingState();
}

class EtcSettingState extends State<EtcSettingWidget> {
  int isShowManOld = 0; //0:안보여줌, 1:보여줌
  Image manOldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment manOldAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowUemyang = 0; //0:안보여줌, 1:보여줌
  Image uemYangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment uemYangAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowKoreanGanji = 0; //0:안보여줌, 1:보여줌
  Image koreanGanjiButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment koreanGanjiAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowPersonalDataNum = 0; //0:안보여줌, 1:보여줌 이름과 성별, 나이, 생년월일시,
  List<String> listPersonalDataInfoString = [ '인적사항을 숨기지 않습니다', '만세력 조회에서 인적사항을 숨깁니다', '항상 인적사항을 숨깁니다'];
  bool isShowPersonalName = false, isShowPersonalOld = false, isShowPersonalBirth = false;
  double personalDataContainerHeight = 0;
  Image personalDataButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment personalDataAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isWakeLock = 0; //화면꺼짐 방지 0:꺼짐, 1:안꺼짐
  Image wakeLockButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment wakeLockAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  double widgetWidth = 0;
  double widgetHeight = 0;

  SetManOld({bool isSwitch = true}){  // 만나이
    if(isSwitch == true)
    {setState(() {
      isShowManOld = (isShowManOld + 1) % 2;
      personalDataManager.SaveEtcData(1, isShowManOld + 1);
    });}

    if(isShowManOld == 0){
      manOldAlign = Alignment.centerLeft;
      manOldButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      manOldAlign = Alignment.centerRight;
      manOldButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetUemyang({bool isSwitch = true}){  //간지에 음양 표시
    if(isSwitch == true)
    {setState(() {
      isShowUemyang = (isShowUemyang + 1) % 2;
      personalDataManager.SaveEtcData(10, isShowUemyang + 1);
    });}

    if(isShowUemyang == 0){
      uemYangAlign = Alignment.centerLeft;
      uemYangButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      uemYangAlign = Alignment.centerRight;
      uemYangButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetKoreanGanji({bool isSwitch = true}){  //한글화
    if(isSwitch == true)
    {setState(() {
      isShowKoreanGanji = (isShowKoreanGanji + 1) % 2;
      personalDataManager.SaveEtcData(100, isShowKoreanGanji + 1);
    });}

    if(isShowKoreanGanji == 0){
      koreanGanjiAlign = Alignment.centerLeft;
      koreanGanjiButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      koreanGanjiAlign = Alignment.centerRight;
      koreanGanjiButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetPersonalData({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowPersonalDataNum = (isShowPersonalDataNum + 1) % 3;
      personalDataManager.SaveEtcData(1000, isShowPersonalDataNum + 1);
    });}

    if(isShowPersonalDataNum == 0){
      personalDataContainerHeight = 0;
      personalDataAlign = Alignment.centerLeft;
      personalDataButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    }  else if(isShowPersonalDataNum == 1) {
      personalDataContainerHeight = style.saveDataMemoLineHeight * 2.5;
      personalDataAlign = Alignment.center;
      personalDataButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    } else if(isShowPersonalDataNum == 2) {
      personalDataContainerHeight = style.saveDataMemoLineHeight * 2.5;
      personalDataAlign = Alignment.centerRight;
      personalDataButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SavePersonalData(){
    if(isShowPersonalDataNum != 0){
      int dataNum = 0;
      if(isShowPersonalName == true){
        dataNum = dataNum + 1;}
      if(isShowPersonalOld == true){
        dataNum = dataNum + 2;}
      if(isShowPersonalBirth == true){
        dataNum = dataNum + 4;}
      if(dataNum == 0){
        dataNum = 9;}
      personalDataManager.SaveEtcData(10000, dataNum);
    }
  }

  SetWakeLock({bool isSwitch = true}){  //한글화
    if(isSwitch == true)
    {setState(() {
      isWakeLock = (isWakeLock + 1) % 2;
      personalDataManager.SaveEtcData(100000, isWakeLock + 1);
    });}

    if(isWakeLock == 0){
      wakeLockAlign = Alignment.centerLeft;
      wakeLockButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      wakeLockAlign = Alignment.centerRight;
      wakeLockButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    int dataNum = personalDataManager.etcData;

    int tempNum = dataNum % 10;
    isShowManOld = (dataNum % 10) - 1;
    SetManOld(isSwitch : false);

    tempNum = ((dataNum % 100) / 10).floor();
    isShowUemyang = tempNum - 1;
    SetUemyang(isSwitch : false);

    tempNum = ((dataNum % 1000) / 100).floor();
    isShowKoreanGanji = tempNum - 1;
    SetKoreanGanji(isSwitch : false);

    tempNum = ((dataNum % 10000) / 1000).floor();
    isShowPersonalDataNum = tempNum - 1;
    SetPersonalData(isSwitch : false);

    tempNum = ((dataNum % 100000) / 10000).floor();
    if(tempNum == 1 || tempNum == 3 || tempNum == 5 || tempNum == 7){
      isShowPersonalName = true;
    } else {
      isShowPersonalName = false;
    }
    if(tempNum == 2 || tempNum == 3 || tempNum == 6 || tempNum == 7){
      isShowPersonalOld = true;
    } else {
      isShowPersonalOld = false;
    }
    if(tempNum == 4 || tempNum == 5 || tempNum == 6 || tempNum == 7){
      isShowPersonalBirth = true;
    } else {isShowPersonalBirth = false;}

    tempNum = ((dataNum % 1000000) / 100000).floor();
    isWakeLock = tempNum - 1;
    SetWakeLock(isSwitch: false);
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
          children: [Container(
            width: style.UIButtonWidth,
            height: style.fullSizeButtonHeight,
            alignment: Alignment.center,
            child:Text('기타', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(  //정렬용 컨테이너
                        width: widgetWidth,
                        height: 1,
                      ),
                      Container(  //한국식 나이
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
                            Text("만 나이로 표시", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetManOld();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //만 나이 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo1),
                        child: Text("나이를 만 나이로 표시합니다", style: style.settingInfoText0),
                      ),
                      Container(  //간지 음양
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
                                      crossFadeState: isShowUemyang == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(
                                      width: 26,
                                      child: AnimatedAlign(
                                        alignment: uemYangAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: uemYangButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("간지 음양", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetUemyang();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //간지 음양 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo1),
                        child: Text("간지의 음양을 표시합니다", style: style.settingInfoText0),
                      ),
                      Container(  //간지 한글
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
                                      crossFadeState: isShowKoreanGanji == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
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
                              onPressed: (){SetKoreanGanji();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //간지 한글 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo1),
                        child: Text("간지를 한글로 표시합니다", style: style.settingInfoText0),
                      ),
                      Container(  //인적사항 숨김
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
                                      crossFadeState: isShowPersonalDataNum == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      alignment: Alignment.center,
                                      firstCurve: Curves.easeIn,
                                      secondCurve: Curves.easeIn,
                                    ),
                                    Container(
                                      width: 34,
                                      child: AnimatedAlign(
                                        alignment: personalDataAlign,
                                        duration: Duration(milliseconds: 130),
                                        curve: Curves.easeIn,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          child: personalDataButtonImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("인적사항 숨김", style: style.settingText0),
                            ElevatedButton( //천간 합충극 스위치 버튼
                              onPressed: (){SetPersonalData();widget.reloadSetting();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                              style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                          ],
                        ),
                      ),
                      Container(  //인적사항 숨김 설명
                        width: (widgetWidth - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight,
                        margin: EdgeInsets.only(bottom: style.SettingMarginTopWithInfo1),
                        child: Text(listPersonalDataInfoString[isShowPersonalDataNum], style: style.settingInfoText0, key: ValueKey<int>(isShowPersonalDataNum),
                        ),
                      ),
                      Stack(
                        children: [
                          AnimatedOpacity(  //인적사항 숨김 옵션들
                            opacity: isShowPersonalDataNum != 0 ? 1.0 : 0.0,
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
                                      Text("이름", style: style.settingText0,),
                                      Checkbox(
                                        value: isShowPersonalName,
                                        onChanged: (value) {
                                          setState(() {
                                            isShowPersonalName = value!;widget.reloadSetting();
                                          });
                                          SavePersonalData();
                                        },
                                      ),
                                      SizedBox(width:20),
                                      Text("나이 ", style: style.settingText0,),
                                      Checkbox(
                                        value: isShowPersonalOld,
                                        onChanged: (value) {
                                          setState(() {
                                            isShowPersonalOld = value!;widget.reloadSetting();
                                          });
                                          if(value == true){
                                            if(((personalDataManager.deunSeunData % 1000000) / 100000).floor() == 2) {
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text('세운에 나이가 표시되지 않습니다', textAlign: TextAlign.center,
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          }
                                          SavePersonalData();
                                        },
                                      ),
                                      SizedBox(width:20),
                                      Text("생년월일 ", style: style.settingText0,),
                                      Checkbox(
                                        value: isShowPersonalBirth,
                                        onChanged: (value) {
                                          setState(() {
                                            isShowPersonalBirth = value!;widget.reloadSetting();
                                          });
                                          SavePersonalData();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(  //천간 합충극 설명
                                  width: (widgetWidth - (style.UIMarginLeft * 2)),
                                  height: style.saveDataMemoLineHeight,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: style.UIMarginLeft,
                                        height: 1,
                                      ),
                                      Text("제외할 사항을 선택해 주세요", style: style.settingInfoText0,),
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
                                height: personalDataContainerHeight,
                                curve: Curves.fastOutSlowIn,
                              ),
                              /*Container(  //화면꺼짐 방지
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
                                              crossFadeState: isWakeLock == 1? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                              firstCurve: Curves.easeIn,
                                              secondCurve: Curves.easeIn,
                                            ),
                                            Container(
                                              width: 26,
                                              child: AnimatedAlign(
                                                alignment: wakeLockAlign,
                                                duration: Duration(milliseconds: 130),
                                                curve: Curves.easeIn,
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  child: wakeLockButtonImage,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("화면 꺼짐 방지", style: style.settingText0),
                                    ElevatedButton( //천간 합충극 스위치 버튼
                                      onPressed: (){SetWakeLock();}, child: Container(width:(widgetWidth - (style.UIMarginLeft * 2)), height:20),
                                      style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, foregroundColor: style.colorBackGround, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0),),
                                  ],
                                ),
                              ),
                              Container(  //간지 한글 설명
                                width: (widgetWidth - (style.UIMarginLeft * 2)),
                                height: style.saveDataMemoLineHeight,
                                //margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                                child: Text("만세력 조회 중 화면이 꺼지지 않습니다", style: style.settingInfoText0),
                              ),*/
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
