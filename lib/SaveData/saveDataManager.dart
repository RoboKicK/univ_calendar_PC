import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../findGanji.dart' as findGanji;
import '../Settings/personalDataManager.dart';

String fileDirPath = '';

SetFileDirectoryPath () async{  //처음 시작할 때 파일 저장하는 폴더의 주소를 초기화함
  final filedirectory = await getApplicationDocumentsDirectory();
  fileDirPath = filedirectory.path;
  await LoadSavedPeople();
  await LoadRecentPeople();
  await LoadSavedDiary();
  await LoadSavedGroup();
}
// 저장번호 - 단일명식 p001, 최근명식 l001, 일기 j001, 단체명식 g001
int saveDataLimitCount = 3000; //단일
int recentDataLimitCount = 300;//1000;  //최근목록
int diaryDataLimitCount = 1000; //일진일기
int groupDataLimitCount = 1000;
List<Map> mapPerson = []; //String name, bool gender, int uemYang, int birth---, String saveDate, String memo, bool mark
List<List<dynamic>> listMapGroup = []; //String name, bool gender, int uemYang, int birth---, String saveDate, String memo, bool mark

List<Map> mapRecentPerson = [];
List<Map> mapDiary = [];  //일진일기

int sortNumMapPerson = 0;

late var snackBar;

  //최초 어플 켰을 때 저장되어 있는 명식들을 로드함
  LoadSavedPeople() async {
    if(mapPerson.length != 0)
      return;

    String saveDataString = '';

    try { //저장 데이터 확인 및 불러오기
      saveDataString = jsonDecode(await File('${fileDirPath}/personData').readAsString());

      if(saveDataString.isNotEmpty) {

        int startNum = 0;
        int endNum = 3;

        String personName = '';
        int birthData = 0;
        late DateTime saveDate;
        String personMemo = '';

        while (true) {

          if (saveDataString.substring(endNum - 2, endNum) == '{{') {
            personName = saveDataString.substring(startNum, endNum - 2);
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

                mapPerson.add({'name': personName, 'birthData': birthData, 'saveDate': saveDate, 'memo': personMemo});
                break;
              } else {
                endNum++;
              }
            }
          } else {
            endNum++;
          }
          if (saveDataString.length < endNum + 2) {
            break;
          }
        }
      }
  } catch(e) {};

    try{  //초기 버전 저장데이터 확인
      Map mapTemp = jsonDecode(await File('${fileDirPath}/p000').readAsString());
      if(mapTemp.isNotEmpty){
        for(int i = 0; i <= saveDataLimitCount; i++){
          if(i < 10){
            try {
              mapTemp = jsonDecode(await File('${fileDirPath}/p00${i}').readAsString());
              await File('${fileDirPath}/p00${i}').delete();
            } catch(e){break;}
          }
          else if(i < 100){
            try{
              mapTemp = jsonDecode(await File('${fileDirPath}/p0${i}').readAsString());
              await File('${fileDirPath}/p0${i}').delete();
            } catch(e){break;}
          }
          else{
            try {
              mapTemp = jsonDecode(await File('${fileDirPath}/p${i}').readAsString());
              await File('${fileDirPath}/p${i}').delete();
            } catch(e){break;}
          }

          int birthHour = mapTemp['birthHour'];
          int birthMin = mapTemp['birthMin'];
          if(birthHour == -2){
            birthHour = 30;
          }
          if(birthMin == -2){
            birthMin = 0;
          }


          int birthData = (((mapTemp['gender'] == true? 1 : 2) * 10000000000000) + (mapTemp['uemYang'] * 1000000000000) + (mapTemp['birthYear'] * 100000000) +
              (mapTemp['birthMonth'] * 1000000) + (mapTemp['birthDay'] * 10000) + (birthHour * 100) + birthMin).toInt();

          Map personData = {'name':mapTemp['name'], 'birthData':birthData, 'saveDate':DateTime.parse(mapTemp['saveDate']), 'memo':mapTemp['memo']};
          mapPerson.add(personData);
        }

        SavePersonFile();
      }
    } catch(e) {};

    //SortPersonFromMark();
  }
  LoadRecentPeople() async {
  if(mapRecentPerson.length != 0)
    return;

  String saveDataString = '';


  try { //저장 데이터 확인 및 불러오기
    saveDataString = jsonDecode(await File('${fileDirPath}/recentPersonData').readAsString());

    if(saveDataString.isNotEmpty) {
      int startNum = 0;
      int endNum = 3;

      String personName = '';
      int birthData = 0;
      late DateTime saveDate;

      while (true) {
        if (saveDataString.length < endNum + 2) {
          break;
        }

        if (saveDataString.substring(endNum - 2, endNum) == '{{') {
          personName = saveDataString.substring(startNum, endNum - 2);
          startNum = endNum;
          birthData = int.parse(saveDataString.substring(startNum, startNum + 14));
          startNum = startNum + 16;
          saveDate = DateTime.parse(saveDataString.substring(startNum, startNum + 26));
          startNum = startNum + 28;
          endNum = startNum + 2;
          mapRecentPerson.add({'name': personName, 'birthData': birthData, 'saveDate': saveDate});
        } else {
          endNum++;
        }
      }
    }
  } catch(e) {};

  try{  //초기 버전 저장데이터 확인
    Map mapTemp = jsonDecode(await File('${fileDirPath}/l000').readAsString());
    if(mapTemp.isNotEmpty){
      for(int i = 0; i <= saveDataLimitCount; i++){
        if(i < 10){
          try {
            mapTemp = jsonDecode(await File('${fileDirPath}/l00${i}').readAsString());
            await File('${fileDirPath}/l00${i}').delete();
          } catch(e){break;}
        }
        else if(i < 100){
          try{
            mapTemp = jsonDecode(await File('${fileDirPath}/l0${i}').readAsString());
            await File('${fileDirPath}/l0${i}').delete();
          } catch(e){break;}
        }
        else{
          try {
            mapTemp = jsonDecode(await File('${fileDirPath}/l${i}').readAsString());
            await File('${fileDirPath}/l${i}').delete();
          } catch(e){break;}
        }

        int birthHour = mapTemp['birthHour'];
        int birthMin = mapTemp['birthMin'];
        if(birthHour == -2){
          birthHour = 30;
        }
        if(birthMin == -2){
          birthMin = 0;
        }

        int birthData = (((mapTemp['gender'] == true? 1 : 2) * 10000000000000) + (mapTemp['uemYang'] * 1000000000000) + (mapTemp['birthYear'] * 100000000) +
            (mapTemp['birthMonth'] * 1000000) + (mapTemp['birthDay'] * 10000) + (birthHour * 100) + birthMin).toInt();

        Map personData = {'name':mapTemp['name'], 'birthData':birthData, 'saveDate':DateTime.parse(mapTemp['saveDate'])};
        mapRecentPerson.add(personData);
      }

      SaveRecentPersonFile();
    }
  } catch(e) {};
}
  LoadSavedGroup() async {
  if(listMapGroup.length != 0)
    return;

  String saveDataString = '';

  try { //저장 데이터 확인 및 불러오기
    saveDataString = jsonDecode(await File('${fileDirPath}/groupData').readAsString());

    if(saveDataString.isNotEmpty) {

      int startNum = 0;
      int endNum = 3;

      String groupName = '';
      String personName = '';
      int birthData = 0;
      late DateTime saveDate;
      String groupMemo = '';
      String personMemo = '';

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
                  listMapGroup.add(groupMap);

                  break;
                }
              } else {
                endNum++;
              }
            }

            if(saveDataString.substring(endNum - 4, endNum - 2) == '}}'){
              break;
            }
          }
        } else {
          endNum++;
        }
      }
    }
  } catch(e) {};

  try{  //초기 버전 저장데이터 확인
    List<dynamic> mapTemp = jsonDecode(await File('${fileDirPath}/g000').readAsString());

    if(mapTemp.isNotEmpty){
      for(int i = 0; i <= saveDataLimitCount; i++){
        if(i < 10){
          try {
            mapTemp = jsonDecode(await File('${fileDirPath}/g00${i}').readAsString());
            await File('${fileDirPath}/g00${i}').delete();
          } catch(e){break;}
        }
        else if(i < 100){
          try{
            mapTemp = jsonDecode(await File('${fileDirPath}/g0${i}').readAsString());
            await File('${fileDirPath}/g0${i}').delete();
          } catch(e){break;}
        }
        else{
          try {
            mapTemp = jsonDecode(await File('${fileDirPath}/g${i}').readAsString());
            await File('${fileDirPath}/g${i}').delete();
          } catch(e){break;}
        }

        List<Map<dynamic, dynamic>> groupMap = [];

        groupMap.add({'groupName':mapTemp.last['groupName'], 'saveDate':DateTime.now(), 'memo':''});
        for(int j = 0; j < mapTemp.length - 1; j++){
          print('0');

          int birthHour = mapTemp[j]['birthHour'];
          int birthMin = mapTemp[j]['birthMin'];
          if(birthHour == -2){
            birthHour = 30;
          }
          if(birthMin == -2){
            birthMin = 0;
          }


          int birthData = (((mapTemp[j]['gender'] == true? 1 : 2) * 10000000000000) + (mapTemp[j]['uemYang'] * 1000000000000) + (mapTemp[j]['birthYear'] * 100000000) +
              (mapTemp[j]['birthMonth'] * 1000000) + (mapTemp[j]['birthDay'] * 10000) + (birthHour * 100) + birthMin).toInt();

          Map personData = {'name':mapTemp[j]['name'], 'birthData':birthData, 'memo':''};

          groupMap.add(personData);
        }

        listMapGroup.add(groupMap);
      }

      SaveGroupFile();
    }
  } catch(e) {};
}
  LoadSavedDiary() async {
    if(mapDiary.length != 0)
      return;

    String saveDataString = '';
    bool isEditedFile = false;

    try {
      saveDataString = jsonDecode(await File('${fileDirPath}/diaryData').readAsString());

      if(saveDataString.isNotEmpty) {
        int startNum = 0;
        int endNum = 3;

        int dayData = 0;
        int labelData = 0;
        String memo = '';

        while (true) {
          if (saveDataString.length < endNum + 2) {
            break;
          }

          if (saveDataString.substring(endNum - 2, endNum) == '{{') {
            dayData = int.parse(saveDataString.substring(startNum, endNum - 2));
            startNum = endNum;

            labelData = int.parse(saveDataString.substring(startNum, startNum + 9));

            startNum = startNum + 11;
            endNum = startNum + 2;

            while(true) {
              if (saveDataString.substring(endNum - 2, endNum) == '{{') {
                memo = saveDataString.substring(startNum, endNum - 2);

                if(memo.length < 4) {
                  isEditedFile = true;

                  memo = memo.substring(0, 2) + '0' + memo.substring(2, memo.length);
                } else  if(int.tryParse(memo.substring(3, 4)) == null){
                  isEditedFile = true;

                  memo = memo.substring(0, 2) + '0' + memo.substring(2, memo.length);
                }

                startNum = endNum;
                endNum = startNum + 2;

                mapDiary.add({'dayData': dayData, 'labelData': labelData, 'memo': memo});
                break;
              } else {
                endNum++;
              }
            }
          } else {
            endNum++;
          }
        }
      }
    } catch(e) {};

    if(isEditedFile == true){
      SaveDiaryFile();
    }
  }


  //데이터 삭제
  Future<void> DeleteFile(int num) async {
    switch(num){
      case 0: { //단일 명식 삭제
        await File('${fileDirPath}/personData').delete();
        mapPerson.clear();
      }
      case 1: { //궁합 명식 삭제
        await File('${fileDirPath}/groupData').delete();
        listMapGroup.clear();
      }
      case 2: { //최근 명식 삭제
        await File('${fileDirPath}/recentPersonData').delete();
        mapRecentPerson.clear();
      }
      case 3: { //일진 일기 삭제
        await File('${fileDirPath}/diaryData').delete();
        mapDiary.clear();
      }
    }
  }
  //북마크 순으로 정렬
  //SortPersonFromMark() {
  //  mapPersonSortedMark.clear();
  //
  //  for(int i = 0; i < mapPerson.length; i++){
  //    mapPersonSortedMark.add(mapPerson[i]);
  //  }
  //
  //  mapPersonSortedMark.sort((a,b) => a['mark'].toString().length.compareTo(b['mark'].toString().length));
  //}
  //SortGroupFromMark(){
  //
  //}

  //저장할 때 내용을 저장할 빈 파일을 생성함
  Future<File> CreateSaveFile(String fileNum) async {
        return File('${fileDirPath}/${fileNum}');
  }

  //그룹을 최초 저장할 때 사용
  SaveGroupData2(List<Map> groupData, {String memo = ''}) {
    groupData[0]['memo'] = memo;

    listMapGroup.add(groupData);

    SaveGroupFile();

    snackBar('${mapWordData['myeongSic'] == 0? '명식':'원국'} 묶음이 저장되었습니다');
  }

  Future<void> SaveGroupFile() async {
    String jsonString = '';
    String personMemoString = '';
    String personSaveDate = '';

    for(int i = 0; i < listMapGroup.length; i++){
      jsonString = jsonString + listMapGroup[i][0]['groupName'] + '{{' +
          listMapGroup[i][0]['saveDate'].toString() + '{{' +
          listMapGroup[i][0]['memo'] + '{{';
      for(int j = 1; j < listMapGroup[i].length; j++){
        if(listMapGroup[i][j]['memo'] == null){
          personMemoString == '';
        } else {
          personMemoString = listMapGroup[i][j]['memo'];
        }
        if(listMapGroup[i][j]['saveDate'] == null || listMapGroup[i][j]['saveDate'] == DateTime.utc(3000)){
          personSaveDate = listMapGroup[i][0]['saveDate'].toString();
        } else {
          personSaveDate = listMapGroup[i][j]['saveDate'].toString();
        }
        jsonString = jsonString + listMapGroup[i][j]['name'] + '{{' + listMapGroup[i][j]['birthData'].toString() + '{{' + personSaveDate + '{{' + personMemoString;

        if(j < listMapGroup[i].length - 1){
          jsonString = jsonString + '{{';
        } else {
          jsonString = jsonString + '}}'; //그룹의 마지막 명식은 }}로 마무리
        }
      }
    }

    final file = await CreateSaveFile('groupData');

    await file.writeAsString(jsonEncode(jsonString));
  }

  //그룹 명식에서 출생 정보를 선택하여 반환
  GetSelectedBirthDataFromGroup(String type, int groupIndex, int personIndex){
  switch(type){
    case 'gender':{
      if(((listMapGroup[groupIndex][personIndex]['birthData'] / 10000000000000) % 10).floor() == 1){
        return true;
      } else {
        return false;
      }
    }
    case 'uemYang':{
      return ((listMapGroup[groupIndex][personIndex]['birthData'] / 1000000000000) % 10).floor();
    }
    case 'birthYear':{
      return ((listMapGroup[groupIndex][personIndex]['birthData'] / 100000000) % 10000).floor();
    }
    case 'birthMonth':{
      return ((listMapGroup[groupIndex][personIndex]['birthData'] / 1000000 ) % 100).floor();
    }
    case 'birthDay':{
      return ((listMapGroup[groupIndex][personIndex]['birthData'] / 10000 ) % 100).floor();
    }
    case 'birthHour':{
      return ((listMapGroup[groupIndex][personIndex]['birthData'] / 100 ) % 100).floor();
    }
    case 'birthMin':{
      return listMapGroup[groupIndex][personIndex]['birthData'] % 100;
    }
  }
}

  //listMapGroup에서 해당 인덱스 찾기
  int FindListMapGroupIndex(String groupName, DateTime saveDate){
  for(int i = 0; i < listMapGroup.length; i++){
    if(listMapGroup[i][0]['groupName'] == groupName && listMapGroup[i][0]['saveDate'] == saveDate){
      return i;
    }
  }

  return -1;
}
  //listMapGroup에서 해당 인덱스 찾기
  int FindListMapGroupIndexWithoutGroupName(DateTime saveDate){
    for(int i = 0; i < listMapGroup.length; i++){
    if(listMapGroup[i][0]['saveDate'] == saveDate){
      return i;
    }
  }

    return -1;
  }
  //listMapGroup에서 해당 명식 찾기
  List<List<int>> FindListMapGroupPersonIndex(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, DateTime saveDate){
    List<List<int>> listGroupPersonIndex = [];
    int personBirthData = ConvertToBirthData(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin);

    for(int i = 0; i < listMapGroup.length; i++){
      for(int j = 1; j < listMapGroup[i].length; j++){
      if(listMapGroup[i][j]['name'] == name && listMapGroup[i][j]['birthData'] == personBirthData && listMapGroup[i][j]['saveDate'] == saveDate){
          listGroupPersonIndex.add([i,j]);
        }
      }
    }

    return listGroupPersonIndex;
  }

  //그룹의 메모를 수정하여 저장할 때 사용
  SaveListMapGroupDataMemo(String groupName, DateTime saveDate, String memo){
  int groupIndex = FindListMapGroupIndex(groupName, saveDate);

  if(listMapGroup[groupIndex][0]['memo'] != memo){
    listMapGroup[groupIndex][0]['memo'] = memo;
    SaveGroupFile();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      snackBar('메모가 저장되었습니다');
    });
  }
}

  //그룹의 이름을 수정하여 저장할 때 사용
  SaveEditedGroupName(String prevGroupName, DateTime saveDate, String nowGroupName){
    int groupIndex = FindListMapGroupIndex(prevGroupName, saveDate);
    listMapGroup[groupIndex][0]['groupName'] = nowGroupName;

    SaveGroupFile();

    snackBar('묶음 이름이 수정되었습니다');
  }

  //그룹의 이름을 수정하여 저장할 때 사용
  SaveEditedGroupNameWithoutPrevGroupName(DateTime saveDate, String nowGroupName){
  int groupIndex = FindListMapGroupIndexWithoutGroupName(saveDate);
  listMapGroup[groupIndex][0]['groupName'] = nowGroupName;

  SaveGroupFile();

  snackBar('묶음 이름이 수정되었습니다');
}

  //그룹을 삭제할 때 사용 - listMapGroup에서 명식을 삭제
  DeleteGroupData(String groupName, DateTime saveDate) {

  listMapGroup.removeAt(FindListMapGroupIndex(groupName, saveDate));
  SaveGroupFile();

  snackBar('${mapWordData['myeongSic'] == 0? '명식':'원국'} 묶음이 삭제되었습니다');
}

  //-- 여기부터 단일 명식 저장

  //생년월일을 birthData로 변환
  int ConvertToBirthData(bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin){
    int genderInt = 1;  //남자:1
    if(gender == false){
      genderInt = 2;  //여자:2
    }

    int birthData = (genderInt * 10000000000000) + (uemYang * 1000000000000) + (birthYear * 100000000) + (birthMonth * 1000000) + (birthDay * 10000) + (birthHour * 100) + birthMin;

    return birthData;
  }

  //명식을 최초 저장할 때 사용2 - mapPerson에 명식을 추가
  SavePersonData2(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, DateTime saveDate, String memo) {
    //int genderVal = genderInt * 10000000000000;
    //int uemYangVal = uemYang * 1000000000000;
    //int birthYearVal = birthYear * 100000000;
    //int birthMonthVal = birthMonth * 1000000;
    //int birthDayVal = birthDay * 10000;
    //int birthHourVal = birthHour * 100;
    //int birthMinVal = birthMin;

    int birthData = ConvertToBirthData(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin);

    Map personData = {'name':name, 'birthData':birthData, 'saveDate':saveDate, 'memo':memo};
    mapPerson.add(personData);
    SavePersonFile();

    snackBar('${mapWordData['myeongSic'] == 0? '명식':'원국'}이 저장되었습니다');
  }

  //단일 명식을 json파일로 저장
  Future<void> SavePersonFile() async {
    String jsonString = '';

    for(int i = 0; i < mapPerson.length; i++){
      jsonString = jsonString + mapPerson[i]['name'] + '{{' + mapPerson[i]['birthData'].toString() + '{{' + mapPerson[i]['saveDate'].toString() + '{{' + mapPerson[i]['memo'] + '{{';
    }

    final file = await CreateSaveFile('personData');

    await file.writeAsString(jsonEncode(jsonString));
  }

  //명식 최초 저장할 때 중복 명식 있는지 확인
  bool SavePersonIsSameChecker(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, sameBirthChecker) {
      //(String name, int birthData, sameBirthChecker) {
    //(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, sameBirthChecker) {
    bool gender = true;
    if(genderString == '여'){
      gender = false; }

    bool sameDataChecker = true;
    String birthMessage = '';

    int genderInt = 1;  //남자:1
    if(gender == false){
      genderInt = 2;  //여자:2
    }

    for(int i = 0; i < mapPerson.length; i++){
      int birthData = ConvertToBirthData(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin);
      //if(mapPerson[i]['gender'] == gender && mapPerson[i]['uemYang'] == uemYang && mapPerson[i]['birthYear'] == birthYear && mapPerson[i]['birthMonth'] == birthMonth && mapPerson[i]['birthDay'] == birthDay && mapPerson[i]['birthHour'] == birthHour && mapPerson[i]['birthMin'] == birthMin){
      if(mapPerson[i]['birthData'] == birthData ){ //mapPerson[i]['name'] == name &&
        String uemYangMessage = '';

        if(uemYang == 0){
          uemYangMessage = '양력';
        }
        else if(uemYang == 1){
          uemYangMessage = '음력';
        }
        else{
          uemYangMessage = '음력 윤달';
        }
        String birthHourMessage = '';
        if(birthHour == 30){
          birthHourMessage = '시간 모름';
        }
        else{
          if(birthHour < 10){
            birthHourMessage = '0${birthHour}';
          }
          else{
            birthHourMessage = '${birthHour}';
          }
          if(birthHour != 30){
            if(birthMin < 10){
              birthHourMessage = birthHourMessage + ':0${birthMin}';
            }
            else if(birthHour != 30){
              birthHourMessage = birthHourMessage + ':${birthMin}';
            }
          }
          //썸머타임 조회
          if(uemYang == 0) {
            if (findGanji.CheckSummerTime(birthYear, birthMonth, birthDay, birthHour, birthMin) == true) {
              birthHourMessage = birthHourMessage + ' (써머타임 -60분)';
            }
          } else {
            List<int> listYangBirth = findGanji.LunarToSolar(birthYear, birthMonth, birthDay, uemYang == 1? false:true);
            if(findGanji.CheckSummerTime(birthYear, birthMonth, birthDay, birthHour, birthMin) == true)
              birthHourMessage = birthHourMessage + ' (써머타임 -60분)';
          }
        }
        if(birthMessage == '') {
          birthMessage = '${mapPerson[i]['name']}(${genderString})\n${birthYear}년 ${birthMonth}월 ${birthDay}일(${uemYangMessage}) ${birthHourMessage}';
        }
        else{
          birthMessage = birthMessage + '\n${mapPerson[i]['name']}\n(${genderString}) ${birthYear}년 ${birthMonth}월 ${birthDay}일 (${uemYangMessage}) ${birthHourMessage}';
        }

        sameDataChecker = false;  //중복 명식이 있으면 false
      }
    }

    if(sameDataChecker == false){
      sameBirthChecker(birthMessage, name, gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin);
    }

    return sameDataChecker;
  }

  //저장목록 관리 - 단일명식 불러오기 할 때 중복 있는지 확인
  bool LoadPersonIsSameChecker(String name, int birthData, DateTime saveDate, String memo, int tryCount){  //
    for(int i = 0; i < tryCount; i++){
      if(mapPerson[i]['name'] == name && mapPerson[i]['birthData'] == birthData && mapPerson[i]['saveDate'] == saveDate){
        mapPerson[i]['memo'] = memo;
        return false;
      }
    }

    return true;
  }
  //저장목록 관리 - 묶음 불러오기 할 때 중복 있는지 확인
  bool LoadGroupIsSameChecker(List<dynamic> groupMap, int tryCount){  //
  for(int i = 0; i < tryCount; i++){
    if(listMapGroup[i][0]['groupName'] == groupMap[0]['groupName'] && listMapGroup[i][0]['saveDate'] == groupMap[0]['saveDate']){
      listMapGroup[i] = groupMap;
      return false;
    }
  }

  return true;
}

  //명식을 삭제할 때 사용2 - mapPerson에서 명식을 삭제
  DeletePersonData2(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, DateTime saveDate) {

    mapPerson.removeAt(FindMapPersonIndex(name, ConvertToBirthData(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin), saveDate));
    SavePersonFile();

    snackBar('${mapWordData['myeongSic'] == 0? '명식':'원국'}이 삭제되었습니다');
  }

  //mapPerson에서 해당 인덱스 찾기
  int FindMapPersonIndex(String name, int birthData, DateTime saveDate){
    for(int i = 0; i < mapPerson.length; i++){
      if(mapPerson[i]['birthData'] == birthData){
        if(mapPerson[i]['name'] == name && mapPerson[i]['saveDate'] == saveDate){
          return i;
        }
      }
    }

    return -1;
  }

  //명식의 메모를 수정하여 저장할 때 사용
  SavePersonDataMemo2(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, DateTime saveDate, String memo, {bool withoutSaveFile = false}){
    bool isSaveMemo = false;

    int personIndex = FindMapPersonIndex(name, ConvertToBirthData(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin), saveDate);
    if(personIndex != -1 && mapPerson[personIndex]['memo'] != memo){
      mapPerson[personIndex]['memo'] = memo;
      if(withoutSaveFile == false) {
        SavePersonFile();
        isSaveMemo = true;
      }
    }

    List<List<int>> listGroupPersonIndex = FindListMapGroupPersonIndex(name, gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin, saveDate);
    for(int i = 0; i < listGroupPersonIndex.length; i++){
      if(listMapGroup[listGroupPersonIndex[i][0]][listGroupPersonIndex[i][1]]['memo'] != memo){
        listMapGroup[listGroupPersonIndex[i][0]][listGroupPersonIndex[i][1]]['memo'] = memo;
        isSaveMemo = true;
      }
    }
    if(withoutSaveFile == false && listGroupPersonIndex.isNotEmpty) {
      SaveGroupFile();
    }

    if(isSaveMemo == true){
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        snackBar('메모가 저장되었습니다');
      });
    }
  }

  //명식의 정보를 수정하여 저장
  SaveEditedPersonData2(String prevName, bool prevGender, int prevUemYang, int prevBirthYear, int prevBirthMonth, int prevBirthDay, int prevBirthHour, int prevBirthMin, DateTime saveDate, String nowName,
      bool nowGender, int nowUemYang, int nowBirthYear, int nowBirthMonth, int nowBirthDay, int nowBirthHour, int nowBirthMin){
    bool isEditData = false;

    int personIndex = FindMapPersonIndex(prevName, ConvertToBirthData(prevGender, prevUemYang, prevBirthYear, prevBirthMonth, prevBirthDay, prevBirthHour, prevBirthMin), saveDate);
    if(personIndex != -1) {
      mapPerson[personIndex]['name'] = nowName;
      mapPerson[personIndex]['birthData'] = ConvertToBirthData(nowGender, nowUemYang, nowBirthYear, nowBirthMonth, nowBirthDay, nowBirthHour, nowBirthMin);

      SavePersonFile();
    }

    List<List<int>> listGroupPersonIndex = FindListMapGroupPersonIndex(prevName, prevGender, prevUemYang, prevBirthYear, prevBirthMonth, prevBirthDay, prevBirthHour, prevBirthMin, saveDate);
    for(int i = 0; i < listGroupPersonIndex.length; i++){
      listMapGroup[listGroupPersonIndex[i][0]][listGroupPersonIndex[i][1]]['name'] = nowName;
      listMapGroup[listGroupPersonIndex[i][0]][listGroupPersonIndex[i][1]]['birthData'] = ConvertToBirthData(nowGender, nowUemYang, nowBirthYear, nowBirthMonth, nowBirthDay, nowBirthHour, nowBirthMin);
    }
    if(listGroupPersonIndex.length > 0) {
      SaveGroupFile();
    }

    if(isEditData == true || listGroupPersonIndex.isNotEmpty){
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        snackBar('${mapWordData['myeongSic'] == 0? '명식':'원국'}이 수정되었습니다');
      });
    }
  }

  //명식의 출생 정보를 선택하여 반환
  GetSelectedBirthData(String type, int index){
    switch(type){
      case 'gender':{
        if(((mapPerson[index]['birthData'] / 10000000000000) % 10).floor() == 1){
          return true;
        } else {
          return false;
        }
      }
      case 'uemYang':{
        return ((mapPerson[index]['birthData'] / 1000000000000) % 10).floor();
      }
      case 'birthYear':{
        return ((mapPerson[index]['birthData'] / 100000000) % 10000).floor();
      }
      case 'birthMonth':{
        return ((mapPerson[index]['birthData'] / 1000000 ) % 100).floor();
      }
      case 'birthDay':{
        return ((mapPerson[index]['birthData'] / 10000 ) % 100).floor();
      }
      case 'birthHour':{
        return ((mapPerson[index]['birthData'] / 100 ) % 100).floor();
      }
      case 'birthMin':{
        return mapPerson[index]['birthData'] % 100;
      }
    }
  }

  //명식 리스트 정렬
  SortMapPerson(int num){
    if(num != -1) {
      sortNumMapPerson = num;
    }

  switch(sortNumMapPerson){
      case 0:{
        mapPerson.sort((a, b) => a['saveDate'].compareTo(b['saveDate']));
      }
      case 1:{
        mapPerson.sort((a, b) => b['saveDate'].compareTo(a['saveDate']));
      }
      case 2:{
        mapPerson.sort((a, b) => a['name'].compareTo(b['name']));
      }
      case 3:{
        mapPerson.sort((a, b) => b['name'].compareTo(a['name']));
      }
    }
  }

  //최근 명식 저장
  SaveRecentPersonData2(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin) {
  int birthData = ConvertToBirthData(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin);

  if(name == '오늘' && birthYear == DateTime.now().year && birthMonth == DateTime.now().month && birthDay == DateTime.now().day && birthHour == DateTime.now().hour){
    return;
  }

  Map personData = {'name':name, 'birthData':birthData, 'saveDate':DateTime.now()};

  bool isSameData = false;
  int sameDataCheckCount = 9;
  if((mapRecentPerson.length - 1) < sameDataCheckCount){
    sameDataCheckCount = (mapRecentPerson.length - 1);
  }
  for(int i = 0; i < sameDataCheckCount; i++){
    if(mapRecentPerson.isNotEmpty && mapRecentPerson[i]['name'] == name && mapRecentPerson[i]['birthData'] == birthData){
      isSameData = true;
    }
  }
  if(isSameData == true){
    return;
  }

  mapRecentPerson.insert(0, personData);

  while(true){
    if(mapRecentPerson.length > recentDataLimitCount){
      mapRecentPerson.removeLast();
    } else {
      break;
    }
  }

  SaveRecentPersonFile();
}

  //최근 명식의 출생 정보를 선택하여 반환
  GetSelectedRecentBirthData(String type, int index){
  switch(type){
    case 'gender':{
      if(((mapRecentPerson[index]['birthData'] / 10000000000000) % 10).floor() == 1){
        return true;
      } else {
        return false;
      }
    }
    case 'uemYang':{
      return ((mapRecentPerson[index]['birthData'] / 1000000000000) % 10).floor();
    }
    case 'birthYear':{
      return ((mapRecentPerson[index]['birthData'] / 100000000) % 10000).floor();
    }
    case 'birthMonth':{
      return ((mapRecentPerson[index]['birthData'] / 1000000 ) % 100).floor();
    }
    case 'birthDay':{
      return ((mapRecentPerson[index]['birthData'] / 10000 ) % 100).floor();
    }
    case 'birthHour':{
      return ((mapRecentPerson[index]['birthData'] / 100 ) % 100).floor();
    }
    case 'birthMin':{
      return mapRecentPerson[index]['birthData'] % 10;
    }
  }
}

  //birthData에서 선택한 값 추출
  GetSelectedDataFromBirthData(String type, int birthData){
  switch(type){
    case 'gender':{
      if(((birthData / 10000000000000) % 10).floor() == 1){
        return true;
      } else {
        return false;
      }
    }
    case 'uemYang':{
      return ((birthData / 1000000000000) % 10).floor();
    }
    case 'birthYear':{
      return ((birthData / 100000000) % 10000).floor();
    }
    case 'birthMonth':{
      return ((birthData / 1000000 ) % 100).floor();
    }
    case 'birthDay':{
      return ((birthData / 10000 ) % 100).floor();
    }
    case 'birthHour':{
      return ((birthData / 100 ) % 100).floor();
    }
    case 'birthMin':{
      return birthData % 100;
    }
    case 'uemYangText':{
      if(((birthData / 1000000000000) % 10).floor() == 0){
        return '양력';
      } else if(((birthData / 1000000000000) % 10).floor() == 1){
        return '음력';
      } else {
        return '음력 윤달';
      }
    }
  }
}

  //최근 명식을 json파일로 저장
  Future<void> SaveRecentPersonFile() async {
  String jsonString = '';

  for(int i = 0; i < mapRecentPerson.length; i++){
    jsonString = jsonString + mapRecentPerson[i]['name'] + '{{' + mapRecentPerson[i]['birthData'].toString() + '{{' + mapRecentPerson[i]['saveDate'].toString() + '{{';
  }

  final file = await CreateSaveFile('recentPersonData');

  await file.writeAsString(jsonEncode(jsonString));
}

  //일진일기를 최초 저장할 때 사용2
  Future<void> SaveDiaryData2(int year, int month, int day, int labelData, List<int> dayPaljaData, String dayString, String memo, bool isFromSaveLabel) async {
    int dayData = (year * 10000) + (month * 100) + day;

    if(mapDiary.isNotEmpty && dayData <= mapDiary.last['dayData']){  //가장 최근에 작성한 일기와 같거나 이전 날짜면
    if(dayData == mapDiary.last['dayData']){  //가장 최근에 작성한 일기면 수정 후 저장
      mapDiary.last['labelData'] = labelData;
      mapDiary.last['memo'] = '${dayString}${dayPaljaData[6]}${dayPaljaData[7]}'+memo;
      print(1);
    } else if(mapDiary.length > 1 && dayData < mapDiary.last['dayData'] && dayData > mapDiary[mapDiary.length - 2]['dayData']){ //가장 최근 일기와 바로 직전 일기의 사이면
      mapDiary.insert(mapDiary.length - 1, {'dayData': dayData, 'labelData': labelData, 'memo':'${dayString}${dayPaljaData[6]}${dayPaljaData[7]}'+memo});
      print(2);
    } else {
      bool isInsertDiary = false;
      for (int i = mapDiary.length - 2; i >= 0; i--) {
        if (dayData == mapDiary[i]['dayData']) {  //이미 작성한 날짜면 수정 후 파일 저장
          mapDiary[i]['labelData'] = labelData;
          mapDiary[i]['memo'] = '${dayString}${dayPaljaData[6]}${dayPaljaData[7]}'+memo;
          isInsertDiary = true;
          print(3);
          break;
        }
        if(dayData > mapDiary[i]['dayData'] && dayData < mapDiary[i+1]['dayData']){ //지금 인덱스와 이전 이덱스 사이면 중간에 삽입하고 저장
          mapDiary.insert(i+1, {'dayData': dayData, 'labelData': labelData, 'memo':'${dayString}${dayPaljaData[6]}${dayPaljaData[7]}'+memo});
          print(4);
          isInsertDiary = true;
          break;
        }
      }
      if(isInsertDiary == false){
        mapDiary.insert(0, {'dayData': dayData, 'labelData': labelData, 'memo':'${dayString}${dayPaljaData[6]}${dayPaljaData[7]}'+memo});
        print(5);
      }
    }
  } else { //dayData가 가장 최신이면 맨 앞에 새로 저장
    mapDiary.add({'dayData': dayData, 'labelData': labelData, 'memo': '${dayString}${dayPaljaData[6]}${dayPaljaData[7]}' + memo});
    print(6);
  }
    SaveDiaryFile();
    if(isFromSaveLabel == false) {
      snackBar('일기를 저장했습니다');
    }
  }

  //일진일기를 json파일로 저장
  Future<void> SaveDiaryFile() async {
  String jsonString = '';

  for(int i = 0; i < mapDiary.length; i++){
    jsonString = jsonString + mapDiary[i]['dayData'].toString() + '{{' + mapDiary[i]['labelData'].toString() + '{{' + mapDiary[i]['memo'] + '{{';
  }

  final file = await CreateSaveFile('diaryData');

  await file.writeAsString(jsonEncode(jsonString));
}

