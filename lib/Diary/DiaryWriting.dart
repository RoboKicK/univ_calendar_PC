import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Settings/personalDataManager.dart' as personalDataManager;
import '../../style.dart' as style;
import '../../CalendarResult/calendarResultPaljaWidget.dart' as calendarResultPaljaWidget;
import '../../CalendarResult/InquireSinsals/yugchinWidget.dart' as yugchinWidget;
import '../../CalendarResult/InquireSinsals/sibiunseong.dart' as sibiunseong;
import '../../CalendarResult/InquireSinsals/MinorSinsals/sibiSinsal.dart' as sibiSinsal;
import '../../SaveData/saveDataManager.dart' as saveDataManager;


class DiaryWriting extends StatefulWidget {
  const DiaryWriting({super.key, required this.listTodayPalja, required this.userGender, required this.userIlganNum, required this.userYeonjiNum,
    required this.diaryYear, required this.diaryMonth, required this.diaryDay, required this.dayString, required this.isWriting, required this.CloseOption, required this.RevealWindow,});

  final List<int> listTodayPalja;
  final bool userGender;
  final int userIlganNum;
  final int userYeonjiNum;
  final int diaryYear, diaryMonth, diaryDay;
  final String dayString;
  final int isWriting;
  final CloseOption, RevealWindow;

  @override
  State<DiaryWriting> createState() => _DiaryWritingState();
}

class _DiaryWritingState extends State<DiaryWriting> {

  String prefixMemo = '';
  String editingMemo = '';
  TextEditingController memoController = TextEditingController();

  bool isEditing = false; //저장한 후로 편집을 다시 시작했는지
  int isEditingMemo = 0;

  List<int> listLabel = [1,1,1,1,1,1,1,1,1];  //1은 선택 안함, 2는 함  //0번부터 사고, 연애, 돈, 직장, 건강, 스트레스, 공부, 가족, 친구

  int isShowLabelContainer = 0; //0:안보여줌, 1:보여줌
  double labelContainerHeight = 0;

  List<Color> listLabelButtonColor = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
  List<Color> listLabelButtonOutlineColor = [style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,];//[style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy];
  List<Widget> listLabelButton = [];
  List<Widget> listSelectedLabelContainer = [SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink()];
  List<String> listLabelString = ['사고', '연애', '돈', '직장', '건강', '스트레스', '공부', '가족', '친구'];

  double labelButtonHeight = 46;
  double labelButtonWidth = 45;
  double labelButtonWidthPerString = 15;

  double selectedLabelContainerHeight = 26;
  double selectedLabelContainerWidth = 38;
  double selectedLabelWidthPerString = 14;

  Color labelButtonEffectColor = Colors.transparent;

  late FocusNode memoFocusNode;

  int diaryIndex = 0;

  ScrollController memoScrollController = ScrollController();

  int koreanGanji = 0;

  List<int> listNowDay = [0,0,0];

  String GetDateText(){ //연월일 텍스트
    String dateString = '';
    //dayString += '${widget.diaryYear}년';
    //dayString += ' ${widget.diaryMonth}월';
    //dayString += ' ${widget.diaryDay}일';
    //dayString += ' ${widget.dayString}요일';
    String monthString = '';
    if(widget.diaryMonth < 10){
      monthString = '0${widget.diaryMonth}';
    } else monthString = '${widget.diaryMonth}';
    String dayString = '';
    if(widget.diaryDay < 10){
      dayString = '0${widget.diaryDay}';
    } else dayString = '${widget.diaryDay}';

    dateString += '${widget.diaryYear}.${monthString}.${dayString} ${widget.dayString}요일 ';
    return dateString;
  }

