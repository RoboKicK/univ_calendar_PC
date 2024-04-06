import 'package:flutter/material.dart';
import 'package:univ_calendar_pc/main.dart';
import 'Calendar/calendarMain.dart' as calendarMain;
import 'Settings/settingManagerWidget.dart' as settingManagerWidget;
import 'style.dart' as style;
import 'package:provider/provider.dart';
//import 'package:win_toast/win_toast.dart';


class BodyWidgetManager extends StatefulWidget {
  const BodyWidgetManager({super.key, required this.pageNum, required this.saveSuccess, required this.loadSuccess, required this.getNowPageNum, required this.setNowPageName});

  final int pageNum;
  final saveSuccess, loadSuccess;
  final getNowPageNum;
  final setNowPageName;

  @override
  State<BodyWidgetManager> createState() => _BodyWidgetManagerState();
}

class _BodyWidgetManagerState extends State<BodyWidgetManager> {

  bool isEditSetting = false;
  bool isGroupSave = false;

  //설정 바뀜 감시자
  ReloadSetting(){
    setState(() {
      context.read<Store>().SetEditSetting();//isEditSetting = !context.watch<Store>().isEditSetting;
      for(int i = 0; i < 3; i++){
      //  listCalendarKey[i].currentState?.isEditSetting = isEditSetting;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  calendarMain.CalendarMain(isEditSetting: isEditSetting, pageNum: widget.pageNum, saveSuccess: widget.saveSuccess, loadSuccess: widget.loadSuccess, getNowPageNum: widget.getNowPageNum, setNowPageName: widget.setNowPageName,);
  }
}