//mapDiary에서 해당 인덱스 찾기
int FindMapDiaryIndex(int year, int month, int day){
  int dayData = (year * 10000) + (month * 100) + day;
  for(int i = mapDiary.length - 1; i >= 0; i--){
    if(mapDiary[i]['dayData'] == dayData){
      return i;
    }
  }

  return -1;
}

//일기 삭제
DeleteDiaryData(int year, int month, int day) async {

  int dayData = (year * 10000) + (month * 100) + day;
  for(int i = mapDiary.length - 1; i >= 0; i--){
    if(mapDiary[i]['dayData'] == dayData){
      mapDiary.removeAt(i);
      SaveDiaryFile();
      return;
    }
  }

  snackBar('일기가 삭제되었습니다');
}



  /*


Future<void> SaveRecentPersonData(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, String memo) async {
  bool gender = true;
  if(genderString == '여'){
    gender = false;
  }

  bool isSameData = false;
  int sameDataCheckCount = 9;
  if((mapRecentPerson.length - 1) < sameDataCheckCount){
    sameDataCheckCount = (mapRecentPerson.length - 1);
  }
  for(int i = 0; i < sameDataCheckCount; i++){
    if(mapRecentPerson.isNotEmpty && mapRecentPerson[i]['gender'] == gender && mapRecentPerson[i]['uemYang'] == uemYang && mapRecentPerson[i]['birthYear'] == birthYear && mapRecentPerson[i]['birthMonth'] == birthMonth && mapRecentPerson[i]['birthDay'] == birthDay && mapRecentPerson[i]['birthHour'] == birthHour && mapRecentPerson[i]['birthMin'] == birthMin){
      isSameData = true;
    }
  }
  if(isSameData == true){
    return;
  }

  int count = min(mapRecentPerson.length, recentDataLimitCount) - 1;
  String fileNum = '';
  if(count > 0){
    for(int i = count; i > -1; i--){
      if(i < 9){  //최근 목록은 l로 시작
        fileNum = 'l00${i+1}';
      }
      else if(i < recentDataLimitCount){
        fileNum = 'l0${i+1}';
      }
      final file = await CreateSaveFile(fileNum);

      await file.writeAsString(jsonEncode({'num':fileNum, 'name': mapRecentPerson[i]['name'], 'gender':mapRecentPerson[i]['gender'], 'uemYang': mapRecentPerson[i]['uemYang'],
        'birthYear':mapRecentPerson[i]['birthYear'], 'birthMonth':mapRecentPerson[i]['birthMonth'], 'birthDay':mapRecentPerson[i]['birthDay'], 'birthHour':mapRecentPerson[i]['birthHour'],
        'birthMin':mapRecentPerson[i]['birthMin'], 'saveDate':DateTime.now().toString(), 'memo':'', 'mark':false}));
    }
  }

  count = mapRecentPerson.length;
  fileNum = 'l000';
  final file = await CreateSaveFile(fileNum);

  await file.writeAsString(jsonEncode({'num':fileNum, 'name': name, 'gender':gender, 'uemYang': uemYang, 'birthYear':birthYear, 'birthMonth':birthMonth,
    'birthDay':birthDay, 'birthHour':birthHour, 'birthMin':birthMin, 'saveDate':DateTime.now().toString(), 'memo':memo, 'mark':false}));

  mapRecentPerson.insert(0, jsonDecode(await file.readAsString()));
  if(mapRecentPerson.length > recentDataLimitCount){
    mapRecentPerson.removeLast();
  }
}





  //명식의 내용을 수정하여 저장한 후 map에 업데이트 함
  //UpdatePersonDataFromMap(int index) async{
  //  //SortPersonFromMark();
//
  //  String fileNum = '';
  //  if(index < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
  //    fileNum = 'p00${index}';
  //  }
  //  else if(index < 100){
  //    fileNum = 'p0${index}';
  //  }
  //  else{
  //    fileNum = 'p${index}';
  //  }
  //  try{
  //    //File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);  //원래 있던 파일을 삭제하고
//
  //    //final file = await CreateSaveFile(fileNum); //같은 파일 이름으로 새로 생성한다
//
  //    final file = File('${fileDirPath}/${fileNum}');
//
  //    await file.writeAsString(jsonEncode({'num':fileNum, 'name': mapPerson[index]['name'], 'gender':mapPerson[index]['gender'], 'uemYang': mapPerson[index]['uemYang'],
  //      'birthYear':mapPerson[index]['birthYear'], 'birthMonth':mapPerson[index]['birthMonth'],'birthDay':mapPerson[index]['birthDay'], 'birthHour':mapPerson[index]['birthHour'],
  //      'birthMin':mapPerson[index]['birthMin'], 'saveDate':mapPerson[index]['saveDate'], 'memo':mapPerson[index]['memo'], 'mark':mapPerson[index]['mark']}));
//
  //  }catch(e){return {};} //내용을 덮어쓴다
  //}

  //---------------여기부터 최근 명식
  //최근 명식 저장


  //명식을 즐겨찾기 하거나 해제하여 저장할 때 사용
  //SavePersonMark(String saveDataNum) async {
  //  int index = 0;
  //  if(saveDataNum != '') {
  //    index = int.parse(saveDataNum.substring(1, 4));
  //  }
  //  else{
  //    index = mapPerson.length - 1;
  //  }
//
  //  if(mapPerson[index]['mark'] == true){
  //    mapPerson[index]['mark'] = false;
  //    snackBar('즐겨찾기가 해제 되었습니다');
  //  }
  //  else{
  //    mapPerson[index]['mark'] = true;
  //    snackBar('즐겨찾기 되었습니다');
  //  }
//
  //  UpdatePersonDataFromMap(index);
  //}

  //명식의 정보를 수정하여 저장할 때 사용
  SaveEditedPersonData(String saveDataNum, String name, bool genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin) async{
  int index = int.parse(saveDataNum.substring(1,4));

  mapPerson[index]['name'] = name;
  mapPerson[index]['gender'] = genderString;
  mapPerson[index]['uemYang'] = uemYang;
  mapPerson[index]['birthYear'] = birthYear;
  mapPerson[index]['birthMonth'] = birthMonth;
  mapPerson[index]['birthDay'] = birthDay;
  mapPerson[index]['birthHour'] = birthHour;
  mapPerson[index]['birthMin'] = birthMin;

  UpdatePersonDataFromMap(index);

  snackBar('명식이 수정되었습니다');
}


  Future<void> SavePersonData(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin) async {

    bool gender = true;
    if(genderString == '여'){
      gender = false;
    }

      int count = mapPerson.length;
      String fileNum = '';
      if(count < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
        fileNum = 'p00${count}';
      }
      else if(count < 100){
        fileNum = 'p0${count}';
      }
      else{
        fileNum = 'p${count}';
      }
      final file = await CreateSaveFile(fileNum);

      await file.writeAsString(jsonEncode({'num':fileNum, 'name': name, 'gender':gender, 'uemYang': uemYang, 'birthYear':birthYear, 'birthMonth':birthMonth,
        'birthDay':birthDay, 'birthHour':birthHour, 'birthMin':birthMin, 'saveDate':DateTime.now().toString(), 'memo':'', 'mark':false}));

      mapPerson.add(jsonDecode(await file.readAsString()));
      //SortPersonFromMark();
    snackBar('명식이 저장되었습니다');
  }

    Future<void> SaveGroupData(List<Map> groupData) async{
    int count = listMapGroup.length;
    String fileNum = '';
    if(count < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
      fileNum = 'g00${count}';
    }
    else if(count < 100){
      fileNum = 'g0${count}';
    }
    else{
      fileNum = 'g${count}';
    }
    final file = await CreateSaveFile(fileNum);
    await file.writeAsString(jsonEncode(groupData));

    listMapGroup.add(jsonDecode(await file.readAsString()));
    //SortGroupFromMark();
    snackBar('단체 명식이 저장되었습니다');
  }


  //명식을 삭제할 때 사용
  DeletePersonData(String num) async {
    int index = int.parse(num.substring(1,4));
    if(index == mapPerson.length-1){  //map의 마지막 파일이면
      String fileNum = '';
      if(index < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
        fileNum = 'p00${index}';
      }
      else if(index < 100){
        fileNum = 'p0${index}';
      }
      else{
        fileNum = 'p${index}';
      }
      File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
      mapPerson.removeLast();
    }
    else{
      for(int i = index; i < mapPerson.length-1; i++){
        String fileNum = '';
        if(i < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
          fileNum = 'p00${i}';
        }
        else if(i < 100){
          fileNum = 'p0${i}';
        }
        else{
          fileNum = 'p${i}';
        }
        mapPerson[i]['name'] = mapPerson[i+1]['name'];
        mapPerson[i]['gender'] = mapPerson[i+1]['gender'];
        mapPerson[i]['uemYang'] = mapPerson[i+1]['uemYang'];
        mapPerson[i]['birthYear'] = mapPerson[i+1]['birthYear'];
        mapPerson[i]['birthMonth'] = mapPerson[i+1]['birthMonth'];
        mapPerson[i]['birthDay'] = mapPerson[i+1]['birthDay'];
        mapPerson[i]['birthHour'] = mapPerson[i+1]['birthHour'];
        mapPerson[i]['birthMin'] = mapPerson[i+1]['birthMin'];
        mapPerson[i]['saveDate'] = mapPerson[i+1]['saveDate'];
        mapPerson[i]['memo'] = mapPerson[i+1]['memo'];
        mapPerson[i]['mark'] = mapPerson[i+1]['mark'];
        //mapPerson[i] = mapPerson[i+1];
        try{
         await File('${fileDirPath}/${fileNum}').writeAsString(jsonEncode({'num':fileNum, 'name': mapPerson[i+1]['name'], 'gender':mapPerson[i+1]['gender'], 'uemYang': mapPerson[i+1]['uemYang'],
           'birthYear':mapPerson[i+1]['birthYear'], 'birthMonth':mapPerson[i+1]['birthMonth'],'birthDay':mapPerson[i+1]['birthDay'], 'birthHour':mapPerson[i+1]['birthHour'],
           'birthMin':mapPerson[i+1]['birthMin'], 'saveDate':mapPerson[i+1]['saveDate'], 'memo':mapPerson[i+1]['memo'], 'mark':mapPerson[i+1]['mark']}));
        }catch(e){return {};}
      }
      String fileNum = '';
      if(mapPerson.length < 11){
        fileNum = 'p00${mapPerson.length - 1}';
      }
      else if(mapPerson.length < 101){
        fileNum = 'p0${mapPerson.length - 1}';
      }
      else{
        fileNum = 'p${mapPerson.length - 1}';
      }

      File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
      mapPerson.removeLast();
    }

    //SortPersonFromMark();

    snackBar('명식이 삭제되었습니다');
  }


    //명식의 메모를 최초, 또는 수정하여 저장할 때 사용
  SavePersonDataMemo(String saveDataNum, String memo) async {

    int index;
    if(saveDataNum == ''){
      index = mapPerson.length - 1;
    }
    else{
      index = int.parse(saveDataNum.substring(1,4));
    }

    if(mapPerson[index]['memo'] != memo){
      WidgetsBinding.instance!.addPostFrameCallback((_){
        snackBar('메모가 저장되었습니다');
      });
    }

    mapPerson[index]['memo'] = memo;

    //UpdatePersonDataFromMap(index);
  }


   */