  Text GetIlganText(){
    var textColor = style.SetOhengColor(true, widget.listTodayPalja[6]);
    return Text(style.stringCheongan[((personalDataManager.etcData%1000)/100).floor() - 1][widget.listTodayPalja[6]],
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, ),);
  }
  Text GetIljiText(){
    var textColor = style.SetOhengColor(false, widget.listTodayPalja[7]);
    return Text(style.stringJiji[((personalDataManager.etcData%1000)/100).floor() - 1][widget.listTodayPalja[7]],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor));
  }

  SetEditingMemo(){
    if(isEditingMemo == 0){ //메모 시작
      editingMemo = prefixMemo;
      memoController.text = editingMemo;
      isEditingMemo = 1;
    }
    else{ //메모 저장 후 종료
      prefixMemo = editingMemo;
      isEditingMemo = 0;
    }
  }
  SaveDiary(bool isFromSaveLabel){
    if(isEditing == true){
      isEditing = false;

      int labelData = 0;
      int val = 0;
      for(int i = 0; i < listLabel.length; i++){
        if(i == 0){
          val = 1;
        }
        labelData = labelData + listLabel[i] * val;
        val = val * 10;
      }
      if(editingMemo != '' || labelData != 111111111) {
        saveDataManager.SaveDiaryData2(widget.diaryYear, widget.diaryMonth, widget.diaryDay, labelData, widget.listTodayPalja, widget.dayString, editingMemo, isFromSaveLabel);
      } else {
        SnackBar snackBar = SnackBar(
          content: Text('일기 내용이 없습니다', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
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
    }
  }
  LoadDiary(){
    if(diaryIndex != -1){
      int savedLabelData = saveDataManager.mapDiary[diaryIndex]['labelData'];
      int percen = 10;
      int division = 0;
      for(int i = 0; i < listLabel.length; i++){
        if(i == 0){
          division = 1;
        }
        listLabel[i] = ((savedLabelData % percen) / division).floor();
        percen = percen * 10;
        division = division * 10;
        SetLabelList(i, isInitSet: true);
        SetLabelColors(i);
      }
      memoController.text = saveDataManager.mapDiary[diaryIndex]['memo'].substring(4, saveDataManager.mapDiary[diaryIndex]['memo'].length);
      prefixMemo = memoController.text;
      editingMemo = prefixMemo;
    } else {
      setState(() {
        listLabel = [1,1,1,1,1,1,1,1,1];
        listLabelButtonColor = [Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent];
        listLabelButtonOutlineColor = [style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,style.colorDarkGrey,];//[style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy, style.colorNavy];
        listSelectedLabelContainer = [SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink()];
        memoController.text = '';
        prefixMemo = memoController.text;
        editingMemo = prefixMemo;
      });
    }
  }

  List<Widget> GetTodayPaljaWidget(){

    List<Widget> listTodayPaljaWidget = [];

    listTodayPaljaWidget.add(Container(
      width: style.UIButtonWidth,
      height: style.UIBoxLineHeight,
      //margin: EdgeInsets.only(top: 0),
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
    ));//
    listTodayPaljaWidget.add(yugchinWidget.YugchinWidget(widgetWidth: style.UIButtonWidth+27, containerColor: style.colorBoxGray0, listPaljaData: widget.listTodayPalja, stanIlganNum: widget.userIlganNum,isManseryoc:false, isCheongan: true, isLastWidget: false, RevealWindow: widget.RevealWindow));
    listTodayPaljaWidget.add(calendarResultPaljaWidget.CalendarResultPaljaWidget(widgetWidth: style.UIButtonWidth+27, containerColor: style.colorBoxGray1, listPaljaData: widget.listTodayPalja, gender: widget.userGender, isShowDrawerUemyangSign: 0, isShowDrawerKoreanGanji: koreanGanji, isLastWidget: false, isShowChooseDayButtons: false, RevealWindow: widget.RevealWindow,));
    listTodayPaljaWidget.add(yugchinWidget.YugchinWidget(widgetWidth: style.UIButtonWidth+27, containerColor: style.colorBoxGray0, listPaljaData: widget.listTodayPalja, stanIlganNum: widget.userIlganNum, isManseryoc:false, isCheongan: false, isLastWidget: false, RevealWindow: widget.RevealWindow));
    listTodayPaljaWidget.add(sibiunseong.Sibiunseong().Get12Unseong(context, style.colorBoxGray1, widget.listTodayPalja, widget.userIlganNum, false, style.UIButtonWidth+27));
    listTodayPaljaWidget.add(sibiSinsal.SibiSinsal().Get12Sinsal(context, style.colorBoxGray0, widget.listTodayPalja, widget.userYeonjiNum, false, 0, true, style.UIButtonWidth+27));

    return listTodayPaljaWidget;
  }

  ShowLabelOptions(){ //라벨 컨테이너 열림
    setState(() {
      isShowLabelContainer = (isShowLabelContainer + 1) % 2;
    });
    if(isShowLabelContainer == 0){
      labelContainerHeight =  0;
    } else {
      labelContainerHeight =  labelButtonHeight+10;
      //if(showPaljaState == 0){
      //  showPaljaState++;
      //}
    }
  }

  SetLabelList(int labelNum, {bool isInitSet = false}){ //선택한 라벨 정보 입력
    if(isInitSet == false){
      isEditing = true;
      if(listLabel[labelNum] == 1){
        listLabel[labelNum] = 2;
      } else {
        listLabel[labelNum] = 1;
      }
    }
    if(listLabel[labelNum] == 2){
      double containerWidth = selectedLabelContainerHeight + selectedLabelWidthPerString;
      if(labelNum == 2){
        containerWidth -= selectedLabelWidthPerString;
      } else if(labelNum == 5){
        containerWidth += selectedLabelWidthPerString * 2;
      }
      listSelectedLabelContainer[labelNum] = Container(
          width: containerWidth,
          height: selectedLabelContainerHeight,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(left:6),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: style.colorNavy,
            borderRadius: BorderRadius.all(Radius.circular(style.deunSeunGanjiRadius)),
          ),
          child: Text(listLabelString[labelNum], style:TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))
      );
    } else {
      listSelectedLabelContainer[labelNum] = SizedBox.shrink();
    }
    SaveDiary(true);
  }
  SetLabelColors(int labelNum){ //라벨 버튼 색깔 들어옴
    if(listLabel[labelNum] == 1){
      listLabelButtonColor[labelNum] = Colors.transparent;
      listLabelButtonOutlineColor[labelNum] = style.colorDarkGrey;//style.colorNavy;
    } else {
      listLabelButtonColor[labelNum] = style.colorMainBlue;
      listLabelButtonOutlineColor[labelNum] = Colors.transparent;
    }
  }
  bool CheckSelectedLabelCount(int labelNum){ //활성화 라벨이 3개 이상이면 false 반환
    int count = 0;
    for(int i = 0; i < listLabel.length; i++){
      if(listLabel[i] == 2){
        count++;
      }
    }
    if(count < 3){
      return true;
    } else {
      if(count == 3 && listLabel[labelNum] == 2){
        return true;
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          //barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                '라벨은 3개까지만 선택할 수 있습니다',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    isEditingMemo = widget.isWriting;

    memoFocusNode = FocusNode();

    listNowDay[0] = widget.diaryYear;
    listNowDay[1] = widget.diaryMonth;
    listNowDay[2] = widget.diaryDay;


    diaryIndex = saveDataManager.FindMapDiaryIndex(widget.diaryYear, widget.diaryMonth, widget.diaryDay);

    LoadDiary();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    SaveDiary(false);

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {

    if(koreanGanji != ((personalDataManager.etcData%1000)/100).floor() - 1){
      setState(() {
        koreanGanji = ((personalDataManager.etcData%1000)/100).floor() - 1;
      });
    }

    if(listNowDay[0] != widget.diaryYear || listNowDay[1] != widget.diaryMonth || listNowDay[2] != widget.diaryDay){
      diaryIndex = saveDataManager.FindMapDiaryIndex(widget.diaryYear, widget.diaryMonth, widget.diaryDay);
      isEditingMemo = widget.isWriting;
      listNowDay[0] = widget.diaryYear;
      listNowDay[1] = widget.diaryMonth;
      listNowDay[2] = widget.diaryDay;
      LoadDiary();
    }

    return
      Container(
        width: style.UIButtonWidth + 30,
        margin: EdgeInsets.only(top:style.UIMarginTop, bottom: style.UIMarginTop),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(  //그룹 이름
                  width: style.UIButtonWidth * 0.8,
                  height: style.saveDataNameLineHeight,
                  padding: EdgeInsets.only(top:4),
                  //color:Colors.green,
                  child: Text("일진일기", style: Theme.of(context).textTheme.headlineSmall),
                ),
                Container(  //라벨 버튼
                  width: style.UIButtonWidth * 0.1,
                  height: style.saveDataNameLineHeight*1.1,
                  //color:Colors.yellow,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: isShowLabelContainer == 0? labelButtonEffectColor : style.colorBlack,
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: ElevatedButton( //라벨 아이콘
                    child: SvgPicture.asset(isShowLabelContainer == 0? 'assets/tag_icon.svg' : 'assets/tag_icon_select.svg', width: style.appbarIconSize*0.9, height: style.appbarIconSize*0.9),
                    onPressed: (){
                      setState(() {
                        ShowLabelOptions();
                      });
                    },
                    onHover: (hover){
                      setState(() {
                        if(hover == true){
                          labelButtonEffectColor = style.colorBlack.withOpacity(0.6);
                        } else {
                          labelButtonEffectColor = Colors.transparent;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent, overlayColor: Colors.transparent),
                  ),
                ),
                Container(  //닫기 버튼
                  width: style.UIButtonWidth * 0.1,
                  height: style.saveDataNameLineHeight*1.1,
                  //color:Colors.blue,
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.CloseOption(false);
                      });
                    },
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                    child: Icon(Icons.close, color:Colors.white, size: style.appbarIconSize * 1.2),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(  //연월일시 라인
                  width: style.UIButtonWidth,
                  height: style.saveDataNameLineHeight+6,
                  //color:Colors.green,
                  margin: EdgeInsets.only(top:style.UIMarginTop * 0.5),
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(  //연월일시
                        height: style.fullSizeButtonHeight,
                        //color:Colors.green,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: style.fullSizeButtonHeight,
                                //color: Colors.green,
                                padding:EdgeInsets.only(top:3.4),
                                child: Text(GetDateText(), style:Theme.of(context).textTheme.titleLarge)),
                            Container(
                              //color:Colors.yellow,
                              height: style.fullSizeButtonHeight,
                              alignment: Alignment.topCenter,
                              //padding:EdgeInsets.only(bottom:1),
                              child: GetIlganText(),
                            ),
                            Container(
                                height: style.fullSizeButtonHeight,
                                alignment: Alignment.topCenter,
                                //padding:EdgeInsets.only(bottom:1),
                                child: GetIljiText()
                            ),
                          ],
                        ),
                      ),
                      Container(  //선택한 라벨 표시
                        height: style.fullSizeButtonHeight,
                        padding:EdgeInsets.only(top:2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listSelectedLabelContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    AnimatedOpacity(  //라벨 버튼들
                      opacity: isShowLabelContainer == 1 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 130),
                      child: Container(
                        //color:Colors.yellow,
                        height: isShowLabelContainer == 1?  labelButtonHeight : 0,//labelButtonHeight * 2 + style.UIMarginTop,
                        width: MediaQuery.of(context).size.width,
                        //margin: EdgeInsets.only(top:2),
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: ClampingScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[0],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[0],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(0) == true){
                                          setState(() {
                                            SetLabelList(0);
                                            SetLabelColors(0);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[0], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[0] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[1],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[1],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(1) == true){
                                          setState(() {
                                            SetLabelList(1);
                                            SetLabelColors(1);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[1], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[1] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[2],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[2],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(2) == true){
                                          setState(() {
                                            SetLabelList(2);
                                            SetLabelColors(2);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[2], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[2] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[3],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[3],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(3) == true){
                                          setState(() {
                                            SetLabelList(3);
                                            SetLabelColors(3);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[3], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[3] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[4],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[4],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(4) == true){
                                          setState(() {
                                            SetLabelList(4);
                                            SetLabelColors(4);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[4], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[4] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString * 3,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[5],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[5],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(5) == true){
                                          setState(() {
                                            SetLabelList(5);
                                            SetLabelColors(5);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[5], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[5] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[6],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[6],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(6) == true){
                                          setState(() {
                                            SetLabelList(6);
                                            SetLabelColors(6);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[6], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[6] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6),
                                    decoration: BoxDecoration(color: listLabelButtonColor[7],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[7],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(7) == true){
                                          setState(() {
                                            SetLabelList(7);
                                            SetLabelColors(7);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[7], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[7] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                                Container(
                                    width: labelButtonWidth + labelButtonWidthPerString,
                                    height:labelButtonHeight,
                                    margin: EdgeInsets.only(left: style.UIMarginLeft, bottom: 6, right: style.UIMarginLeft),
                                    decoration: BoxDecoration(color: listLabelButtonColor[8],
                                      borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                                      border: Border.all(
                                        width: 2,
                                        color: listLabelButtonOutlineColor[8],
                                      ),
                                    ),
                                    child:TextButton(
                                      onPressed: () {
                                        if(CheckSelectedLabelCount(8) == true){
                                          setState(() {
                                            SetLabelList(8);
                                            SetLabelColors(8);
                                          });
                                        }
                                      },
                                      child: Text(listLabelString[8], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                                      style: ButtonStyle(shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius - 2))), padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStateColor.resolveWith((states) => listLabel[8] == 1? style.colorBlack:style.colorMainBlue)),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        AnimatedContainer(  //라벨 버튼 컨테이너 열림
                          duration: Duration(milliseconds: 170),
                          width: MediaQuery.of(context).size.width,
                          height: labelContainerHeight,
                          curve: Curves.fastOutSlowIn,
                        ),
                        Column( //일진 사주
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: GetTodayPaljaWidget(),
                        ),
                        SizedBox(height: 6),  //메모와의 간격
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Expanded( //메모
              child: [
                Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                        child: Scrollbar(
                          thumbVisibility: true,
                          notificationPredicate: (notification) => notification.depth >= 0,
                          controller: memoScrollController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            controller: memoScrollController,
                            child: Container( //메모 본문
                              width: style.UIButtonWidth,
                              margin: EdgeInsets.only(top:style.UIMarginTop * 0.5),
                              alignment: Alignment.topLeft,
                              child:Text(prefixMemo, style: Theme.of(context).textTheme.displayMedium),//Theme.of(context).textTheme.displayMedium),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(  //메모 버튼
                          width: style.UIButtonWidth * 0.48,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(top:style.UIMarginTop),//, bottom:style.UIMarginTop),
                          decoration: BoxDecoration(
                            color: style.colorMainBlue,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child:ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  SetEditingMemo();
                                });
                              },
                              style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorMainBlue, elevation:0.0),
                              child: Text('메모', style: Theme.of(context).textTheme.headlineSmall)
                          ),
                        ),
                        Container(  //여백
                          width: style.UIButtonWidth * 0.04,
                        ),
                        Container(  //삭제 버튼
                          width: style.UIButtonWidth * 0.48,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(top:style.UIMarginTop),//, bottom:style.UIMarginTop),
                          child:ElevatedButton(
                              onPressed: (){
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("일기를 삭제합니다"),
                                      actions:[
                                        TextButton(
                                          onPressed: () async {
                                            await saveDataManager.DeleteDiaryData(widget.diaryYear, widget.diaryMonth, widget.diaryDay);
                                            widget.CloseOption(false);

                                            //Navigator.of(context).pop(true);
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text("네"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text("취소"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorRed, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                              child: Text('삭제', style: Theme.of(context).textTheme.headlineSmall)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: style.UIButtonWidth,
                        color: style.colorNavy,
                        margin: EdgeInsets.only(top:style.UIMarginTop*0.5),
                        child: TextField(
                          autofocus: true,
                          controller: memoController,
                          keyboardType: TextInputType.multiline,
                          maxLength: 500,
                          maxLines: null,
                          style: Theme.of(context).textTheme.displayMedium,
                          focusNode: memoFocusNode,
                          onTapOutside: (event) {
                            memoFocusNode.requestFocus();
                          },
                          decoration:InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(top:5, bottom: 10),
                            counterText:"",
                            border: InputBorder.none,),
                          onChanged: (text){
                            setState(() {
                              editingMemo = text;
                              isEditing = true;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(  //메모 저장 버튼
                      width: style.UIButtonWidth,
                      height: style.fullSizeButtonHeight,
                      margin: EdgeInsets.only(top:style.UIMarginTop),//, bottom:style.UIMarginTop),
                      decoration: BoxDecoration(
                        color: style.colorMainBlue,
                        borderRadius: BorderRadius.circular(style.textFiledRadius),
                      ),
                      child:  ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(style.colorMainBlue),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                          //overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        child: Text('저장', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            SetEditingMemo();
                            SaveDiary(false);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ][isEditingMemo],
            ),
          ]
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