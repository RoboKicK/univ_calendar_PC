import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import '../SaveData/saveDataManager.dart' as saveDataManager;

class DataManageWidget extends StatefulWidget {
  const DataManageWidget({super.key, required this.widgetWidth, required this.widgetHeight, required this. refreshMapPersonLengthAndSort, required this.refreshListMapGroupLength});

  final double widgetWidth;
  final double widgetHeight;

  final refreshMapPersonLengthAndSort, refreshListMapGroupLength;

  @override
  State<DataManageWidget> createState() => _DataManageWidgetState();
}

//저장 목록 관리
class _DataManageWidgetState extends State<DataManageWidget> {
  bool isExportPersonData = false, isExportGroupData = false, isExportDiary = false;

  double widgetWidth = 0;
  double widgetHeight = 0;

  Future<void> ExportData() async { //데이터 추출

    if(isExportPersonData == false && isExportGroupData == false && isExportDiary == false){
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        //barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              '추출할 데이터를 선택해 주세요',
              textAlign: TextAlign.center,
            ),
          );
        },
      );
      return;
    }

    String jsonString = '';
    if(isExportPersonData == true){ //단일 명식
      jsonString = '{[]}personData_pc{[]}';

      for(int i = 0; i < saveDataManager.mapPerson.length; i++){
        jsonString = jsonString + saveDataManager.mapPerson[i]['name'] + '{{' + saveDataManager.mapPerson[i]['birthData'].toString() + '{{' + saveDataManager.mapPerson[i]['saveDate'].toString() + '{{' + saveDataManager.mapPerson[i]['memo'] + '{{';
      }
    }
    if(isExportGroupData == true){  //명식 묶음
      jsonString = jsonString + '{[]}groupData_pc{[]}';

      String personMemoString = '';
      String personSaveDate = '';

      for(int i = 0; i < saveDataManager.listMapGroup.length; i++){
        jsonString = jsonString + saveDataManager.listMapGroup[i][0]['groupName'] + '{{' +
            saveDataManager.listMapGroup[i][0]['saveDate'].toString() + '{{' +
            saveDataManager.listMapGroup[i][0]['memo'] + '{{';
        for(int j = 1; j < saveDataManager.listMapGroup[i].length; j++){
          if(saveDataManager.listMapGroup[i][j]['memo'] == null){
            personMemoString == '';
          } else {
            personMemoString = saveDataManager.listMapGroup[i][j]['memo'];
          }
          if(saveDataManager.listMapGroup[i][j]['saveDate'] == null || saveDataManager.listMapGroup[i][j]['saveDate'] == DateTime.utc(3000)){
            personSaveDate = saveDataManager.listMapGroup[i][0]['saveDate'].toString();
          } else {
            personSaveDate = saveDataManager.listMapGroup[i][j]['saveDate'].toString();
          }
          jsonString = jsonString + saveDataManager.listMapGroup[i][j]['name'] + '{{' + saveDataManager.listMapGroup[i][j]['birthData'].toString() + '{{' + personSaveDate + '{{' + personMemoString;

          if(j < saveDataManager.listMapGroup[i].length - 1){
            jsonString = jsonString + '{{';
          } else {
            jsonString = jsonString + '}}'; //그룹의 마지막 명식은 }}로 마무리
          }
        }
      }
    }

    String? fileDir = await FilePicker.platform.saveFile(initialDirectory: Platform.packageConfig, type: FileType.custom, dialogTitle: Platform.packageConfig, fileName: 'LOC_PC_Data', allowedExtensions: List.empty());

    final file = await File('${fileDir}');
    await file.writeAsString(jsonEncode(jsonString));
  }

  LoadSavedData() async { //저장목록 불러오기
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    bool isLoadSuccess = false;

    if(result != null && result.files.isNotEmpty){
      String filePath = result.files.single.path!;

      String saveDataString = jsonDecode(await File('${filePath}').readAsString());

      int startNum = 0;
      int endNum = 0;

      if(saveDataString.substring(startNum, 21) == '{[]}personData_pc{[]}'){
        startNum = 21;
        endNum = 24;

        String personName = '';
        int birthData = 0;
        late DateTime saveDate;
        String personMemo = '';

        int samePersonCheckTryCount = saveDataManager.mapPerson.length; //중복확인 시도 횟수

        while (true) {
          if (saveDataString.substring(endNum - 2, endNum) == '{{') {
            personName = saveDataString.substring(startNum, endNum - 2);
            if(personName.length > 20 && personName.substring(0,20) == '{[]}groupData_pc{[]}'){
              saveDataManager.SavePersonFile();
              widget.refreshMapPersonLengthAndSort();
              isLoadSuccess = true;
              break;
            }
            startNum = endNum;
            birthData = int.parse(saveDataString.substring(startNum, startNum + 14));
            startNum = startNum + 16;
            saveDate = DateTime.parse(saveDataString.substring(startNum, startNum + 26));
            startNum = startNum + 28;
            endNum = startNum + 2;

            while(true) {
              if (saveDataString.substring(endNum - 2, endNum) == '{{') {
                personMemo = saveDataString.substring(startNum, endNum - 2);
                startNum = endNum;
                endNum = startNum + 2;

                if(saveDataManager.LoadPersonIsSameChecker(personName, birthData, saveDate, personMemo, samePersonCheckTryCount) == true) {
                  saveDataManager.mapPerson.add({'name': personName, 'birthData': birthData, 'saveDate': saveDate, 'memo': personMemo});
                }
                break;
              } else {
                endNum++;
              }
            }
          } else {
            endNum++;
          }
          if (saveDataString.length < endNum + 2) {
            saveDataManager.SavePersonFile();
            widget.refreshMapPersonLengthAndSort();
            isLoadSuccess = true;
            break;
          }
        }
      }
      if(saveDataString.substring(startNum, startNum + 20) == '{[]}groupData_pc{[]}'){

        startNum = startNum + 20;
        endNum = startNum + 2;

        String groupName = '';
        String personName = '';
        int birthData = 0;
        late DateTime saveDate;
        String groupMemo = '';
        String personMemo = '';

        int samePersonCheckTryCount = saveDataManager.listMapGroup.length;

        while (true) {
          if (saveDataString.length < endNum + 2) {
            break;
          }

          if (saveDataString.substring(endNum - 2, endNum) == '{{') {

            List<dynamic> groupMap = [];

            while(true){
              groupName = saveDataString.substring(startNum, endNum - 2);
              startNum = endNum;
              saveDate = DateTime.parse(saveDataString.substring(startNum, startNum + 26));
              startNum = startNum + 28;
              endNum = startNum + 2;
              while(true){  //그룹 메모
                if (saveDataString.substring(endNum - 2, endNum) == '{{'){
                  groupMemo = saveDataString.substring(startNum, endNum - 2);
                  startNum = endNum;
                  endNum = startNum + 2;

                  break;
                } else {
                  endNum++;
                }
              }

              groupMap.add({'groupName':groupName, 'saveDate':saveDate, 'memo':groupMemo});

              while(true) { //명식
                if (saveDataString.substring(endNum - 2, endNum) == '{{') {
                  personName = saveDataString.substring(startNum, endNum - 2);
                  startNum = endNum;
                  birthData = int.parse(saveDataString.substring(startNum, startNum + 14));
                  startNum = startNum + 16;
                  endNum = startNum + 2;

                  if(saveDataString.substring(startNum, startNum+1) == '2'){
                    saveDate = DateTime.parse(saveDataString.substring(startNum, startNum + 26));
                    startNum = startNum + 28;
                    endNum = startNum + 2;
                  }

                  while(true){  //메모
                    if (saveDataString.substring(endNum - 2, endNum) == '{{' || saveDataString.substring(endNum - 2, endNum) == '}}'){
                      personMemo = saveDataString.substring(startNum, endNum - 2);
                      startNum = endNum;
                      endNum = startNum + 2;

                      break;
                    } else {
                      endNum++;
                    }
                  }

                  groupMap.add({'name': personName, 'birthData': birthData, 'saveDate': saveDate, 'memo': personMemo});
                  if(saveDataString.substring(endNum - 4, endNum - 2) == '}}'){
                    if(saveDataManager.LoadGroupIsSameChecker(groupMap, samePersonCheckTryCount) == true) {
                      saveDataManager.listMapGroup.add(groupMap);
                    }
                    break;
                  }
                } else {
                  endNum++;
                }
              }

              if(saveDataString.substring(endNum - 4, endNum - 2) == '}}'){
                saveDataManager.SaveGroupFile();
                widget.refreshListMapGroupLength();
                isLoadSuccess = true;
                break;
              }
            }
          } else {
            endNum++;
          }
        }
      }
    }
    if(isLoadSuccess == true) {
      saveDataManager.snackBar('불러오기를 완료했습니다');
    }
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
      width: widgetWidth,//widgetWidth,
      height: widgetHeight,
      decoration: BoxDecoration(
        //color: style.colorBackGround,
        borderRadius: BorderRadius.circular(style.textFiledRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: style.UIButtonWidth,
            height: style.fullSizeButtonHeight,
            alignment: Alignment.center,
            child:Text('저장 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Column(
            children: [
              Container(  //정렬용 컨테이너
                width: widgetWidth,
                height: 1,
              ),
              Container(  //데이터 추출 설명
                height: style.saveDataMemoLineHeight * 0.6,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("선택한 데이터를 추출합니다", style: style.settingInfoText0,),
              ),
              Container(  //데이터 추출 옵션 버튼들
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: style.saveDataMemoLineHeight,
                margin: EdgeInsets.only(top: style.SettingMarginTopWithInfo1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("단일 명식 ", style: style.settingText0,),
                    Checkbox(
                      value: isExportPersonData,
                      onChanged: (value) {
                        setState(() {isExportPersonData = value!;});
                      },
                    ),
                    SizedBox(width:20),
                    Text("묶음 명식 ", style: style.settingText0,),
                    Checkbox(
                      value: isExportGroupData,
                      onChanged: (value) {
                        setState(() {isExportGroupData = value!;});
                      },
                    ),
                    SizedBox(width:20),
                    Text("일진 일기 ", style: style.settingText0,),
                    Checkbox(
                      value: isExportDiary,
                      onChanged: (value) {setState(() {isExportDiary = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: style.UIMarginTop),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      //splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
                    ),
                    child: Text(
                      '추출',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {ExportData();});
                    }),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: 1,
                margin: EdgeInsets.only(top: 22),
                color: style.colorGrey,
              ),
              Container(  //데이터 불러오기 설명
                height: style.saveDataMemoLineHeight * 0.7,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("추출한 파일을 통해 데이터를 불러옵니다", style: style.settingInfoText0,),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: style.fullSizeButtonHeight,
                margin: EdgeInsets.only(top: style.UIMarginTop),
                decoration: BoxDecoration(
                  color: style.colorMainBlue,
                  borderRadius: BorderRadius.circular(style.textFiledRadius),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      //splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
                    ),
                    child: Text(
                      '불러오기',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        LoadSavedData();
                      });
                    }),
              ),
              Container(
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                height: 200,
                margin: EdgeInsets.only(top:style.SettingMarginTopWithInfo1),
                child: Text("· 생년월일과 저장일자가 같은 명식은 덮어씁니다\n· 묶음 이름과 저장일자가 같은 묶음은 덮어씁니다", style: style.settingInfoText0,),
              ),
              //Container(
              //  width: (widgetWidth - (style.UIMarginLeft * 2)),
              //  height: 268,
              //  decoration: BoxDecoration(
              //    border: Border.all(width: 2, color:style.colorDarkGrey),
              //    borderRadius: BorderRadius.circular(style.textFiledRadius),
              //  ),
              //  margin: EdgeInsets.only(top: 18),
              //  child: Text("추출한 파일을 통해 데이터를 불러옵니다", style: style.settingInfoText0,),
              //),
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

