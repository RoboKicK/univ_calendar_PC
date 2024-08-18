import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../style.dart' as style;
import '../Settings/personalDataManager.dart' as personalDataManager;
import '../SaveData/saveDataManager.dart' as saveDataManager;
import '../findGanji.dart' as findGanji;
import '../CalendarResult/calendarDeunSeun.dart' as calendarDeunSeun;
import 'diaryWriting.dart' as diaryWriting;

class Diarysavelist extends StatefulWidget {
  const Diarysavelist({super.key, required this.widgetWidth, required this.SetSideOptionWidget, required this.CloseOption, required this.RevealWindow});

  final double widgetWidth;
  final SetSideOptionWidget;
  final CloseOption, RevealWindow;

  @override
  State<Diarysavelist> createState() => _DiarysavelistState();
}

class _DiarysavelistState extends State<Diarysavelist> {

  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextFocusNode = FocusNode();

  double tagButtonWidth = 80;

  List<String> listLabelString = ['사고', '연애', '돈', '직장', '건강', '스트레스', '공부', '가족', '친구'];
  double selectedLabelContainerHeight = 26;
  double selectedLabelContainerWidth = 38;
  double selectedLabelWidthPerString = 14;

  double labelButtonWidth = 45;
  double labelButtonWidthPerString = 15;

  int searchNum = 0;
  double searchContainerHeight = 40;
  String searchButtonText = '천간';
  Color searchButtonTextColor = Colors.white;

  int selectedLabelNum = -1;
  int selectedCheonganNum = -1;
  int selectedJijiNum = -1;
  int selectedLabelNumToData = -1;

  int koreanGanji = 0;

  int stateNum = 0;

