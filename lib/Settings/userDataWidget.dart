import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import '../findGanji.dart' as findGanji;
import 'personalDataManager.dart' as personalDataManager;
import '../findGanji.dart' as findGanji;
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';

class UserDataWidget extends StatefulWidget {
  const UserDataWidget({super.key, required this.diaryFirstSet, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting, required this.refreshDiaryUserData});

  final diaryFirstSet;
  final double widgetWidth;
  final double widgetHeight;
  final reloadSetting;
  final refreshDiaryUserData;

  @override
  State<UserDataWidget> createState() => _UserDataState();
}

enum Gender { Male, Female, None }

//사용자 설정
class _UserDataState extends State<UserDataWidget> {
  Gender? gender = Gender.None;
  int genderState = 3;

  var popUpVal = [
    '간지 선택 ▼',
    '23:30 ~ 01:30 子시',
    '01:30 ~ 03:30 丑시',
    '03:30 ~ 05:30 寅시',
    '05:30 ~ 07:30 卯시',
    '07:30 ~ 09:30 辰시',
    '09:30 ~ 11:30 巳시',
    '11:30 ~ 13:30 午시',
    '13:30 ~ 15:30 未시',
    '15:30 ~ 17:30 申시',
    '17:30 ~ 19:30 酉시',
    '19:30 ~ 21:30 戌시',
    '21:30 ~ 23:30 亥시'
  ];
  var popUpSelect = '간지 선택 ▼';

