import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import '../SaveData/saveDataManager.dart' as saveDataManager;
import '../Settings/personalDataManager.dart' as personalDataManager;
import 'package:url_launcher/url_launcher.dart';

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

  //데이터 추출
  Future<void> ExportData() async {
    //추출 항목 선택 안 했을 때
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

    if(isExportDiary == true){  //일기
      jsonString = jsonString + '{[]}diaryData_pc{[]}';

      //dayData 숫자 8자리, labelData 숫자 9자리, memo 요일 1글자, 천간 숫자 1개, 지지 숫자 2개, ~메모

      for(int i = 0; i < saveDataManager.mapDiary.length; i++){
        jsonString = jsonString + saveDataManager.mapDiary[i]['dayData'].toString() + '{{' + saveDataManager.mapDiary[i]['labelData'].toString() + '{{' + saveDataManager.mapDiary[i]['memo'] + '{{';
      }
    }

    String saveDay = (DateTime.now().year % 100).toString();

    if(DateTime.now().month < 10){
      saveDay = saveDay + '0' + DateTime.now().month.toString();
    } else {
      saveDay = saveDay + DateTime.now().month.toString();
    }

    if(DateTime.now().day < 10){
      saveDay = saveDay + '0' + DateTime.now().day.toString();
    } else {
      saveDay = saveDay + DateTime.now().day.toString();
    }

    String? fileDir = await FilePicker.platform.saveFile(initialDirectory: Platform.packageConfig, type: FileType.custom, dialogTitle: Platform.packageConfig, fileName: 'LOC_PC_Data_${saveDay}', allowedExtensions: List.empty());

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

      //PC버전 단일명식 불러오기
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

            if(personName.length > 12){ //PC버전 묶음명식 저장목록이 시작되면 break
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
      //PC버전 묶음명식 불러오기
      if(saveDataString.length > startNum + 20 && saveDataString.substring(startNum, startNum + 20) == '{[]}groupData_pc{[]}'){

        startNum = startNum + 20;
        endNum = startNum + 3;

        String groupName = '';
        String personName = '';
        int birthData = 0;
        late DateTime saveDate;
        String groupMemo = '';
        String personMemo = '';

        int samePersonCheckTryCount = saveDataManager.listMapGroup.length;

        bool search = true;

        while (search) {
          if (saveDataString.length < endNum + 2) {
            break;
          }

          if (saveDataString.substring(endNum - 2, endNum) == '{{') {

            List<dynamic> groupMap = [];

            while(true){
              groupName = saveDataString.substring(startNum, endNum - 2);

              if(groupName.length > 12){// && groupName.substring(0,20) == '{[]}diaryData_pc{[]}'){

                saveDataManager.SaveGroupFile();
                isLoadSuccess = true;
                search = false;
                break;
              }

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
      //pc버전 일진일기 불러오기
      if(saveDataString.length > startNum + 20 && saveDataString.substring(startNum, startNum + 20) == '{[]}diaryData_pc{[]}'){
        if(personalDataManager.mapUserData.isEmpty){
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                Text(
                  "사용자 등록을 하지 않아 일기를 불러올 수 없습니다",
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
          return;
        }

        startNum = startNum + 20;

        int dayData = 0;
        int labelData = 0;
        String memo = '';

        int sameDiaryCheckTryCount = saveDataManager.mapDiary.length; //중복확인 시도 횟수

        while (true) {
          dayData = int.parse(saveDataString.substring(startNum, startNum + 8));
          startNum = startNum + 10;
          labelData = int.parse(saveDataString.substring(startNum, startNum + 9));
          startNum = startNum + 11;
          endNum = startNum + 2;

          while(true) {
            if (saveDataString.substring(endNum - 2, endNum) == '{{') {
              memo = saveDataString.substring(startNum, endNum - 2);
              startNum = endNum;
              endNum = startNum + 2;

              if(saveDataManager.LoadDiaryIsSameChecker(dayData, labelData, memo, sameDiaryCheckTryCount) == true) {
                saveDataManager.SaveDiaryData2((dayData/10000).floor(), (((dayData%10000)/100).floor()), (dayData % 100), labelData,
                    [0,0,0,0,0,0,int.parse(memo.substring(1,2)),int.parse(memo.substring(2,4))], memo.substring(0,1), memo.substring(4,memo.length), true);
              }
              break;
            } else {
              endNum++;
            }
          }

          if (saveDataString.length < endNum + 2) {
            saveDataManager.SaveDiaryFile();
            isLoadSuccess = true;
            break;
          }
        }
      }

      //모바일 버전 단일명식 불러오기
      if(saveDataString.length > startNum + 22 && saveDataString.substring(startNum, 22) == '{[]}personData_mob{[]}'){
        startNum = 22;
        endNum = 25;

        String personName = '';
        int birthData = 0;
        late DateTime saveDate;
        String personMemo = '';

        int samePersonCheckTryCount = saveDataManager.mapPerson.length; //중복확인 시도 횟수

        while (true) {
          if (saveDataString.substring(endNum - 2, endNum) == '{{') {
            personName = saveDataString.substring(startNum, endNum - 2);

            //이름이 12글자가 넘어가면 다음으로
            if(personName.length > 12){//21 && personName.substring(0,21) == '{[]}matchData_mob{[]}'){
              saveDataManager.SavePersonFile();
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
            isLoadSuccess = true;
            break;
          }
        }
      }
      //모바일 버전 궁합명식 불러오기
      if(saveDataString.length > startNum + 21 && saveDataString.substring(startNum, startNum + 21) == '{[]}matchData_mob{[]}'){  //모바일 버전 궁합명식 저장목록

        startNum = startNum + 21;
        endNum = startNum + 3;

        String personName0 = '', personName1 = '';
        int birthData0 = 0, birthData1 = 0;
        late DateTime saveDate;
        String groupMemo = '';

        int sameMatchCheckTryCount = saveDataManager.listMapGroup.length; //중복확인 시도 횟수

        while (true) {
          if (saveDataString.substring(endNum - 2, endNum) == '{{') {

            List<dynamic> groupMap = [];

            personName0 = saveDataString.substring(startNum, endNum - 2);

            if(personName0.length > 12){//21 && personName0.substring(0,21) == '{[]}diaryData_mob{[]}'){
              saveDataManager.SaveGroupFile();
              isLoadSuccess = true;
              break;
            }

            startNum = endNum;
            birthData0 = int.parse(saveDataString.substring(startNum, startNum + 14));
            startNum = startNum + 16;
            endNum = startNum + 2;

            while (true) {
              if(saveDataString.substring(endNum - 2, endNum) == '{{'){
                personName1 = saveDataString.substring(startNum, endNum - 2);
                startNum = endNum;
                birthData1 = int.parse(saveDataString.substring(startNum, startNum + 14));
                startNum = startNum + 16;
                break;
              } else {
                endNum++;
              }
            }

            saveDate = DateTime.parse(saveDataString.substring(startNum, startNum + 26));
            startNum = startNum + 28;
            endNum = startNum + 2;

            while(true) {
              if (saveDataString.substring(endNum - 2, endNum) == '{{') {
                groupMemo = saveDataString.substring(startNum, endNum - 2);
                startNum = endNum;
                endNum = startNum + 2;

                groupMap.add({'groupName':"모바일 궁합", 'saveDate':saveDate, 'memo':groupMemo});
                groupMap.add({'name': personName0, 'birthData': birthData0, 'saveDate': saveDate, 'memo': ''});
                groupMap.add({'name': personName1, 'birthData': birthData1, 'saveDate': saveDate, 'memo': ''});

                if(saveDataManager.LoadGroupIsSameChecker(groupMap, sameMatchCheckTryCount) == true) {
                  saveDataManager.listMapGroup.add(groupMap);
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
            saveDataManager.SaveGroupFile();
            isLoadSuccess = true;
            break;
          }
        }
      }
      //모바일 버전 일진일기 불러오기
      if(saveDataString.length > startNum + 21 && saveDataString.substring(startNum, startNum + 21) == '{[]}diaryData_mob{[]}'){
        if(personalDataManager.mapUserData.isEmpty){
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                Text(
                  "사용자 등록을 하지 않아 일기를 불러올 수 없습니다",
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
          return;
        }

        startNum = startNum + 21;

        int dayData = 0;
        int labelData = 0;
        String memo = '';

        int sameDiaryCheckTryCount = saveDataManager.mapDiary.length; //중복확인 시도 횟수

        while (true) {
          dayData = int.parse(saveDataString.substring(startNum, startNum + 8));
          startNum = startNum + 10;
          labelData = int.parse(saveDataString.substring(startNum, startNum + 9));
          startNum = startNum + 11;
          endNum = startNum + 2;

          while(true) {
            if (saveDataString.substring(endNum - 2, endNum) == '{{') {
              memo = saveDataString.substring(startNum, endNum - 2);
              startNum = endNum;
              endNum = startNum + 2;

              if(saveDataManager.LoadDiaryIsSameChecker(dayData, labelData, memo, sameDiaryCheckTryCount) == true) {
                saveDataManager.SaveDiaryData2((dayData/10000).floor(), (((dayData%10000)/100).floor()), (dayData % 100), labelData,
                    [0,0,0,0,0,0,int.parse(memo.substring(1,2)),int.parse(memo.substring(2,4))], memo.substring(0,1), memo.substring(4,memo.length), true);
              }
              break;
            } else {
              endNum++;
            }
          }

          if (saveDataString.length < endNum + 2) {
            saveDataManager.SaveDiaryFile();
            isLoadSuccess = true;
            break;
          }
        }
      }
    }

    if(isLoadSuccess == true) {
      saveDataManager.snackBar('불러오기를 완료했습니다');
    }
  }

  Future<void> launchWebView(String url) async {
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
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
                    Text("단일 ${style.myeongsicString} ", style: style.settingText0,),
                    Checkbox(
                      value: isExportPersonData,
                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                      onChanged: (value) {
                        setState(() {
                          if(value == true && saveDataManager.mapPerson.length == 0){
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content:
                                    Text(
                                      "저장된 ${personalDataManager.GetMyeongsicText()}이 없습니다",
                                      textAlign: TextAlign.center,
                                    )
                                );
                              },
                            );
                          } else {
                            isExportPersonData = value!;}
                        });
                      },
                    ),
                    SizedBox(width:20),
                    Text("묶음 ${style.myeongsicString} ", style: style.settingText0,),
                    Checkbox(
                      value: isExportGroupData,
                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                      onChanged: (value) {
                        setState(() {
                          if(value == true && saveDataManager.listMapGroup.length == 0){
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content:
                                    Text(
                                      "저장된 묶음이 없습니다",
                                      textAlign: TextAlign.center,
                                    )
                                );
                              },
                            );
                          } else {isExportGroupData = value!;}});
                      },
                    ),
                    SizedBox(width:20),
                    Text("일진 일기 ", style: style.settingText0,),
                    Checkbox(
                      value: isExportDiary,
                      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                      onChanged: (value) {setState(() {
                        if(value == true && saveDataManager.mapDiary.length == 0){
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content:
                                  Text(
                                    "저장된 일기가 없습니다",
                                    textAlign: TextAlign.center,
                                  )
                              );
                            },
                          );
                        } else {
                            isExportDiary = value!;
                          }
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
                margin: EdgeInsets.only(top: 32),
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
                      overlayColor: WidgetStateProperty.all(style.colorMainBlue.withOpacity(0.0)),
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
                height: 46,
                margin: EdgeInsets.only(top:style.SettingMarginTopWithInfo1),
                child: Text("· 생년월일과 저장일자가 같은 ${style.myeongsicString}은 덮어씁니다\n· 묶음 이름과 저장일자가 같은 묶음은 덮어씁니다", style: style.settingInfoText0,),
              ),
              Container(
                width: widgetWidth - (style.UIMarginLeft * 2),
                height: 1,
                margin: EdgeInsets.only(top: 32),
                color: style.colorGrey,
              ),
              Container(  //데이터 불러오기 설명
                height: style.saveDataMemoLineHeight * 0.7,
                width: (widgetWidth - (style.UIMarginLeft * 2)),
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child:  Text("동영상 매뉴얼을 확인합니다", style: style.settingInfoText0,),
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
                      '매뉴얼',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onPressed: () {
                      launchWebView("https://youtube.com/shorts/01D8zYNmmBM?si=gp-8YAD0VkReI86U");
                    }),
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

