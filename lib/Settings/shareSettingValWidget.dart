import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;

class ShareSettingValWidget extends StatefulWidget {
  const ShareSettingValWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<ShareSettingValWidget> createState() => _ShareSettingValWidgetState();
}

//저장 목록 관리
class _ShareSettingValWidgetState extends State<ShareSettingValWidget> {
  TextEditingController codeTextController = TextEditingController();

  String settingCodeString = '';

  double widgetWidth = 0;
  double widgetHeight = 0;

  ShowSnackBar(String text){
    SnackBar snackBar = SnackBar(
      content: Text(text, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
      backgroundColor: style.colorMainBlue,//Colors.white,
      //style.colorMainBlue,
      shape: StadiumBorder(),
      duration: Duration(milliseconds: style.snackBarDuration),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: 20,
          left: (MediaQuery.of(context).size.width - style.UIButtonWidth) * 0.5,
          right: (MediaQuery.of(context).size.width - style.UIButtonWidth) * 0.5),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SetSettingCodeString(){
    String code0 = '';

    int temp = 0;

    if(personalDataManager.mapWordData['ilGan'] == 0 ) {
      code0 = '3' + personalDataManager.mapWordData['yugChin'].toString(); //일간, 육친
    } else {
      code0 = personalDataManager.mapWordData['ilGan'].toString() + personalDataManager.mapWordData['yugChin'].toString(); //일간, 육친
    }

    temp = (personalDataManager.mapWordData['myeongSic'] == 0? 0:1);  //명식
    temp = temp + (personalDataManager.mapWordData['geukChung'] == 1? 0:3); //천간극충
    temp = temp + (personalDataManager.mapWordData['hab'] == 1? 0:5); //지지합
    code0 = code0 + temp.toString();

    code0 = code0 + (personalDataManager.calendarData % 10).toString() + ((personalDataManager.calendarData % 100)/10).floor().toString()
        + ((personalDataManager.calendarData % 1000)/100).floor().toString() + ((personalDataManager.calendarData % 100000)/10000).floor().toString(); //천간합충극, 방합, 삼합, 형

    temp = (((personalDataManager.calendarData % 10000)/1000).floor() == 1? 0:1) + (((personalDataManager.calendarData % 1000000)/100000).floor() == 1? 0:3)
        + (((personalDataManager.calendarData % 10000000)/1000000).floor() == 1? 0:5);  //육합1, 충3, 파5
    code0 = code0 + temp.toString();

    temp = (((personalDataManager.calendarData % 100000000)/10000000).floor() == 1? 0:1) + (((personalDataManager.calendarData % 100000000)/10000000).floor() == 1? 0:3)
        + (((personalDataManager.calendarData % 10000000000)/1000000000).floor() == 1? 0:5);  //원진1, 귀문3, 격각5
    code0 = code0 + temp.toString();

    code0 = code0 + ((personalDataManager.calendarData % 100000000000)/10000000000).floor().toString(); //지장간

    temp = (((personalDataManager.calendarData % 1000000000000)/100000000000).floor() == 1? 0:1) + (((personalDataManager.calendarData % 10000000000000)/1000000000000).floor() == 1? 0:3);
    code0 = code0 + temp.toString();  //십이운성1, 육친3

    code0 = code0 + (personalDataManager.deunSeunData % 10).toString(); //간지 추가

    temp = (((personalDataManager.deunSeunData % 100)/10).floor() == 1? 0:1) + (((personalDataManager.deunSeunData % 1000)/100).floor() == 1? 0:3)
        + (((personalDataManager.deunSeunData % 10000)/1000).floor() == 1? 0:5);
    code0 = code0 + temp.toString();  //육친1, 십이운성3, 대운십이신살5

    code0 = code0 + ((personalDataManager.deunSeunData % 100000)/10000).floor().toString(); //대운 공망

    temp = (((personalDataManager.deunSeunData % 1000000)/100000).floor() == 1? 0:1) + (((personalDataManager.deunSeunData % 10000000)/1000000).floor() == 1? 0:3)
        + (((personalDataManager.sinsalData % 100)/10).floor() == 1? 0:5);
    code0 = code0 + temp.toString();  //세운나이1, 월운3, 신살 - 십이신살5

    code0 = code0 + (personalDataManager.sinsalData % 10).toString() + (((personalDataManager.sinsalData % 1000)/100).floor()).toString(); //신살 - 공망고르기, 공망 보기 타입

    temp = ((personalDataManager.etcData % 10).floor() == 1? 0:1) + (((personalDataManager.etcData % 100)/10).floor() == 1? 0:3)
        + (((personalDataManager.etcData % 1000)/100).floor() == 1? 0:5);
    code0 = code0 + temp.toString();  //만나이1, 음양표시3, 한글화5

    code0 = (int.parse(code0).toRadixString(36)).toString().toUpperCase();

    setState(() {
      settingCodeString = code0;
    });
  }

  CopySettingCode(){
    Clipboard.setData(ClipboardData(text: settingCodeString));
    ShowSnackBar('클립보드에 코드가 복사되었습니다');
  }

  PasteSettingCodeFromClipboard() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

    if(cdata?.text == ''){
      ShowSnackBar('클립보드가 비어있습니다');
    } else {
      setState(() {
        codeTextController.text = cdata?.text ?? '';
      });
    }
  }

  ApplyCode(){
    if(codeTextController.text == ''){
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        //barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('코드를 먼저 입력해주세요',textAlign: TextAlign.center,
            ),
          );
        },
      );
      return;
    }
    if(InspectCode() == false){
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        //barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('올바르지 않은 코드를 입력하셨습니다',textAlign: TextAlign.center,
            ),
          );
        },
      );
      return;
    }

    String code = int.parse(codeTextController.text, radix: 36).toString();
    int subInt = 0;

    for(int i = 0; i < 18; i++){
      subInt = int.parse(code.substring(i, i+1));
      switch(i){
        case 0:{  //일간  단어
          if(subInt == 3){
            personalDataManager.mapWordData['ilGan'] = 0;
          } else {
            personalDataManager.mapWordData['ilGan'] = subInt;
          }
        }
        case 1:{  //육친 단어
          personalDataManager.mapWordData['yugChin'] = subInt;
        }
        case 2:{  //명식, 천간충, 지지합
          print(subInt);
          if(subInt == 1 || subInt == 4 || subInt == 6 || subInt == 9){ //명식
            personalDataManager.mapWordData['myeongSic'] = 1;
          } else {
            personalDataManager.mapWordData['myeongSic'] = 0;
          }
          if(subInt == 3 || subInt == 4 || subInt == 8 || subInt == 9){ //천간극충
            personalDataManager.mapWordData['geukChung'] = 2;
            print(2);
          } else {
            personalDataManager.mapWordData['geukChung'] = 1;
          }
          if(subInt == 5 || subInt == 6 || subInt == 8 || subInt == 9){ //합 통일
            personalDataManager.mapWordData['hab'] = 2;
          } else {
            personalDataManager.mapWordData['hab'] = 1;
          }
        }
        case 3:{  //천간합충극
          personalDataManager.SaveCalendarData(1, subInt, withoutSave: true);
        }
        case 4:{  //방합
          personalDataManager.SaveCalendarData(10, subInt, withoutSave: true);
        }
        case 5:{  //삼합
          personalDataManager.SaveCalendarData(100, subInt, withoutSave: true);
        }
        case 6:{  //형
          personalDataManager.SaveCalendarData(10000, subInt, withoutSave: true);
        }
        case 7:{  //육합, 충, 파
          if(subInt == 1 || subInt == 4 || subInt == 6 || subInt == 9){ //육합
            personalDataManager.SaveCalendarData(1000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(1000, 1, withoutSave: true);
          }
          if(subInt == 3 || subInt == 4 || subInt == 8 || subInt == 9){ //충
            personalDataManager.SaveCalendarData(100000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(100000, 1, withoutSave: true);
          }
          if(subInt == 5 || subInt == 6 || subInt == 8 || subInt == 9){ //파
            personalDataManager.SaveCalendarData(1000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(1000000, 1, withoutSave: true);
          }
        }
        case 8:{  //원진, 귀문, 격각
          if(subInt == 1 || subInt == 4 || subInt == 6 || subInt == 9){ //원진
            personalDataManager.SaveCalendarData(10000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(10000000, 1, withoutSave: true);
          }
          if(subInt == 3 || subInt == 4 || subInt == 8 || subInt == 9){ //귀문
            personalDataManager.SaveCalendarData(100000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(100000000, 1, withoutSave: true);
          }
          if(subInt == 5 || subInt == 6 || subInt == 8 || subInt == 9){ //격각
            personalDataManager.SaveCalendarData(1000000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(1000000000, 1, withoutSave: true);
          }
        }
        case 9:{  //지장간
          personalDataManager.SaveCalendarData(10000000000, subInt, withoutSave: true);
        }
        case 10:{  //십이운성, 육친
          if(subInt == 1 || subInt == 4){ //십이운성
            personalDataManager.SaveCalendarData(100000000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(100000000000, 1, withoutSave: true);
          }
          if(subInt == 3 || subInt == 4){ //육친
            personalDataManager.SaveCalendarData(1000000000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveCalendarData(1000000000000, 1, withoutSave: true);
          }
        }
        case 11:{ //간지추가
          personalDataManager.SaveDeunSeunData(1, subInt, withoutSave: true);
        }
        case 12:{ //대운 육친,십이운성,십이신살
          if(subInt == 1 || subInt == 4 || subInt == 6 || subInt == 9){ //대운 육친
            personalDataManager.SaveDeunSeunData(10, 2, withoutSave: true);
          } else {
            personalDataManager.SaveDeunSeunData(10, 1, withoutSave: true);
          }
          if(subInt == 3 || subInt == 4 || subInt == 8 || subInt == 9){ //십이운성
            personalDataManager.SaveDeunSeunData(100, 2, withoutSave: true);
          } else {
            personalDataManager.SaveDeunSeunData(100, 1, withoutSave: true);
          }
          if(subInt == 5 || subInt == 6 || subInt == 8 || subInt == 9){ //십이신살
            personalDataManager.SaveDeunSeunData(1000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveDeunSeunData(1000, 1, withoutSave: true);
          }
        }
        case 13:{ //대운 공망
          personalDataManager.SaveDeunSeunData(10000, subInt, withoutSave: true);
        }
        case 14:{ //세운 나이표시, 월운, 신살-십이신살
          if(subInt == 1 || subInt == 4 || subInt == 6 || subInt == 9){ //세운 나이표시
            personalDataManager.SaveDeunSeunData(100000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveDeunSeunData(100000, 1, withoutSave: true);
          }
          if(subInt == 3 || subInt == 4 || subInt == 8 || subInt == 9){ //월운표시
            personalDataManager.SaveDeunSeunData(1000000, 2, withoutSave: true);
          } else {
            personalDataManager.SaveDeunSeunData(1000000, 1, withoutSave: true);
          }
          if(subInt == 5 || subInt == 6 || subInt == 8 || subInt == 9){ //신살-십이신살
            personalDataManager.SaveSinsalData(10, 2, withoutSave: true);
          } else {
            personalDataManager.SaveSinsalData(10, 1, withoutSave: true);
          }
        }
        case 15:{ //공망 선택
          personalDataManager.SaveSinsalData(1, subInt, withoutSave: true);
        }
        case 16:{ //공망 보기 타입
          personalDataManager.SaveSinsalData(100, subInt, withoutSave: true);
        }
        case 17:{ //만나이, 음양, 한글화
          if(subInt == 1 || subInt == 4 || subInt == 6 || subInt == 9){ //만나이
            personalDataManager.SaveEtcData(1, 2, withoutSave: true);
          } else {
            personalDataManager.SaveEtcData(1, 1, withoutSave: true);
          }
          if(subInt == 3 || subInt == 4 || subInt == 8 || subInt == 9){ //음양표시
            personalDataManager.SaveEtcData(10, 2, withoutSave: true);
          } else {
            personalDataManager.SaveEtcData(10, 1, withoutSave: true);
          }
          if(subInt == 5 || subInt == 6 || subInt == 8 || subInt == 9){ //한글화
            personalDataManager.SaveEtcData(100, 2, withoutSave: true);
          } else {
            personalDataManager.SaveEtcData(100, 1, withoutSave: true);
          }
        }
      }
    }

    personalDataManager.SaveAllFiles();

    widget.reloadSetting();

    ShowSnackBar('설정 코드가 적용되었습니다');
  }

  InspectCode(){
    bool pass = true;
    int subInt = 0;
    String code = int.parse(codeTextController.text, radix: 36).toString();

    for(int i = 0; i < 18; i++){
      subInt = int.parse(code.substring(i, i+1));
      switch(i){
        case 0:{  //일간  단어
          print(i);
          if(subInt == 0 || subInt > 3){
            pass = false; return pass;
          }
        }
        case 1:{  //육친 단어
          print(i);
          if(subInt > 2){
            pass = false; return pass;
          }
        }
        case 2:{  //명식, 천간충, 지지합
          print(i);
          if(subInt == 2 || subInt == 7){
            pass = false; return pass;
          }
        }
        case 3:{  //천간합충극
          print(i);
          if(subInt == 8){
            pass = false; return pass;
          }
        }
        case 4:{  //방합
          print(i);
          if(subInt == 0 || subInt > 3){
            pass = false; return pass;
          }
        }
        case 5:{  //삼합
          print(i);
          if(subInt == 0 || subInt > 3){
            pass = false; return pass;
          }
        }
        case 6:{  //형
          print(i);
          if(subInt == 0 || subInt == 8){
            pass = false; return pass;
          }
        }
        case 7:{  //육합, 충, 파
          print(i);
          if(subInt == 2 || subInt == 7){
            pass = false; return pass;
          }
        }
        case 8:{  //원진, 귀문, 격각
          print(i);
          if(subInt == 2 || subInt == 7){
            pass = false; return pass;
          }
        }
        case 9:{  //지장간
          print(i);
          if(subInt < 2 || subInt == 4 || subInt == 6 || subInt == 8){
            pass = false; return pass;
          }
        }
        case 10:{  //십이운성, 육친
          print(i);
          if(subInt == 2 || subInt > 4){
            pass = false; return pass;
          }
        }
        case 11:{ //간지추가
          print(i);
          if(subInt == 0 || subInt > 3){
            pass = false; return pass;
          }
        }
        case 12:{ //대운 육친,십이운성,십이신살
          print(i);
          if(subInt == 2 || subInt == 7){
            pass = false; return pass;
          }
        }
        case 13:{ //대운 공망
          print(i);
          if(subInt == 0 || subInt == 8){
            pass = false; return pass;
          }
        }
        case 14:{ //세운 나이표시, 월운, 십이신살
          print(i);
          if(subInt == 2 || subInt == 7){
            pass = false; return pass;
          }
        }
        case 15:{ //신살 공망 선택
          print(i);
          if(subInt == 0 || subInt == 8){
            pass = false; return pass;
          }
        }
        case 16:{ //공망 타입
          print(i);
          if(subInt == 0 || subInt > 3){
            pass = false; return pass;
          }
        }
        case 17:{ //만나이, 음양, 한글화
          print(i);
          if(subInt == 2 || subInt == 7){
            pass = false; return pass;
          }
        }
      }
    }
    return pass;
  }

  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    SetSettingCodeString();
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
            child:Text('설정 공유', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Column(
            children: [
              Container(  //정렬용 컨테이너
                width: widgetWidth,
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(  //개인 설정 코드
                    height: style.saveDataMemoLineHeight*1.2,
                    //width: (widgetWidth - (style.UIMarginLeft * 2)),
                    margin: EdgeInsets.only(top: style.UIMarginTop, left: style.UIMarginLeft),
                    child:  Text("개인 설정 코드", style: style.settingText0,),
                  ),
                  Container(  //개인 설정 코드 복사
                    height: style.saveDataMemoLineHeight*1.2,
                    //width: (widgetWidth - (style.UIMarginLeft * 2)),
                    margin: EdgeInsets.only(top: style.UIMarginTop, right: style.UIMarginLeft),
                    child:  SelectableText(settingCodeString, style: style.settingText0,),
                  ),
                ],
              ),
              Container(  //복사 버튼
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      //splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
                    ),
                    child: Text(
                      '코드 복사',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        CopySettingCode();
                      });
                    }),
              ),
              Container(  //중간 구분선
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: 1,
                margin: EdgeInsets.only(top: 32),
                color: style.colorGrey,
              ),
              Container(  //코드 적는 곳
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: style.colorNavy,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(  //텍스트 필드
                      //width: widgetWidth - (style.UIMarginLeft * 2), //MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      child: TextField(
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: codeTextController,
                        keyboardType: TextInputType.none,
                        cursorColor: Colors.white,
                        maxLength: 22,
                        style: Theme.of(context).textTheme.labelLarge,
                        onEditingComplete: () {

                        },
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          prefix: Text('    '),
                          hintText: '코드 입력', // (${DateFormat('yyyy MM dd').format(DateTime.now())})',
                          hintStyle: Theme.of(context).textTheme.labelSmall,),
                        onChanged: (text) {
                          setState(() {
                            codeTextController.text;
                          });
                        },
                      ),
                      ),
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 130),
                      firstChild: SizedBox(width:34, height:20,),
                      secondChild:  Container(
                        width:34,
                        height:20,
                        child: IconButton(
                          icon: Icon(Icons.cancel, color: style.colorGrey, size: 20,),
                          style: ElevatedButton.styleFrom(visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, overlayColor: Colors.transparent),
                          onPressed: (){
                            setState(() {
                              codeTextController.text = '';
                            });
                          },
                        ),
                      ),
                      crossFadeState: codeTextController.text.length == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstCurve: Curves.easeIn,
                      secondCurve: Curves.easeIn,
                    ),
                    Container(  //붙여넣기 버튼
                      width: 40,
                      height: style.appBarHeight,
                      margin: EdgeInsets.only(left: 00),
                      child: ElevatedButton(
                        onPressed: (){
                          setState(() {
                            PasteSettingCodeFromClipboard();
                          });
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Icon(Icons.paste, size: 20, color:Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: 18),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      //splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
                    ),
                    child: Text(
                      '코드 적용',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        ApplyCode();
                      });
                    }),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 200,
                margin: EdgeInsets.only(top: 18),
                child: Text("· 인적사항 숨김은 적용되지 않습니다\n· 화면 꺼짐 방지는 적용되지 않습니다", style: style.settingInfoText0,),
              ),
            ],
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

