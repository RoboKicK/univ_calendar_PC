import 'package:flutter/material.dart';
import '../../style.dart' as style;
import 'yugchinClass.dart' as yugchinClass;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class YugchinWidget extends StatefulWidget {
  const YugchinWidget({super.key, required this.containerColor, required this.listPaljaData, required this.stanIlganNum, required this.isManseryoc, required this.isCheongan, required this.isLastWidget, required this.widgetWidth});

  final Color containerColor;
  final List<int> listPaljaData;
  final int stanIlganNum;
  final bool isManseryoc;
  final bool isCheongan;
  final bool isLastWidget;
  final double widgetWidth;

  @override
  State<YugchinWidget> createState() => _YugchinWidgetState();
}

class _YugchinWidgetState extends State<YugchinWidget> {


  List<Widget> GetYugchinCheonganWidget(BuildContext context){
    List<Widget> listYugchinCheonganWidget = [];
    List<String> listCheonganYugchinString = [];

    int divideVal = (widget.listPaljaData.length / 2).floor();

    if(widget.stanIlganNum % 2 == 0){ //양일간
      if(widget.listPaljaData[0] != -2){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[(widget.listPaljaData[0] - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      } else {
        listCheonganYugchinString.add(style.emptySinsalText);
      }
      listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[(widget.listPaljaData[2] - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      if(widget.isManseryoc == true){
        listCheonganYugchinString.add(personalDataManager.GetIlganText());
      } else {
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[(widget.listPaljaData[4] - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      if(widget.listPaljaData[6] != -2){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[(widget.listPaljaData[6] - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      else{
        listCheonganYugchinString.add(style.emptySinsalText);
      }
      if(widget.listPaljaData.length > 8){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[(widget.listPaljaData[8] - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      if(widget.listPaljaData.length > 10){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[(widget.listPaljaData[10] - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
    }
    else{ //음일간
      if(widget.listPaljaData[0] != -2){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[((widget.listPaljaData[0]%2 == 1? widget.listPaljaData[0]:(widget.listPaljaData[0]+2)) - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      } else {
        listCheonganYugchinString.add(style.emptySinsalText);
      }
      listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[((widget.listPaljaData[2]%2 == 1? widget.listPaljaData[2]:(widget.listPaljaData[2]+2)) - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      if(widget.isManseryoc == true){
        listCheonganYugchinString.add(personalDataManager.GetIlganText());
      } else {
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[((widget.listPaljaData[4]%2 == 1? widget.listPaljaData[4]:(widget.listPaljaData[4]+2)) - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      if(widget.listPaljaData[6] != -2){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[((widget.listPaljaData[6]%2 == 1? widget.listPaljaData[6]:(widget.listPaljaData[6]+2)) - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      else{
        listCheonganYugchinString.add(style.emptySinsalText);
      }
      if(widget.listPaljaData.length > 8){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[((widget.listPaljaData[8]%2 == 1? widget.listPaljaData[8]:(widget.listPaljaData[8]+2)) - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      if(widget.listPaljaData.length > 10){
        listCheonganYugchinString.add(yugchinClass.YugchinClass().list6chin[((widget.listPaljaData[10]%2 == 1? widget.listPaljaData[10]:(widget.listPaljaData[10]+2)) - widget.stanIlganNum + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
    }

    if(widget.listPaljaData.length > 10){
      listYugchinCheonganWidget.add(Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listCheonganYugchinString[5], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(widget.listPaljaData.length > 8){
      listYugchinCheonganWidget.add(Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listCheonganYugchinString[4], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }

    listYugchinCheonganWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganYugchinString[3], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listYugchinCheonganWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganYugchinString[2], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listYugchinCheonganWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganYugchinString[1], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listYugchinCheonganWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganYugchinString[0], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return listYugchinCheonganWidget;
  }
  List<Widget> GetYugchinJijiWidget(BuildContext context){
    List<Widget> listYugchinJijiWidget = [];
    List<String> listCheonganJijiString = [];

    int divideVal = (widget.listPaljaData.length / 2).floor();

    if(widget.listPaljaData[1] != -2){
      listCheonganJijiString.add(yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(widget.listPaljaData[1],widget.stanIlganNum)]);
    } else {
      listCheonganJijiString.add(style.emptySinsalText);
    }
    listCheonganJijiString.add(yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(widget.listPaljaData[3],widget.stanIlganNum)]);
    listCheonganJijiString.add(yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(widget.listPaljaData[5],widget.stanIlganNum)]);
    if(widget.listPaljaData[7] != -2){
      listCheonganJijiString.add(yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(widget.listPaljaData[7],widget.stanIlganNum)]);
    }
    else{
      listCheonganJijiString.add(style.emptySinsalText);
    }
    if(widget.listPaljaData.length > 8){
      listCheonganJijiString.add(yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(widget.listPaljaData[9],widget.stanIlganNum)]);
    }
    if(widget.listPaljaData.length > 10){
      listCheonganJijiString.add(yugchinClass.YugchinClass().list6chin[yugchinClass.YugchinClass().FindJijiYugchin0(widget.listPaljaData[11],widget.stanIlganNum)]);
    }

    if(widget.listPaljaData.length > 10){
      listYugchinJijiWidget.add(Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listCheonganJijiString[5], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(widget.listPaljaData.length > 8){
      listYugchinJijiWidget.add(Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listCheonganJijiString[4], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }

    listYugchinJijiWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganJijiString[3], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listYugchinJijiWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganJijiString[2], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listYugchinJijiWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganJijiString[1], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listYugchinJijiWidget.add(Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listCheonganJijiString[0], style: Theme.of(context).textTheme.bodySmall, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return listYugchinJijiWidget;
  }

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    if(widget.isCheongan == true){

      List<Widget> listYugchinCheongan = GetYugchinCheonganWidget(context);

      return Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
        height: style.UIBoxLineHeight,
        //margin: EdgeInsets.only(left: style.UIMarginLeft),
        decoration: BoxDecoration(
          //border: Border(bottom: BorderSide(width:1, color:style.colorDarkGrey)),
          color: widget.containerColor,
          boxShadow: [
            BoxShadow(
              color: widget.containerColor,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: listYugchinCheongan,
        ),
      );
    }
    else{
      List<Widget> listYugchinJiji = GetYugchinJijiWidget(context);

      return Container(
        width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
        height: style.UIBoxLineHeight,
        //margin: EdgeInsets.only(left: style.UIMarginLeft),
        decoration: BoxDecoration(color: widget.containerColor,
            //border: Border(top: BorderSide(width:1, color:style.colorDarkGrey)),
          boxShadow: [
              BoxShadow(
                color: widget.containerColor,
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.isLastWidget==false? 0:style.textFiledRadius), bottomRight: Radius.circular(widget.isLastWidget==false? 0:style.textFiledRadius))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: listYugchinJiji,
        ),
      );
    }
  }
}

/*
class Yugchin{  //육친 계산해주는 클래스

  List<String> list6chin = ['비견','겁재','식신','상관','편재','정재','편관','정관','편인','정인'];

  int FindJijiYugchin0(int jijiNum, int ilganNum){
    int yugchinNum = 0;
    int ilganRev = 0;
    int jijiRev = 0;

    if(ilganNum == 4 || ilganNum == 5){ //일간이 토일 때
      jijiRev = (jijiNum + 4) % style.stringJiji[0].length;

      if(jijiNum % 3 != 1) { //지지가 토가 아닐 때
        yugchinNum = ((jijiRev - (jijiRev/3).floor() + 2) + list6chin.length) % list6chin.length;//list6chin.length;
        //print((jijiRev - (jijiRev/3).floor()));
        if(ilganNum == 5){
          if(yugchinNum % 2 == 0){
            yugchinNum++;
          }
          else{
            yugchinNum--;
          }
        }
      }
      else{
        if(jijiNum == 4 || jijiNum == 10){
          yugchinNum = ilganNum % 2;
        }
        else{
          yugchinNum = (ilganNum + 1) % 2;
        }
      }
    }
    else{  //일간이 양일 때  // if(ilganNum % 2 == 0)
      bool isYang = true; //true는 양, false는 음
      if(ilganNum % 2 == 1){
        isYang = false;
      }

      if(isYang == true){
        ilganRev = ((ilganNum - 6) + style.stringCheongan[0].length) % style.stringCheongan[0].length;
      }
      else{
        ilganRev = ((ilganNum - 7) + style.stringCheongan[0].length) % style.stringCheongan[0].length;
      }

      jijiRev = ((jijiNum - 8) + style.stringJiji[0].length) % style.stringJiji[0].length;

      if(jijiNum % 3 != 1) {  //지지가 토가 아닐 때
        yugchinNum = (jijiRev - (jijiRev/3).floor() - ilganRev) % list6chin.length;
      }
      else{ //지지가 토일 때
        if(ilganNum < 2 || ilganNum == 6 || ilganNum == 7){//(ilganNum == 0 || ilganNum == 6){ //갑경 일간
          yugchinNum = (((jijiNum + 3) / 3).floor() % 2) + 4 + (ilganNum * (4 / 6)).floor();
        }
        else{ //병임일간
          yugchinNum = (((jijiNum + 3)/ 3).floor() % 2) + 2 + ((ilganNum - 2) * (4 / 6)).floor();
        }
      }

      if(isYang == false){
        if(yugchinNum % 2 == 0){
          yugchinNum++;
        }
        else{
          yugchinNum--;
        }
      }
    }

    return yugchinNum;
  }

  GetCheonganYugchin(BuildContext context, Color containerColor, ContainerColorSwitchSetter, List<int> _listPaljaData){
    ContainerColorSwitchSetter;

    List<String> listCheonganYugchin = [];
    if(_listPaljaData[4] % 2 == 0){ //양일간
      if(_listPaljaData[6] != -2){
        listCheonganYugchin.add(list6chin[(_listPaljaData[6] - _listPaljaData[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      else{
        listCheonganYugchin.add(style.emptySinsalText);
      }
      listCheonganYugchin.add('일간');
      listCheonganYugchin.add(list6chin[(_listPaljaData[2] - _listPaljaData[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      listCheonganYugchin.add(list6chin[(_listPaljaData[0] - _listPaljaData[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
    }
    else{ //음일간
      if(_listPaljaData[6] != -2){
        listCheonganYugchin.add(list6chin[((_listPaljaData[6]%2 == 1? _listPaljaData[6]:(_listPaljaData[6]+2)) - _listPaljaData[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      }
      else{
        listCheonganYugchin.add(style.emptySinsalText);
      }
      listCheonganYugchin.add('일간');
      listCheonganYugchin.add(list6chin[((_listPaljaData[2]%2 == 1? _listPaljaData[2]:(_listPaljaData[2]+2)) - _listPaljaData[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
      listCheonganYugchin.add(list6chin[((_listPaljaData[0]%2 == 1? _listPaljaData[0]:(_listPaljaData[0]+2)) - _listPaljaData[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length]);
    }
    return Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
      height: style.UIBoxLineHeight,
      margin: EdgeInsets.only(left: style.UIMarginLeft),
      decoration: BoxDecoration(color: containerColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[0], style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[1], style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[2], style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[3], style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  GetJijiYugchin(BuildContext context, Color containerColor, ContainerColorSwitchSetter, List<int> _listPaljaData){
    ContainerColorSwitchSetter;

    List<String> listCheonganYugchin = [];

    if(_listPaljaData[7] != -2){
      listCheonganYugchin.add(list6chin[FindJijiYugchin0(_listPaljaData[7],_listPaljaData[4])]);
    }
    else{
      listCheonganYugchin.add(style.emptySinsalText);
    }
    listCheonganYugchin.add(list6chin[FindJijiYugchin0(_listPaljaData[5],_listPaljaData[4])]);
    listCheonganYugchin.add(list6chin[FindJijiYugchin0(_listPaljaData[3],_listPaljaData[4])]);
    listCheonganYugchin.add(list6chin[FindJijiYugchin0(_listPaljaData[1],_listPaljaData[4])]);

    return Container(
      width: (widget.widgetWidth - (style.UIMarginLeft * 2)),
      height: style.UIBoxLineHeight,
      margin: EdgeInsets.only(left: style.UIMarginLeft),
      decoration: BoxDecoration(color: containerColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[0], style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[1], style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[2], style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            width: (widget.widgetWidth - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listCheonganYugchin[3], style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

}*/