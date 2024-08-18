import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../findGanji.dart' as findGanji;
import '../CalendarResult/calendarDeunSeun.dart' as calendarDeunSeun;
import '../style.dart' as style;
import '../Settings/personalDataManager.dart' as personalDataManager;
import '../CalendarResult/InquireSinsals/yugchinWidget.dart' as yugchinWidget;
import '../CalendarResult/InquireSinsals/sibiunseong.dart' as sibiunseong;
import '../CalendarResult/InquireSinsals/MinorSinsals/sibiSinsal.dart' as sibiSinsal;
import '../CalendarResult/calendarResultPaljaWidget.dart' as calendarResultPaljaWidget;
import 'DiaryWriting.dart' as diaryWriting;
import '../../Settings/userDataWidget.dart' as userDataWidget;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DiaryWritingMain extends StatefulWidget {
  const DiaryWritingMain({super.key, required this.widgetWidth, required this.isRegiedUserData, required this.SetSettingWidget, required this.SetSideOptionWidget, required this.CloseOption, required this.RevealWindow});

  final double widgetWidth;

  final bool isRegiedUserData;
  final SetSettingWidget;
  final SetSideOptionWidget;
  final CloseOption, RevealWindow;

  @override
  State<DiaryWritingMain> createState() => _DiaryWritingMainState();
}

class _DiaryWritingMainState extends State<DiaryWritingMain> {

  int calendarType = 0; //0:일진, 1:달력

  String todayString = '';

  int userIlganNum = -1;
  int userYeonjiNum = 0;

  List<int> listTodayPalja = [];

  DateTime calendarSelectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime calendarFocusedDay = DateTime.now();

  int stateNum = 0; //1이면 사용자를 등록해주세요 뜸
  int koreanGanji = 0;

  Map mapUserData = {};

  String GetDateText(){ //연월일 텍스트
    String selectedDayString = '';
    selectedDayString += '${calendarSelectedDay.year}년';
    selectedDayString += ' ${calendarSelectedDay.month}월';
    selectedDayString += ' ${calendarSelectedDay.day}일';
    selectedDayString += ' $todayString요일';
    return selectedDayString;
  }

  String GetDayString(String usString){ //한글로 월화수목 만들기
    String dayString = '';

    switch(usString){
      case 'Mon':{
        dayString = '월';
      }
      case 'Tue':{
        dayString = '화';
      }
      case 'Wed':{
        dayString = '수';
      }
      case 'Thu':{
        dayString = '목';
      }
      case 'Fri':{
        dayString = '금';
      }
      case 'Sat':{
        dayString = '토';
      }
      case 'Sun':{
        dayString = '일';
      }
    }
    return dayString;
  }

  SetCalendarType(){  //일진사주-달력 변환 버튼
    calendarType = (calendarType + 1) % 2;
    if(calendarType == 0){
      GetDdayPalja();
    }
  }

  GetDdayPalja(){ //일진 생성
    List<int> listFindGanji = findGanji.InquireGanji(calendarSelectedDay.year, calendarSelectedDay.month, calendarSelectedDay.day, calendarSelectedDay.hour, calendarSelectedDay.minute);
    List<int> listUserPalja = [];
    List<int> listTodayGanji = [];
    var listDynamicUserPalja = mapUserData['listPaljaData'];
    listUserPalja = [listDynamicUserPalja[0], listDynamicUserPalja[1], listDynamicUserPalja[2], listDynamicUserPalja[3], listDynamicUserPalja[4], listDynamicUserPalja[5], listDynamicUserPalja[6], listDynamicUserPalja[7]];
    listTodayGanji =  calendarDeunSeun.DeunFindClass().FindDeun(
        mapUserData['gender'], mapUserData['birthYear'], mapUserData['birthMonth'],
        mapUserData['birthDay'], mapUserData['birthHour'], mapUserData['birthMin'],
        listUserPalja, calendarSelectedDay.year, calendarSelectedDay.month, calendarSelectedDay.day);

    listTodayPalja = [listTodayGanji[0], listTodayGanji[1], listFindGanji[0], listFindGanji[1], listFindGanji[2], listFindGanji[3], listFindGanji[4], listFindGanji[5]];
  }

  SetFirstUserData(bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, List<int> paljaData){
    mapUserData['gender'] = gender;
    mapUserData['uemYang'] = uemYang;
    mapUserData['birthYear'] = birthYear;
    mapUserData['birthMonth'] = birthMonth;
    mapUserData['birthDay'] = birthDay;
    mapUserData['birthHour'] = birthHour;
    mapUserData['birthMin'] = birthMin;
    mapUserData['listPaljaData'] = paljaData;

    userIlganNum = paljaData[4];
    userYeonjiNum = paljaData[1];

    GetDdayPalja();
    setState(() {
      stateNum = 0;
    });
  }

