import 'package:flutter/material.dart';
import 'Calendar/calendarMain.dart' as calendarMain;

class BodyWidgetManager extends StatefulWidget {
  const BodyWidgetManager({super.key, required this.nowMainTap});

  final int nowMainTap;

  @override
  State<BodyWidgetManager> createState() => _BodyWidgetManagerState();
}

class _BodyWidgetManagerState extends State<BodyWidgetManager> {
  @override
  Widget build(BuildContext context) {
    return calendarMain.CalendarMain();
  }
}
