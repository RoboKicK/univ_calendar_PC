import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'personalDataManager.dart' as personalDataManager;
import '../style.dart' as style;
import '../SaveData/saveDataManager.dart' as saveDataManager;

class ResetSettingWidget extends StatefulWidget {
  const ResetSettingWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this.reloadSetting, required this.refreshMapPersonLengthAndSort,
    required this.refreshListMapGroupLength, required this.refreshMapRecentLength, required this.refreshMapDiaryLength, required this.refreshDiaryUserData});

  final double widgetWidth;
  final double widgetHeight;

  final reloadSetting;
  final refreshMapPersonLengthAndSort, refreshListMapGroupLength, refreshMapRecentLength, refreshMapDiaryLength, refreshDiaryUserData;

  @override
  State<ResetSettingWidget> createState() => _ResetSettingWidgetState();
}

//저장 목록 관리
class _ResetSettingWidgetState extends State<ResetSettingWidget> {

  bool isDeletePersonData = false, isDeleteGroupData = false, isDeleteRecentData = false, isDeleteDiary = false;

  double widgetWidth = 0;
  double widgetHeight = 0;

  ShowSnackBar(String text){
    SnackBar snackBar = SnackBar(
      content: Text(text, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
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

  Future<void> DeleteData() async {
    if(isDeletePersonData == false && isDeleteGroupData == false && isDeleteDiary == false && isDeleteRecentData == false){
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        //barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              '삭제할 데이터를 선택해 주세요',
              textAlign: TextAlign.center,
            ),
          );
        },
      );
      return;
    }

    if(isDeletePersonData == true){
      saveDataManager.DeleteFile(0);
      widget.refreshMapPersonLengthAndSort();
    }
    if(isDeleteGroupData == true){
      saveDataManager.DeleteFile(1);
      widget.refreshListMapGroupLength();
    }
    if(isDeleteRecentData == true){
      saveDataManager.DeleteFile(2);
      widget.refreshMapRecentLength();
    }
    if(isDeleteDiary == true){
      saveDataManager.DeleteFile(3);
      widget.refreshMapDiaryLength();
    }
    ShowSnackBar('데이터를 삭제했습니다');
    widget.reloadSetting();
  }

  @override
  initState() {
    super.initState();

    widgetWidth = widget.widgetWidth;
    widgetHeight = widget.widgetHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(style.textFiledRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: widgetWidth,
            height: style.fullSizeButtonHeight,
            alignment: Alignment.center,
            child:Text('데이터 초기화', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Container(  //정렬용 컨테이너
            width: widgetWidth,
            height: 1,
          ),
          Column(
            children: [
              Container(  //정렬용 컨테이너
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 1,
              ),
              Container(  //설정 설명
                height: style.saveDataMemoLineHeight * 0.7,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("설정값을 초기화합니다", style: style.settingInfoText0,),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: style.UIMarginTop),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      //splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
                    ),
                    child: Text(
                      '설정 초기화',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        personalDataManager.ResetAllFiles();
                        widget.refreshDiaryUserData(setOnlyRegiedUserData: true);
                        ShowSnackBar('개인 설정을 초기화했습니다');
                      });
                    }),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 46,
                margin: EdgeInsets.only(top:style.UIMarginTop),
                child: Text("· 개인 설정을 초기화합니다\n· 설정 옵션에 오류가 있는 경우 사용합니다", style: style.settingInfoText0,),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 1,
                margin: EdgeInsets.only(top: 32),//22),
                color: style.colorGrey,
              ),
              Container(  //저장목록 초기화 설명
                height: style.saveDataMemoLineHeight * 0.7,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("선택한 저장 목록을 삭제합니다", style: style.settingInfoText0,),
              ),
              Container(  //데이터 추출 옵션 버튼들
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: style.saveDataMemoLineHeight,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("단일 ${style.myeongsicString} ", style: style.settingText0,),
                        Checkbox(
                          value: isDeletePersonData,
                          overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                          onChanged: (value) {
                            setState(() {isDeletePersonData = value!;});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("묶음 ${style.myeongsicString} ", style: style.settingText0,),
                        Checkbox(
                          value: isDeleteGroupData,
                          overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                          onChanged: (value) {
                            setState(() {isDeleteGroupData = value!;});
                          },
                        ),
                      ]
                    ),
                    Row(
                      children: [
                        Text("최근 ${style.myeongsicString} ", style: style.settingText0,),
                        Checkbox(
                          value: isDeleteRecentData,
                          overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                          onChanged: (value) {
                            setState(() {isDeleteRecentData = value!;});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("일진 일기 ", style: style.settingText0,),
                        Checkbox(
                          value: isDeleteDiary,
                          overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                          visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity
                          ),
                          onChanged: (value) {setState(() {isDeleteDiary = value!;
                          });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: style.UIMarginTop),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      //splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
                    ),
                    child: Text(
                      '저장 목록 삭제',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                '데이터 백업을 먼저 하시는 것을\n추천합니다',
                                textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => style.colorRed.withOpacity(0.7)), overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.3)), shadowColor: WidgetStateProperty.all(Colors.grey), elevation: WidgetStateProperty.all(1.0)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    DeleteData();
                                  },
                                  child: Text('삭제', style: TextStyle(color:Colors.white),),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('취소')),
                              ],
                            );
                          },
                        );
                      });
                    }),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 46,
                margin: EdgeInsets.only(top:style.UIMarginTop),
                child: Text("· 먼저 데이터를 백업하시고 삭제하세요", style: style.settingInfoText0,),
              ),
            ],
          ),
        ],
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

