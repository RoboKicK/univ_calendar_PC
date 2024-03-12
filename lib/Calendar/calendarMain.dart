import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import '../../findGanji.dart' as findGanji;
import 'mainCalendarInquireResult.dart' as mainCalendarInquireResult;
import '../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import '../CalendarResult/calendarResultBirthTextWidget.dart' as calendarResultBirthTextWidget;  //이름과 생년월일
import 'MainCalendarChange/mainCalendarChange.dart' as mainCalendarChange;
import 'MainCalendarSaveList/mainCalendarSaveList.dart' as mainCalendarSaveList;

class CalendarMain extends StatefulWidget {
  const CalendarMain({super.key, required this.isEditSetting});

  final isEditSetting;

  @override
  State<CalendarMain> createState() => _CalendarMainState();
}

class _CalendarMainState extends State<CalendarMain> {
  List<Map> listKey = [];

  int unlimitedCalendarNum = 0; //달력 번호 무제한으로 매기는 변수

  List<Widget> listCalendarWidget = [];

  ScrollController controller = ScrollController();

  bool isEditSetting = false;

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

  AddCalendarWidget(bool isLeft){  //위젯 추가
    if(listKey.length == 8){
      ShowDialogMessage('만세력은 최대 8개까지만 동시에 사용할 수 있습니다');
      return;
    }
    setState(() {
      Map mapNumAndKey = {'widgetNum':unlimitedCalendarNum, 'globalKey':GlobalKey<_CalendarWidget>()};
      if(isLeft == true){
        listKey.add(mapNumAndKey);
        listCalendarWidget.insert(0, CalendarWidget(key: mapNumAndKey['globalKey'], closeWidget: CloseCalendarWidget, widgetNum: mapNumAndKey['widgetNum'], nowWidgetCount: listKey.length - 1, isEditSetting: isEditSetting, getCalendarWidgetCount: GetCalendarWidgetCount,));
      } else {
        listKey.add(mapNumAndKey);
        listCalendarWidget.add(CalendarWidget(key: mapNumAndKey['globalKey'], closeWidget: CloseCalendarWidget, widgetNum: mapNumAndKey['widgetNum'], nowWidgetCount: listKey.length - 1, isEditSetting: isEditSetting, getCalendarWidgetCount: GetCalendarWidgetCount,));
      }
      unlimitedCalendarNum++;
      for(int i = 0; i < listKey.length; i++){
        listKey[i]['globalKey'].currentState?.SetWidgetWidth(listCalendarWidget.length - 1);
      }
    }
    );
  }

  int GetCalendarWidgetCount(){
    return (listCalendarWidget.length - 1);
  }

  CloseCalendarWidget(int widgetNum){ //위젯 끄기
    if(listCalendarWidget.length == 1){
      return;
    }

    setState(() {
      for(int i = 0; i < listKey.length; i++){
        if(listKey[i]['widgetNum'] == widgetNum){
          for(int j = 0; j < listCalendarWidget.length; j++){
            if(listCalendarWidget[j].key == listKey[i]['globalKey']){
              listCalendarWidget.removeAt(j);
              listKey.removeAt(i);
              break;
            }
          }
          break;
        }
      }

      for(int i = 0; i < listKey.length; i++){
        listKey[i]['globalKey'].currentState?.SetWidgetWidth(listCalendarWidget.length - 1);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    AddCalendarWidget(false);
    isEditSetting = widget.isEditSetting;
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      if(isEditSetting != widget.isEditSetting){
        for(int i = 0; i < listKey.length; i++){
          if(listKey[i]['globalKey'].currentState?.nowState == 1){
            listKey[i]['globalKey'].currentState?.SetCalendarResultWidget();
          }
        }
        isEditSetting = widget.isEditSetting;
      }
    });

    return Container(
        height: MediaQuery.of(context).size.height - 60,
        color: style.colorDarkGrey,
        child:Stack(
          children: [
            ScrollConfiguration(
              behavior: MyCustomScrollBehavior().copyWith(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                child: Row(
                  children: [
                    Container(width:style.marginContainerWidth),
                    Container(
                      child: Row(children: listCalendarWidget),
                    ),
                    Container(width:style.marginContainerWidth),
                  ],//GetWidget(),
                ),
              ),
            ),
            Container(  //위젯 추가 버튼
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 20,
                    height: 40,
                    margin: EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: (){
                        AddCalendarWidget(true);
                      },
                      child: Text('+', style: TextStyle(color:Colors.white)),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),backgroundColor: style.colorMainBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius))),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 40,
                    margin: EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                        onPressed: (){
                          AddCalendarWidget(false);
                        },
                        child: Text('+', style: TextStyle(color:Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),backgroundColor: style.colorMainBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius))),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
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


//여기부터는 달력 위젯
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key, required this.closeWidget, required this.widgetNum, required this.nowWidgetCount, required this.isEditSetting, required this.getCalendarWidgetCount});

  final int widgetNum, nowWidgetCount;
  final closeWidget;
  final bool isEditSetting;
  final getCalendarWidgetCount;

  @override
  State<CalendarWidget> createState() => _CalendarWidget();
}

