import 'package:flutter/material.dart';
import 'package:LuciaOneCalendar/main.dart';
import '../../style.dart' as style;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import '../../findGanji.dart' as findGanji;
import '../../SaveData/saveDataManager.dart' as saveDataManager;
import 'package:provider/provider.dart';

class CalendarResultBirthTextWidget extends StatefulWidget {
  const CalendarResultBirthTextWidget({super.key, required this.name, required this.gender, required this.uemYang, required this.birthYear, required this.birthMonth, required this.birthDay, required this.birthHour, required this.birthMin, required this.isShowDrawerManOld, required this.isOneWidget, required this.widgetWidth, required this.isEditSetting,
  required this.setTargetName, required this.setUemYangBirthType, required this.refreshMapPersonLengthAndSort});

  final String name;
  final String gender;
  final int uemYang;
  final int birthYear, birthMonth, birthDay, birthHour, birthMin;
  final int isShowDrawerManOld;
  final double widgetWidth;
  final bool isOneWidget;
  final bool isEditSetting;
  final setTargetName;
  final setUemYangBirthType;
  final refreshMapPersonLengthAndSort;

  @override
  State<CalendarResultBirthTextWidget> createState() => _CalendarResultBirthTextWidgetState();
}

class _CalendarResultBirthTextWidgetState extends State<CalendarResultBirthTextWidget> {

  bool isShowPersonalName = true, isShowPersonalOld = true, isShowPersonalBirth = true;
  bool isEditSetting = false;
  int isShowPersonalData = 0;
  int personalDataNum = 0;

  TextEditingController nameTextController = new TextEditingController();
  String nameText = '';

  TextStyle textStyle = TextStyle(color : Colors.white, fontSize: 20, fontWeight: FontWeight.w500);

  bool isEditWorldPersonName = false;

  String GetOld() {
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1){  //인적사항 숨김
      if(isShowPersonalOld == false){
        return '';
      }
    }
    int birthYear = widget.birthYear;
    if(widget.uemYang != 0){
      //print(widget.birthMonth);
      //print(widget.birthDay);
      //List<int> listSolBirth = findGanji.LunarToSolar(widget.birthYear, widget.birthMonth, widget.birthDay, widget.uemYang == 1? false:true);
      birthYear = findGanji.LunarToSolar(widget.birthYear, widget.birthMonth, widget.birthDay, widget.uemYang == 1? false:true)[0];//listSolBirth[0];
    }
    int old = DateTime.now().year - birthYear + 1;//widget.birthYear + 1;
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