  ShowDialogMessage(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
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
  int targetBirthHour = 0;
  int targetBirthMin = 0;
  int uemYangType = 0;

  Color uemPyeongYunColor = style.colorGrey;
  bool isUemryoc = false;
  bool isYundal = false;
  bool genderVal = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController hourController = TextEditingController();

  String seasonMessageDate = ''; //절입시간 안내할 때 중복 방지용 변수

  int editingUserData = 0;

  FocusNode nameTextFocusNode = FocusNode();
  FocusNode maleFocusNode = FocusNode();
  FocusNode femaleFocusNode = FocusNode();
  FocusNode birthTextFocusNode = FocusNode();
  FocusNode birthHourTextFocusNode = FocusNode();

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

  int GanjiSelect() {
    int count = 1;

    while (count < popUpVal.length) {
      if (popUpSelect == popUpVal[count]) {
        break;
      } else {
        count++;
      }
    }
    return (count - 1) * 2;
  }

  ResetAll() {
    setState(() {
      gender = Gender.None;
      genderState = 3;
      popUpSelect = '간지 선택 ▼';

      uemPyeongYunColor = style.colorGrey;
      isUemryoc = false;
      isYundal = false;

      nameController.text = '';
      birthController.text = '';
      hourController.text = '';
    });
  }

  bool InqureChecker(bool isInquire) {
    //조회 전에 입력 잘 했는지 확인 isInquire = false 명식교체,true 조회
    bool passVal = true;

    if (gender == Gender.None) {
      ShowDialogMessage('성별을 선택해 주세요');
      return false;
    }
    if (birthController.text.length != 10) {
      ShowDialogMessage('생년월일을 모두 입력해 주세요\n형식 : 1987 01 31');
      return false;
    }

    targetBirthYear = int.parse(birthController.text.substring(0, 4));
    targetBirthMonth = int.parse(birthController.text.substring(5, 7));
    targetBirthDay = int.parse(birthController.text.substring(8, 10));

    if(targetBirthYear <= DateTime.now().year - 99){
      ShowDialogMessage('99세 이상의 사람은 등록할 수 없습니다');
      return false;
    }
    if (BirthDayErrorChecker(
        targetBirthYear, targetBirthMonth, targetBirthDay) ==
        false) {
      return false;
    }

    if (hourController.text.length == 0) {
      //시간모름일 때
      if (popUpSelect == popUpVal[0]) {
        targetBirthHour = 30; //시간 모름일 때는 30로 정함
        targetBirthMin = 30; //분도 30로 정함
      } else {
        targetBirthHour = GanjiSelect();
        targetBirthMin = 30;
      }
    } else if (hourController.text.length == 5) {
      targetBirthHour = int.parse(hourController.text.substring(0, 2));
      targetBirthMin = int.parse(hourController.text.substring(3, 5));
      if (BirthHourErrorChecker(targetBirthHour, targetBirthMin) == false) {
        return false;
      }
    } else {
      ShowDialogMessage('태어난 시간을 정확히 입력해주세요\n형식 : 07 05');
      return false;
    }

    if (isUemryoc == true) {
      if (isYundal == false) {
        uemYangType = 1;
      } else {
        uemYangType = 2;
      }
    } else {
      uemYangType = 0;
    }

    if (gender == Gender.Male) {
      genderVal = true;
    } else {
      genderVal = false;
    }

    if (nameController.text == '') {
      targetName = '이름 없음';
    } else {
      targetName = nameController.text;
    }

    //여기까지가 에러 체크
    return passVal;
  }

  @override
  initState(){
    super.initState();

    if (personalDataManager.mapUserData['birthYear'] != null) {
      nameController.text = personalDataManager.mapUserData['name'];
      String birthYear = '';
      if (personalDataManager.mapUserData['birthYear'] < 10) {
        birthYear = '000${personalDataManager.mapUserData['birthYear']}';
      } else if (personalDataManager.mapUserData['birthYear'] < 100) {
        birthYear = '00${personalDataManager.mapUserData['birthYear']}';
      } else if (personalDataManager.mapUserData['birthYear'] < 1000) {
        birthYear = '0${personalDataManager.mapUserData['birthYear']}';
      } else {
        birthYear = '${personalDataManager.mapUserData['birthYear']}';
      }
      String birthMonth = '';
      if (personalDataManager.mapUserData['birthMonth'] < 10) {
        birthMonth = '0${personalDataManager.mapUserData['birthMonth']}';
      } else {
        birthMonth = '${personalDataManager.mapUserData['birthMonth']}';
      }
      String birthDay = '';
      if (personalDataManager.mapUserData['birthDay'] < 10) {
        birthDay = '0${personalDataManager.mapUserData['birthDay']}';
      } else {
        birthDay = '${personalDataManager.mapUserData['birthDay']}';
      }
      birthController.text = birthYear + ' ' + birthMonth + ' ' + birthDay;

      String birthHour = '';
      if (personalDataManager.mapUserData['birthHour'] == 30) {
        hourController.text = '';
      } else {
        if (personalDataManager.mapUserData['birthHour'] < 10) {
          birthHour = '0${personalDataManager.mapUserData['birthHour']}';
        } else {
          birthHour = '${personalDataManager.mapUserData['birthHour']}';
        }
        String birthMin = '';
        if (personalDataManager.mapUserData['birthMin'] < 10) {
          birthMin = '0${personalDataManager.mapUserData['birthMin']}';
        } else {
          birthMin = '${personalDataManager.mapUserData['birthMin']}';
        }
        hourController.text = birthHour + ' ' + birthMin;
      }
      if (personalDataManager.mapUserData['gender'] == true) {
        gender = Gender.Male;
        genderState = 0;
      } else {
        gender = Gender.Female;
        genderState = 1;
      }

      if (personalDataManager.mapUserData['uemYang'] == 0) {
        isUemryoc = false;
        isYundal = false;
      } else if (personalDataManager.mapUserData['uemYang'] == 1) {
        isUemryoc = true;
        isYundal = false;
      } else {
        isUemryoc = true;
        isYundal = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.widgetWidth,//MediaQuery.of(context).size.width,
      height: widget.widgetHeight,
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
              child:Text('사용자 등록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
            ),
            Container(
              //이름
              width: style.UIButtonWidth,
              height: style.fullSizeButtonHeight,
              margin: EdgeInsets.only(top: style.UIMarginTop),
              decoration: BoxDecoration(
                color: style.colorNavy,
                borderRadius:
                BorderRadius.circular(style.textFiledRadius),
              ),
              child: Row(
                children: [
                  Container(
                    //이름 텍스트필드
                    width: style.UIButtonWidth * 0.55,
                    height: 50,
                    child: TextField(
                      focusNode: nameTextFocusNode,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      maxLength: 10,
                      onEditingComplete:() {
                        if(genderState == 3) {
                          FocusScope.of(context).requestFocus(maleFocusNode);
                        } else if(birthController.text == '') {
                          FocusScope.of(context).requestFocus(birthTextFocusNode);
                        } else if(hourController.text == ''){
                          FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                        }
                      },
                      style:
                      Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          prefix: Text('    '),
                          hintText: '이름',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall),
                    ),
                  ),
                  Container(
                    width: style.UIButtonWidth * 0.45,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Radio<Gender>(
                          //남자 버튼
                            visualDensity: const VisualDensity(
                              horizontal:
                              VisualDensity.minimumDensity,
                              vertical:
                              VisualDensity.minimumDensity,
                            ),
                            value: Gender.Male,
                            focusNode: maleFocusNode,
                            groupValue: gender,
                            fillColor: gender == Gender.Male
                                ? WidgetStateColor.resolveWith(
                                    (states) => style.colorMainBlue)
                                : WidgetStateColor.resolveWith(
                                    (states) => style.colorGrey),
                            splashRadius: 16,
                            hoverColor: Colors.white.withOpacity(0.1),
                            focusColor: Colors.white.withOpacity(0.1),
                            onChanged: (Gender? value) {
                              setState(() {
                                genderState = 0;
                                gender = value;
                                //SetGenderRadioButtonColor(value);
                                if(nameController.text == ''){
                                  FocusScope.of(context).requestFocus(nameTextFocusNode);
                                } else if(birthController.text == '') {
                                  FocusScope.of(context).requestFocus(birthTextFocusNode);
                                } else if(hourController.text == ''){
                                  FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                                }
                              });
                            }),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: style.UIPaddingBottom),
                          margin: EdgeInsets.only(left: 4, right: 4),
                          child: Text("남자 ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium),
                        ),
                        Radio<Gender>(
                          //여자 버튼
                            visualDensity: const VisualDensity(
                              horizontal:
                              VisualDensity.minimumDensity,
                              vertical:
                              VisualDensity.minimumDensity,
                            ),
                            value: Gender.Female,
                            groupValue: gender,
                            fillColor: gender == Gender.Female
                                ? WidgetStateColor.resolveWith(
                                    (states) => style.colorMainBlue)
                                : WidgetStateColor.resolveWith(
                                    (states) => style.colorGrey),
                            focusNode: femaleFocusNode,
                            splashRadius: 16,
                            hoverColor: Colors.white.withOpacity(0.1),
                            focusColor: Colors.white.withOpacity(0.1),

                            onChanged: (Gender? value) {
                              setState(() {
                                genderState = 1;
                                gender = value;
                                if(nameController.text == ''){
                                  FocusScope.of(context).requestFocus(nameTextFocusNode);
                                } else if(birthController.text == '') {
                                  FocusScope.of(context).requestFocus(birthTextFocusNode);
                                } else if(hourController.text == ''){
                                  FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                                }
                              });
                            }),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: style.UIPaddingBottom),
                          margin: EdgeInsets.only(
                              right: style.UIMarginLeft, left: 4),
                          child: Text("여자 ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //생년월일
              width: style.UIButtonWidth,
              height: style.fullSizeButtonHeight,
              margin: EdgeInsets.only(top: style.UIMarginTop),
              decoration: BoxDecoration(
                color: style.colorNavy,
                borderRadius:
                BorderRadius.circular(style.textFiledRadius),
              ),
              child: Row(
                children: [
                  Container(
                    width: style.UIButtonWidth * 0.55,
                    height: 50,
                    child: TextField(
                      focusNode: birthTextFocusNode,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: birthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9 ]')),
                        BirthSpacer(),
                      ],
                      cursorColor: Colors.white,
                      maxLength: 10,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(birthHourTextFocusNode);
                      },
                      style:
                      Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          prefix: Text('    '),
                          hintText:
                          '생년월일', // (${DateFormat('yyyy MM dd').format(DateTime.now())})',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall),
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
                            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
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
                            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
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
            ),
            Container(
              //시간
              width: style.UIButtonWidth,
              height: style.fullSizeButtonHeight,
              margin: EdgeInsets.only(top: style.UIMarginTop),
              decoration: BoxDecoration(
                color: style.colorNavy,
                borderRadius:
                BorderRadius.circular(style.textFiledRadius),
              ),
              child: Row(
                children: [
                  Container(
                    width: style.UIButtonWidth * 0.5,
                    height: 50,
                    child: TextField(
                      focusNode: birthHourTextFocusNode,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: hourController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9 ]')),
                        HourSpacer(),
                      ],
                      cursorColor: Colors.white,
                      maxLength: 5,
                      style:
                      Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          prefix: Text('    '),
                          hintText: '태어난 시간',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall),
                      onEditingComplete: () {
                        if (InqureChecker(true) == true) {
                          List<int> listPaljaData = [];
                          List<int> listBirthLunarToSolar;
                          if(targetBirthYear > 1900){ //1900년 이후 출생은 findGanji로 팔자를 뽑는다
                            if(uemYangType == 0){ //양력
                              listPaljaData = findGanji.InquireGanji(targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);
                            }
                            else{
                              if(uemYangType == 1){
                                listBirthLunarToSolar = findGanji.LunarToSolar(targetBirthYear, targetBirthMonth, targetBirthDay, false);
                                listPaljaData = findGanji.InquireGanji(listBirthLunarToSolar[0], listBirthLunarToSolar[1], listBirthLunarToSolar[2], targetBirthHour, targetBirthMin);
                              }
                              else{
                                listBirthLunarToSolar = findGanji.LunarToSolar(targetBirthYear, targetBirthMonth, targetBirthDay, true);
                                listPaljaData = findGanji.InquireGanji(listBirthLunarToSolar[0], listBirthLunarToSolar[1], listBirthLunarToSolar[2], targetBirthHour, targetBirthMin);
                              }
                            }
                          }
                          else{

                          }

                          personalDataManager.SaveUserData(
                              targetName,
                              gender == Gender.Male ? true : false,
                              uemYangType,
                              targetBirthYear,
                              targetBirthMonth,
                              targetBirthDay,
                              targetBirthHour,
                              targetBirthMin,
                              listPaljaData,
                              diaryFirstSet: widget.diaryFirstSet
                          );

                          widget.refreshDiaryUserData();

                          SnackBar snackBar = SnackBar(
                            content: Text("사용자 정보가 저장되었습니다", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
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
                            padding: EdgeInsets.only(
                                bottom: style.UIPaddingBottom),
                            margin: EdgeInsets.only(
                                right: style.UIMarginLeft - 6),
                            child: DropdownButton<String>(
                                value: popUpSelect,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium,
                                menuMaxHeight:
                                MediaQuery.of(context)
                                    .size
                                    .height,
        //elevation: 10,
                                iconSize: 0.0,
                                underline: SizedBox.shrink(),
                                dropdownColor: Colors
                                    .black, //style.colorMainBlue,//colorBackGround,
                                items: popUpVal
                                    .map(
                                        (value) => DropdownMenuItem(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        width: style.UIButtonWidth * 0.4, //
                                        alignment: Alignment
                                            .center,
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
              //버튼들
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //저장 버튼
                  width: style.UIButtonWidth - style.fullSizeButtonHeight - style.UIMarginTop,
                  height: style.fullSizeButtonHeight,
                  margin: EdgeInsets.only(
                      top: style.UIButtonPaddingTop),
                  decoration: BoxDecoration(
                    color: style.colorMainBlue,
                    borderRadius: BorderRadius.circular(
                        style.textFiledRadius),
                  ),
                  child: TextButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(
                            Colors.transparent),
                      ),
                      child: Text('저장',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall),
                      onPressed: () {
                        if (InqureChecker(true) == true) {
                          List<int> listPaljaData = [];
                          List<int> listBirthLunarToSolar;
                          if(targetBirthYear > 1900){ //1900년 이후 출생은 findGanji로 팔자를 뽑는다
                            if(uemYangType == 0){ //양력
                              listPaljaData = findGanji.InquireGanji(targetBirthYear, targetBirthMonth, targetBirthDay, targetBirthHour, targetBirthMin);
                            }
                            else{
                              if(uemYangType == 1){
                                listBirthLunarToSolar = findGanji.LunarToSolar(targetBirthYear, targetBirthMonth, targetBirthDay, false);
                                listPaljaData = findGanji.InquireGanji(listBirthLunarToSolar[0], listBirthLunarToSolar[1], listBirthLunarToSolar[2], targetBirthHour, targetBirthMin);
                              }
                              else{
                                listBirthLunarToSolar = findGanji.LunarToSolar(targetBirthYear, targetBirthMonth, targetBirthDay, true);
                                listPaljaData = findGanji.InquireGanji(listBirthLunarToSolar[0], listBirthLunarToSolar[1], listBirthLunarToSolar[2], targetBirthHour, targetBirthMin);
                              }
                            }
                          }
                          else{

                          }

                          personalDataManager.SaveUserData(
                              targetName,
                              gender == Gender.Male ? true : false,
                              uemYangType,
                              targetBirthYear,
                              targetBirthMonth,
                              targetBirthDay,
                              targetBirthHour,
                              targetBirthMin,
                              listPaljaData,
                            diaryFirstSet: widget.diaryFirstSet
                          );

                          widget.refreshDiaryUserData();

                            SnackBar snackBar = SnackBar(
                              content: Text("사용자 정보가 저장되었습니다", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
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
                      }),
                ),
                Container(
                  width: style.fullSizeButtonHeight,
                  height: style.fullSizeButtonHeight,
                  margin: EdgeInsets.only(
                      left: style.UIMarginLeft,
                      top: style.UIButtonPaddingTop),
                  decoration: BoxDecoration(
                    color: style.colorMainBlue,
                    borderRadius: BorderRadius.circular(
                        style.textFiledRadius),
                  ),
                  child: ElevatedButton(
                    style:  ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(style.colorMainBlue),
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                      //overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                      elevation: WidgetStatePropertyAll(0),
                    ),
                    child:SvgPicture.asset('assets/recycle_icon.svg', width: style.iconSize, height: style.iconSize,),
                    onPressed: () {
                      setState(() {
                        ResetAll();
                      });
                    },
                  ),
                ),
              ],
            ),
            //Container(
            //  //사용자 설정 설명
            //    width: (MediaQuery.of(context).size.width -
            //        (style.UIMarginLeft * 2)),
            //    margin: EdgeInsets.only(top: 30),
            //    height: style.fullSizeButtonHeight * 5,
            //    child: Text(infoText,
            //        style:
            //        Theme.of(context).textTheme.displayMedium)),
          ],
        ),
      );
  }
}

class BirthSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 4 ||
        newValue.selection.baseOffset == 7) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}

class HourSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';

    if (newValue.selection.baseOffset == 2) {
      if (newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length - 1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length));
    }

    return newValue;
  }
}
