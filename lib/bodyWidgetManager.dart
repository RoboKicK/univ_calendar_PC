import 'package:flutter/material.dart';
import 'package:univ_calendar_pc/main.dart';
import 'Calendar/calendarMain.dart' as calendarMain;
import 'Settings/settingManagerWidget.dart' as settingManagerWidget;
import 'style.dart' as style;
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';


class BodyWidgetManager extends StatefulWidget {
  const BodyWidgetManager({super.key, required this.nowMainTap, required this.isShowSettingPage, required this.setSettingPage, required this.nowCalendarNum, required this.clearPageNum, required this.setClearPageNum});

  final int nowMainTap;
  final bool isShowSettingPage;
  final setSettingPage;
  final int nowCalendarNum;
  final int clearPageNum;
  final setClearPageNum;

  @override
  State<BodyWidgetManager> createState() => _BodyWidgetManagerState();
}

class _BodyWidgetManagerState extends State<BodyWidgetManager> {

  Widget settingWidget = SizedBox.shrink();
  bool isEditSetting = false;

  int calendarCount = 5;
  List<Widget> listCalendarMain = [];
  int nowCalendarNum = 0;

  //설정 위젯 보이기 안보이기
  SetSettingWidget(bool isShow){
    if(isShow == true){
      settingWidget = Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 6,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.1),
        child: settingManagerWidget.SettingManagerWidget(setSettingPage: widget.setSettingPage, reloadSetting: ReloadSetting),
      );
    } else {
      settingWidget = SizedBox.shrink();
    }
  }

  //설정 바뀜 감시자
  ReloadSetting(){
    setState(() {
      context.read<Store>().SetEditSetting();//isEditSetting = !context.watch<Store>().isEditSetting;
      for(int i = 0; i < 3; i++){
      //  listCalendarKey[i].currentState?.isEditSetting = isEditSetting;
      }
    });
  }

  //페이지 비우기
  ClearPage(int num){
    setState(() {
      listCalendarMain.removeAt(num);
      listCalendarMain.insert(num,calendarMain.CalendarMain(isEditSetting: isEditSetting, key:UniqueKey()));
    });
  }

  //모든 페이지 비우기
  ClearAllPage(){
    setState(() {
      listCalendarMain.clear();
      for(int i = 0; i < calendarCount; i++){
        listCalendarMain.add(calendarMain.CalendarMain(isEditSetting: isEditSetting, key:UniqueKey()));
      }
      nowCalendarNum = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    nowCalendarNum = widget.nowCalendarNum;
    for(int i = 0; i < calendarCount; i++){
      //listCalendarKey.add(GlobalKey<calendarMain._CalendarMainState?>());
      listCalendarMain.add(calendarMain.CalendarMain(isEditSetting: isEditSetting, key:UniqueKey()));
    }
  }

  @override
  Widget build(BuildContext context) {

    SetSettingWidget(widget.isShowSettingPage);
    setState(() {
      nowCalendarNum = widget.nowCalendarNum;
    });

    if(widget.clearPageNum != -1){
      if(widget.clearPageNum == -2){  //모든 페이지 삭제
        ClearAllPage();
      } else {  //한 페이지 삭제
        ClearPage(widget.clearPageNum);
      }
      widget.setClearPageNum();
    }
    return Stack(
        children: [
          //calendarMain.CalendarMain(isEditSetting: isEditSetting),
          IndexedStack(
            index: nowCalendarNum,
            children: [
            listCalendarMain[0],
              listCalendarMain[1],
              listCalendarMain[2],
              listCalendarMain[3],
              listCalendarMain[4],
            ],
          ),
          Container(
            //color:Colors.yellow,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - style.appBarHeight,
            alignment: Alignment.center,
            child: settingWidget,
          ),
        ]
    ) ;

  }
}