    if (widget.birthHour == 30) {
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

      //썸머타임 조회
      if(widget.uemYang == 0) {
        if (findGanji.CheckSummerTime(widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin) == true) {
          birthTimeText = birthTimeText + ' (서머타임 -60분)';
        }
      } else {
        List<int> listYangBirth = findGanji.LunarToSolar(widget.birthYear, widget.birthMonth, widget.birthDay, widget.uemYang == 1? false:true);
        if(findGanji.CheckSummerTime(listYangBirth[0], listYangBirth[1], listYangBirth[2], widget.birthHour, widget.birthMin) == true)
          birthTimeText = birthTimeText + ' (서머타임 -60분)';
      }

      return Text(birthTimeText, style: textStyle);
    }
  }

  String GetName(){
    if(isShowPersonalData != 1){
      if(isShowPersonalName == false){
        return '';
      }
    }

    return nameText;
  }

  ChangePersonName(){
    if(nameText == '이름 없음'){
      nameTextController.text = '';
    } else {
      nameTextController.text = nameText;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        //title: Text('성별을 선택해 주세요'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: nameTextController,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorBlack),
                maxLength: 10,
                cursorColor: style.colorBlack,
                autofocus: true,
                onEditingComplete: () {
                  Navigator.of(context).pop();
                  setState(() {
                    nameText = nameTextController.text;
                    widget.setTargetName(nameText);
                   // widget.refreshMapPersonLengthAndSort();
                  });
                },
                decoration: InputDecoration(
                  labelText: '이름을 수정합니다', labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: style.colorBlack, height: -0.4),
                  hintText: '이름 없음', hintStyle:  TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorGrey),
                  counterText:'',
                  focusedBorder:UnderlineInputBorder(
                    borderSide: BorderSide(width:2, color:style.colorDarkGrey),
                  ),
                ),
              ),
            ),
          ],
        ),
        buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0),
        actions: [
          ElevatedButton(
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                nameText = nameTextController.text;
                widget.setTargetName(nameText);
              //  widget.refreshMapPersonLengthAndSort();
              });
            },
            child: Text('저장'),
          ),
          ElevatedButton(
              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소')),
        ],
      ),
    );
  }

  TextButton GetGenderTextButtonWidget(){
    String genderString = '';
    Text genderTextWidget;
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1 && isShowPersonalName == false){
      if(widget.gender == '남'){
        genderString = '남성 ';
      } else {
        genderString = '여성 ';
      }
      genderTextWidget = Text(genderString, style: textStyle);
    } else {
      genderString = '(${widget.gender}) ';
      genderTextWidget = Text(genderString, style: textStyle);
    }

    return TextButton(
        onPressed: (){
          ChangePersonName();
        },
        style: TextButton.styleFrom(padding: EdgeInsets.all(0), minimumSize: Size(0, 20)),
        child: genderTextWidget);
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
    String birthText = '';
    if(((personalDataManager.etcData % 10000) / 1000).floor() != 1 && isShowPersonalBirth == false){
      birthText = '생년월일 숨김';
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(birthText, style: textStyle),
        ],
      );
    } else {
      birthText = '${widget.birthYear}년 ${widget.birthMonth}월 ${widget.birthDay}일';
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(birthText, style: textStyle),
          Text(GetUemYangText() + ' ', style: textStyle),
          GetBirthTimeText(),
          //Text(GetBirthTimeText(_hour,_min), style: Theme.of(context).textTheme.labelLarge),
        ],
      );
    }
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
    if(widget.isOneWidget == true){ //안씀
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
    }
    else {
      textStyle = TextStyle(color : Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
      return Container(
        width: widget.widgetWidth,
        //height: containerHeight,
        child: Container(
          width: widget.widgetWidth,
          //height: containerHeight,
          margin: EdgeInsets.only(top: 0, left: style.UIMarginLeft),
          color: style.colorBackGround,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Text(GetName(), style: textStyle),
                  Container(
                    height: 26,
                    child: TextButton(
                        onPressed: (){
                          ChangePersonName();
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0), minimumSize: Size(0, 20)),
                        child: Text(GetName(), style: textStyle)),
                  ),
                  Container(
                    height: 26,
                    child: GetGenderTextButtonWidget(),
                  ),
                  Container(
                    height: 26,
                    child: Text('${GetOld()} ', style: textStyle),
                  ),
                ],
              ),
              Container(
                height: 24,
                child: ElevatedButton(
                    onPressed: (){
                      widget.setUemYangBirthType();
                    },
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent, surfaceTintColor: Colors.transparent),
                    child: GetBirthText()
                ),
              ),
              Container(
                width: widget.widgetWidth,
                height: 6,
                color:style.colorBackGround,
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

    nameText = widget.name;

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

    if(isEditWorldPersonName != context.watch<Store>().isEditWorldPersonName){
      if(nameText == context.watch<Store>().personPrevName &&
          saveDataManager.ConvertToBirthData(widget.gender == '남'? true:false, widget.uemYang, widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin) == context.watch<Store>().personBirthData){
        setState(() {
          nameText = context.watch<Store>().personNowName;
        });
      }
      isEditWorldPersonName = context.watch<Store>().isEditWorldPersonName;
    }
    //if(nameText != widget.name){
    //  nameText = widget.name;
    //}

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
