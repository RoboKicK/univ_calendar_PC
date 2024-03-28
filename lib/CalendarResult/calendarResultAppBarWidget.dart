import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../SaveData/saveDataManager.dart' as saveDataManager;
import 'dart:io';
import '../../style.dart' as style;


class CalendarResultAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  const CalendarResultAppBarWidget({super.key, required this.name, required this.gender, required this.uemYang, required this.birthYear, required this.birthMonth, required this.birthDay, required this.birthHour
    , required this.birthMin, required this.memo, required this.saveDataNum, required this.ShowMemo, required this.OpenEndDrawer});

  final String name;
  final String gender;
  final int uemYang;
  final int birthYear, birthMonth, birthDay, birthHour, birthMin;
  final String memo;
  final String saveDataNum;
  final ShowMemo;
  final OpenEndDrawer;

  @override
  Size get preferredSize => new Size.fromHeight(60);
  
  @override
  State<CalendarResultAppBarWidget> createState() => _CalendarResultAppBarWidgetState();
}

class _CalendarResultAppBarWidgetState extends State<CalendarResultAppBarWidget> {

  int isSaved = 1; //저장되어 있는 명식인가? 0:네, 1:아니오

  IconData markIcon = Icons.check_circle_outline;
  String saveDataNum = '';

  ShowDialogMessage(String birth){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('이미 같은 명식이 저장되어 있습니다\n그래도 저장하시겠습니까?'),
          content: Text(birth, textAlign: TextAlign.center),
          buttonPadding: EdgeInsets.only(left:20, right:20, top:0),
          actions: [
            ElevatedButton(
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                onPressed: (){
                  saveDataManager.SavePersonData(widget.name, widget.gender, widget.uemYang, widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin);
                  setState(() {
                    isSaved = 0;
                  });
                  Navigator.pop(context);
                },
                child: Text('저장')),
            ElevatedButton(
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('취소')),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();

    if (widget.saveDataNum != '') {
      isSaved = 0;
      saveDataNum = widget.saveDataNum;

      if(saveDataManager.mapPerson[int.parse(saveDataNum.substring(1,4))]['mark'] == true){
        markIcon = Icons.check_circle;
      }
      else{
        markIcon = Icons.check_circle_outline;
      }
    }
  }

  SetMarkIcon(){  //주의! 아이콘 저장 순서 때문에 조건문과 반대로 되어있음
    setState(() {
        if(saveDataNum != ''){
          if(saveDataManager.mapPerson[int.parse(saveDataNum.substring(1,4))]['mark'] == true){
            markIcon = Icons.check_circle_outline;
          }
          else{
            markIcon = Icons.check_circle;
          }
        }
        else{
          if(saveDataManager.mapPerson.last['mark'] == true){
            markIcon = Icons.check_circle_outline;
          }
          else{
            markIcon = Icons.check_circle;
          }
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      centerTitle: true,
      shadowColor: Color(0xff343434),
      //surfaceTintColor: Color.fromARGB(255, 21, 21, 21),
      elevation: 5.0, //Drop Shadow, 붕 떠 있는 느낌의 수치
      actions:[
        AnimatedOpacity(
          opacity: isSaved == 0? 1.0 : 0.0,
          duration: Duration(milliseconds: 130),
          child: IconButton( //즐겨찾기 아이콘
            icon: Icon(markIcon),
            onPressed: (){
              SetMarkIcon();
                saveDataManager.SavePersonMark(saveDataNum);
            },
          ),
        ),
        [
          AnimatedOpacity( //메모 아이콘
          opacity: isSaved == 0? 1.0 : 0.0,
          duration: Duration(milliseconds: 130),
          child: IconButton(
            icon: Icon(Icons.chat),
            onPressed: (){
              widget.ShowMemo();
            },
          ),
        ),
          IconButton( //저장 아이콘
            icon: Icon(Icons.add_box),
            onPressed: (){
                bool isSamePerson = saveDataManager.SavePersonIsSameChecker(widget.name, widget.gender, widget.uemYang, widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin, ShowDialogMessage);

                if(isSamePerson == true){
                  saveDataManager.SavePersonData(widget.name, widget.gender, widget.uemYang, widget.birthYear, widget.birthMonth, widget.birthDay, widget.birthHour, widget.birthMin);
                  setState(() {
                    isSaved = 0;
                  });
                }
            },
          ),][isSaved],
        IconButton( //메뉴 아이콘
          icon: Icon(Icons.menu),
          onPressed: (){
            widget.OpenEndDrawer();
          },
        ),
      ],
      title : Text('만세력', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
    );
  }
}