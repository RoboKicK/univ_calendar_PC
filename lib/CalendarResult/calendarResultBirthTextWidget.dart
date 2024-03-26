import 'package:flutter/material.dart';
import 'package:univ_calendar_pc/main.dart';
import '../../style.dart' as style;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';

class CalendarResultBirthTextWidget extends StatefulWidget {
  const CalendarResultBirthTextWidget({super.key, required this.name, required this.gender, required this.uemYang, required this.birthYear, required this.birthMonth, required this.birthDay, required this.birthHour, required this.birthMin, required this.isShowDrawerManOld, required this.isOneWidget, required this.widgetWidth, required this.isEditSetting});

  final String name;
  final String gender;
  final int uemYang;
  final int birthYear, birthMonth, birthDay, birthHour, birthMin;
  final int isShowDrawerManOld;
  final double widgetWidth;
  final bool isOneWidget;
  final bool isEditSetting;

  @override
  State<CalendarResultBirthTextWidget> createState() => _CalendarResultBirthTextWidgetState();
}

class _CalendarResultBirthTextWidgetState extends State<CalendarResultBirthTextWidget> {

  bool isShowPersonalName = true, isShowPersonalOld = true, isShowPersonalBirth = true;
  bool isEditSetting = false;
  int isShowPersonalData = 0;
  int personalDataNum = 0;

  TextStyle textStyle = TextStyle(color : Colors.white, fontSize: 20, fontWeight: FontWeight.w500);