  TodayButtonAction(){
    calendarFocusedDay = DateTime.now();
    calendarSelectedDay = DateTime.now();
    if(calendarType == 0){
      GetDdayPalja();
    }
  }

  List<Widget> GetTodayPaljaWidget(){
    koreanGanji = ((personalDataManager.etcData%1000)/100).floor() - 1;

    List<Widget> listTodayPaljaWidget = [];

    if(mapUserData.isNotEmpty){
      listTodayPaljaWidget.add(Container(
        width: style.UIButtonWidth,
        height: style.UIBoxLineHeight,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: style.colorMainBlue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('일운', style: Theme.of(context).textTheme.titleSmall),
            Text('월운', style: Theme.of(context).textTheme.titleSmall),
            Text('세운', style: Theme.of(context).textTheme.titleSmall),
            Text('대운', style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ));//연주 월주 일주 시주
      listTodayPaljaWidget.add(yugchinWidget.YugchinWidget(widgetWidth: style.UIButtonWidth+27, containerColor: style.colorBoxGray0, listPaljaData: listTodayPalja, stanIlganNum: userIlganNum,isManseryoc:false, isCheongan: true, isLastWidget: false, RevealWindow: widget.RevealWindow,));
      listTodayPaljaWidget.add(calendarResultPaljaWidget.CalendarResultPaljaWidget(widgetWidth: style.UIButtonWidth+27, containerColor: style.colorBoxGray1, gender: mapUserData['gender'], listPaljaData: listTodayPalja, isShowDrawerUemyangSign: 0, isShowDrawerKoreanGanji: koreanGanji, isLastWidget: false, isShowChooseDayButtons: false, RevealWindow: widget.RevealWindow,));
      listTodayPaljaWidget.add(yugchinWidget.YugchinWidget(widgetWidth: style.UIButtonWidth+27, containerColor: style.colorBoxGray0, listPaljaData: listTodayPalja, stanIlganNum: userIlganNum, isManseryoc:false, isCheongan: false, isLastWidget: false, RevealWindow: widget.RevealWindow));
      listTodayPaljaWidget.add(sibiunseong.Sibiunseong().Get12Unseong(context, style.colorBoxGray1, listTodayPalja, userIlganNum, false, style.UIButtonWidth+27));
      listTodayPaljaWidget.add(sibiSinsal.SibiSinsal().Get12Sinsal(context, style.colorBoxGray0, listTodayPalja, userYeonjiNum, false, 0, true, style.UIButtonWidth+27));
    }
    return listTodayPaljaWidget;
  }

  @override
  void initState() {
    super.initState();

    if(personalDataManager.mapUserData.isEmpty){  //사용자 등록이 안되어있으면
      stateNum = 1; }
    else {
      mapUserData['gender'] = personalDataManager.mapUserData['gender'];
      mapUserData['uemYang'] = personalDataManager.mapUserData['uemYang'];
      mapUserData['birthYear'] = personalDataManager.mapUserData['birthYear'];
      mapUserData['birthMonth'] = personalDataManager.mapUserData['birthMonth'];
      mapUserData['birthDay'] = personalDataManager.mapUserData['birthDay'];
      mapUserData['birthHour'] = personalDataManager.mapUserData['birthHour'];
      mapUserData['birthMin'] = personalDataManager.mapUserData['birthMin'];
      mapUserData['listPaljaData'] = personalDataManager.mapUserData['listPaljaData'];

      userIlganNum = personalDataManager.mapUserData['listPaljaData'][4];
      userYeonjiNum = personalDataManager.mapUserData['listPaljaData'][1];
      GetDdayPalja();

      calendarSelectedDay = DateTime.now();
      todayString = GetDayString(DateFormat('E').format(calendarSelectedDay));
    }

    koreanGanji = ((personalDataManager.etcData%1000)/100).floor() - 1;
  }

  @override
  Widget build(BuildContext context) {

    if(personalDataManager.mapUserData.isEmpty && widget.isRegiedUserData == false){  //사용자 등록이 안되어있으면
      stateNum = 1;}
    else {
      stateNum = 0;

      mapUserData['gender'] = personalDataManager.mapUserData['gender'];
      mapUserData['uemYang'] = personalDataManager.mapUserData['uemYang'];
      mapUserData['birthYear'] = personalDataManager.mapUserData['birthYear'];
      mapUserData['birthMonth'] = personalDataManager.mapUserData['birthMonth'];
      mapUserData['birthDay'] = personalDataManager.mapUserData['birthDay'];
      mapUserData['birthHour'] = personalDataManager.mapUserData['birthHour'];
      mapUserData['birthMin'] = personalDataManager.mapUserData['birthMin'];
      mapUserData['listPaljaData'] = personalDataManager.mapUserData['listPaljaData'];

      userIlganNum = personalDataManager.mapUserData['listPaljaData'][4];
      userYeonjiNum = personalDataManager.mapUserData['listPaljaData'][1];
      GetDdayPalja();
    }

    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(  //연월일시 라인
                width: style.UIButtonWidth,
                height: style.saveDataMemoLineHeight,
                margin: EdgeInsets.only(top:style.UIMarginTopTop),
                //color:Colors.green,
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(  //연월일시
                      width: style.UIButtonWidth * 0.8,
                      height: style.fullSizeButtonHeight,
                      //color:Colors.green,
                      child:Text(GetDateText(), style:Theme.of(context).textTheme.headlineLarge),
                    ),
                    Container(  //타입 교체 버튼
                      width: style.fullSizeButtonHeight*0.8,
                      height: style.fullSizeButtonHeight,
                      margin:EdgeInsets.only(top:2, right:2),
                      decoration: BoxDecoration(
                        color: calendarType == 0? style.colorBlack:style.colorMainBlue,
                        borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius),
                      ),
                      child: ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.transparent),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        //child: SvgPicture.asset('assets/close_all_icon.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                        child: SvgPicture.asset(calendarType == 0? 'assets/calendar_icon.svg':'assets/calendar_icon_select.svg', width: style.iconSize*0.9, height: style.iconSize*0.9,),
                        onPressed: () {
                          setState(() {
                            SetCalendarType();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              [
                Column( //일진 사주
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: GetTodayPaljaWidget(),
                ),
                Container(  //달력
                  width: style.UIButtonWidth,
                  height: (style.UIBoxLineHeight * 4) + (style.fullSizeButtonHeight * 1.25 * 2) + style.UIBoxLineHeight + style.UIBoxLineHeight+6,
                  margin: EdgeInsets.only(top:10),
                  decoration: BoxDecoration(
                    color : style.colorBoxGray0,
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  //color: Colors.green,
                  child: Column(
                    children: [
                      Container(  //화살표 버튼
                        width: style.UIButtonWidth,
                        height: style.UIBoxLineHeight,
                        decoration: BoxDecoration(
                          color : style.colorMainBlue,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(style.textFiledRadius), topRight: Radius.circular(style.textFiledRadius)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: style.UIBoxLineHeight,
                              height : style.UIBoxLineHeight,
                              child:ElevatedButton(
                                style:  ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(style.colorMainBlue),
                                  padding: WidgetStatePropertyAll(EdgeInsets.only(left:6)),
                                  elevation: WidgetStatePropertyAll(0),
                                ),
                                child:Icon(Icons.arrow_back, color:Colors.white, size: 18,),
                                onPressed: () {
                                  setState(() {
                                    calendarFocusedDay = DateTime(calendarFocusedDay.year, calendarFocusedDay.month - 1, 15);
                                  });
                                },
                              ),
                            ),
                            Flexible(
                                fit: FlexFit.tight,
                                child:Container(
                                  height:style.UIBoxLineHeight,
                                  alignment: Alignment.center,
                                  child: Text('${calendarFocusedDay.year}년 ${calendarFocusedDay.month}월', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                )
                            ),
                            Container(
                              width: style.UIBoxLineHeight,
                              height : style.UIBoxLineHeight,
                              child:ElevatedButton(
                                style:  ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(style.colorMainBlue),
                                  padding: WidgetStatePropertyAll(EdgeInsets.only(right:6)),
                                  elevation: WidgetStatePropertyAll(0),
                                ),
                                child:Icon(Icons.arrow_forward, color:Colors.white, size: 18),
                                onPressed: () {
                                  setState(() {
                                    calendarFocusedDay = DateTime(calendarFocusedDay.year, calendarFocusedDay.month + 1, 15);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCalendar(  //달력
                        locale:'ko_KR',
                        focusedDay: calendarFocusedDay,
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        headerVisible: false,
                        rowHeight: style.UIBoxLineHeight*1.3,
                        availableGestures: AvailableGestures.none,
                        calendarBuilders: CalendarBuilders(
                            dowBuilder: (context,day) {
                              if(day.weekday == DateTime.sunday){
                                return Center(
                                  child: Text('일', style: TextStyle(color:Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
                                );
                              } else if(day.weekday == DateTime.saturday){
                                return Center(
                                  child: Text('토', style: TextStyle(color:style.colorMainBlue, fontSize: 12, fontWeight: FontWeight.w500)),
                                );
                              } else {
                                return Center(
                                  child: Text(GetDayString(DateFormat('E').format(day)), style: TextStyle(color:style.colorRealBlack, fontSize: 12, fontWeight: FontWeight.w500)),
                                );
                              }
                            }
                        ),
                        //daysOfWeekStyle: DaysOfWeekStyle(
                        //  weekdayStyle: TextStyle(color:Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                        //),
                        daysOfWeekHeight: style.UIBoxLineHeight,
                        pageJumpingEnabled: true,
                        calendarStyle: CalendarStyle(
                          //isTodayHighlighted: false,
                          selectedDecoration: BoxDecoration(
                            color:style.colorMainBlue,
                            shape:BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color:style.colorGrey,
                            shape:BoxShape.circle,
                          ),
                          defaultTextStyle: TextStyle(color:style.colorRealBlack, fontSize: 12, fontWeight: FontWeight.w500),
                          outsideTextStyle: TextStyle(color:style.colorGrey, fontSize: 12, fontWeight: FontWeight.w500),
                          //holidayTextStyle: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                          selectedTextStyle: TextStyle(color:Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          todayTextStyle: TextStyle(color:Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          weekendTextStyle: TextStyle(color:style.colorRealBlack, fontSize: 12, fontWeight: FontWeight.w500),
                          //disabledTextStyle: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        onDaySelected: (DateTime selectedDay, DateTime focusedDay){
                          setState(() {
                            calendarSelectedDay = selectedDay;
                            calendarFocusedDay = focusedDay;
                            todayString = GetDayString(DateFormat('E').format(calendarSelectedDay));
                            SetCalendarType();
                          });
                        },
                        selectedDayPredicate: (DateTime day){
                          return isSameDay(calendarSelectedDay, day);
                        },
                        onPageChanged: (focusedDay) {

                        },
                      ),
                    ],
                  ),
                ),
              ][calendarType],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //조회 버튼
                    width: style.UIButtonWidth - style.fullSizeButtonHeight - style.UIMarginTop,
                    height: style.fullSizeButtonHeight,
                    margin: EdgeInsets.only(top: style.UIButtonPaddingTop, bottom: style.UIButtonPaddingTop),
                    decoration: BoxDecoration(
                      color: style.colorMainBlue,
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: TextButton(
                      style:TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        '작성',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onPressed: () {
                        GetDdayPalja();
                        setState(() {
                          widget.SetSideOptionWidget(diaryWriting.DiaryWriting(listTodayPalja: listTodayPalja, userGender: mapUserData['gender'], userIlganNum: userIlganNum, userYeonjiNum: userYeonjiNum, diaryYear: calendarSelectedDay.year, diaryMonth: calendarSelectedDay.month,
                              diaryDay: calendarSelectedDay.day, dayString: GetDayString(DateFormat('E').format(calendarSelectedDay)), isWriting: 1, CloseOption: widget.CloseOption, RevealWindow: widget.RevealWindow,), isCompulsionOn : true,);
                        });
                      },
                    ),
                  ),
                  Container(
                    //리셋 버튼
                    width: style.fullSizeButtonHeight,
                    height: style.fullSizeButtonHeight,
                    margin: EdgeInsets.only(left: style.UIMarginLeft, top: style.UIButtonPaddingTop, bottom: style.UIButtonPaddingTop),
                    decoration: BoxDecoration(
                      color: style.colorMainBlue,
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: ElevatedButton(
                      style:  ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(style.colorMainBlue),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                        //overlayColor: WidgetStateProperty.all(Colors.transparent),
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      child:SvgPicture.asset('assets/recycle_icon.svg', width: style.iconSize, height: style.iconSize,),
                      onPressed: () {
                        setState(() {
                          TodayButtonAction();
                        });
                      },
                    ),
                  ),
                ],
              ), //조회 버튼
            ],
          ),
          Column( //사용자 등록
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: style.UIButtonWidth,
                  height: 160,
                  margin: EdgeInsets.only(top:100),
                  //color: Colors.green,
                  alignment: Alignment.center,
                  child: Text('등록된 사용자가 없습니다\n사용자 정보를 먼저 등록해 주세요', style: Theme.of(context).textTheme.headlineSmall,textAlign: TextAlign.center,)
              ),
              Container(
                //조회 버튼
                width: style.UIButtonWidth,
                height: style.fullSizeButtonHeight,
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                  style:TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    '등록',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  onPressed: () {
                    widget.SetSettingWidget(true,directGoPageNum : 1);
                  },
                ),
              ),
            ],
          ),
        ]
        [stateNum],
      ],
    );
  }
}
