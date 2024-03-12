import 'package:flutter/material.dart';
import '../../style.dart' as style;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class CalendarResultBirthTextWidget extends StatefulWidget {
  const CalendarResultBirthTextWidget({super.key, required this.name, required this.gender, required this.uemYang, required this.birthYear, required this.birthMonth, required this.birthDay, required this.birthHour, required this.birthMin, required this.isShowDrawerManOld, required this.isOneWidget, required this.widgetWidth});

  final String name;
  final String gender;
  final int uemYang;
  final int birthYear, birthMonth, birthDay, birthHour, birthMin;
  final int isShowDrawerManOld;
  final double widgetWidth;
  final bool isOneWidget;

  @override
  State<CalendarResultBirthTextWidget> createState() => _CalendarResultBirthTextWidgetState();
}

class _CalendarResultBirthTextWidgetState extends State<CalendarResultBirthTextWidget> {
  double containerHeight = 50;
  bool isShowPersonalName = true, isShowPersonalOld = true, isShowPersonalBirth = true;

  TextStyle textStyle = TextStyle(color : Colors.white, fontSize: 20, fontWeight: FontWeight.w500);

  String GetOld() {
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){  //인적사항 숨김
      if(isShowPersonalOld == false){
        return '';
      }
    }
    int old = DateTime.now().year - widget.birthYear + 1;
    if(widget.isShowDrawerManOld == 1){ //만으로 표시
      old--;
      if(DateTime.now().month < widget.birthMonth || (DateTime.now().month == widget.birthMonth && DateTime.now().day < widget.birthDay)){
        old--;
      }
      if (old >= 0) {
        return '${old}세';
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
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){
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
        height: containerHeight,
        child: Container(
          width: widget.widgetWidth,
          height: containerHeight,
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
        height: containerHeight,
        child: Container(
          width: widget.widgetWidth,
          height: containerHeight,
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
  @override
  void initState() {
    super.initState();

    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){
      int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
      if(isShowPersonalDataNum == 1 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 7){
        isShowPersonalName = false;
      }
      if(isShowPersonalDataNum == 2 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7){
        isShowPersonalOld = false;
      }
      if(isShowPersonalDataNum == 4 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7){
        containerHeight = 40;
        isShowPersonalBirth = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
