import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_calendar_pc/main.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../findGanji.dart' as findGanji;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';

class MainCalendarSaveListOption extends StatefulWidget {
  const MainCalendarSaveListOption({super.key, required this.name0, required this.gender0, required this.uemYang0, required this.birthYear0, required this.birthMonth0,
    required this.birthDay0, required this.birthHour0, required this.birthMin0, required this.saveDate, required this.memo,
  required this.closeOption, required this.refreshMapPersonLengthAndSort});

  final String name0;
  final bool gender0;
  final int uemYang0;
  final int birthYear0, birthMonth0, birthDay0, birthHour0, birthMin0;
  final DateTime saveDate;
  final String memo;
  final refreshMapPersonLengthAndSort;

  final closeOption;

  @override
  State<MainCalendarSaveListOption> createState() => _MainCalendarSaveListOptionState();
}

enum Gender {Male, Female, None}

class _MainCalendarSaveListOptionState extends State<MainCalendarSaveListOption> {

  String GetUemYangText(int uemYang){
    String uemYangText = '';
    if(uemYang == 0){
      uemYangText = '(양력)';
    }
    else if(uemYang == 1){
      uemYangText = '(음력)';
    }
    else{
      uemYangText = '(음력 윤달)';
    }

    return uemYangText;
  }
  String GetBirthTimeText(int birthHour, int birthMin){
    String birthTimeText = '';

    if(birthHour == 30){
      return birthTimeText = '시간 모름';
    }
    else {
      if (birthHour < 10) {
        birthTimeText = '0${birthHour}';
      }
      else {
        birthTimeText = '${birthHour}';
      }

      if (birthMin < 10) {
        birthTimeText = birthTimeText + ':0${birthMin}';
      }
      else {
        birthTimeText = birthTimeText + ':${birthMin}';
      }
      return birthTimeText;
    }
  }
  String GetNameText(String text){
    String nameText = '';
    int textLengthLimit = 9;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        break;
      }
      if(i+1 > text.length){
        break;
      }
      if(i > textLengthLimit){
        nameText = nameText+'..';
        break;
      }
      nameText = nameText + text.substring(i, i+1);
    }
    return nameText;
  }

  TextEditingController memoController = TextEditingController();

  String prefixMemo = '';
  String editingMemo = '';
  String editingName0 = '';
  String editingBirthDay0 = '';
  int editingBirthHour0 = 0;
  int editingBirthMin0 = 0;
  String uemYangText0 = '';
  Gender? editingGender0 = Gender.None;

  double categoryMargin = 6;

  int isEditingPersonData = 0;
  int isEditingMemo = 0;
  int buttonMode = 0;

  late FocusNode memoFocusNode;

  SetMemo(String memo){
    editingMemo = memo;
  }

  int genderState = 3;

  var popUpVal = ['간지 선택 ▼',  '23:30 ~ 01:30 子시', '01:30 ~ 03:30 丑시', '03:30 ~ 05:30 寅시', '05:30 ~ 07:30 卯시', '07:30 ~ 09:30 辰시', '09:30 ~ 11:30 巳시',
    '11:30 ~ 13:30 午시', '13:30 ~ 15:30 未시', '15:30 ~ 17:30 申시', '17:30 ~ 19:30 酉시', '19:30 ~ 21:30 戌시', '21:30 ~ 23:30 亥시'];
  var popUpSelect = '간지 선택 ▼';

  int uemYangType0 = 0;
  int targetBirthYear = 0;
  int targetBirthMonth = 0;
  int targetBirthDay = 0;
  int targetBirthHour = 0;  //시간 모름일 때는 30로 조회한다
  int targetBirthMin = 0;
  String targetName = '';
  bool gender0 = true;

  bool isUemryoc = true;
  bool isYundal = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController hourController = TextEditingController();

  String seasonMessageDate = '';  //절입시간 안내할 때 중복 방지용 변수

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true;

  bool isEditWorldCalendarMemo = false;  //프로젝트 전체에서 메모 변동
  bool isEditWorldPersonName = false; //프로젝트 전체에서 이름 변동
  
  ShowDialogMessage(String message){
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      //barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  SeasonDayMessage() {
    //절입시간이 있는 날인지 알려줌
    if (birthController.text.length == 10 && seasonMessageDate != birthController.text) {
      seasonMessageDate = birthController.text;

      int _year = int.parse(birthController.text.substring(0, 4));
      if (_year < 1901) {
        return;
      }
      int _month = int.parse(birthController.text.substring(5, 7));
      int _day = int.parse(birthController.text.substring(8, 10));

      if (isUemryoc == false) {
        int seasonData = findGanji.listSeasonData[_year - findGanji.stanYear][_month - 1];
        if ((seasonData / 10000).floor() == _day) {
          ShowDialogMessage('양력 ${_year}년 ${_month}월 ${_day}일은\n절입시간(${seasonData.toString().substring(1, 3)}:${seasonData.toString().substring(3, 5)})이 적용되는 날입니다\n생시를 정확히 입력해 주세요');
        }
      } else {
        List<int> listSolBirth = findGanji.LunarToSolar(_year, _month, _day, isYundal);

        int seasonData = findGanji.listSeasonData[listSolBirth[0] - findGanji.stanYear][listSolBirth[1]];

        if ((seasonData / 10000).floor() == listSolBirth[2]) {
          if (isYundal == false) {
            ShowDialogMessage(
                '음력 ${_year}년 ${_month}월 ${_day}일은\n절입시간(${seasonData.toString().substring(1, 3)}:${seasonData.toString().substring(3, 5)})이 적용되는 날입니다\n생시를 정확히 입력해 주세요');
          }
          else{
            ShowDialogMessage(
                '음력 ${_year}년 ${_month}월 ${_day}일은\n절입시간(${seasonData.toString().substring(1, 3)}:${seasonData.toString().substring(3, 5)})이 적용되는 날입니다\n생시를 정확히 입력해 주세요');
          }
        }
      }
    }
  } //절입시간 있는 날 알려줌

  SetYangrocUemryoc(bool isUemYangryoc, bool onOff){
    if(isUemYangryoc == true){  //음력양력 눌렀을 때
      isUemryoc = onOff;
      if(onOff == false){  //음력 on일 때
        isYundal = false;
      }
    } else {  //윤달 눌렀을 때
      if(onOff == true){
        isUemryoc = true;
      }
      isYundal = onOff;
    }
  }

  bool BirthDayErrorChecker(int year, int month, int day) {
    //연도
    if (year > 2050) {
      ShowDialogMessage('2050년 이후는 조회할 수 없습니다');
      return false;
    }
    if (year < 0) {
      ShowDialogMessage('기원전 생일은 조회할 수 없습니다');
      return false;
    }
    if (isUemryoc == true && year < 1901) {
      ShowDialogMessage('음력은 1901년부터 조회할 수 있습니다');
      return false;
    }
    //생월
    if (month < 1 || month > 12) {
      ShowDialogMessage('생월을 정확히 입력해 주세요');
      return false;
    }
    if (isUemryoc == true && isYundal == true) {
      if (findGanji.listLunNday[year - findGanji.stanYear][(month - 1) * 2 + 1] == 0) {
        ShowDialogMessage('음력 ${year}년은 윤${month}월이 없습니다');
        return false;
      }
    }
    //생일
    if (day < 1 || day > 31) {
      ShowDialogMessage('생일을 정확히 입력해 주세요');
      return false;
    }
    if (isUemryoc == false) {
      //양력일 때
      if (day > findGanji.listSolNday[month - 1]) {
        //
        ShowDialogMessage('양력 ${month}월은 ${day}일이 없습니다');
        return false;
      }
    }
    else {
      //음력일 때
      if (isYundal == false && findGanji.listLunNday[year - findGanji.stanYear][(month - 1) * 2] < day) {
        ShowDialogMessage('음력 ${month}월은 ${day}일이 없습니다');
        return false;
      } else if (isYundal == true && findGanji.listLunNday[year - findGanji.stanYear][(month - 1) * 2 + 1] < day) {
        ShowDialogMessage('음력 윤${month}월은 ${day}일이 없습니다');
        return false;
      }
    }

    return true;
  }

  bool BirthHourErrorChecker(int hour, int min){
    if(hour > 23){
      ShowDialogMessage('태어난 시간을 정확히 입력해주세요');
      return false;
    }
    if(min > 59){
      ShowDialogMessage('태어난 분을 정확히 입력해주세요');
      return false;
    }

    return true;
  }

  int GanjiSelect(){
    int count = 1;

    while(count < popUpVal.length){
      if(popUpSelect == popUpVal[count]){
        break;
      }
      else{
        count++;
      }
    }

    return (count - 1) * 2;
  }

  SetEditingMemo(){ //메모 시작과 저장할 때
    if(isEditingMemo == 0){ //메모 시작
      editingMemo = prefixMemo;
      memoController.text = editingMemo;
      isEditingMemo = 1;
      buttonMode = 1;
    }
    else{ //메모 저장 후 종료
      saveDataManager.SavePersonDataMemo2(editingName0, gender0, uemYangType0, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, widget.saveDate, editingMemo);
      prefixMemo = editingMemo;
      editingMemo = '';
      isEditingMemo = 0;
      buttonMode = 0;
      context.read<Store>().SetEditWorldCalendarMemo();
    }
  }

  SetEditingPersonData(){  //생년월일 등 정보 수정할 때
    if(isEditingPersonData == 0){ //수정 시작
      isEditingPersonData = 1;
      buttonMode = 2;
      nameController.text = editingName0;
      if(editingName0 == '이름 없음'){
        nameController.text = '';
      }
      birthController.text = editingBirthDay0;
      String birthMinString = '';
      if(editingBirthMin0 < 10){
        birthMinString = '0${editingBirthMin0}';
      }
      else if(editingBirthMin0 < 60){
        birthMinString = '${editingBirthMin0}';
      }
      String birthHourString = '';
      if(editingBirthHour0 < 10){
        birthHourString = '0${editingBirthHour0}';
      }
      else{
        birthHourString = '${editingBirthHour0}';
      }
      hourController.text = '${birthHourString} ${birthMinString}';
      if(editingBirthHour0 == 30){
        hourController.text = '';
      }
    }
    else{ //수정 후 종료
      isEditingPersonData = 0;
      buttonMode = 0;
      int uemYang = 0;
      if(isUemryoc == false){
        uemYang = 0;
      }
      else {
        uemYang = 1;
        if(isYundal == true){
          uemYang = 2;
        }
      }
      uemYangText0 = GetUemYangText(uemYang);
    }
  }

  String GetFirstLineText(String text){
    String firstLineText = '';
    int textLengthLimit = 29;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        break;
      }
      if(i+1 > text.length){
        break;
      }
      if(i > textLengthLimit){
        firstLineText = firstLineText+'..';
        break;
      }
      firstLineText = firstLineText + text.substring(i, i+1);
    }
    return firstLineText;
  }

  Text GetIlganText(int ilganNum){
    var textColor = style.SetOhengColor(true, ilganNum);
    return Text('  ${style.stringCheongan[((personalDataManager.etcData%1000)/100).floor() - 1][ilganNum]}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, height: 1.1));
  }
  Text GetIljiText(int iljiNum){
    var textColor = style.SetOhengColor(false, iljiNum);
    return Text(style.stringJiji[((personalDataManager.etcData%1000)/100).floor() - 1][iljiNum],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, height: 1.1));
  }

  List<Widget> GetPersonNameAndGanjiText(){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == false && isShowPersonalName == false){ //이름 숨김일 때
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("${gender0 == true ? '남성' : '여성'}", style: Theme.of(context).textTheme.titleLarge)));
    }
    else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("${GetNameText(editingName0)}", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("(${gender0 == true ?'남':'여'})", style: Theme.of(context).textTheme.titleLarge)));
    }

    if(((personalDataManager.etcData % 10000000) / 1000000).floor() == 2){
      List<int> listPaljaData = [];
      if(uemYangType0 == 0) {
        listPaljaData = findGanji.InquireGanji(targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);
      } else {
        List<int> listBirth = findGanji.LunarToSolar(targetBirthYear, targetBirthMonth, targetBirthDay, uemYangType0 == 1? false:true);
        listPaljaData = findGanji.InquireGanji(listBirth[0], listBirth[1], listBirth[2], targetBirthHour, targetBirthMin);
      }
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child: GetIlganText(listPaljaData[4])));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child: GetIljiText(listPaljaData[5])));
    }

    return listPersonalTextData;
  }
  List<Widget> GetPersonBirthText(){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == true || isShowPersonalBirth == true){
      listPersonalTextData.add(
          Container(
              height: style.saveDataMemoLineHeight,
              child:Text("${targetBirthYear}년 ${targetBirthMonth}월 ${targetBirthDay}일", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataMemoLineHeight,
          child:Text("${uemYangText0}",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataMemoLineHeight,
          child:Text(" ${GetBirthTimeText(targetBirthHour, targetBirthMin)}", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    } else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataMemoLineHeight,
              child:Text("****.**.** **:**",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    }

    return listPersonalTextData;
  }

  FocusNode maleFocusNode = FocusNode();
  FocusNode femaleFocusNode = FocusNode();
  FocusNode birthTextFocusNode = FocusNode();
  FocusNode birthHourTextFocusNode = FocusNode();

  CheckPersonalDataHide(){
    if(((personalDataManager.etcData % 10000) / 1000).floor() == 3){
      isShowPersonalDataAll = false;
      int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
      if(isShowPersonalDataNum == 1 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 7){
        isShowPersonalName = false;
      } else { isShowPersonalName = true; }
      if(isShowPersonalDataNum == 4 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7){
        isShowPersonalBirth = false;
      } else { isShowPersonalBirth = true; }
    } else {
      isShowPersonalDataAll = true;
    }
  }
  
  @override
  void initState() {
    super.initState();

    memoFocusNode = FocusNode();

    prefixMemo = widget.memo;
    editingName0 = widget.name0;
    String year = '';
    if(widget.birthYear0 < 10){
      year = '000${widget.birthYear0}';
    }
    else if(widget.birthYear0 < 100){
      year = '00${widget.birthYear0}';
    }
    else if(widget.birthYear0 < 10){
      year = '0${widget.birthYear0}';
    }
    else{
      year = '${widget.birthYear0}';
    }
    String month = '';
    if(widget.birthMonth0 < 10){
      month = '0${widget.birthMonth0}';
    }
    else{
      month = '${widget.birthMonth0}';
    }
    String day = '';
    if(widget.birthDay0 < 10){
      day = '0${widget.birthDay0}';
    }
    else{
      day = '${widget.birthDay0}';
    }

    editingBirthDay0 = '${year} ${month} ${day}';
    editingBirthHour0 = widget.birthHour0;
    editingBirthMin0 = widget.birthMin0;
    widget.gender0? editingGender0 = Gender.Male: editingGender0 = Gender.Female;
    widget.gender0? genderState = 0: genderState = 1;
    if(widget.uemYang0 == 0) {
      isUemryoc = false;
      isYundal = false;
    }
    else if(widget.uemYang0 == 1) {
      isUemryoc = true;
      isYundal = false;
    }
    else{ //2
      isUemryoc = true;
      isYundal = true;
    }

    uemYangType0 = widget.uemYang0;
    targetBirthYear = widget.birthYear0;
    targetBirthMonth = widget.birthMonth0;
    targetBirthDay = widget.birthDay0;
    targetBirthHour = widget.birthHour0;
    targetBirthMin = widget.birthMin0;
    gender0 = widget.gender0;
    uemYangText0 = GetUemYangText(widget.uemYang0);

    CheckPersonalDataHide();
  }

  @override
  void didChangeDependencies(){

    super.didChangeDependencies();
  }

  @override
  void deactivate(){
    super.deactivate();

    if(isEditingMemo == 1){
      SetEditingMemo();
    }
  }

  @override
  Widget build(BuildContext context) {

    CheckPersonalDataHide();

    if(isEditWorldCalendarMemo != context.watch<Store>().isEditWorldCalendarMemo){
      int personIndex = saveDataManager.FindMapPersonIndex(editingName0, saveDataManager.ConvertToBirthData(gender0, uemYangType0, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin), widget.saveDate);
      if(memoController.text != saveDataManager.mapPerson[personIndex]['memo'] || prefixMemo != saveDataManager.mapPerson[personIndex]['memo'] || editingMemo != saveDataManager.mapPerson[personIndex]['memo']){
        memoController.text = saveDataManager.mapPerson[personIndex]['memo'];
        prefixMemo = saveDataManager.mapPerson[personIndex]['memo'];
        editingMemo = saveDataManager.mapPerson[personIndex]['memo'];
      }
      isEditWorldCalendarMemo = context.watch<Store>().isEditWorldCalendarMemo;
    }
    if(isEditWorldPersonName != context.watch<Store>().isEditWorldPersonName){
      if(editingName0 == context.watch<Store>().personPrevName && widget.saveDate == context.watch<Store>().personNameSaveDate &&
          saveDataManager.ConvertToBirthData(gender0, uemYangType0, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin) == context.watch<Store>().personBirthData){
        setState(() {
          editingName0 = context.watch<Store>().personNowName;
        });
      }
    isEditWorldPersonName = context.watch<Store>().isEditWorldPersonName;
    }

    return Container(
      width: style.UIButtonWidth + 30,
      margin: EdgeInsets.only(top:style.UIMarginTop, bottom: style.UIMarginTop),
      child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(  //이름
                          width: style.UIButtonWidth * 0.9,
                          height: style.saveDataNameLineHeight,
                          child:Row(
                            children: GetPersonNameAndGanjiText(),
                          ),
                        ),Container(  //생년월일
                          width: style.UIButtonWidth * 0.9,
                          height: style.saveDataMemoLineHeight,
                          //padding: EdgeInsets.only(top:4),
                          child:Row(
                            children: GetPersonBirthText(),
                          ),
                        ),
                      ],
                    ),
                    Container(  //닫기 버튼
                      width: style.UIButtonWidth * 0.1,
                      height: style.saveDataNameLineHeight + style.saveDataMemoLineHeight,
                      alignment: Alignment.topCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.closeOption(false);
                          });
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                        child: Icon(Icons.close, color:Colors.white, size: style.appbarIconSize * 1.2),
                      ),
                    ),
                  ],
                ),
                [
                  Expanded( //
                  child: Column(
                    children:[
                      Container(  //저장일자 제목
                        width: style.UIButtonWidth,
                        height: style.saveDataNameLineHeight,
                        margin: EdgeInsets.only(top: categoryMargin),
                        padding: EdgeInsets.only(top:6),
                        child: Text("저장일자", style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Container( //저장일자 정보
                        width: style.UIButtonWidth,
                        height: style.saveDataMemoLineHeight,
                        child:Text("${widget.saveDate.year}년 ${widget.saveDate.month}월 ${widget.saveDate.day}일", style: Theme.of(context).textTheme.displayMedium),//Theme.of(context).textTheme.displayMedium),
                      ),
                      Container(  //메모 제목
                        width: style.UIButtonWidth,
                        height: style.saveDataNameLineHeight,
                        margin: EdgeInsets.only(top: categoryMargin),
                        padding: EdgeInsets.only(top:6),
                        child: Text("메모", style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: [
                              Container( //메모 본문
                                width: style.UIButtonWidth,
                                alignment: Alignment.topLeft,
                                child:Text(prefixMemo, style: style.memoTextStyle),//Theme.of(context).textTheme.displayMedium),
                              ),
                              Container( //메모 본문 수정
                                width: style.UIButtonWidth,
                                height: 1000,
                                color: style.colorNavy,
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: TextField(
                                    autofocus: true,
                                    controller: memoController,
                                    keyboardType: TextInputType.multiline,
                                    maxLength: 500,
                                    maxLines: null,
                                    focusNode: memoFocusNode,
                                    onTapOutside: (event) {
                                      memoFocusNode.requestFocus();
                                    },
                                    style: style.memoTextStyle,
                                    decoration:InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(top: 5),
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
                            ][isEditingMemo],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  Expanded( //명식 정보 수정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        Container( //이름
                          width: style.UIButtonWidth,
                          height: style.fullSizeButtonHeight,
                          decoration: BoxDecoration(
                            color: style.colorNavy,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child:
                          Row(
                            children:[
                              Container(  //텍스트필드
                                width: style.UIButtonWidth*0.55,//MediaQuery.of(context).size.width * 0.4,
                                height: 50,
                                child: TextField(
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.white,
                                  maxLength: 10,
                                  onEditingComplete:() {
                                    FocusScope.of(context).requestFocus(maleFocusNode);
                                  },
                                  style: Theme.of(context).textTheme.labelLarge,
                                  decoration:InputDecoration(
                                      counterText:"",
                                      border: InputBorder.none,
                                      prefix: Text('    '),
                                      hintText: '이름',
                                      hintStyle: Theme.of(context).textTheme.labelSmall),
                                ),
                              ),
                              Container(
                                width: style.UIButtonWidth*0.45,
                                height: 50,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:[
                                    Radio<Gender>(
                                        visualDensity: const VisualDensity(
                                          horizontal: VisualDensity.minimumDensity,
                                          vertical: VisualDensity.minimumDensity,
                                        ),
                                        value: Gender.Male,
                                        focusNode: maleFocusNode,
                                        groupValue: editingGender0,
                                        fillColor: (genderState == 0) ? MaterialStateColor.resolveWith((states) => style.colorMainBlue) : MaterialStateColor.resolveWith((states) => style.colorGrey) ,
                                        splashRadius: 16,
                                        hoverColor: Colors.white.withOpacity(0.1),
                                        focusColor: Colors.white.withOpacity(0.1),
                                        onChanged: (Gender? value){
                                          setState(() {
                                            genderState = 0;
                                            editingGender0 = value;
                                          });
                                        }
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4),
                                      margin: EdgeInsets.only(left: 4, right: 4),
                                      child:Text("남자 ", style: Theme.of(context).textTheme.labelMedium),),
                                    Radio<Gender>(
                                        visualDensity: const VisualDensity(
                                          horizontal: VisualDensity.minimumDensity,
                                          vertical: VisualDensity.minimumDensity,
                                        ),
                                        value: Gender.Female,
                                        groupValue: editingGender0,
                                        fillColor: (genderState == 1) ? MaterialStateColor.resolveWith((states) => style.colorMainBlue) : MaterialStateColor.resolveWith((states) => style.colorGrey) ,splashRadius: 16,
                                        hoverColor: Colors.white.withOpacity(0.1),
                                        focusColor: Colors.white.withOpacity(0.1),
                                        onChanged: (Gender? value){
                                          setState(() {
                                            genderState = 1;
                                            editingGender0 = value;
                                            SeasonDayMessage();
                                          });
                                        }
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4),
                                      margin: EdgeInsets.only(right: style.UIMarginLeft, left: 4),
                                      child:Text("여자 ", style: Theme.of(context).textTheme.labelMedium),),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ),
                        Container( //생년월일
                          width: style.UIButtonWidth,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(top: style.UIMarginTop),
                          decoration: BoxDecoration(
                            color: style.colorNavy,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child:
                          Row(
                            children:[
                              Container(
                                width: style.UIButtonWidth*0.55,//MediaQuery.of(context).size.width * 0.4,
                                height: 50,
                                child: TextField(
                                  obscureText: isShowPersonalBirth == false? true : false,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: birthController,
                                  focusNode: birthTextFocusNode,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                                    BirthSpacer(),
                                  ],
                                  cursorColor: Colors.white,
                                  maxLength: 10,
                                  style: Theme.of(context).textTheme.labelLarge,
                                  onEditingComplete: () {
                                  FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                                },
                                  decoration:InputDecoration(
                                      counterText:"",
                                      border: InputBorder.none,
                                      prefix: Text('    '),
                                      hintText: '생년월일',// (${DateFormat('yyyy MM dd').format(DateTime.now())})',
                                      hintStyle: Theme.of(context).textTheme.labelSmall),
                                  onChanged: (text){
                                    setState(() {
                                      SeasonDayMessage();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: style.UIButtonWidth*0.45,
                                height: 50,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:[
                                    SizedBox(
                                      width: 32,
                                      height: 50,
                                      child: Checkbox(
                                        value: isUemryoc,
                                        onChanged: (value) {
                                          setState(() {
                                            SetYangrocUemryoc(true, value!);
                                            SeasonDayMessage();
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4),
                                      //margin: EdgeInsets.only(right: marginVal),
                                      child: Text("음력 ", style: Theme.of(context).textTheme.labelMedium),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 50,
                                      child: Checkbox(
                                        value: isYundal,
                                        onChanged: (value) {
                                          setState(() {
                                            SetYangrocUemryoc(false, value!);
                                            SeasonDayMessage();
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 4),
                                      margin: EdgeInsets.only(right: style.UIMarginLeft),
                                      child: Text("윤달 ", style: Theme.of(context).textTheme.labelMedium),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container( //시간
                          width: style.UIButtonWidth,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(top: style.UIMarginTop),
                          decoration: BoxDecoration(
                            color: style.colorNavy,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child:Row(
                            children:[
                              Container(
                                width: style.UIButtonWidth*0.5,//MediaQuery.of(context).size.width * 0.4,
                                height: 50,
                                child: TextField(
                                  focusNode: birthHourTextFocusNode,
                                  obscureText: isShowPersonalBirth == false? true : false,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: hourController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                                    HourSpacer(),],
                                  cursorColor: Colors.white,
                                  maxLength: 5,
                                  style: Theme.of(context).textTheme.labelMedium,
                                  decoration:InputDecoration(
                                      counterText:"",
                                      border: InputBorder.none,
                                      prefix: Text('    '),
                                      hintText: '태어난 시간',
                                      hintStyle: Theme.of(context).textTheme.labelSmall),
                                  onChanged: (text){setState(() {
                                    if(popUpSelect != popUpVal[0]){
                                      popUpSelect = popUpVal[0];
                                    }
                                    SeasonDayMessage();
                                  });
                                  },
                                ),
                              ),
                              Container(
                                width: style.UIButtonWidth*0.5,
                                height: 50,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:[
                                    Container(
                                        padding: EdgeInsets.only(bottom: 4),
                                        margin: EdgeInsets.only(right: style.UIMarginLeft-6),
                                        child:
                                        DropdownButton<String>(
                                            value: popUpSelect,
                                            style: Theme.of(context).textTheme.labelMedium,
                                            menuMaxHeight: MediaQuery.of(context).size.height,
                                            //elevation: 10,
                                            iconSize: 0.0,
                                            underline: SizedBox.shrink(),
                                            dropdownColor: Colors.black,//style.colorMainBlue,//colorBackGround,
                                            items: popUpVal.map((value) => DropdownMenuItem(
                                              value: value,
                                              child:Container(
                                                child: Text(value),
                                                width: style.UIButtonWidth * 0.4,//135,
                                                alignment: Alignment.center,
                                              ),
                                            )).toList(),
                                            onChanged: (value){
                                              setState(() {
                                                popUpSelect = value as String;
                                                hourController.clear();
                                                SeasonDayMessage();
                                              });
                                            }
                                        )
                                    ),
                                  ] ,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child:Container(),
                        ),
                      ],
                    ),
                  ),
                ][isEditingPersonData],
                Column( //옵션 버튼들
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    [
                      Column(
                        children: [
                          Row(  //수정 삭제 버튼
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(  //수정 버튼
                                width: style.UIButtonWidth * 0.32,
                                height: style.fullSizeButtonHeight,
                                margin: EdgeInsets.only(top:style.UIMarginTop),
                                child:ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        SetEditingPersonData();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(padding:EdgeInsets.only(left:0), backgroundColor: style.colorNavy, elevation:0.0, foregroundColor: style.colorBlack, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                                    child: Text('수정', style: Theme.of(context).textTheme.headlineSmall)
                                ),
                              ),
                              Container(  //띄우기
                                width: style.UIButtonWidth * 0.02,
                              ),
                              Container(  //메모 버튼
                                width: style.UIButtonWidth * 0.32,
                                height: style.fullSizeButtonHeight,
                                margin: EdgeInsets.only(top:style.UIMarginTop),
                                child:ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        SetEditingMemo();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorNavy, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                                    child: Text('메모', style: Theme.of(context).textTheme.headlineSmall)
                                ),
                              ),
                              Container(  //여백
                                width: style.UIButtonWidth * 0.02,
                              ),
                              Container(  //삭제 버튼
                                width: style.UIButtonWidth * 0.32,
                                height: style.fullSizeButtonHeight,
                                margin: EdgeInsets.only(top:style.UIMarginTop),
                                child:ElevatedButton(
                                    onPressed: (){
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text("${style.myeongsicString}을 삭제합니다", textAlign: TextAlign.center),
                                            actionsAlignment: MainAxisAlignment.center,
                                            actions:[
                                              ElevatedButton(
                                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                                                  onPressed: () async {
                                                    await saveDataManager.DeletePersonData2(editingName0 == ''?'이름 없음':editingName0, gender0, uemYangType0, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, widget.saveDate);
                                                    setState(() {
                                                      print(saveDataManager.fileDirPath);
                                                    });
                                                    widget.closeOption(false);//widget.closeOption(false,0);
                                                    Navigator.of(context).pop(true);
                                                  },
                                                  child: Text('네')),
                                              ElevatedButton(
                                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                  },
                                                  child: Text('취소')),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorNavy, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                                    child: Text('삭제', style: Theme.of(context).textTheme.headlineSmall)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(  //메모 저장 버튼
                        width: style.UIButtonWidth,
                        height: style.fullSizeButtonHeight,
                        margin: EdgeInsets.only(top:style.UIButtonWidth*0.02),
                        child:ElevatedButton(
                            onPressed: (){
                              setState(() {
                                SetEditingMemo();
                              });
                            },
                            style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorMainBlue, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                            child: Text('메모 저장', style: Theme.of(context).textTheme.headlineSmall)
                        ),
                      ),
                      Container(  //수정 완료 버튼
                        width: style.UIButtonWidth,
                        height: style.fullSizeButtonHeight,
                        margin: EdgeInsets.only(top:style.UIButtonWidth*0.02),
                        decoration: BoxDecoration(
                          color: style.colorMainBlue,
                          borderRadius: BorderRadius.circular(style.textFiledRadius),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.white), overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Text('수정 완료', style:Theme.of(context).textTheme.headlineSmall,),
                          onPressed: () {

                           int prevUemYangType = uemYangType0;
                           int prevBirthYear = targetBirthYear;
                           int prevBirthMonth = targetBirthMonth;
                           int prevBirthDay = targetBirthDay;
                           int prevBirthHour = targetBirthHour;
                           int prevBirthMin = targetBirthMin;
                           String prevName = editingName0;
                           if(editingName0 ==''){
                             prevName = '이름 없음';
                           }

                            if(editingGender0 == Gender.None){
                              ShowDialogMessage('성별을 선택해 주세요');
                              return;
                            }
                            if(birthController.text.length != 10){
                              ShowDialogMessage('생년월일을 모두 입력해 주세요\n형식 : 1987 01 31');
                              return;
                            }

                            targetBirthYear = int.parse(birthController.text.substring(0, 4));
                            targetBirthMonth = int.parse(birthController.text.substring(5, 7));
                            targetBirthDay = int.parse(birthController.text.substring(8, 10));

                            if(BirthDayErrorChecker(targetBirthYear, targetBirthMonth, targetBirthDay) == false){
                              return;
                            }

                            if(hourController.text.length == 0){  //시간모름일 때
                              if(popUpSelect == popUpVal[0]){
                                targetBirthHour = 30; //시간 모름일 때는 30로 정함
                                targetBirthMin = 30;  //분도 30로 정함
                              }
                              else{
                                targetBirthHour = GanjiSelect();
                                targetBirthMin = 30;
                              }
                            }
                            else if(hourController.text.length == 5) {
                              targetBirthHour = int.parse(hourController.text.substring(0, 2));
                              targetBirthMin = int.parse(hourController.text.substring(3, 5));
                              if(BirthHourErrorChecker(targetBirthHour, targetBirthMin) == false){
                                return;
                              }
                            }
                            else{
                              ShowDialogMessage('태어난 시간을 정확히 입력해주세요\n형식 : 07 05');
                              return;
                            }

                            int uemYangType = 0;
                            if(isUemryoc == true){
                              if(isYundal == false){
                                uemYangType = 1;
                              }
                              else{
                                uemYangType = 2;
                              }
                            }

                            bool genderVal = true;
                            if(editingGender0 == Gender.Male){
                              genderVal = true;}
                            else
                              genderVal = false;

                            if(nameController.text == ''){
                              editingName0 = '이름 없음';
                            }
                            else{
                              editingName0 = nameController.text;
                            }

                            saveDataManager.SaveEditedPersonData2(prevName, gender0, prevUemYangType, prevBirthYear, prevBirthMonth, prevBirthDay, prevBirthHour, prevBirthMin, widget.saveDate,
                            editingName0, genderVal, uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);

                            setState(() {
                              editingBirthDay0 = birthController.text;
                              editingBirthHour0 = targetBirthHour;
                              editingBirthMin0 = targetBirthMin;
                              uemYangType0 = uemYangType;
                              gender0 = genderVal;
                              GetBirthTimeText(targetBirthHour, targetBirthMin);
                              SetEditingPersonData();
                              widget.refreshMapPersonLengthAndSort();
                            });
                          },
                        ),
                      ),
                      ][buttonMode]
                  ],
                ),
              ],
            ),
    );
  }
}

class BirthSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue){

    String newText = '';

    if(newValue.selection.baseOffset == 4 || newValue.selection.baseOffset == 7){
      if(newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length-1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length)
      );
    }

    return newValue;
  }
}

class HourSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue){

    String newText = '';

    if(newValue.selection.baseOffset == 2){
      if(newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length-1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length)
      );
    }

    return newValue;
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