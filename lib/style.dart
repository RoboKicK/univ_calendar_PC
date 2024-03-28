import 'package:flutter/material.dart';

var theme = ThemeData(
  fontFamily: 'NotoSansKR',
  splashColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
  highlightColor: Colors.transparent,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateColor.resolveWith(
          (states) {
        if (states.contains(MaterialState.selected)) {
          return colorMainBlue; // the color when checkbox is selected;
        }
        return Colors.white; //the color when checkbox is unselected;
      },
    ),
    fillColor: MaterialStateColor.resolveWith(
          (states) { if (states.contains(MaterialState.selected)) {
        return Colors.white; // the color when checkbox is selected;
      }
      return Colors.transparent;
      },
    ),
    side: BorderSide(color: Colors.white),
  ),
  iconTheme: IconThemeData(color : Color.fromARGB(255, 255, 255, 255)), //아이콘 색
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent.withOpacity(0.0)), shadowColor: MaterialStateProperty.all(Colors.transparent)),
  ),
  buttonTheme: ButtonThemeData(
    hoverColor: Colors.transparent,

  ),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colorBlack),
    contentTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorBlack),
    alignment: Alignment.center,
  ),
  appBarTheme: AppBarTheme(
      color : Color.fromARGB(255, 21, 21, 21),//Colors.black,//
      shadowColor: Color.fromARGB(255, 21, 21, 21),//Colors.black,//
      surfaceTintColor: Color.fromARGB(255, 21, 21, 21),
      actionsIconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      titleTextStyle: TextStyle(
        color : Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ) //앱바 텍스트 두께
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color : Colors.white, fontSize: 26, fontWeight: FontWeight.w500),  //사주창 이름 나이,
    headlineMedium: TextStyle(color : Colors.white, fontSize: 20, fontWeight: FontWeight.w500), //사주창 성별
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),//헤드라인, 풀사이즈 버튼
    labelSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colorGrey), //입력창 힌트텍스트,
    labelMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white), //사주창 양력,
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), //입력창 입력텍스트, 사주창 생년월일, 저장목록 이름, 저장목록 생년월일시간
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),  //사주 타이틀 - 연주 월주 일주 시주, 저장목록 성별, 저장목록 음양
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), //저장목록 이름
    bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white), //팔자 오행
    bodyMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colorBlack), //팔자 오행 금
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff111111), height: 1.54), //팔자 오행 금,  신살
    displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorBlack), //다이알로그 메세지
    displayMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorGrey), //메모 내용, 안내문
    displayLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorBlack), //메모 내용 편집 중

  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 21, 21, 21), //Colors.black,//어플 배경색
);
TextStyle settingText0 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white);  //설정 기본 텍스트
TextStyle settingInfoText0 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorGrey);  //설정 설명 텍스트
TextStyle settingButtonTextStyle0 = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colorGrey);//헤드라인, 풀사이즈 버튼

double marginContainerWidth = 30;
double UIButtonWidth = 340;

double headLineHeight = 40; //헤드라인 총 높이

double textFiledRadius = 14;//6;  //모든 창의 둥근 정도값
double deunSeunGanjiRadius = 8;//대운간지 둥근값
double fullSizeButtonHeight = 48;  //가로 풀사이즈 버튼 높이
double saveDataButtonHeight = 68;
double saveDataNameLineHeight = 30;  //저장목록 이름 줄 높이
double saveDataNameTextLineHeight = 20;  //저장목록 이름 텍스트 줄 높이
double saveDataMemoLineHeight = 34;  //저장목록 메모 줄 높이
double resultDrawerInfoLineHeight = 28;  //팔자 서랍옵션 설명 줄 높이

double iconSize = 16; //모든 아이콘 사이즈

double UIMarginLeft = 14;
double UIMarginTop = 13;
double UIMarginTopTop = 30;
double UIPaddingBottom = 1.0;

double UIButtonPaddingTop = UIMarginTop * 2 - UIMarginTop * 0.3;
double UIButtonPaddingBetween = UIButtonPaddingTop * 0.583;

