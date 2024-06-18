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
    String code0 = '', code1 = '';
    if(personalDataManager.mapWordData['ilGan'] == 0){
      code0 = '3' + personalDataManager.mapWordData['yugChin'].toString() + personalDataManager.mapWordData['wonJin'].toString() + personalDataManager.mapWordData['geukChung'].toString() + personalDataManager.mapWordData['hab'].toString();
    }
    else {
      code0 = personalDataManager.mapWordData['ilGan'].toString() + personalDataManager.mapWordData['yugChin'].toString() + personalDataManager.mapWordData['wonJin'].toString() + personalDataManager.mapWordData['geukChung'].toString() + personalDataManager.mapWordData['hab'].toString();
    }
    code0 = code0 + personalDataManager.calendarData.toString();
    code1 = personalDataManager.deunSeunData.toString() + personalDataManager.sinsalData.toString() + personalDataManager.etcSinsalData.toString();

    code0 = (int.parse(code0).toRadixString(36)).toString().toUpperCase();
    code1 = (int.parse(code1).toRadixString(36)).toString().toUpperCase();

    setState(() {
      settingCodeString = code0 + code1;
    });
  }

  CopySettingCode(){
    Clipboard.setData(ClipboardData(text: settingCodeString));
    ShowSnackBar('클립보드에 코드가 복사되었습니다');
  }

  PasteSettingCodeFromClipboard() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

    setState(() {
      codeTextController.text = cdata?.text ?? '';
    });
  }

  ApplyCode(){

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
                margin: EdgeInsets.only(top: 22),
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
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(  //텍스트 필드
                    width: widgetWidth - (style.UIMarginLeft * 2), //MediaQuery.of(context).size.width * 0.4,
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

                        });
                      },
                    ),
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

                      });
                    }),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 258,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color:style.colorDarkGrey),
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                margin: EdgeInsets.only(top: 18),
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