enum Gender { Male, Female, None }

class _CalendarWidget extends State<CalendarWidget> {
  int widgetNum = 0;

  Gender? gender = Gender.None;
  int genderState = 3;

  var popUpVal = ['간지 선택 ▼', '23:30~01:30 子시', '01:30~03:30 丑시', '03:30~05:30 寅시', '05:30~07:30 卯시', '07:30~09:30 辰시', '09:30~11:30 巳시', '11:30~13:30 午시', '13:30~15:30 未시', '15:30~17:30 申시', '17:30~19:30 酉시', '19:30~21:30 戌시', '21:30~23:30 亥시'];
  var popUpSelect = '간지 선택 ▼', popUpSelect0 = '간지 선택 ▼', popUpSelect1 = '간지 선택 ▼';

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

  String targetName = '';
  int targetBirthYear = 0;
  int targetBirthMonth = 0;
  int targetBirthDay = 0;
  int targetBirthHour = 0; //시간 모름일 때는 -2로 조회한다
  int targetBirthMin = 0;
  int uemYangType = 0; //0: 양력, 1:음력 평달, 2:음력 윤달
  bool isUemryoc = false;

  bool isYundal = false;
  bool genderVal = true;
  bool passVal = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController hourController = TextEditingController();

  String seasonMessageDate = ''; //절입시간 안내할 때 중복 방지용 변수

  String infoText = '생년월일 8자를 입력해 주세요(ex. 1987 01 31)\n'
      '태어난 시간을 4자로 입력해 주세요(ex. 07 05)\n'
      '태어난 시간을 모를 경우 빈칸으로 두세요\n'
      '1901년 이전 명식은 절입시간 오차 가능성이 있습니다';

  bool isShowPersonalBirth = true;

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

  bool BirthHourErrorChecker(int hour, int min) {
    if (hour > 23) {
      ShowDialogMessage('태어난 시간을 정확히 입력해주세요');
      return false;
    }
    if (min > 59) {
      ShowDialogMessage('태어난 분을 정확히 입력해주세요');
      return false;
    }

    return true;
  }

  int GanjiSelect(int targetPopUpSelect) {  // 0: popUpSelect, 1: popUpSelect0, 2: popUpSelect1
    int count = 1;

    String popUpText = '';
    popUpText = popUpSelect;

    while (count < popUpVal.length) {
      if (popUpText == popUpVal[count]) {
        break;
      } else {
        count++;
      }
    }
    return (count - 1) * 2;
  }

  ResetAll() {
    //0:모두, 1:명식1, 2:명식2
    setState(() {
      gender = Gender.None;
      genderState = 3;
      SetGenderRadioButtonColor(gender);
      popUpSelect = '간지 선택 ▼';

      isUemryoc = false;
      isYundal = false;

      nameController.text = '';
      birthController.text = '';
      hourController.text = '';
      gender = Gender.None;
      genderState = 3;

      popUpSelect0 = '간지 선택 ▼';

      targetName = '';
      targetBirthYear = 0;
      targetBirthMonth = 0;
      targetBirthDay = 0;
      targetBirthHour = 0;
      targetBirthMin = 0;
      uemYangType = 0;

      isYundal = false;
      genderVal = true;
      passVal = false;
    });
  }