double UIBoxLineHeight = 30; //사주창 한줄 라인
double UIBoxLineAddHeight = 18; //사주창 줄 더할 때마다
double UIPaljaBoxHeight = 130; //팔자 박스 높이
double UIPaljaDeunBoxHeight = 40;  //팔자 대운 박스 높이
double UIOhengMarginTop = 7.2;
double UIOhengFontSize = 24; //팔자 텍스트 사이즈
double UIOhengDeunFontSize = 16;  //대운 팔자 텍스트 사이즈
double UIOhengDiaryListSize = 20;
FontWeight UIOhengFontWeight = FontWeight.w800;  //팔자 텍스트 두께
FontWeight UIOhengDeunFontWeight = FontWeight.w600;  //팔자 텍스트 두께
//double UIOhengBoxPadding0 = 6; //간지변환 팔자 버튼 텍스트 패딩
//double UIOhengBoxPadding1 = 4; //팔자 텍스트 패딩
double UIOhengBoxPadding2 = 2; //대운 간지 텍스트 패딩

double SettingDisWithRadioButton = 20;
double SettingMarginTop = 30;
double SettingMarginTopWithInfo = 10;
double SettingMarginTopWithInfo1 = 6;

int snackBarDuration = 1000;

var colorMainBlue = Color(0xff1E9EFF);
var colorGrey = Color(0xffB4B4B4);
var colorDarkGrey = Color(0xff767676);
var colorBackGround = Color.fromARGB(255, 21, 21, 21);
var colorNavy = Color(0xff2B2941);
var colorRed = Color(0xffff4500);
var colorGreen = Color(0xff32cd32);
var colorYellow = Color(0xffffb020);
var colorBlack = Color(0xff373737);
var colorRealBlack = Color(0xff111111);

var colorBoxGray0 = Color(0xfff0f0f0); //밝음
var colorBoxGray1 = Color(0xffe1e1e1); //어두움

ButtonStyle uiButtonStyle = ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent));
BoxShadow uiOhengShadow = BoxShadow(color: Color(0xff111111).withOpacity(0.25), spreadRadius: 1, blurRadius: 2 );//BoxShadow(color: Colors.white.withOpacity(0.35), spreadRadius: 2, blurRadius: 4 );//
BoxShadow uiDeunSeunShadow = BoxShadow(color: Color(0xff111111).withOpacity(0.20), spreadRadius: 1, blurRadius: 1 );//BoxShadow(color: Colors.white.withOpacity(0.35), spreadRadius: 1, blurRadius: 2 );//
//BoxShadow uiWidgetOhengShadow = BoxShadow(color: Colors.grey.withOpacity(0.35), spreadRadius: 1, blurRadius: 6 );

List<List<String>> stringCheongan = [['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],['갑','을','병','정','무','기','경','신','임','계']];
List<List<String>> stringJiji = [['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'],['자','축','인','묘','진','사','오','미','신','유','술','해']];
String unknownTimeText = '-';
String emptySinsalText = 'ㅡ';

int uemYangStringTypeNum = 0;

Color SetOhengColor(bool isCheongan, int num){  //오행 박스 컬러
  if(isCheongan == true){
    if(num < 2 && num != -2){
      return colorGreen;}
    else if(num >= 2 && num < 4){
      return colorRed;}
    else if(num >= 4 && num < 6){
      return colorYellow;}
    else if((num >= 6 && num < 8) || num == -2){
      return Colors.white;}
    else if(num >= 8){
      return colorBlack;}
  }
  else{
    if(num == 0 || num == 11){
      return colorBlack;}
    else if(num == 1 || num == 4 || num == 7 || num == 10){
      return colorYellow;}
    else if(num >= 2 && num < 4){
      return colorGreen;}
    else if(num >= 5 && num < 7){
      return colorRed;}
    else if((num >= 8 && num < 10) || num == -2){
      return Colors.white;}
  }

  return Colors.white;
}

double appBarHeight = 50;