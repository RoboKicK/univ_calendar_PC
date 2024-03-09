import 'package:flutter/material.dart';
import 'Calendar/calendarMain.dart' as calendarMain;
import 'Settings/settingManagerWidget.dart' as settingManagerWidget;
import 'style.dart' as style;


class BodyWidgetManager extends StatefulWidget {
  const BodyWidgetManager({super.key, required this.nowMainTap, required this.isShowSettingPage, required this.setSettingPage});

  final int nowMainTap;
  final bool isShowSettingPage;
  final setSettingPage;

  @override
  State<BodyWidgetManager> createState() => _BodyWidgetManagerState();
}

class _BodyWidgetManagerState extends State<BodyWidgetManager> {

  Widget settingWidget = SizedBox.shrink();


  SetSettingWidget(bool isShow){
    if(isShow == true){
      settingWidget = Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 6,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.1),
        child: settingManagerWidget.SettingManagerWidget(setSettingPage: widget.setSettingPage),
      );
    } else {
      settingWidget = SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {

    SetSettingWidget(widget.isShowSettingPage);

    return Stack(
        children: [
          calendarMain.CalendarMain(),
          Container(
            //color:Colors.yellow,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 60,
            alignment: Alignment.center,
            child: settingWidget,
          ),

        ]
    ) ;

  }
}
