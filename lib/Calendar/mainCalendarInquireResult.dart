import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:univ_calendar_pc/main.dart';
import '../style.dart' as style;
import '../findGanji.dart' as findGanji;
import '../SaveData/saveDataManager.dart' as saveDataManager;
//import '../CalendarResult/calendarResultAppBarWidget.dart' as calendarResultAppBarWidget;  //앱바
//import '../CalendarResult/calendarResultBirthTextWidget2.dart' as calendarResultBirthTextWidget2;  //이름과 생년월일
import '../CalendarResult/calendarResultPaljaWidget.dart' as calendarResultPaljaWidget;  //팔자
import '../CalendarResult/InquireSinsals/yugchinWidget.dart' as yugchinWidget;  //육친
import '../CalendarResult/InquireSinsals/sibiunseong.dart' as sibiunseong; //12운성
import '../CalendarResult/InquireSinsals/habChungHyeongPaWidget.dart' as habChungHyeongPa; //합충형파
import '../CalendarResult/InquireSinsals/jijanggan.dart' as jijanggan; //지장간
import '../CalendarResult/InquireSinsals/gongmang.dart' as gongmang; //공망
import '../CalendarResult/InquireSinsals/MinorSinsals/sibiSinsal.dart' as sibiSinsal; //12신살
import '../CalendarResult/calendarDeunSeun.dart' as deunSeun;  //대운
import '../CalendarResult/calendarOptionDrawer.dart' as calendarOptionDrawer; //옵션창
import '../Settings/personalDataManager.dart' as personalDataManager;  //개인설정
import 'package:provider/provider.dart';

class MainCalendarInquireResult extends StatefulWidget {
  const MainCalendarInquireResult({super.key, required this.name, required this.gender, required this.uemYang, required this.birthYear, required this.birthMonth, required this.birthDay, required this.birthHour, required this.birthMin,
    required this.memo, required this.saveDate, required this.widgetWidth, required this.isEditSetting, required this.isShowChooseDayButtons, required this.setWidgetCalendarResultBirthTextFromChooseDayMode, required this.setUemYangBirthType});

  final String name;
  final bool gender;
  final int uemYang; //0: 양력, 1:음력 평달, 2:음력 윤달
  final int birthYear, birthMonth, birthDay, birthHour, birthMin;
  final String memo;
  final DateTime saveDate;
  final double widgetWidth;
  final bool isEditSetting;
  final bool isShowChooseDayButtons;
  final setWidgetCalendarResultBirthTextFromChooseDayMode;
  final setUemYangBirthType;

  @override
  State<MainCalendarInquireResult> createState() => _MainCalendarInquireResultState();
}

class _MainCalendarInquireResultState extends State<MainCalendarInquireResult> {
  List<int> listPaljaData = [];

  bool containerColorSwitch = true;

  List<Color> listContainerColor = [style.colorBoxGray0, style.colorBoxGray1];  //[밝은, 어두운]
  int containerColorNum = 1;

  List<Widget> listSajuTitle = [];

  int yearGongmangNum = 0;
  int dayGongmangNum = 0;
  List<int> listRocGongmangNum = [];
  List<int> listBirth = [];
  late DateTime saveDate;

  bool showMemo = false;
  String prefixMemo = '', editingMemo = '';
  TextEditingController memoController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int lastWidgetNum = 0, lastDeunSeunWidgetNum = 0;

  int isShowDrawerHabChung = 0, isShowDrawerYugchin = 0, isShowDrawerJijanggan = 0, isShowDrawerSibiunseong = 0, isShowDrawerGongmang = 0, isShowDrawerSinsal = 0;
  int isShowDrawerDeunSeunYugchin = 0, isShowDrawerDeunSeunSibiunseong = 0, isShowDrawerDeunSeunSibisinsal = 0, isShowDrawerDeunSeunGongmang = 0, isShowDrawerDeunSeunOld = 0;
  int deunContainerColorNum = 1, seunContainerColorNum = 1;
  int isShowDrawerManOld = 0, isShowDrawerUemyang = 0, isShowDrawerKoreanGanji = 0;

  late FocusNode memoFocusNode;

  bool isOneWidget = false;
  double widgetWidth = 0;

  bool isEditSetting = false;
  //bool isShowChooseDayButton = false;

  int calendarData = 0, sinsalData = 0, deunSeunData = 0, etcData = 0;