  bool InqureChecker(bool isInquire) {
    //조회 전에 입력 잘 했는지 확인 isInquire = false 명식교체,true 조회

    if (gender == Gender.None) {
      ShowDialogMessage('성별을 선택해 주세요');
      return false;
    }
    if (birthController.text.length != 10) {
      ShowDialogMessage('생년월일을 모두 입력해 주세요\n형식 : 1987 01 31');
      return false;
    }

    int _targetBirthYear = int.parse(birthController.text.substring(0, 4));
    int _targetBirthMonth = int.parse(birthController.text.substring(5, 7));
    int _targetBirthDay = int.parse(birthController.text.substring(8, 10));

    if (_targetBirthYear < 1901) {
      //아직 1900년 이전은 조회가 안돼요!
      ShowDialogMessage('1901년 이전은 아직 조회가 안됩니다');
      return false;
    }

    if (BirthDayErrorChecker(_targetBirthYear, _targetBirthMonth, _targetBirthDay) == false) {
      return false;
    }

    int _targetBirthHour = 0, _targetBirthMin = 0;
    if (hourController.text.length == 0) {
      //시간모름일 때
      if (popUpSelect == popUpVal[0]) {
        _targetBirthHour = -2; //시간 모름일 때는 -2로 정함
        _targetBirthMin = -2; //분도 -2로 정함
      }
    } else if (hourController.text.length == 5) {
      _targetBirthHour = int.parse(hourController.text.substring(0, 2));
      _targetBirthMin = int.parse(hourController.text.substring(3, 5));
      if (BirthHourErrorChecker(_targetBirthHour, _targetBirthMin) == false) {
        return false;
      }
    } else {
      ShowDialogMessage('태어난 시간을 정확히 입력해주세요\n형식 : 07 05');
      return false;
    }

    int _uemYangType = 0;
    if (isUemryoc == true) {
      if (isYundal == false) {
        _uemYangType = 1;
      } else {
        _uemYangType = 2;
      }
    }

    bool _genderVal = true;
    if (gender == Gender.Male) {
      _genderVal = true;
    } else {
      _genderVal = false;
    }

    String _targetName = '';
    if (nameController.text == '') {
      _targetName = '이름 없음';
    } else {
      _targetName = nameController.text;
    }

    targetName = _targetName;
    //gender = gender;
    genderVal = _genderVal;
    uemYangType = _uemYangType;
    targetBirthYear = _targetBirthYear;
    targetBirthMonth = _targetBirthMonth;
    targetBirthDay = _targetBirthDay;
    targetBirthHour = _targetBirthHour;
    targetBirthMin = _targetBirthMin;

    if(hourController.text.length == 0 && popUpSelect != popUpVal[0]) {
      targetBirthHour = GanjiSelect(0);
      targetBirthMin = 30;
    }

    return true;
  }

  SetYangrocUemryoc(bool isUemYangryoc, bool onOff){
    if(isUemYangryoc == true){  //음력양력 눌렀을 때
      isUemryoc = onOff;
      if(onOff == true){  //음력 켤 때
        uemYangType = 1;
      } else {
        uemYangType = 0;
        isYundal = false;
      }
    } else {  //윤달 눌렀을 때
      if(onOff == true){
        isUemryoc = true;
      }
      isYundal = onOff;
      uemYangType = 2;
    }
  }

