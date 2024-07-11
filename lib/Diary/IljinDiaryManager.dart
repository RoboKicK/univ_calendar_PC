import 'package:flutter/material.dart';
import '../style.dart' as style;
import 'DiaryWritingMain.dart' as diaryWritingMain;
import 'DiarySaveList.dart' as diarySaveList;

class Iljindiarymanager extends StatefulWidget {
  const Iljindiarymanager({super.key, required this.SetSettingWidget, required this.isRegiedUserData, required this.SetSideOptionWidget, required this.CloseOption});

  final bool isRegiedUserData;

  final SetSettingWidget;
  final SetSideOptionWidget;
  final CloseOption;

  @override
  State<Iljindiarymanager> createState() => _IljindiarymanagerState();
}

class _IljindiarymanagerState extends State<Iljindiarymanager> {

  List<Color> listDiaryTextColor = [Colors.white, style.colorGrey];
  var underLineOpacity = [1.0,0.0];

  List<Text> listDiaryTexts = [];
  List<String> diaryHeadLineTitle = ['일진일기', '일기목록'];

  int nowDiaryHeadLine = 0;

  List<Widget> listDiaryWidget = [];

  double widgetWidth = style.UIButtonWidth + 38;

  //헤드라인 눌렀을 때
  HeadLineButtonAction(int buttonNum) {
    setState(() {
      if(buttonNum == nowDiaryHeadLine){
        return;
      }

      listDiaryTexts[nowDiaryHeadLine] = Text(diaryHeadLineTitle[nowDiaryHeadLine], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorGrey));
      listDiaryTexts[buttonNum] = Text(diaryHeadLineTitle[buttonNum], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white));

      underLineOpacity[nowDiaryHeadLine] = 0.0;
      underLineOpacity[buttonNum] = 1.0;

      nowDiaryHeadLine = buttonNum;
    });
  }

  @override
  void initState() {

    listDiaryTexts.add(Text(diaryHeadLineTitle[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listDiaryTextColor[0]), ));
    listDiaryTexts.add(Text(diaryHeadLineTitle[1], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: listDiaryTextColor[1]), ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    listDiaryWidget = [ //일기 위젯
      Container(
        width: widgetWidth,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: diaryWritingMain.DiaryWritingMain(widgetWidth: widgetWidth, isRegiedUserData: widget.isRegiedUserData, SetSettingWidget: widget.SetSettingWidget, SetSideOptionWidget: widget.SetSideOptionWidget, CloseOption: widget.CloseOption),
      ),
      Container(
        width: widgetWidth,
        height: MediaQuery.of(context).size.height - style.appBarHeight - 55,
        child: diarySaveList.Diarysavelist(widgetWidth: widgetWidth, SetSideOptionWidget: widget.SetSideOptionWidget, CloseOption: widget.CloseOption,),
      ),
    ];

    return Column(
      children: [
        Container(
          width: style.UIButtonWidth,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: style.UIMarginTop),
          child: Row(  //헤드라인 글자
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                  height: style.headLineHeight,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[0])))),
                  child: TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: WidgetStateProperty.all(Colors.transparent),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      child:listDiaryTexts[0],
                      onPressed:(){HeadLineButtonAction(0);})
              ),
              Container(
                  height: style.headLineHeight,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[1])))),
                  child:TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory, overlayColor: WidgetStateProperty.all(Colors.transparent),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      child:listDiaryTexts[1]
                      , onPressed:(){HeadLineButtonAction(1);})
              ),
              Container(
                  height: style.headLineHeight,
                  alignment: Alignment.topCenter,
                  //decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[0])))),
                   child:Text('일진일기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.transparent)),
              ),
              Container(
                  height: style.headLineHeight,
                  alignment: Alignment.topCenter,
                  //decoration: BoxDecoration(border: Border(bottom: BorderSide(width:4, color:style.colorMainBlue.withOpacity(underLineOpacity[0])))),
                child:Text('일진일기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color:  Colors.transparent)),
              )],
          ),
        ),
        IndexedStack(
          index: nowDiaryHeadLine,
          children: listDiaryWidget,
          alignment: Alignment.topCenter,
        )
      ],
    );
  }
}