  ShowDialogMessage(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      //barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

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

  SetPersonPaljaData(int personNum, bool isDeun, List<int> listGanji, {int AddDeunCheongan = 0, int AddDeunJiji = 0}){
    if(widget.isShowChooseDayButtons == true){
      ShowSnackBar('택일 모드 중에는 간지가 추가되지 않습니다');
      return;
    }
    setState(() {
        if(isDeun == true){ //대운을 눌렀을 때
          if(listPaljaData.length > 8 && listGanji[0] == listPaljaData[8]) {
            //if (listGanji[0] == -2) { //간지 번호가 -2면 삭제 신호
              while (listPaljaData.length > 8) {
                listPaljaData.removeLast();
              }
        } else {  //아니면 추가
            while(listPaljaData.length > 10){  //세운을 지운다
              listPaljaData.removeLast();
            }
            if(listPaljaData.length == 8){ //간지 8개면 대운 2개 추가
              listPaljaData.add(listGanji[0]);
              listPaljaData.add(listGanji[1]);
            } else {  //이미 대운이 있으면 추가하지 않고 교체
              listPaljaData[8] = listGanji[0];
              listPaljaData[9] = listGanji[1];
            }
          }
        } else {  //세운을 눌렀을 때
          if(listPaljaData.length > 10 && listGanji[0] == listPaljaData[10]) {
          //if(listGanji[0] == -2){ //간지 번호가 -2면 삭제 신호
            while(listPaljaData.length > 10){
              listPaljaData.removeLast();
            }
          }
          else {  //아니면 추가
            if(listPaljaData.length == 8){  //간지 8개면 대운 2개 추가
              listPaljaData.add(AddDeunCheongan);
              listPaljaData.add(AddDeunJiji);
            }
            if(listPaljaData.length == 10){ //간지 10개면 세운 2개 추가
              listPaljaData.add(listGanji[0]);
              listPaljaData.add(listGanji[1]);
            } else {  //이미 세운이 있으면 추가하지 않고 교체
              listPaljaData[10] = listGanji[0];
              listPaljaData[11] = listGanji[1];
            }
          }
        }
    });
  }

  Widget GetSajuTitle(){

    if(listSajuTitle.length == 0){
      listSajuTitle.add(Text('연주', style: Theme.of(context).textTheme.titleSmall));
      listSajuTitle.add(Text('월주', style: Theme.of(context).textTheme.titleSmall));
      listSajuTitle.add(Text('일주', style: Theme.of(context).textTheme.titleSmall));
      listSajuTitle.add(Text('시주', style: Theme.of(context).textTheme.titleSmall));
    }
    while((listPaljaData.length / 2).floor() < listSajuTitle.length){
      listSajuTitle.removeLast();
    }

    if(listPaljaData.length > 8 && listSajuTitle.length < 5){
      listSajuTitle.add(Text('대운', style: Theme.of(context).textTheme.titleSmall));
    }
    if(listPaljaData.length > 10 && listSajuTitle.length < 6){
      listSajuTitle.add(Text('세운', style: Theme.of(context).textTheme.titleSmall));
    }

    return Container(
      width:  (widgetWidth - (style.UIMarginLeft * 2)),
      height: style.UIBoxLineHeight,
      //margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: style.colorMainBlue,
          boxShadow: [
            BoxShadow(
              color: style.colorMainBlue,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl,
        children: listSajuTitle,
      ),
    );
  }

  SetGongmangNum(int year, int day, List<int> listRoc){
      yearGongmangNum = year;
      dayGongmangNum = day;
      listRocGongmangNum.clear();
      if(listRoc.isNotEmpty){
        listRocGongmangNum = listRoc;
      }
  }

  ShowMemo(){
    setState(() {
      if(showMemo == false){  // 메모 시작
        showMemo = true;
        editingMemo = prefixMemo;
        memoController.text = editingMemo;
      }
      else{ //메모 저장
        showMemo = false;
        saveDataManager.SavePersonDataMemo2(widget.name, widget.gender, widget.uemYang, listBirth[0], listBirth[1], listBirth[2], listBirth[3], listBirth[4], saveDate, editingMemo);
        prefixMemo = editingMemo;
        editingMemo = '';
      }
    });
  }

  FindLastWidgetNum(){
    //모서리를 둥글게 만들 마지막 위젯의 번호를 찾는다
  //0번부터 순서대로
    //0 calendarResultPaljaWidget.CalendarResultPaljaWidget(containerColor: listContainerColor[1], listPaljaData: listPaljaData0), //팔자 오행
    //1 GetYugchinWidget(false, listPaljaData0),  //육친
    //2 GetJijangganWidget(listPaljaData0), //지장간
    //3 Get12UnseongWidget(listPaljaData0), //십이운성
    //4 GetHabChungHyeongPaWidget(false, listPaljaData0), //합충형파
    //5 GetGongmangWidget(listPaljaData0),  //공망
    //6 Get12SinsalWidget(listPaljaData0, true),  //십이신살

    if(isShowDrawerSinsal != 0){ //십이신살
      lastWidgetNum = 6;
    } else if(isShowDrawerGongmang != 0){  //공망
      lastWidgetNum = 5;
    } else if(isShowDrawerHabChung != 0){  //합충형파
      lastWidgetNum = 4;
    } else if(isShowDrawerSibiunseong != 0){  //십이운성
      lastWidgetNum = 3;
    } else if(isShowDrawerJijanggan != 0){  //지장간
      lastWidgetNum = 2;
    } else if(isShowDrawerYugchin != 0){  //육친
      lastWidgetNum = 1;
    } else {
      lastWidgetNum = 0;
    }
  }

  FindLastDeunSeunWidgetNum(){
    //모서리를 둥글게 만들 마지막 위젯의 번호를 찾는다
    //0번부터 순서대로
    //0 본체 //팔자 오행
    //1 육친
    //2 십이운성
    //3 공망
    //4 십이신살

    if(isShowDrawerDeunSeunSibisinsal != 0){ //십이신살
      lastDeunSeunWidgetNum = 4;
    } else if(isShowDrawerDeunSeunGongmang != 0){  //공망
      lastDeunSeunWidgetNum = 3;
    } else if(isShowDrawerDeunSeunSibiunseong != 0){  //십이운성
      lastDeunSeunWidgetNum = 2;
    } else if(isShowDrawerDeunSeunYugchin != 0){  //육친
      lastDeunSeunWidgetNum = 1;
    } else {
      lastDeunSeunWidgetNum = 0;
    }
  }

  Widget GetHabChungHyeongPaWidget(bool isCheongan, List<int> listPalja){
    if(isCheongan == true){
      if((calendarData % 10 != 9 && isShowDrawerHabChung == 1) || isShowDrawerHabChung == 2) {
        int cheonganHabChungContainerColorNum;
        if(isShowDrawerYugchin == 1){
          cheonganHabChungContainerColorNum = 1;  //어두운
        } else {
          cheonganHabChungContainerColorNum = 0;  } //밝은
        return habChungHyeongPa.HabChungHyeongPa().GetHabChungHyeongPaCheongan(context, listContainerColor[cheonganHabChungContainerColorNum], listPalja, isShowDrawerHabChung == 2? true:false, widgetWidth);
      }
      else{
        return SizedBox.shrink();
      }
    }
    else{
      if((((calendarData % 10000000000) / 10).floor() != 111119111  && isShowDrawerHabChung == 1) || isShowDrawerHabChung == 2) {
        containerColorNum = (containerColorNum + 1) % 2;
        return habChungHyeongPa.HabChungHyeongPa().GetHabChungHyeongPaJiji(context, listContainerColor[containerColorNum], listPalja, isShowDrawerHabChung == 2? true:false, lastWidgetNum == 4?true:false, widgetWidth);
      }
      else{
        return SizedBox.shrink();
      }
    }
  }

  Widget GetYugchinWidget(bool isCheongan, List<int> listPalja){
    if(isShowDrawerYugchin == 1){ //((personalDataManager.calendarData % 10000000000000) / 1000000000000).floor() == 2 &&
      if(isCheongan == true){
        return yugchinWidget.YugchinWidget(containerColor: listContainerColor[0], listPaljaData: listPalja, stanIlganNum: listPalja[4], isManseryoc:true, isCheongan: true, isLastWidget: false, widgetWidth: widgetWidth);
      } else {
        containerColorNum = (containerColorNum + 1) % 2;
        return yugchinWidget.YugchinWidget(containerColor: listContainerColor[containerColorNum], listPaljaData: listPalja, stanIlganNum: listPalja[4], isManseryoc:true, isCheongan: false, isLastWidget: lastWidgetNum == 1?true:false, widgetWidth: widgetWidth);
      }
    }
    else{
      return SizedBox.shrink();
    }
  }

  Widget Get12UnseongWidget(List<int> listPalja){
    if(isShowDrawerSibiunseong == 1){//((personalDataManager.calendarData % 1000000000000) / 100000000000).floor() == 2){
      containerColorNum = (containerColorNum + 1) % 2;
      return sibiunseong.Sibiunseong().Get12Unseong(context, listContainerColor[containerColorNum], listPalja, listPaljaData[4], lastWidgetNum == 3?true:false, widgetWidth);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget GetJijangganWidget(List<int> listPalja){
    if((((calendarData / 10000000000).floor() % 10) != 9 && isShowDrawerJijanggan == 1) ||  isShowDrawerJijanggan == 2){
      containerColorNum = (containerColorNum + 1) % 2;
      return jijanggan.Jijanggan().GetJijanggan(context, listContainerColor[containerColorNum], listPalja, isShowDrawerJijanggan == 2? true:false, lastWidgetNum == 2?true:false, widgetWidth);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget GetGongmangWidget(List<int> listPalja, int personNum){
    if((sinsalData % 10 != 1 && isShowDrawerGongmang == 1) || isShowDrawerGongmang == 2){
      containerColorNum = (containerColorNum + 1) % 2;
      return gongmang.Gongmang().GetGongmang(context, listContainerColor[containerColorNum], listPalja, yearGongmangNum, dayGongmangNum, listRocGongmangNum, isShowDrawerGongmang == 2? true:false,lastWidgetNum == 5?true:false, widgetWidth);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget Get12SinsalWidget(List<int> listPalja, bool person){
    if(((((sinsalData % 100) / 10).floor() == 2 || personalDataManager.etcSinsalData != personalDataManager.etcSinsalDataAllOff) && isShowDrawerSinsal == 1) || isShowDrawerSinsal == 2){
      containerColorNum = (containerColorNum + 1) % 2;
      if (person == true) { //명식 1
        return sibiSinsal.SibiSinsal().Get12Sinsal(context, listContainerColor[containerColorNum], listPalja, listPalja[1], true, isShowDrawerSinsal, lastWidgetNum == 6?true:false, widgetWidth);
      } else {
        return sibiSinsal.SibiSinsal().Get12Sinsal(context, listContainerColor[containerColorNum], listPalja, listPalja[1], true, isShowDrawerSinsal,  lastWidgetNum == 6?true:false, widgetWidth);
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget GetDeunSeunWidget(){

    return deunSeun.CalendarDeunSeun(
        gender0: widget.gender,
        birthYear0: listBirth[0],
        birthMonth0: listBirth[1],
        birthDay0: listBirth[2],
        birthHour0: listBirth[3],
        birthMin0: listBirth[4],
        listPaljaData0: listPaljaData,
        yearGongmangNum: yearGongmangNum,
        dayGongmangNum: dayGongmangNum,
        isShowDrawerDeunSeunYugchin: isShowDrawerDeunSeunYugchin,
        isShowDrawerDeunSeunSibiunseong: isShowDrawerDeunSeunSibiunseong,
        isShowDrawerDeunSeunSibisinsal: isShowDrawerDeunSeunSibisinsal,
        isShowDrawerDeunSeunGongmang: isShowDrawerDeunSeunGongmang,
        isShowDrawerDeunSeunOld: isShowDrawerDeunSeunOld,
        lastDeunSeunWidgetNum: lastDeunSeunWidgetNum,
        deunContainerColorNum: deunContainerColorNum,
        seunContainerColorNum: seunContainerColorNum,
        isShowDrawerManOld: isShowDrawerManOld,
        isShowDrawerKoreanGanji: isShowDrawerKoreanGanji,
        personNum: 0,
        setPersonPaljaData: SetPersonPaljaData,
        widgetWidth: widgetWidth,
        isOneWidget: isOneWidget);
  }

  Widget GetChooseDayWidget(){
    if(widget.isShowChooseDayButtons == true) {
        return Column(
          children: [
            Container(
              width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
              height: style.UIBoxLineHeight,
              //alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(0, true);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_up_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(1, true);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_up_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(2, true);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_up_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(3, true);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_up_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 146,
            ),
            Container(
              width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
              height: style.UIBoxLineHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(0, false);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_down_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(1, false);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_down_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(2, false);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_down_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        EditBirthData(3, false);
                      },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: listContainerColor[1], surfaceTintColor: Colors.transparent),
                      child: Icon(Icons.arrow_drop_down_sharp, color: style.colorMainBlue, size: 40),),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
      return SizedBox.shrink();
    }
  }

  SetChooseDayMode(){
    if(listPaljaData.length > 8) {
      while (listPaljaData.length > 8) {
        listPaljaData.removeLast();
      }
    }
  }

  Widget GetPaljaResult(){
    containerColorNum = 1;
    if(isOneWidget == false) {
      return Stack(
        alignment: Alignment.topCenter,
        children:[
          Container(
          height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 46,
          color: style.colorBackGround,
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //calendarResultBirthTextWidget2.CalendarResultBirthTextWidget2(name:widget.name, gender:widget.gender? '남' : '여', uemYang:widget.uemYang, birthYear:widget.birthYear, birthMonth:widget.birthMonth, birthDay:widget.birthDay,
                  //    birthHour:widget.birthHour, birthMin:widget.birthMin, isShowDrawerManOld:0, widgetWidth:widgetWidth,
                  //    isOneWidget:(widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false, isEditSetting:isEditSetting, setTargetName:null),
                  SizedBox(
                    height: 4
                  ),
                  GetSajuTitle(), //연주 월주 일주 시주
                  GetHabChungHyeongPaWidget(true, listPaljaData), //천간 합충형파
                  GetYugchinWidget(true, listPaljaData),
                  Stack(
                    children: [
                      calendarResultPaljaWidget.CalendarResultPaljaWidget(
                          containerColor: listContainerColor[1],
                          listPaljaData: listPaljaData,
                          isShowDrawerUemyangSign: isShowDrawerUemyang,
                          isShowDrawerKoreanGanji: isShowDrawerKoreanGanji,
                          isLastWidget: lastWidgetNum == 0 ? true : false,
                          widgetWidth: widgetWidth,
                        isShowChooseDayButtons: widget.isShowChooseDayButtons,
                      ), //팔자 오행
                      GetChooseDayWidget(), //택일 버튼
                    ],
                  ),
                  GetYugchinWidget(false, listPaljaData),
                  GetJijangganWidget(listPaljaData),
                  Get12UnseongWidget(listPaljaData),
                  GetHabChungHyeongPaWidget(false, listPaljaData),
                  GetGongmangWidget(listPaljaData, 0),
                  Get12SinsalWidget(listPaljaData, true),
                  SizedBox(width: 10, height: style.UIButtonPaddingTop * 0.5),
                  GetDeunSeunWidget(),
                ],
              ),
            ),
          ),
        ),
          Container(
            width: widgetWidth,
            height: 1,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: style.colorBackGround.withOpacity(0.9),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0,0),
                  )
                ]
            ),
          ),
        ]
      );
    }
    else {
      return Stack(
          alignment: Alignment.topCenter,
        children: [
          Container(
          height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 38,
          color: style.colorBackGround,
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 38,
                width: widgetWidth,
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 4
                        ),
                        GetSajuTitle(), //연주 월주 일주 시주
                        GetHabChungHyeongPaWidget(true, listPaljaData), //천간 합충형파
                        GetYugchinWidget(true, listPaljaData),
                        calendarResultPaljaWidget.CalendarResultPaljaWidget(
                            containerColor: listContainerColor[1],
                            listPaljaData: listPaljaData,
                            isShowDrawerUemyangSign: isShowDrawerUemyang,
                            isShowDrawerKoreanGanji: isShowDrawerKoreanGanji,
                            isLastWidget: lastWidgetNum == 0 ? true : false,
                            widgetWidth: widgetWidth,
                          isShowChooseDayButtons: widget.isShowChooseDayButtons,), //팔자 오행
                        GetYugchinWidget(false, listPaljaData),
                        GetJijangganWidget(listPaljaData),
                        Get12UnseongWidget(listPaljaData),
                        GetHabChungHyeongPaWidget(false, listPaljaData),
                        GetGongmangWidget(listPaljaData, 0),
                        Get12SinsalWidget(listPaljaData, true),
                        SizedBox(width: 10, height: style.UIButtonPaddingTop * 0.5),
                        //Expanded(child: SizedBox.shrink())
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: widgetWidth,
                height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50,
                //color:Colors.red,
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 4
                        ),
                        GetDeunSeunWidget(),
                      ]
                    )
                  )
                )
              ),
            ],
          ),
        ),
          Container(
            width: widgetWidth*2,
            height: 1,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: style.colorBackGround.withOpacity(0.9),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0,0),
                  )
                ]
            ),
          ),
        ]
      );
    }
  }

  Widget GetMemoScreen(){
    if(showMemo == false){
      return Container();
    }
    else{
      return AnimatedOpacity(
        opacity: showMemo? 1.0 : 0.0,
        duration: Duration(milliseconds: 130),
        child: Column(
          children: [
            Expanded(child: SizedBox.shrink()),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                width: widget.widgetWidth,
                height: (MediaQuery.of(context).size.height) * 0.5,
                color: Color(0xff111111).withOpacity(0.8),
                child: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:
                      Container( //메모 본문 수정
                        width: widget.widgetWidth,
                        height:600,
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
                          padding: EdgeInsets.only(top:style.UIMarginTop),
                          child: TextField(
                            autofocus: true,
                            controller: memoController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: Theme.of(context).textTheme.displayMedium,
                            focusNode: memoFocusNode,
                            onTapOutside: (event) {
                              memoFocusNode.requestFocus();
                            },
                            decoration:InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              counterText:"",
                              border: InputBorder.none,),
                            onChanged: (text){
                              setState(() {
                                editingMemo = text;
                              });
                            },
                          ),
                        ),
                      ),
                  ),
                ),
                ),
                Container(  //메모 저장 버튼
                  width: (widget.widgetWidth - (style.UIMarginLeft * 2)) * 0.1,
                  height: style.saveDataMemoLineHeight,
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        ShowMemo();
                      });
                    },
                    icon: Icon(Icons.check_circle_outline),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void OpenEndDrawer(){
    scaffoldKey.currentState!.openEndDrawer();
  }

  SetDrawerOption(int optionNum, int onOffNum){
    setState(() {
      if(optionNum < 6){
        switch(optionNum){
          case 0:{
            isShowDrawerHabChung = onOffNum;
          }
          case 1:{
            isShowDrawerYugchin = onOffNum;
          }
          case 2:{
            isShowDrawerJijanggan = onOffNum;
          }
          case 3:{
            isShowDrawerSibiunseong = onOffNum;
          }
          case 4:{
            isShowDrawerGongmang = onOffNum;
          }
          case 5:{
            isShowDrawerSinsal = onOffNum;
          }
        }
        FindLastWidgetNum();
      } else if(optionNum > 5 && optionNum < 11){
        switch(optionNum){
          case 6:{
            isShowDrawerDeunSeunYugchin = onOffNum;
          }
          case 7:{
            isShowDrawerDeunSeunSibiunseong = onOffNum;
          }
          case 8:{
            isShowDrawerDeunSeunSibisinsal = onOffNum;
          }
          case 9:{
            isShowDrawerDeunSeunGongmang = onOffNum;
          }
          case 10:{
            isShowDrawerDeunSeunOld = onOffNum;
          }
        }
        FindLastDeunSeunWidgetNum();
        deunContainerColorNum = 1;
        seunContainerColorNum = 1;
      } else {
        switch(optionNum){
          case 11:{
            isShowDrawerManOld = onOffNum;
          }
          case 12:{
            isShowDrawerUemyang = onOffNum;
          }
          case 13:{
            isShowDrawerKoreanGanji = onOffNum;
          }
        }
      }
    });
  }

  ReloadOptions(){
    setState(() {
      calendarData = personalDataManager.calendarData;
      sinsalData = personalDataManager.sinsalData;
      deunSeunData = personalDataManager.deunSeunData;
      etcData = personalDataManager.etcData;

      int optionDataNum = personalDataManager.calendarData % 10000000000;
      if(optionDataNum != 1111191119){
        isShowDrawerHabChung = 1; } else {isShowDrawerHabChung = 0;}

      optionDataNum = ((personalDataManager.calendarData % 10000000000000) / 1000000000000).floor();
      if(optionDataNum == 2){
        isShowDrawerYugchin = 1;
        } else {isShowDrawerYugchin = 0;
      }

      optionDataNum = ((personalDataManager.calendarData % 100000000000) / 10000000000).floor();
      if(optionDataNum != 9){
        isShowDrawerJijanggan = 1; } else {isShowDrawerJijanggan = 0;}

      optionDataNum = ((personalDataManager.calendarData % 1000000000000) / 100000000000).floor();
      if(optionDataNum == 2){
        isShowDrawerSibiunseong = 1; } else {isShowDrawerSibiunseong = 0;}

      optionDataNum = personalDataManager.sinsalData % 10;
      if(optionDataNum != 9){
        isShowDrawerGongmang = 1; } else {isShowDrawerGongmang = 0;}

      optionDataNum = ((personalDataManager.sinsalData % 100) / 10).floor();
      if(optionDataNum == 2 || personalDataManager.etcSinsalData != personalDataManager.etcSinsalDataAllOff){
        isShowDrawerSinsal = 1; } else {isShowDrawerSinsal = 0;}

      FindLastWidgetNum();

      //대운세운
      if(((personalDataManager.deunSeunData % 100) / 10).floor() == 2){
        isShowDrawerDeunSeunYugchin = 1;
      } else {isShowDrawerDeunSeunYugchin = 0;}
      if(((personalDataManager.deunSeunData % 1000) / 100).floor() == 2){
        isShowDrawerDeunSeunSibiunseong = 1;
      } else {isShowDrawerDeunSeunSibiunseong = 0;}
      if(((personalDataManager.deunSeunData % 10000) / 1000).floor() == 2){
        isShowDrawerDeunSeunSibisinsal = 1;
      } else {isShowDrawerDeunSeunSibisinsal = 0;}
      if(((personalDataManager.deunSeunData % 100000) / 10000).floor() != 9){
        isShowDrawerDeunSeunGongmang = 1;
      } else {isShowDrawerDeunSeunGongmang = 0;}
      if(((personalDataManager.deunSeunData % 1000000) / 100000).floor() == 2){ //세운에 나이 보기 활성화 되어있으면
        isShowDrawerDeunSeunOld = 1;
      } else {isShowDrawerDeunSeunOld = 0;}
      if(((personalDataManager.etcData % 10000) / 1000).floor() != 1) { //인적사항 숨김에 나이 표시되어있으면
        int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
        if (isShowPersonalDataNum == 2 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7) {
          isShowDrawerDeunSeunOld = 0;
        }
      }

      FindLastDeunSeunWidgetNum();

      if(personalDataManager.etcData % 10 == 2){
        isShowDrawerManOld = 1;
      } else {isShowDrawerManOld = 0;}
      if(((personalDataManager.etcData % 100) / 10).floor() == 2){
        isShowDrawerUemyang = 1;
      } else {
        isShowDrawerUemyang = 0;
      }
      if(((personalDataManager.etcData % 1000) / 100).floor() == 2){
        isShowDrawerKoreanGanji = 1;
      } else {isShowDrawerKoreanGanji = 0;}
    });
  }

  //택일모드 기능
  EditBirthData(int editMode, bool isUp){ //mode 0:시간, 1:일, 2:월, 3:연
    if(widget.uemYang != 0){
      ShowDialogMessage('명식이 양력으로 변경됩니다');
      //widget.setUemYangBirthType();
    }
    switch(editMode){
      case 0:{  //시간
        if(isUp == true){ //올리기
          if(listBirth[0] == 2050 && listBirth[1] == 12 && listBirth[2] == 6 && listPaljaData[7] == 11){
            ShowDialogMessage('2050년 12월 6일 이후는 조회할 수 없습니다');
            return;
          }
          if(listBirth[3] == 30){
            listBirth[3] = 12;
            listBirth[4] = 30;
          } else {
              listBirth[3] = ((listPaljaData[7] + 1) * 2);
              listBirth[4] = 30;
              if (listBirth[3] > 23) {
                listBirth[3] = listBirth[3] % 24;
                EditBirthData(1, true);
              }
            }
          } else {
          if(listBirth[0] == 1902 && listBirth[1] == 1 && listBirth[2] == 1 && listPaljaData[7] == 0 ){
            ShowDialogMessage('1902년 1월 1일 이전은 조회할 수 없습니다');
            return;
          }
          if(listBirth[3] == 30){
            listBirth[3] = 12;
            listBirth[4] = 30;
          } else {
              listBirth[3] = ((listPaljaData[7] - 1) * 2);
              listBirth[4] = 30;
              if (listBirth[3] < 0) {
                listBirth[3] = 22;
                EditBirthData(1, false);
              }
            }
          }
      }
      case 1:{  //일
        if(isUp == true){
          if(listBirth[0] == 2050 && listBirth[1] == 12 && listBirth[2] == 6){
            ShowDialogMessage('2050년 12월 6일 이후는 조회할 수 없습니다');
            return;
          }
          listBirth[2] = listBirth[2] + 1;

          if(listBirth[1] == 2 && (listBirth[0] % 4 == 0)) { //2월 윤달일 때
            if(listBirth[2] > 29){
              listBirth[2] = 1;
              EditBirthData(2, true);
            }
          } else {
            if (listBirth[2] > findGanji.listSolNday[listBirth[1] - 1]) {
              listBirth[2] = 1;
              EditBirthData(2, true);
            }
          }
        } else {
          if(listBirth[0] == 1902 && listBirth[1] == 1 && listBirth[2] == 1){
            ShowDialogMessage('1902년 1월 1일 이전은 조회할 수 없습니다');
            return;
          }
          listBirth[2] = listBirth[2] - 1;

          if(listBirth[2] == 0){
            listBirth[2] = findGanji.listSolNday[(listBirth[1] + 10) % findGanji.listSolNday.length];
            if(listBirth[1] == 3 && (listBirth[0] % 4 == 0)){
              listBirth[2]++;
            }
            EditBirthData(2, false);
          }
        }
      }
      case 2:{  //월
        if(isUp == true){
          if(listBirth[0] == 2050 && listBirth[1] == 12){
            ShowDialogMessage('2050년 12월 이후는 조회할 수 없습니다');
            return;
          }
          listBirth[1] = listBirth[1] + 1;
          if(listBirth[1] > 12){
            listBirth[1] = 1;
            EditBirthData(3, true);
          }
          if (listBirth[2] > findGanji.listSolNday[listBirth[1] - 1]) {
            listBirth[2] = findGanji.listSolNday[listBirth[1] - 1];
          }
        } else {
          if(listBirth[0] == 1902 && listBirth[1] == 1){
            ShowDialogMessage('1902년 1월 이전은 조회할 수 없습니다');
            return;
          }
          listBirth[1] = listBirth[1] - 1;
          if(listBirth[1] == 0){
            listBirth[1] = 12;
            EditBirthData(3, false);
          }
        }
      }
      case 3:{  //연
        if(isUp == true) {
          if (listBirth[0] == 2050) {
            ShowDialogMessage('2050년 이후는 조회할 수 없습니다');
            return;
          }
          listBirth[0] = listBirth[0] + 1;
        }
        else {
          if (listBirth[0] == 1902) {
            ShowDialogMessage('1902년 이전은 조회할 수 없습니다');
            return;
          }
          listBirth[0] = listBirth[0] - 1;
        }
        if (listBirth[1] == 2 && (listBirth[0] % 4 == 0) && listBirth[2] == 29) {
          listBirth[2] = 28;
        }
      }
    }

    setState(() {
      listPaljaData = findGanji.InquireGanji(listBirth[0], listBirth[1], listBirth[2], listBirth[3], listBirth[4]);
    });

    widget.setWidgetCalendarResultBirthTextFromChooseDayMode(listBirth[0], listBirth[1], listBirth[2], listBirth[3], listBirth[4]);
  }

  @override
  void initState() {
    super.initState();

    if(widget.birthYear > 1900){ //1900년 이후 출생은 findGanji로 팔자를 뽑는다
      if(widget.uemYang == 0){ //양력
        listBirth = [widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin];
        listPaljaData = findGanji.InquireGanji(widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin);
      }
      else{
        if(widget.uemYang == 1){
          listBirth = findGanji.LunarToSolar(widget.birthYear, widget.birthMonth, widget.birthDay, false);
          listBirth.add(widget.birthHour);
          listBirth.add(widget.birthMin);
          listPaljaData = findGanji.InquireGanji(listBirth[0], listBirth[1], listBirth[2], widget.birthHour, widget.birthMin);
        }
        else{
          listBirth = findGanji.LunarToSolar(widget.birthYear, widget.birthMonth, widget.birthDay, true);
          listBirth.add(widget.birthHour);
          listBirth.add(widget.birthMin);
          listPaljaData = findGanji.InquireGanji(listBirth[0], listBirth[1], listBirth[2], widget.birthHour, widget.birthMin);
        }
      }
    }
    else{

    }

    saveDate = widget.saveDate;
    saveDataManager.SaveRecentPersonData2(widget.name, widget.gender, widget.uemYang, widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin);
    gongmang.Gongmang().FindGongmangNum(listPaljaData, 0, SetGongmangNum); //공망 찾기

    calendarData = personalDataManager.calendarData;
    sinsalData = personalDataManager.sinsalData;
    deunSeunData = personalDataManager.deunSeunData;
    etcData = personalDataManager.etcData;

    int optionDataNum = personalDataManager.calendarData % 10000000000;
    if(optionDataNum != 1111191119){
      isShowDrawerHabChung = 1; }

    optionDataNum = ((personalDataManager.calendarData % 10000000000000) / 1000000000000).floor();
    if(optionDataNum == 2){
      isShowDrawerYugchin = 1; }

    optionDataNum = ((personalDataManager.calendarData % 100000000000) / 10000000000).floor();
    if(optionDataNum != 9){
      isShowDrawerJijanggan = 1; }

    optionDataNum = ((personalDataManager.calendarData % 1000000000000) / 100000000000).floor();
    if(optionDataNum == 2){
      isShowDrawerSibiunseong = 1; }

    optionDataNum = personalDataManager.sinsalData % 10;
    if(optionDataNum != 9){
      isShowDrawerGongmang = 1; }

    optionDataNum = ((personalDataManager.sinsalData % 100) / 10).floor();
    if(optionDataNum == 2 || personalDataManager.etcSinsalData != personalDataManager.etcSinsalDataAllOff){
      isShowDrawerSinsal = 1; }

    prefixMemo = widget.memo;

    FindLastWidgetNum();

    //대운세운
    if(((personalDataManager.deunSeunData % 100) / 10).floor() == 2){
      isShowDrawerDeunSeunYugchin = 1;
    }
    if(((personalDataManager.deunSeunData % 1000) / 100).floor() == 2){
      isShowDrawerDeunSeunSibiunseong = 1;
    }
    if(((personalDataManager.deunSeunData % 10000) / 1000).floor() == 2){
      isShowDrawerDeunSeunSibisinsal = 1;
    }
    if(((personalDataManager.deunSeunData % 100000) / 10000).floor() != 9){
      isShowDrawerDeunSeunGongmang = 1;
    }
    if(((personalDataManager.deunSeunData % 1000000) / 100000).floor() == 2){ //세운에 나이 보기 활성화 되어있으면
      isShowDrawerDeunSeunOld = 1;
    }
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1) { //인적사항 숨김에 나이 표시되어있으면
      int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
      if (isShowPersonalDataNum == 2 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7) {
        isShowDrawerDeunSeunOld = 0;
      }
    }

    FindLastDeunSeunWidgetNum();

    if(personalDataManager.etcData % 10 == 2){
      isShowDrawerManOld = 1;
    }
    if(((personalDataManager.etcData % 100) / 10).floor() == 2){
      isShowDrawerUemyang = 1;
    }
    if(((personalDataManager.etcData % 1000) / 100).floor() == 2){
      isShowDrawerKoreanGanji = 1;
    }

    memoFocusNode = FocusNode();
    isEditSetting = widget.isEditSetting;
    //isShowChooseDayButton = widget.isShowChooseDayButtons;
  }

  @override
  void deactivate(){
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.widgetWidth > 500){//MediaQuery.of(context).size.width * 0.6){
      isOneWidget = true;
      widgetWidth = widget.widgetWidth * 0.5;
      } else {
      isOneWidget = false;
      widgetWidth = widget.widgetWidth;
    }

    //if(isEditSetting != widget.isEditSetting){
    //  ReloadOptions();
    //  isEditSetting = widget.isEditSetting;
    //}
    if(isEditSetting != context.watch<Store>().isEditSetting){
      ReloadOptions();
      isEditSetting = context.watch<Store>().isEditSetting;
    }

    if(widget.isShowChooseDayButtons == true){
      SetChooseDayMode();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
          //alignment: Alignment.topCenter,
            children: [
          GetPaljaResult(),
          GetMemoScreen(),
        ]);
  }
}

//마우스로 스크롤
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };

}