  String GetOld() {
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){  //인적사항 숨김
      if(isShowPersonalOld == false){
        return '';
      }
    }
    int old = DateTime.now().year - widget.birthYear + 1;
    if((personalDataManager.etcData % 10) == 2){ //만으로 표시
      old--;
      if(DateTime.now().month < widget.birthMonth || (DateTime.now().month == widget.birthMonth && DateTime.now().day < widget.birthDay)){
        old--;
      }
      if (old >= 0) {
        return '${old}세(만 나이)';
      }
    } else {
      if (old > 0) {
        return '${old}세';
      }
    }
    return '';
  }

  String GetUemYangText() {
    String uemYangText = '';
    if (widget.uemYang == 0) {
      uemYangText = '(양력)';
    } else if (widget.uemYang == 1) {
      uemYangText = '(음력)';
    } else {
      uemYangText = '(음력 윤달)';
    }

    return uemYangText;
  }

  Text GetBirthTimeText() {
    String birthTimeText = '';

    if (widget.birthHour == -2) {
      birthTimeText = '시간 모름';
      return Text(birthTimeText, style: textStyle);
    } else {
      if (widget.birthHour < 10) {
        birthTimeText = '0${widget.birthHour}';
      } else {
        birthTimeText = '${widget.birthHour}';
      }

      if (widget.birthMin < 10) {
        birthTimeText = birthTimeText + ':0${widget.birthMin}';
      } else {
        birthTimeText = birthTimeText + ':${widget.birthMin}';
      }
      return Text(birthTimeText, style: textStyle);
    }
  }

  String GetName(){
   // print(isShowPersonalData);
   // print(isShowPersonalName);
    if(isShowPersonalData != 1){
      if(isShowPersonalName == false){
        return '';
      }
    }
    return widget.name;
  }

  Text GetGenderTextWidget(){
    String genderString = '';
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1 && isShowPersonalName == false){
        if(widget.gender == '남'){
          genderString = '남성 ';
        } else {
          genderString = '여성 ';
        }
        return Text(genderString, style: textStyle);
    } else {
    genderString = '(${widget.gender}) ';
      return Text(genderString, style: textStyle);
    }
  }

  Widget GetBirthText(){
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){
        if(isShowPersonalBirth == false){
        return SizedBox.shrink();
      }
    }
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('${widget.birthYear}.${widget.birthMonth}.${widget.birthDay}', style: textStyle),
          Text(GetUemYangText() + ' ', style: textStyle),
          GetBirthTimeText(),
          //Text(GetBirthTimeText(_hour,_min), style: Theme.of(context).textTheme.labelLarge),
        ],
      );
  }

  Widget GetManTextWidget(){
    String manString = '';
    if(widget.isShowDrawerManOld == 1) { //만으로 표시
      manString = '(만 나이)';
      return Container(
        height: 28,
        alignment: Alignment.bottomCenter,
        child:  Text(manString, style: textStyle)
      );
    } else {
      return SizedBox.shrink();
    }

  }

  Widget GetBirthTextWidget(){
    if(widget.isOneWidget == true){
      textStyle = TextStyle(color : Colors.white, fontSize: 20, fontWeight: FontWeight.w500);
      return Container(
        width: widget.widgetWidth,
        //height: containerHeight,
        child: Container(
          width: widget.widgetWidth,
          //height: containerHeight,
          margin: EdgeInsets.only(top: style.UIMarginLeft),
          //color: Colors.blue,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(GetName(), style: textStyle),
                  GetGenderTextWidget(),
                  Text('${GetOld()} ', style: textStyle),
                  GetManTextWidget(),
                  GetBirthText(),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      textStyle = TextStyle(color : Colors.white, fontSize: 14, fontWeight: FontWeight.w500);
      return Container(
        width: widget.widgetWidth,
        //height: containerHeight,
        child: Container(
          width: widget.widgetWidth,
          //height: containerHeight,
          margin: EdgeInsets.only(top: 6),
          //color: Colors.blue,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(GetName(), style: textStyle),
                  GetGenderTextWidget(),
                  Text('${GetOld()} ', style: textStyle),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GetManTextWidget(),
                  GetBirthText(),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  SetPersonalDataNum(){
    isShowPersonalData = ((personalDataManager.etcData % 10000) / 1000).floor();
    personalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();

    if(personalDataNum == 1 || personalDataNum == 3 || personalDataNum == 5 || personalDataNum == 7){
      isShowPersonalName = false;
    } else {isShowPersonalName = true;}
    if(personalDataNum == 2 || personalDataNum == 3 || personalDataNum == 6 || personalDataNum == 7){
      isShowPersonalOld = false;
    }else {isShowPersonalOld = true;}
    if(personalDataNum == 4 || personalDataNum == 5 || personalDataNum == 6 || personalDataNum == 7){
      isShowPersonalBirth = false;
    }else {isShowPersonalBirth = true;}
  }

  @override
  void initState() {
    super.initState();

    isShowPersonalData = ((personalDataManager.etcData % 10000) / 1000).floor();
    if(isShowPersonalData != 1){
      SetPersonalDataNum();
    }

    isEditSetting = widget.isEditSetting;
  }

  @override
  Widget build(BuildContext context) {
    if(isEditSetting != widget.isEditSetting){
  setState(() {
    SetPersonalDataNum();
  });
      isEditSetting = widget.isEditSetting;
    }

    if(isEditSetting != context.watch<Store>().isEditSetting){
      setState(() {
        SetPersonalDataNum();
      });
      isEditSetting = context.watch<Store>().isEditSetting;
    }

    return GetBirthTextWidget();
  }
}
/*
class CalendarResultBirthText {


  GetNameAndBirthText(BuildContext context, String _name, String _gender, int _year, int _month, int _day, int _hour, int _min, int _uemYang){
    return Container(
      width:widgetWidth,
      height: 61,
      margin: EdgeInsets.only(left: style.UIMarginLeft),
      //color: Colors.blue,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(_name, style: Theme.of(context).textTheme.headlineLarge),
              Text('(${_gender}) ', style: textStyle),
              Text('${GetOld(_year,_month,_day)}세', style: Theme.of(context).textTheme.headlineLarge),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Text('${_year}.${_month}.${_day}', style: Theme.of(context).textTheme.labelLarge),
              Text(GetUemYangText(_uemYang)+' ', style: Theme.of(context).textTheme.labelMedium),
              GetBirthTimeText(context,_hour,_min),
              //Text(GetBirthTimeText(_hour,_min), style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}*/