  String GetDateText(int year, int month, int day, String _dayString){ //연월일 텍스트
    String dateString = '';
    String monthString = '';
    if(month < 10){
      monthString = '0${month}';
    } else monthString = '${month}';
    String dayString = '';
    if(day < 10){
      dayString = '0${day}';
    } else dayString = '${day}';

    dateString += '${year}.${monthString}.${dayString} ${_dayString}요일 ';

    return dateString;
  }
  Text GetIlganText(int ilganNum){
    var textColor = style.SetOhengColor(true, ilganNum);
    return Text(style.stringCheongan[((personalDataManager.etcData%1000)/100).floor() - 1][ilganNum],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor));
  }
  Text GetIljiText(int iljiNum){
    var textColor = style.SetOhengColor(false, iljiNum);
    return Text(style.stringJiji[((personalDataManager.etcData%1000)/100).floor() - 1][iljiNum],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor));
  }
  String GetFirstLineText(String text){
    String firstLineText = '';
    int textLengthLimit = 100;
    int enterCount = 0;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        enterCount++;
        if(enterCount == 3){
          break;
        }
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
  double GetIljiContainerHeight(String text){
    double height = 0;
    int textLengthLimit = 100;
    int enterCount = 0;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        enterCount++;
        if(enterCount == 3){
          enterCount = 2;
          break;
        }
      }
      if(i+1 > text.length){
        break;
      }
      if(i > textLengthLimit){
        break;
      }
    }

    height = (style.saveDataMemoLineHeight * 0.73) * (enterCount + 1);
    if(text.length == 0){
      height = 0;
    }
    return height;
  }
  List<Widget> GetLabelContainer(int labelData){
    List<Widget> listLabel = [];

    int percen = 10;
    int division = 0;
    int labelVal = 0;
    for(int i = 0; i < listLabelString.length; i++){
      if(i == 0){
        division = 1;
      }
      labelVal = ((labelData % percen) / division).floor();
      if(labelVal == 2){
        double containerWidth = selectedLabelContainerHeight + selectedLabelWidthPerString;
        if(i == 2){
          containerWidth -= selectedLabelWidthPerString;
        } else if(i == 5){
          containerWidth += selectedLabelWidthPerString * 2;
        }
        listLabel.add(Container(
            width: containerWidth,
            height: selectedLabelContainerHeight,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(left:6),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: style.colorNavy,
              borderRadius: BorderRadius.all(Radius.circular(style.deunSeunGanjiRadius)),
            ),
            child: Text(listLabelString[i], style:TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))
        ));
      }
      percen = percen * 10;
      division = division * 10;
    }

    return listLabel;
  }
  SetSearchNum(){
    searchNum = (searchNum + 1) % 3;
    switch(searchNum){
      case 0:{
        searchButtonText = '천간';
      }
      case 1:{
        searchButtonText = '지지';
      }
      case 2:{
        searchButtonText = '라벨';
      }
    }
  }
  SetSelectedLabel(int num){
    setState(() {
      if(selectedLabelNum == num){
        selectedLabelNum = -1;
        selectedLabelNumToData = -1;
      } else {
        selectedLabelNum = num;
        selectedLabelNumToData = 1;
        for(int i = 0; i < num; i++){
          selectedLabelNumToData = selectedLabelNumToData * 10;
        }
      }
      SetSearchButtonTextColor();
    });
  }
  SetSelectedCheongan(int num){
    setState(() {
      if(selectedCheonganNum == num){
        selectedCheonganNum = -1;
      } else {
        selectedCheonganNum = num;
      }
      SetSearchButtonTextColor();
    });
  }
  SetSelectedJiji(int num){
    setState(() {
      if(selectedJijiNum == num){
        selectedJijiNum = -1;
      } else {
        selectedJijiNum = num;
      }
      SetSearchButtonTextColor();
    });
  }
  SetSearchButtonTextColor(){
    if(selectedLabelNum == -1 && selectedCheonganNum == -1 && selectedJijiNum == -1){
      searchButtonTextColor = Colors.white;
    } else {
      searchButtonTextColor = style.colorMainBlue;
    }
  }

  @override
  void initState() {
    super.initState();

    koreanGanji = ((personalDataManager.etcData % 1000) / 100).floor() - 1;
  }

  @override
  Widget build(BuildContext context) {

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(  //검색창
            height: style.fullSizeButtonHeight,
            width: style.UIButtonWidth,
            margin: EdgeInsets.only(top: style.UIMarginTopTop),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(  //검색 버튼
                        height: style.fullSizeButtonHeight,
                        width: (style.UIButtonWidth - (style.UIMarginLeft * 2)) - tagButtonWidth - style.fullSizeButtonHeight,// * 0.83,
                        decoration: BoxDecoration(
                          color: style.colorNavy,
                          borderRadius: BorderRadius.circular(style.textFiledRadius),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                //width: (style.UIButtonWidth - (style.UIMarginLeft * 3)) - tagButtonWidth - style.fullSizeButtonHeight,//MediaQuery.of(context).size.width * 0.4,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: searchTextController,
                                  focusNode: searchTextFocusNode,
                                  cursorColor: Colors.white,
                                  maxLength: 10,
                                  style: Theme.of(context).textTheme.labelMedium,
                                  decoration:InputDecoration(
                                      counterText:"",
                                      border: InputBorder.none,
                                      prefix: Text('    '),
                                      hintText: '날짜 또는 메모',
                                      hintStyle: Theme.of(context).textTheme.labelSmall),
                                  onChanged: (value){
                                    setState(() {
                                      searchTextController.text;
                                    });
                                  },
                                ),
                              ),
                            ),
                            AnimatedCrossFade(
                              duration: Duration(milliseconds: 130),
                              firstChild: SizedBox(width:40, height:20,),
                              secondChild:  Container(
                                width:40,
                                height:20,
                                child: IconButton(
                                  icon: Icon(Icons.cancel, color: style.colorGrey, size: 20,),
                                  style: ElevatedButton.styleFrom(visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, overlayColor: Colors.transparent),
                                  onPressed: (){
                                    setState(() {
                                      searchTextController.text = '';
                                      FocusScope.of(context).requestFocus(searchTextFocusNode);
                                    });
                                  },
                                ),
                              ),
                              crossFadeState: searchTextController.text.length == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                              firstCurve: Curves.easeIn,
                              secondCurve: Curves.easeIn,
                            ),
                          ],
                        )
                    ),
                    Container(  //간지 버튼
                      height: style.fullSizeButtonHeight,
                      width: tagButtonWidth,// * 0.83,
                      margin: EdgeInsets.only(left: style.UIMarginLeft),
                      decoration: BoxDecoration(
                        color: style.colorNavy,
                        borderRadius: BorderRadius.circular(style.textFiledRadius),
                      ),
                      child: TextButton(
                        child: Text(searchButtonText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: searchButtonTextColor)),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorNavy, surfaceTintColor: Colors.transparent),
                        onPressed: () {
                          setState(() {
                            SetSearchNum();
                          });
                        },
                      ),
                    ),
                    Container(  //모두 취소 버튼
                      height: style.fullSizeButtonHeight,
                      width: style.fullSizeButtonHeight,// * 0.83,
                      margin: EdgeInsets.only(left: style.UIMarginLeft),
                      decoration: BoxDecoration(
                        color: style.colorNavy,
                        borderRadius: BorderRadius.circular(style.textFiledRadius),
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset('assets/recycle_icon.svg', width: style.iconSize, height: style.iconSize,),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, foregroundColor: style.colorNavy, surfaceTintColor: Colors.transparent),
                        onPressed: () {
                          setState(() {
                            SetSelectedLabel(-1);
                            SetSelectedCheongan(-1);
                            SetSelectedJiji(-1);
                            searchTextController.text = '';
                            SetSearchButtonTextColor();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          [ //검색 버튼들
            Container(  //천간
              width: style.UIButtonWidth+37,
              height: 60,
              margin: EdgeInsets.only(top:10),
              child: ScrollConfiguration(  //검색 버튼들
                behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  child: Row(
                    children: [
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft * 1.3),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,0),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 0? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(0);
                            },
                            child: Text(style.stringCheongan[koreanGanji][0], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold',
                                fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,1),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 1? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(1);
                            },
                            child: Text(style.stringCheongan[koreanGanji][1], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,2),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 2? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(2);
                            },
                            child: Text(style.stringCheongan[koreanGanji][2], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,3),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 3? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(3);
                            },
                            child: Text(style.stringCheongan[koreanGanji][3], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,4),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 4? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(4);
                            },
                            child: Text(style.stringCheongan[koreanGanji][4], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,5),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 5? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(5);
                            },
                            child: Text(style.stringCheongan[koreanGanji][5], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,6),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 6? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(6);
                            },
                            child: Text(style.stringCheongan[koreanGanji][6], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: style.colorBlack)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,7),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 7? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(7);
                            },
                            child: Text(style.stringCheongan[koreanGanji][7], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: style.colorBlack)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,8),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 8? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(8);
                            },
                            child: Text(style.stringCheongan[koreanGanji][8], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft, right: style.UIMarginLeft * 1.3),
                          decoration: BoxDecoration(color: style.SetOhengColor(true,9),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedCheonganNum == 9? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedCheongan(9);
                            },
                            child: Text(style.stringCheongan[koreanGanji][9], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(  //지지
              width: style.UIButtonWidth+37,
              height: 60,
              margin: EdgeInsets.only(top:10),
              child: ScrollConfiguration(  //검색 버튼들
                behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  child: Row(
                    children: [
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft * 1.3),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,0),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 0? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(0);
                            },
                            child: Text(style.stringJiji[koreanGanji][0], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,1),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 1? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(1);
                            },
                            child: Text(style.stringJiji[koreanGanji][1], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,2),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 2? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(2);
                            },
                            child: Text(style.stringJiji[koreanGanji][2], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,3),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 3? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(3);
                            },
                            child: Text(style.stringJiji[koreanGanji][3], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,4),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 4? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(4);
                            },
                            child: Text(style.stringJiji[koreanGanji][4], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,5),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 5? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(5);
                            },
                            child: Text(style.stringJiji[koreanGanji][5], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,6),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 6? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(6);
                            },
                            child: Text(style.stringJiji[koreanGanji][6], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,7),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 7? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(7);
                            },
                            child: Text(style.stringJiji[koreanGanji][7], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,8),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 8? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(8);
                            },
                            child: Text(style.stringJiji[koreanGanji][8], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: style.colorBlack)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,9),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 9? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(9);
                            },
                            child: Text(style.stringJiji[koreanGanji][9], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: style.colorBlack)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,10),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 10? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(10);
                            },
                            child: Text(style.stringJiji[koreanGanji][10], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: searchContainerHeight,
                          height: searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft, right: style.UIMarginLeft * 1.3),
                          decoration: BoxDecoration(color: style.SetOhengColor(false,11),
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedJijiNum == 11? style.colorBoxGray1 : Colors.transparent,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedJiji(11);
                            },
                            child: Text(style.stringJiji[koreanGanji][11], style:TextStyle(fontSize: style.UIOhengDiaryListSize, fontFamily: 'NotoSansKR-Bold', fontWeight: style.UIOhengDeunFontWeight, color: Colors.white)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(  //라벨
              width: style.UIButtonWidth+37,
              height: 60,
              margin: EdgeInsets.only(top:10),
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  child: Row(
                    children: [
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft * 1.3),
                          decoration: BoxDecoration(color: selectedLabelNum == 0? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 0? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(0);
                            },
                            child: Text(listLabelString[0], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 1? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 1? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(1);
                            },
                            child: Text(listLabelString[1], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 2? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 2? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(2);
                            },
                            child: Text(listLabelString[2], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 3? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 3? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(3);
                            },
                            child: Text(listLabelString[3], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 4? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 4? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(4);
                            },
                            child: Text(listLabelString[4], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString * 3,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 5? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 5? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(5);
                            },
                            child: Text(listLabelString[5], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 6? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 6? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(6);
                            },
                            child: Text(listLabelString[6], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft),
                          decoration: BoxDecoration(color: selectedLabelNum == 7? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 7? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(7);
                            },
                            child: Text(listLabelString[7], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                      Container(
                          width: labelButtonWidth + labelButtonWidthPerString,
                          height:searchContainerHeight,
                          margin: EdgeInsets.only(left: style.UIMarginLeft, right: style.UIMarginLeft * 1.3),
                          decoration: BoxDecoration(color: selectedLabelNum == 8? style.colorMainBlue : Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                            border: Border.all(
                              width: 2,
                              color: selectedLabelNum == 8? Colors.transparent : style.colorDarkGrey,
                            ),
                          ),
                          child:TextButton(
                            onPressed: () {
                              SetSelectedLabel(8);
                            },
                            child: Text(listLabelString[8], style:Theme.of(context).textTheme.labelMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                            style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),][searchNum],
          Expanded(
            child: Container(  //저장목록
              //높이 = 스크린 높이 - 앱바 높이 - 바텀네비 높이 - 헤드라인 높이 - 헤드라인 밑줄 높이 - 검색창 버튼 높이 - 검색창 버튼 마진 높이 - 리스트뷰 마진 높이 - 임의 보정
              //height: MediaQuery.of(context).size.height - 60 - 60 - style.headLineHeight - 3 - style.fullSizeButtonHeight - style.UIMarginTopTop - style.UIMarginTop - 50,
              width: style.UIButtonWidth,
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  //reverse: true,
                  itemCount:saveDataManager.mapDiary.length,
                  itemBuilder: (context, i){
                    i = saveDataManager.mapDiary.length - i - 1;
                    bool passVal = false;
                    if(searchTextController.text == '' && selectedCheonganNum == -1 && selectedJijiNum == -1 && selectedLabelNum == -1){
                      passVal = true;
                    }
                    else{
                      String data = "${(saveDataManager.mapDiary[i]['dayData']/10000).floor()}년${((saveDataManager.mapDiary[i]['dayData']%10000)/100).floor()}월${(saveDataManager.mapDiary[i]['dayData'] % 100)}일";
                      String monthString = '';
                      if(((saveDataManager.mapDiary[i]['dayData']%10000)/100).floor() < 10){
                        monthString = '0${((saveDataManager.mapDiary[i]['dayData']%10000)/100).floor()}';
                      } else {
                        monthString = '${((saveDataManager.mapDiary[i]['dayData']%10000)/100).floor()}';
                      }
                      String dayString = '';
                      if((saveDataManager.mapDiary[i]['dayData']%100).floor() < 10){
                        dayString = '0${(saveDataManager.mapDiary[i]['dayData']%100).floor()}';
                      } else {
                        dayString = '${(saveDataManager.mapDiary[i]['dayData']%100).floor()}';
                      }

                      String data0 = "${(saveDataManager.mapDiary[i]['dayData']/10000).floor()}.${monthString}.${dayString}.";
                      if(searchTextController.text != ''){
                        if(data.toLowerCase().contains(searchTextController.text.toLowerCase()) || data0.toLowerCase().contains(searchTextController.text.toLowerCase()) || saveDataManager.mapDiary[i]['memo'].substring(4, saveDataManager.mapDiary[i]['memo'].length).toLowerCase().contains(searchTextController.text.toLowerCase())){
                          passVal = true;
                        }
                      }
                      if(selectedCheonganNum == int.parse(saveDataManager.mapDiary[i]['memo'].substring(1,2))
                          || selectedJijiNum == int.parse(saveDataManager.mapDiary[i]['memo'].substring(2,4))
                          || ((saveDataManager.mapDiary[i]['labelData'] % (selectedLabelNumToData * 10)) / selectedLabelNumToData).floor() == 2){
                        passVal = true;
                      }
                    }
                    if(passVal == true){
                      return Container(
                        //color:Colors.green,
                        width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                        height: style.saveDataMemoLineHeight + GetIljiContainerHeight(saveDataManager.mapDiary[i]['memo'].substring(4, saveDataManager.mapDiary[i]['memo'].length)),
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: (){
                            Map mapUserData = {};

                            if(personalDataManager.mapUserData.isNotEmpty){  //사용자 등록이 안되어있으면
                              mapUserData['gender'] = personalDataManager.mapUserData['gender'];
                              mapUserData['uemYang'] = personalDataManager.mapUserData['uemYang'];
                              mapUserData['birthYear'] = personalDataManager.mapUserData['birthYear'];
                              mapUserData['birthMonth'] = personalDataManager.mapUserData['birthMonth'];
                              mapUserData['birthDay'] = personalDataManager.mapUserData['birthDay'];
                              mapUserData['birthHour'] = personalDataManager.mapUserData['birthHour'];
                              mapUserData['birthMin'] = personalDataManager.mapUserData['birthMin'];
                              mapUserData['listPaljaData'] = personalDataManager.mapUserData['listPaljaData'];
                            }

                            List<int> listFindGanji = findGanji.InquireGanji((saveDataManager.mapDiary[i]['dayData'] / 10000).floor(), ((saveDataManager.mapDiary[i]['dayData'] % 10000) / 100).floor(),
                                saveDataManager.mapDiary[i]['dayData'] % 100, 12, 20);
                            List<int> listUserPalja = [];
                            List<int> listTodayGanji = [];
                            var listDynamicUserPalja = mapUserData['listPaljaData'];
                            listUserPalja = [listDynamicUserPalja[0], listDynamicUserPalja[1], listDynamicUserPalja[2], listDynamicUserPalja[3], listDynamicUserPalja[4], listDynamicUserPalja[5], listDynamicUserPalja[6], listDynamicUserPalja[7]];
                            listTodayGanji =  calendarDeunSeun.DeunFindClass().FindDeun(
                                mapUserData['gender'], mapUserData['birthYear'], mapUserData['birthMonth'],
                                mapUserData['birthDay'], mapUserData['birthHour'], mapUserData['birthMin'],
                                listUserPalja, (saveDataManager.mapDiary[i]['dayData'] / 10000).floor(), ((saveDataManager.mapDiary[i]['dayData'] % 10000) / 100).floor(), saveDataManager.mapDiary[i]['dayData'] % 100);

                            List<int> listTodayPalja = [listTodayGanji[0], listTodayGanji[1], listFindGanji[0], listFindGanji[1], listFindGanji[2], listFindGanji[3], listFindGanji[4], listFindGanji[5]];

                            setState(() {
                              widget.SetSideOptionWidget(diaryWriting.DiaryWriting(listTodayPalja: listTodayPalja, userGender: personalDataManager.mapUserData['gender'], userIlganNum: personalDataManager.mapUserData['listPaljaData'][4], userYeonjiNum: personalDataManager.mapUserData['listPaljaData'][1], diaryYear: (saveDataManager.mapDiary[i]['dayData'] / 10000).floor(), diaryMonth: ((saveDataManager.mapDiary[i]['dayData'] % 10000) / 100).floor(),
                                diaryDay: saveDataManager.mapDiary[i]['dayData'] % 100, dayString: saveDataManager.mapDiary[i]['memo'].substring(0,1), isWriting: 0, CloseOption: widget.CloseOption, RevealWindow: widget.RevealWindow,), isCompulsionOn : true);
                            });
                          },
                          style: ElevatedButton.styleFrom(padding:EdgeInsets.zero, backgroundColor: style.colorBackGround, elevation:0.0, shadowColor: style.colorBackGround, foregroundColor: style.colorBackGround),
                          child: Column(
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(  //연월일 간지
                                      height: style.saveDataMemoLineHeight,
                                      child: Row(
                                          children:[
                                            Container(
                                                height: style.saveDataMemoLineHeight,
                                                padding: EdgeInsets.only(top:6.6),
                                                child: Text(GetDateText((saveDataManager.mapDiary[i]['dayData'] / 10000).floor(), ((saveDataManager.mapDiary[i]['dayData'] % 10000) / 100).floor(), saveDataManager.mapDiary[i]['dayData'] % 100, saveDataManager.mapDiary[i]['memo'].substring(0,1)), style:Theme.of(context).textTheme.titleLarge)),
                                            Container(
                                                height: style.saveDataMemoLineHeight,
                                                padding:EdgeInsets.only(top:2.8),
                                                child: GetIlganText(int.parse(saveDataManager.mapDiary[i]['memo'].substring(1,2)))),
                                            Container(
                                              height: style.saveDataMemoLineHeight,
                                              padding:EdgeInsets.only(top:2.8),
                                              child: GetIljiText(int.parse(saveDataManager.mapDiary[i]['memo'].substring(2,4))),
                                            ),]
                                      ),
                                    ),
                                    Container(  //일기의 라벨 표시
                                      height: style.saveDataMemoLineHeight,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: GetLabelContainer(saveDataManager.mapDiary[i]['labelData']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              saveDataManager.mapDiary[i]['memo'].length == 3? SizedBox.shrink():
                              Container(
                                  width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
                                  height: GetIljiContainerHeight(saveDataManager.mapDiary[i]['memo'].substring(4, saveDataManager.mapDiary[i]['memo'].length)),// style.saveDataMemoLineHeight * 2,
                                  child: Text(GetFirstLineText(saveDataManager.mapDiary[i]['memo'].substring(4, saveDataManager.mapDiary[i]['memo'].length)), style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    else{
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
          //SizedBox(width:10, height: style.UIMarginLeft),
        ],
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