  BoxDecoration? personButtonDeco0, personButtonDeco1; //명식 버튼 박스 데코레이션
  BoxDecoration? personListButtonDeco0, personListButtonDeco1; //명식 버튼 안의 불러오기 버튼 박스 데코레이션
  BoxDecoration selectedPersonBoxDeco = BoxDecoration(
    color: style.colorMainBlue,
    borderRadius: BorderRadius.circular(style.textFiledRadius),
  );
  BoxDecoration noneSelectedPersonBoxDeco = BoxDecoration(
    color: style.colorGrey,
    border: Border.all(color: Colors.white, width: 4),
    borderRadius: BorderRadius.circular(style.textFiledRadius),
  );
  BoxDecoration selectedPersonBoxListButtonDeco = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
  );
  BoxDecoration nonSelectedPersonBoxListButtonDeco = BoxDecoration(
    color: style.colorGrey,
    borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
  );
  Color? personListButtonColor0, personListButtonColor1;

  MaterialStateColor? genderColorMale, genderColorFemale;

  double widgetWidth = 1200;

  Widget closeButtonWidget = SizedBox(width: 50,height: 50,);
  Widget backButtonWidget = SizedBox.shrink();
  Widget saveButtonWidget = SizedBox(width: 100,height: 50,);
  Widget calendarResultWidget = SizedBox.shrink();
  Widget calendarChangeWidget = SizedBox.shrink();
  Widget calendarSaveListWidget = SizedBox.shrink();
  Widget calendarRecentListWidget = SizedBox.shrink();
  Widget calendarBirthTextWidget = SizedBox.shrink();

  int nowState = 0; //0:만세력 입력화면, 1:만세력 조회화면
  bool isEditSetting = false;

  FocusNode maleFocusNode = FocusNode();
  FocusNode femaleFocusNode = FocusNode();
  FocusNode birthTextFocusNode = FocusNode();
  FocusNode birthHourTextFocusNode = FocusNode();

  String personMemo = '';
  String personDataNum = '';

  int nowUnderLine = 0;
  var nowCalendarHeadLine = 0;
  List<Text> listCalendarTexts = [];
  var underLineOpacity = [1.0,0.0,0.0,0.0];
  List<String> calendarHeadLineTitle = ['조회하기', '간지변환', '저장목록', '최근목록'];
  List<Color> listCalendarTextColor = [Colors.white, style.colorGrey, style.colorGrey, style.colorGrey];
  double sizedBoxWidth = 16;  //헤드라인 사이 빈칸 크기

  int isSaved = 1; //저장되어 있는 명식인가? 0:네, 1:아니오

  //헤드라인 눌렀을 때
  HeadLineButtonAction(int buttonNum) {
    setState(() {
      if(buttonNum == nowCalendarHeadLine){
        return;
      }

      listCalendarTexts[nowCalendarHeadLine] = Text(calendarHeadLineTitle[nowCalendarHeadLine], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorGrey));
      listCalendarTexts[buttonNum] = Text(calendarHeadLineTitle[buttonNum], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white));

      underLineOpacity[nowCalendarHeadLine] = 0.0;
      underLineOpacity[buttonNum] = 1.0;

      nowCalendarHeadLine = buttonNum;
    });
  }

  //위젯 가로 크기 정하기
  SetWidgetWidth(int widgetCount){
    setState(() {
        if (widgetCount == 0) {
          widgetWidth = MediaQuery.of(context).size.width - 60 - 8; //1200;
        } else if (widgetCount == 1) {
          widgetWidth = ((MediaQuery.of(context).size.width - 60) * 0.5) - 8; //596;
        } else if (widgetCount == 2) {
          widgetWidth = widgetWidth = ((MediaQuery.of(context).size.width - 60) * 0.33333333) - 8; //596;//440; //394.4;
        } else {
          widgetWidth = widgetWidth = ((MediaQuery.of(context).size.width - 60) * 0.25) - 8;//440; //394.4;
        }

        if(widgetWidth < 440){
          widgetWidth = 440;
        }

      SetWidgetCloseButton(widgetCount);
      if(nowState == 1){
        SetCalendarResultWidget();
      }
    });
  }

  //위젯 닫기 버튼 설정
  SetWidgetCloseButton(int widgetCount){
    if(widgetCount == 0){
      closeButtonWidget = SizedBox(width: 50,height: 50,);
    } else {
      closeButtonWidget = Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(top:0, right:10),
        child:
        ElevatedButton(
          onPressed: (){
            widget.closeWidget(widgetNum);
          },
          child: Icon(Icons.close, color: Colors.white),//Text('×', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),Icon(Icons.close),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
        ),
      );
    }
  }

  //뒤로가기 버튼 설정
  SetWidgetBackButton(){
    if(nowState == 0){
      backButtonWidget = SizedBox.shrink();
    } else {
      backButtonWidget = Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(top:0, left:10),
        child:
        ElevatedButton(
          onPressed: (){
            BackButtonAction();
          },
          child: Icon(Icons.arrow_back, color:Colors.white),//Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
        ),
      );
    }
  }

  //저장 버튼 설정
  SetWidgetSaveButton(){
    if(nowState == 1){
      saveButtonWidget = Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(top:0, right:10),
        child:
        ElevatedButton(
          onPressed: (){
            bool isSamePerson = saveDataManager.SavePersonIsSameChecker(targetName, genderVal==true? '남':'여', uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin, ShowSameCheckerMessage);

            if(isSamePerson == true){
              saveDataManager.SavePersonData(targetName, genderVal==true?'남':'여', uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);
              setState(() {
                isSaved = 0;
              });
            }
          },
          child: Icon(Icons.save, color:Colors.white),//Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent),
        ),
      );
    } else {
      saveButtonWidget = SizedBox(width: 50,height: 50,);
    }
  }

  ShowSameCheckerMessage(String birth){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('이미 같은 명식이 저장되어 있습니다\n그래도 저장하시겠습니까?'),
          content: Text(birth, textAlign: TextAlign.center),
          buttonPadding: EdgeInsets.only(left:20, right:20, top:0),
          actions: [
            ElevatedButton(
                onPressed: (){
                  saveDataManager.SavePersonData(targetName, genderVal==true?'남':'여', uemYangType, targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);
                  setState(() {
                    isSaved = 0;
                  });
                  Navigator.pop(context);
                },
                child: Text('저장')),
            ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('취소')),
          ],
        ));
  }

  //뒤로가기 버튼 기능
  BackButtonAction(){
    if(nowState == 1){  //만세력 조회 화면이면 최초 화면으로 간다
      setState(() {
        nowState = 0;
        calendarResultWidget = SizedBox.shrink();
        SetWidgetCalendarResultBirthText();
        SetWidgetSaveButton();
        SetWidgetBackButton();
      });
    }
  }

  //만세력 이름 위젯 설정
  SetWidgetCalendarResultBirthText(){
    if(nowState == 0){
      calendarBirthTextWidget = SizedBox.shrink();
    } else if(nowState == 1){
      calendarBirthTextWidget = calendarResultBirthTextWidget.CalendarResultBirthTextWidget(
          name: targetName,
          gender: genderVal ? '남' : '여',
          uemYang: uemYangType,
          birthYear: targetBirthYear,
          birthMonth: targetBirthMonth,
          birthDay: targetBirthDay,
          birthHour: targetBirthHour,
          birthMin: targetBirthMin,
          isShowDrawerManOld: 0,
        widgetWidth: widgetWidth,
        isOneWidget: (widgetWidth > (MediaQuery.of(context).size.width * 0.6))? true : false,
      );//isShowDrawerManOld);
    }
  }

  SetGenderRadioButtonColor(Gender? button) {
    if (button == Gender.Male) {
      genderColorMale = MaterialStateColor.resolveWith((states) => style.colorMainBlue);
      genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorGrey);
    } else if (button == Gender.Female) {
      genderColorMale = MaterialStateColor.resolveWith((states) => style.colorGrey);
      genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorMainBlue);
    } else {
      genderColorMale = MaterialStateColor.resolveWith((states) => style.colorGrey);
      genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorGrey);
    }
  }

  //만세력 조회 화면 생성
  SetCalendarResultWidget(){
    nowState = 1;
    isEditSetting = !isEditSetting;
    setState(() {
      double _widgetWidth = widgetWidth;
      calendarResultWidget = mainCalendarInquireResult.MainCalendarInquireResult(
        name: targetName, gender: genderVal, uemYang: uemYangType, birthYear: targetBirthYear, birthMonth: targetBirthMonth,
        birthDay: targetBirthDay, birthHour: targetBirthHour, birthMin: targetBirthMin, memo: '', saveDataNum: '', widgetWidth: _widgetWidth, isEditSetting: isEditSetting);
      SetWidgetBackButton();
      SetWidgetSaveButton();
      SetWidgetCalendarResultBirthText();
    });
  }

  //다른 위젯에서 조회 정보 입력
  SetInquireInfo(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, String memo, String saveDataNum){
    targetName = name;
    genderVal = gender;
    uemYangType = uemYang;
    targetBirthYear = birthYear;
    targetBirthMonth = birthMonth;
    targetBirthDay = birthDay;
    targetBirthHour = birthHour;
    targetBirthMin = birthMin;
    personMemo = memo;
    personDataNum = saveDataNum;
  }

  @override
  void initState() {
    super.initState();

    genderColorMale = MaterialStateColor.resolveWith((states) => style.colorGrey);
    genderColorFemale = MaterialStateColor.resolveWith((states) => style.colorGrey);

    widgetNum = widget.widgetNum;
    isEditSetting = widget.isEditSetting;

    listCalendarTexts.add(Text(calendarHeadLineTitle[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[0]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[1], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[1]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[2], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[2]), ));
    listCalendarTexts.add(Text(calendarHeadLineTitle[3], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listCalendarTextColor[3]), ));
  }

  @override void didChangeDependencies() {  //initState 끝나고 실행됨

    SetWidgetWidth(widget.nowWidgetCount);
    super.didChangeDependencies();
  }

  @override
  void deactivate() { //꺼질 때 실행됨

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {

    SetWidgetWidth(widget.getCalendarWidgetCount());

    return Container(
      width: widgetWidth,
      margin: EdgeInsets.only(left:4, right:4, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: style.colorBackGround,
          borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius))
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Stack(
            children: [
              //뒤로 버튼과 닫기 버튼
              Container(
                width: widgetWidth,
                height: 50,
                //color: Colors.yellow,
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backButtonWidget,
                    Container(
                      //color:Colors.green,
                      width: widgetWidth - 150,
                      height: 50,
                      child: calendarBirthTextWidget,
                    ),
                    saveButtonWidget,
                    closeButtonWidget,
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children:[
              Column(
                children: [
                  Row(  //헤드라인 글자
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Container(
                          height: style.headLineHeight,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[0])))),
                          child: TextButton(
                              style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                              child:listCalendarTexts[0]
                              , onPressed:(){HeadLineButtonAction(0);})
                      ),
                      SizedBox(
                        width: sizedBoxWidth,
                      ),
                      Container(
                          height: style.headLineHeight,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[1])))),
                          child:TextButton(
                              style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                              child:listCalendarTexts[1]
                              , onPressed:(){HeadLineButtonAction(1);})
                      ),
                      SizedBox(
                        width: sizedBoxWidth,
                      ),
                      Container(
                          height: style.headLineHeight,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[2])))),
                          child:TextButton(
                              style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                              child:listCalendarTexts[2]
                              , onPressed:(){HeadLineButtonAction(2);})
                      ),
                      SizedBox(
                        width: sizedBoxWidth,
                      ),
                      Container(
                          height: style.headLineHeight,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[3])))),
                          child:TextButton(
                              style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
                              child:listCalendarTexts[3]
                              , onPressed:(){HeadLineButtonAction(3);})
                      )],
                  ),
                  Stack(
                    children: [
                      [
                        Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            //이름
                            width: style.UIButtonWidth,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(top: style.UIMarginTopTop),
                            decoration: BoxDecoration(
                              //border: Border.all(color: focusBoxColorNum == 0? style.colorMainBlue:Colors.transparent, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                              color: style.colorNavy,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  //이름 텍스트필드
                                  width: style.UIButtonWidth * 0.55, //MediaQuery.of(context).size.width * 0.4,
                                  height: 50,
                                  child: TextField(
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.white,
                                    maxLength: 10,
                                    onEditingComplete:() {
                                      FocusScope.of(context).requestFocus(maleFocusNode);
                                    },
                                    style: Theme.of(context).textTheme.labelLarge,
                                    decoration: InputDecoration(counterText: "", border: InputBorder.none, prefix: Text('    '), hintText: '이름', hintStyle: Theme.of(context).textTheme.labelSmall,),
                                  ),
                                ),
                                Container(
                                  width: style.UIButtonWidth * 0.45,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Radio<Gender>(//남자 버튼
                                          visualDensity: const VisualDensity(
                                            horizontal: VisualDensity.minimumDensity,
                                            vertical: VisualDensity.minimumDensity,
                                          ),
                                          value: Gender.Male,
                                          focusNode: maleFocusNode,
                                          groupValue: gender,
                                          fillColor: genderColorMale,
                                          splashRadius: 16,
                                          hoverColor: Colors.white.withOpacity(0.1),
                                          focusColor: Colors.white.withOpacity(0.1),
                                          onChanged: (Gender? value) {
                                            setState(() {
                                              genderState = 0;
                                              gender = value;
                                              SetGenderRadioButtonColor(value);
                                              FocusScope.of(context).requestFocus(birthTextFocusNode);
                                            });
                                          }),
                                      Container(
                                        padding: EdgeInsets.only(bottom: style.UIPaddingBottom),
                                        margin: EdgeInsets.only(left: 4, right: 4),
                                        child: Text("남자 ", style: Theme.of(context).textTheme.labelMedium),
                                      ),
                                      Radio<Gender>(
                                        //여자 버튼
                                          visualDensity: const VisualDensity(
                                            horizontal: VisualDensity.minimumDensity,
                                            vertical: VisualDensity.minimumDensity,
                                          ),
                                          value: Gender.Female,
                                          groupValue: gender,
                                          fillColor: genderColorFemale,
                                          focusNode: femaleFocusNode,
                                          splashRadius: 16,
                                          hoverColor: Colors.white.withOpacity(0.1),
                                          focusColor: Colors.white.withOpacity(0.1),
                                          onChanged: (Gender? value) {
                                            setState(() {
                                              genderState = 1;
                                              gender = value;
                                              SetGenderRadioButtonColor(value);
                                              FocusScope.of(context).requestFocus(birthTextFocusNode);
                                            });
                                          }),
                                      Container(
                                        padding: EdgeInsets.only(bottom: style.UIPaddingBottom),
                                        margin: EdgeInsets.only(right: style.UIMarginLeft, left: 4),
                                        child: Text("여자 ", style: Theme.of(context).textTheme.labelMedium),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), //이름
                          Container(
                            //생년월일
                            width: style.UIButtonWidth,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(top: style.UIMarginTop),
                            decoration: BoxDecoration(
                              color: style.colorNavy,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: style.UIButtonWidth * 0.55, //MediaQuery.of(context).size.width * 0.4,
                                  height: 50,
                                  child: TextField(
                                    obscureText: isShowPersonalBirth == false? true : false,
                                    focusNode: birthTextFocusNode,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: birthController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                                      BirthSpacer(),
                                    ],
                                    cursorColor: Colors.white,
                                    maxLength: 10,
                                    style: Theme.of(context).textTheme.labelLarge,
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      prefix: Text('    '),
                                      hintText: '생년월일', // (${DateFormat('yyyy MM dd').format(DateTime.now())})',
                                      hintStyle: Theme.of(context).textTheme.labelSmall,),
                                    onChanged: (text) {
                                      setState(() {
                                        SeasonDayMessage();
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width: style.UIButtonWidth * 0.45,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
                                        padding: EdgeInsets.only(bottom: style.UIPaddingBottom),
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
                                        padding: EdgeInsets.only(bottom: style.UIPaddingBottom),
                                        margin: EdgeInsets.only(right: style.UIMarginLeft),
                                        child: Text("윤달 ", style: Theme.of(context).textTheme.labelMedium),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), //생년월일
                          Container(
                            //시간
                            width: style.UIButtonWidth,
                            height: style.fullSizeButtonHeight,
                            margin: EdgeInsets.only(top: style.UIMarginTop),
                            decoration: BoxDecoration(
                              color: style.colorNavy,
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: style.UIButtonWidth * 0.5,
                                  height: 50,
                                  child: TextField(
                                    focusNode: birthHourTextFocusNode,
                                    obscureText: isShowPersonalBirth == false? true : false,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: hourController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                                      HourSpacer(),
                                    ],
                                    cursorColor: Colors.white,
                                    maxLength: 5,
                                    style: Theme.of(context).textTheme.labelLarge,
                                    decoration: InputDecoration(counterText: "", border: InputBorder.none, prefix: Text('    '), hintText: '태어난 시간', hintStyle: Theme.of(context).textTheme.labelSmall,),
                                    onEditingComplete: () {
                                      if (InqureChecker(true) == true) {
                                        SetCalendarResultWidget();
                                      }
                                    },
                                    onChanged: (text) {
                                      setState(() {
                                        if (popUpSelect != popUpVal[0]) {
                                          popUpSelect = popUpVal[0];
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  //간지 선택 버튼
                                  width: style.UIButtonWidth * 0.5,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(bottom: style.UIPaddingBottom),
                                          margin: EdgeInsets.only(right: style.UIMarginLeft - 6),
                                          child: DropdownButton<String>(
                                              value: popUpSelect,
                                              style: Theme.of(context).textTheme.labelMedium,
                                              menuMaxHeight: MediaQuery.of(context).size.height,
                                              focusColor: Colors.white.withOpacity(1),
                                              iconSize: 0.0,
                                              underline: SizedBox.shrink(),
                                              dropdownColor: Colors.black, //style.colorMainBlue,//colorBackGround,
                                              items: popUpVal
                                                  .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Container(
                                                  child: Text(value),
                                                  width: style.UIButtonWidth * 0.4, //135,
                                                  alignment: Alignment.center,
                                                ),
                                              ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  popUpSelect = value as String;
                                                  hourController.clear();
                                                });
                                              })),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), //시간
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                //조회버튼
                                width: style.UIButtonWidth - style.fullSizeButtonHeight - style.UIMarginTop,
                                height: style.fullSizeButtonHeight,
                                margin: EdgeInsets.only(top: style.UIButtonPaddingTop),
                                decoration: BoxDecoration(
                                  color: style.colorMainBlue,
                                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    '조회',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  onPressed: () {
                                    if (InqureChecker(true) == true) {
                                      SetCalendarResultWidget();
                                    }

                                    return;
                                  },
                                ),
                              ),
                              Container(
                                //리셋 버튼
                                width: style.fullSizeButtonHeight,
                                height: style.fullSizeButtonHeight,
                                margin: EdgeInsets.only(left: style.UIMarginLeft, top: style.UIButtonPaddingTop),
                                decoration: BoxDecoration(
                                  color: style.colorMainBlue,
                                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                                ),
                                child:  ElevatedButton(
                                  style:  ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(style.colorMainBlue),
                                    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                                    //overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                                    elevation: MaterialStatePropertyAll(0),
                                  ),
                                  child:Icon(Icons.recycling,),
                                  onPressed: () {
                                    setState(() {
                                      ResetAll();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ), //조회 버튼
                          Container(
                            //단일 조회 안내문
                            width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                            margin: EdgeInsets.only(top: 30),
                            padding: EdgeInsets.all(style.UIMarginLeft),
                            //height: style.fullSizeButtonHeight * 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(style.textFiledRadius),
                              //border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              '',//infoText,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ],
                      ),
                        Container(
                            width: widgetWidth,
                            height: MediaQuery.of(context).size.height - 60 - 16 - 50 - 44,
                            child:
                            mainCalendarChange.MainCalendarChange(SetInquireInfo: SetInquireInfo, SetCalendarResultWidget: SetCalendarResultWidget)
                        ),
                        Container(
                            width: widgetWidth,
                            height: MediaQuery.of(context).size.height - 60 - 16 - 50 - 44,
                            child:
                            mainCalendarSaveList.MainCalendarSaveList(SetInquireInfo: SetInquireInfo, SetCalendarResultWidget: SetCalendarResultWidget)
                        ),
                        SizedBox.shrink(),
                      ][nowCalendarHeadLine],
                    ],
                  ),
                ],
              ),
              calendarResultWidget
            ]
          ),
        ],
      ),
    );
  }
}

class BirthSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 4 || newValue.selection.baseOffset == 7) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(text: newText, selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}

class HourSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 2) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(text: newText, selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}