import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'personalDataManager.dart' as personalDataManager;

class DataManageWidget extends StatefulWidget {
  const DataManageWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting});

  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;

  @override
  State<DataManageWidget> createState() => _DataManageWidgetState();
}

//저장 목록 관리
class _DataManageWidgetState extends State<DataManageWidget> {
  int isShowCheongan = 0; //0:안보여줌, 1:보여줌
  bool isShowCheonganHab = false, isShowCheonganChung = false, isShowCheonganGeuc = false;
  double cheonganHabChungContainerHeight = 0;
  Image cheonganHabChungButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment cheonganHabAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowBanguiHabNum = 0; //0:안보여줌, 1:왕지가 있어야 보여줌, 2: 왕지가 없어도 보여줌
  List<String> listBanguiHabInfoString = ['방합을 표시하지 않습니다', '방합의 왕지가 있어야 표시합니다', '방합의 왕지가 비어있어도 표시합니다'];
  Image banguiHabButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment banguiHabAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowSamHabNum = 0;
  List<String> listSamHabInfoString = [ '삼합 또는 계절합을 표시하지 않습니다', '삼합 또는 계절합의 왕지가 있어야 표시합니다', '삼합 또는 계절합의 왕지가 비어있어도 표시합니다'];
  Image samHabButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment samHabAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowYucHab = 0;
  Image yucHabButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment yucHabAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowHyeong = 0;
  bool isShowJamyoHyeong = false, isShowInsasin = false, isShowChucsulmi = false;
  double hyeongContainerHeight = 0;
  Image hyeongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment hyeongAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowChung = 0;
  Image chungButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment chungAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowPa = 0;
  Image paButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment paAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowWonjin = 0;
  Image wonjinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment wonjinAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowGuimun = 0;
  Image guimunButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment guimunAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowGyeocgac = 0;
  Image gyeocgacButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment gyeocgacAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowJijanggan = 0;
  bool isShowJijangganYugchin = false, isShowJijangganDay = false;
  double jijangganContainerHeight = 0;
  Image jijangganButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment jijangganAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowSibiunseong = 0;
  Image sibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment sibiunseongAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  int isShowYugchin = 0;
  Image yugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16); //스위치 동그라미 이미지
  Alignment yugchinAlign = Alignment.centerLeft;  //스위치 동그라미 정렬

  double widgetWidth = 0;
  double widgetHeight = 0;

  SetCheonganHabChung({bool isSwitch = true}){  //천간 합충극 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowCheongan = (isShowCheongan + 1) % 2;
    });}

    if(isShowCheongan == 0){
      cheonganHabChungContainerHeight = 0;
      cheonganHabAlign = Alignment.centerLeft;
      cheonganHabChungButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      cheonganHabChungContainerHeight = style.saveDataMemoLineHeight * 2.5;
      cheonganHabAlign = Alignment.centerRight;
      cheonganHabChungButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SaveCheonganHabChungData(){
    if(isShowCheongan == 0){
      personalDataManager.SaveCalendarData(1, 9);
    }
    else{
      int dataNum = 0;
      if(isShowCheonganHab == true){
        dataNum = dataNum + 1;}
      if(isShowCheonganChung == true){
        dataNum = dataNum + 2;}
      if(isShowCheonganGeuc == true){
        dataNum = dataNum + 4;}
      if(dataNum == 0){
        dataNum = 9;
      }
      personalDataManager.SaveCalendarData(1, dataNum);
    }
  }

  SetBanguiHab({bool isSwitch = true}){ //방합 보여줌, 애니메이션
    if(isSwitch == true){
      setState(() {
        isShowBanguiHabNum = (isShowBanguiHabNum + 1) % 3;
      });
      personalDataManager.SaveCalendarData(10, isShowBanguiHabNum + 1);}
    if(isShowBanguiHabNum == 0){
      banguiHabAlign = Alignment.centerLeft;
      banguiHabButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowBanguiHabNum == 1){
      banguiHabAlign = Alignment.center;
      banguiHabButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    } else if(isShowBanguiHabNum == 2){
      banguiHabAlign = Alignment.centerRight;
      banguiHabButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetSamHab({bool isSwitch = true}){  //삼합 보여줌, 애니메이션
    if(isSwitch == true)
    {setState(() {
      isShowSamHabNum = (isShowSamHabNum + 1) % 3;
    });
    personalDataManager.SaveCalendarData(100, isShowSamHabNum + 1);}
    if(isShowSamHabNum == 0){
      samHabAlign = Alignment.centerLeft;
      samHabButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else if(isShowSamHabNum == 1){
      samHabAlign = Alignment.center;
      samHabButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    } else if(isShowSamHabNum == 2){
      samHabAlign = Alignment.centerRight;
      samHabButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetYucHab({bool isSwitch = true}){  //육친 보여줌
    if(isSwitch == true) {
      setState(() {
        isShowYucHab = (isShowYucHab + 1) % 2;
      });
      personalDataManager.SaveCalendarData(1000, isShowYucHab + 1);
    }
    if(isShowYucHab == 0){
      yucHabAlign = Alignment.centerLeft;
      yucHabButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      yucHabAlign = Alignment.centerRight;
      yucHabButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetHyeong({bool isSwitch = true}){  //형 보여줌, 애니메이션
    if(isSwitch == true) {
      setState(() {
        isShowHyeong = (isShowHyeong + 1) % 2;
      });
    }
    if(isShowHyeong == 0){
      hyeongContainerHeight = 0;
      hyeongAlign = Alignment.centerLeft;
      hyeongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      hyeongContainerHeight = style.saveDataMemoLineHeight * 2.5;
      hyeongAlign = Alignment.centerRight;
      hyeongButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SaveHyeongData(){
    if(isShowHyeong == 0){
      personalDataManager.SaveCalendarData(10000, 9);
    }
    else{
      int dataNum = 0;
      if(isShowJamyoHyeong == true){
        dataNum = dataNum + 1;}
      if(isShowInsasin == true){
        dataNum = dataNum + 2;}
      if(isShowChucsulmi == true){
        dataNum = dataNum + 4;}
      if(dataNum == 0){
        dataNum = 9;
      }
      personalDataManager.SaveCalendarData(10000, dataNum);
    }
  }

  SetChung({bool isSwitch = true}){
    if(isSwitch == true) {
      setState(() {
        isShowChung = (isShowChung + 1) % 2;
      });
      personalDataManager.SaveCalendarData(100000, isShowChung + 1);
    }
    if(isShowChung == 0){
      chungAlign = Alignment.centerLeft;
      chungButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      chungAlign = Alignment.centerRight;
      chungButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetPa({bool isSwitch = true}){
    if(isSwitch == true) {
      setState(() {
        isShowPa = (isShowPa + 1) % 2;
      });
      personalDataManager.SaveCalendarData(1000000, isShowPa + 1);
    }
    if(isShowPa == 0){
      paAlign = Alignment.centerLeft;
      paButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      paAlign = Alignment.centerRight;
      paButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }

  }

  SetWonjin({bool isSwitch = true}){
    if(isSwitch == true) {
      setState(() {
        isShowWonjin = (isShowWonjin + 1) % 2;
      });
      personalDataManager.SaveCalendarData(10000000, isShowWonjin + 1);
    }
    if(isShowWonjin == 0){
      wonjinAlign = Alignment.centerLeft;
      wonjinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      wonjinAlign = Alignment.centerRight;
      wonjinButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetGuimun({bool isSwitch = true}){
    if(isSwitch == true) {
      setState(() {
        isShowGuimun = (isShowGuimun + 1) % 2;
      });
      personalDataManager.SaveCalendarData(100000000, isShowGuimun + 1);
    }
    if(isShowGuimun == 0){
      guimunAlign = Alignment.centerLeft;
      guimunButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      guimunAlign = Alignment.centerRight;
      guimunButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetGyeocgac({bool isSwitch = true}){
    if(isSwitch == true) {
      setState(() {
        isShowGyeocgac = (isShowGyeocgac + 1) % 2;
        personalDataManager.SaveCalendarData(1000000000, isShowGyeocgac + 1);
      });
    }
    if(isShowGyeocgac == 0){
      gyeocgacAlign = Alignment.centerLeft;
      gyeocgacButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      gyeocgacAlign = Alignment.centerRight;
      gyeocgacButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetJijanggan({bool isSwitch = true}){ //지장간 보여줌, 애니메이션
    if(isSwitch == true) {
      setState(() {
        isShowJijanggan = (isShowJijanggan + 1) % 2;
      });
    }
    if(isShowJijanggan == 0){
      jijangganContainerHeight = 0;
      jijangganAlign = Alignment.centerLeft;
      jijangganButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      jijangganContainerHeight = style.saveDataMemoLineHeight * 2.5;
      jijangganAlign = Alignment.centerRight;
      jijangganButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SaveJijangganData(){
    if(isShowJijanggan == 0){
      personalDataManager.SaveCalendarData(10000000000, 9);
    }
    else{
      int dataNum = 1;
      if(isShowJijangganYugchin == true){
        dataNum = dataNum + 2;}
      if(isShowJijangganDay == true){
        dataNum = dataNum + 4;}
      personalDataManager.SaveCalendarData(10000000000, dataNum);
    }
  }

  SetSibiunseong({bool isSwitch = true}){  //육친 보여줌
    if(isSwitch == true) {
      setState(() {
        isShowSibiunseong = (isShowSibiunseong + 1) % 2;
      });
      personalDataManager.SaveCalendarData(100000000000, isShowSibiunseong + 1);
    }
    if(isShowSibiunseong == 0){
      sibiunseongAlign = Alignment.centerLeft;
      sibiunseongButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      sibiunseongAlign = Alignment.centerRight;
      sibiunseongButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetYugchin({bool isSwitch = true}){
    if(isSwitch == true) {
      setState(() {
        isShowYugchin = (isShowYugchin + 1) % 2;
      });
      personalDataManager.SaveCalendarData(1000000000000, isShowYugchin + 1);
    }
    if(isShowYugchin == 0){
      yugchinAlign = Alignment.centerLeft;
      yugchinButtonImage = Image.asset('assets/EllipseGray.png', width: 16, height: 16);
    } else {
      yugchinAlign = Alignment.centerRight;
      yugchinButtonImage = Image.asset('assets/EllipseBlue.png', width: 16, height: 16);
    }
  }

  SetAllShow(bool isAllShow){
    if(isAllShow == true){  //모두 보기, 모두 끈 상태에서 애니메이션을 돌린다
      isShowCheongan = 1; //0:안보여줌, 1:보여줌
      isShowBanguiHabNum = 2;
      isShowSamHabNum = 2;
      isShowYucHab = 1;
      isShowHyeong = 1;
      isShowChung = 1;
      isShowPa = 1;
      isShowWonjin = 1;
      isShowGuimun = 1;
      isShowGyeocgac = 1;
      isShowJijanggan = 1;
      isShowSibiunseong = 1;
      isShowYugchin = 1;
    }
    else{ //모두 끄기
      isShowCheongan = 0; //0:안보여줌, 1:보여줌
      isShowBanguiHabNum = 0;
      isShowSamHabNum = 0;
      isShowYucHab = 0;
      isShowHyeong = 0;
      isShowChung = 0;
      isShowPa = 0;
      isShowWonjin = 0;
      isShowGuimun = 0;
      isShowGyeocgac = 0;
      isShowJijanggan = 0;
      isShowSibiunseong = 0;
      isShowYugchin = 0;
    }

    isShowCheonganHab = isAllShow;
    isShowCheonganChung = isAllShow;
    isShowCheonganGeuc = isAllShow;
    isShowJamyoHyeong = isAllShow;
    isShowInsasin = isAllShow;
    isShowChucsulmi = isAllShow;
    isShowJijangganYugchin = isAllShow;
    isShowJijangganDay = isAllShow;

    SetCheonganHabChung(isSwitch: false);
    SetBanguiHab(isSwitch: false);
    SetSamHab(isSwitch: false);
    SetYucHab(isSwitch: false);
    SetHyeong(isSwitch: false);
    SetChung(isSwitch: false);
    SetPa(isSwitch: false);
    SetWonjin(isSwitch: false);
    SetGuimun(isSwitch: false);
    SetGyeocgac(isSwitch: false);
    SetJijanggan(isSwitch: false);
    SetSibiunseong(isSwitch: false);
    SetYugchin(isSwitch: false);

    personalDataManager.SaveCalendarData(0, isAllShow == false? 1 : 2, isAll:true);
  }

  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;

    int dataNum = personalDataManager.calendarData;

    //천간 합충극
    int tempNum = dataNum % 10;
    if(tempNum == 9){
      isShowCheongan = 0;
      isShowCheonganHab = false;
      isShowCheonganChung = false;
      isShowCheonganGeuc = false;
    }
    else{
      isShowCheongan = 1;

      if(tempNum == 1 || tempNum == 3 || tempNum == 5 || tempNum == 7){
        isShowCheonganHab = true;
      } else {
        isShowCheonganHab = false;
      }
      if(tempNum == 2 || tempNum == 3 || tempNum == 6 || tempNum == 7){
        isShowCheonganChung = true;
      } else {
        isShowCheonganChung = false;
      }
      if(tempNum == 4 || tempNum == 5 || tempNum == 6 || tempNum == 7){
        isShowCheonganGeuc = true;
      } else {isShowCheonganGeuc = false;}
    }
    SetCheonganHabChung(isSwitch : false);

    tempNum = ((dataNum % 100) / 10).floor(); //방합
    isShowBanguiHabNum = tempNum - 1;
    SetBanguiHab(isSwitch : false);

    tempNum = ((dataNum % 1000) / 100).floor(); //삼합
    isShowSamHabNum = tempNum - 1;
    SetSamHab(isSwitch:false);

    tempNum = ((dataNum % 10000) / 1000).floor(); //육합
    isShowYucHab = tempNum - 1;
    SetYucHab(isSwitch:false);

    tempNum = ((dataNum % 100000) / 10000).floor(); //형
    if(tempNum == 9){
      isShowHyeong = 0;
      isShowJamyoHyeong = false;
      isShowInsasin = false;
      isShowChucsulmi = false;
    }
    else{
      isShowHyeong = 1;

      if(tempNum == 1 || tempNum == 3 || tempNum == 5 || tempNum == 7){
        isShowJamyoHyeong = true;
      } else {
        isShowJamyoHyeong = false;
      }
      if(tempNum == 2 || tempNum == 3 || tempNum == 6 || tempNum == 7){
        isShowInsasin = true;
      } else {
        isShowInsasin = false;
      }
      if(tempNum == 4 || tempNum == 5 || tempNum == 6 || tempNum == 7){
        isShowChucsulmi = true;
      } else {isShowChucsulmi = false;}
    }
    SetHyeong(isSwitch : false);

    tempNum = ((dataNum % 1000000) / 100000).floor(); //충
    isShowChung = tempNum - 1;
    SetChung(isSwitch:false);

    tempNum = ((dataNum % 10000000) / 1000000).floor(); //파
    isShowPa = tempNum - 1;
    SetPa(isSwitch:false);

    tempNum = ((dataNum % 100000000) / 10000000).floor(); //원진
    isShowWonjin = tempNum - 1;
    SetWonjin(isSwitch:false);

    tempNum = ((dataNum % 1000000000) / 100000000).floor(); //귀문
    isShowGuimun = tempNum - 1;
    SetGuimun(isSwitch:false);

    tempNum = ((dataNum % 10000000000) / 1000000000).floor(); //격각
    isShowGyeocgac = tempNum - 1;
    SetGyeocgac(isSwitch:false);

    tempNum = ((dataNum % 100000000000) / 10000000000).floor(); //지장간
    if(tempNum == 9){
      isShowJijanggan = 0;
      isShowJijangganYugchin = false;
      isShowJijangganDay = false;
    }
    else{
      isShowJijanggan = 1;

      if(tempNum == 3 || tempNum == 7){
        isShowJijangganYugchin = true;
      } else {
        isShowJijangganYugchin = false;
      }
      if(tempNum == 5 || tempNum == 7){
        isShowJijangganDay = true;
      } else {
        isShowJijangganDay = false;
      }
    }
    SetJijanggan(isSwitch : false);

    tempNum = ((dataNum % 1000000000000) / 100000000000).floor(); //육친
    isShowSibiunseong = tempNum - 1;
    SetSibiunseong(isSwitch:false);

    tempNum = ((dataNum % 10000000000000) / 1000000000000).floor(); //육친
    isShowYugchin = tempNum - 1;
    SetYugchin(isSwitch:false);
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
            child:Text('저장 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Column(
            children: [
              Container(  //정렬용 컨테이너
                width: widgetWidth,
                height: 1,
              ),
              Container(  //데이터 추출 설명
                height: style.saveDataMemoLineHeight * 0.6,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("선택한 데이터를 추출합니다", style: style.settingInfoText0,),
              ),
              Container(  //데이터 추출 옵션 버튼들
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: style.saveDataMemoLineHeight,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("단일 명식 ", style: style.settingText0,),
                    Checkbox(
                      value: isShowCheonganHab,
                      onChanged: (value) {
                        setState(() {
                          isShowCheonganHab = value!;widget.reloadSetting();
                        });
                        SaveCheonganHabChungData();
                      },
                    ),
                    SizedBox(width:20),
                    Text("그룹 명식 ", style: style.settingText0,),
                    Checkbox(
                      value: isShowCheonganChung,
                      onChanged: (value) {
                        setState(() {
                          isShowCheonganChung = value!;widget.reloadSetting();
                        });
                        SaveCheonganHabChungData();
                      },
                    ),
                    SizedBox(width:20),
                    Text("일진 일기 ", style: style.settingText0,),
                    Checkbox(
                      value: isShowCheonganGeuc,
                      onChanged: (value) {
                        setState(() {
                          isShowCheonganGeuc = value!;widget.reloadSetting();
                        });
                        SaveCheonganHabChungData();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: style.UIMarginTop),
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
                      '추출',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {

                      });
                    }),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: 1,
                margin: EdgeInsets.only(top: 22),
                color: style.colorGrey,
              ),
              Container(  //데이터 불러오기 설명
                height: style.saveDataMemoLineHeight * 0.7,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("추출한 파일을 통해 데이터를 불러옵니다", style: style.settingInfoText0,),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: style.UIMarginTop),
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
                      '불러오기',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {

                      });
                    }),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 268,
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

