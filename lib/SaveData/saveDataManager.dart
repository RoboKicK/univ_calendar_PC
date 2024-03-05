import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

String fileDirPath = '';

SetFileDirectoryPath () async{  //처음 시작할 때 파일 저장하는 폴더의 주소를 초기화함
  final filedirectory = await getApplicationDocumentsDirectory();
  fileDirPath = filedirectory.path;
  await LoadSavedPeople();
  await LoadSavedMatch();
  await LoadRecentPeople();
  await LoadSavedDiary();
}
// 저장번호 - 단일명식 a001, 궁합명식 b001, 최근명식 r001, 일기 d001
int saveDataLimitCount = 200; //단일,궁합 공용
int recentDataLimitCount = 30;  //최근목록
int diaryDataLimitCount = 1000; //일진일기

//int savedPersonDataCount = 0;
List<Map> mapPerson = []; //String name, bool gender, int uemYang, int birth---, String saveDate, String memo, bool mark
List<Map> mapPersonSortedMark = []; //즐겨찾기로 정렬된 리스트
List<Map> mapMatch = [];  //String name0, bool gender0, int uemYang0, int birth---0, String name1, bool gender1, int uemYang1, int birth---1, String saveDate, String memo, bool mark
List<Map> mapMatchSortedMark = []; //즐겨찾기로 정렬된 궁합 리스트

List<Map> mapRecentPerson = [];
List<Map> mapDiary = [];  //일진일기

  //최초 어플 켰을 때 저장되어 있는 명식들을 로드함
  LoadSavedPeople() async {
    if(mapPerson.length != 0)
      return;

    for(int i = 0; i <= saveDataLimitCount; i++){
      if(i < 10){
        try {
          mapPerson.add(
              jsonDecode(await File('${fileDirPath}/a00${i}').readAsString()));
        } catch(e){break;}
      }
      else if(i < 100){
        try{mapPerson.add(jsonDecode(await File('${fileDirPath}/a0${i}').readAsString()));}
            catch(e){break;}
      }
      else{
        try{mapPerson.add(jsonDecode(await File('${fileDirPath}/a${i}').readAsString()));}
            catch(e){break;}
      }
    }
    SortPersonFromMark();
  }
  LoadSavedMatch() async {
  if(mapMatch.length != 0)
    return;

  for(int i = 0; i <= saveDataLimitCount; i++){
    if(i < 10){
      try {
        mapMatch.add(
            jsonDecode(await File('${fileDirPath}/b00${i}').readAsString()));
      } catch(e){break;}
    }
    else if(i < 100){
      try{mapMatch.add(jsonDecode(await File('${fileDirPath}/b0${i}').readAsString()));}
      catch(e){break;}
    }
    else{
      try{mapMatch.add(jsonDecode(await File('${fileDirPath}/b${i}').readAsString()));}
      catch(e){break;}
    }
  }
  SortMatchFromMark();
}
  LoadRecentPeople() async {
  if(mapRecentPerson.length != 0)
    return;

  for(int i = 0; i <= recentDataLimitCount; i++){
    if(i < 10){
      try {
        mapRecentPerson.add(
            jsonDecode(await File('${fileDirPath}/r00${i}').readAsString()));
      } catch(e){break;}
    }
    else if(i < 100){
      try{mapRecentPerson.add(jsonDecode(await File('${fileDirPath}/r0${i}').readAsString()));}
      catch(e){break;}
    }
    else{
      try{mapRecentPerson.add(jsonDecode(await File('${fileDirPath}/r${i}').readAsString()));}
      catch(e){break;}
    }
  }
}
  LoadSavedDiary() async {
  if(mapDiary.length != 0)
    return;

  for(int i = 0; i <= diaryDataLimitCount; i++){
    if(i < 10){
      try {
        mapDiary.add(
            jsonDecode(await File('${fileDirPath}/d000${i}').readAsString()));
      } catch(e){break;}
    }
    else if(i < 100){
      try{mapDiary.add(jsonDecode(await File('${fileDirPath}/d00${i}').readAsString()));}
      catch(e){break;}
    }
    else if(i < 1000){
      try{mapDiary.add(jsonDecode(await File('${fileDirPath}/d0${i}').readAsString()));}
      catch(e){break;}
    }
    else{
      try{mapDiary.add(jsonDecode(await File('${fileDirPath}/d${i}').readAsString()));}
      catch(e){break;}
    }
  }
}

  //북마크 순으로 정렬
  SortPersonFromMark() {
    mapPersonSortedMark.clear();

    for(int i = 0; i < mapPerson.length; i++){
      mapPersonSortedMark.add(mapPerson[i]);
    }

    mapPersonSortedMark.sort((a,b) => a['mark'].toString().length.compareTo(b['mark'].toString().length));
  }
  SortMatchFromMark() {
  mapMatchSortedMark.clear();

  for(int i = 0; i < mapMatch.length; i++){
    mapMatchSortedMark.add(mapMatch[i]);
  }

  mapMatchSortedMark.sort((a,b) => a['mark'].toString().length.compareTo(b['mark'].toString().length));
}

  //저장할 때 내용을 저장할 빈 파일을 생성함
  Future<File> CreateSaveFile(String fileNum) async {
        return File('${fileDirPath}/${fileNum}');
  }

  //명식을 최초 저장할 때 사용
  Future<void> SavePersonData(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin) async {
    bool gender = true;
    if(genderString == '여'){
      gender = false;
    }

      int count = mapPerson.length;
      String fileNum = '';
      if(count < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
        fileNum = 'a00${count}';
      }
      else if(count < 100){
        fileNum = 'a0${count}';
      }
      else{
        fileNum = 'a${count}';
      }
      final file = await CreateSaveFile(fileNum);


      await file.writeAsString(jsonEncode({'num':fileNum, 'name': name, 'gender':gender, 'uemYang': uemYang, 'birthYear':birthYear, 'birthMonth':birthMonth,
        'birthDay':birthDay, 'birthHour':birthHour, 'birthMin':birthMin, 'saveDate':DateTime.now().toString(), 'memo':'', 'mark':false}));
      mapPerson.add(jsonDecode(await file.readAsString()));
      SortPersonFromMark();
      Fluttertoast.showToast(msg: '명식이 저장되었습니다');
  }

  //명식 최초 저장할 때 중복 명식 있는지 확인
  bool SavePersonIsSameChecker(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, sameBirthChecker) {
    bool gender = true;
    if(genderString == '여'){
      gender = false; }

    bool sameDataChecker = true;
    String birthMessage = '';

    for(int i = 0; i < mapPerson.length; i++){
      if(mapPerson[i]['gender'] == gender && mapPerson[i]['uemYang'] == uemYang && mapPerson[i]['birthYear'] == birthYear && mapPerson[i]['birthMonth'] == birthMonth && mapPerson[i]['birthDay'] == birthDay && mapPerson[i]['birthHour'] == birthHour && mapPerson[i]['birthMin'] == birthMin){
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
        if(birthHour == -2){
          birthHourMessage = '시간 모름';
        }
        else{
          if(birthHour < 10){
            birthHourMessage = '0${birthHour}';
          }
          else{
            birthHourMessage = '${birthHour}';
          }
          if(birthMin != -2){
            if(birthMin < 10){
              birthHourMessage = birthHourMessage + ':0${birthMin}';
            }
            else if(birthMin != -2){
              birthHourMessage = birthHourMessage + ':${birthMin}';
            }
          }
        }
        if(birthMessage == '') {
          birthMessage = '${mapPerson[i]['name']}(${genderString}) ${birthYear}.${birthMonth}.${birthDay}(${uemYangMessage}) ${birthHourMessage}';

        }
        else{
          birthMessage = birthMessage + '\n${mapPerson[i]['name']}(${genderString}) ${birthYear}.${birthMonth}.${birthDay}(${uemYangMessage}) ${birthHourMessage}';
        }

        sameDataChecker = false;  //중복 명식이 있으면 false
      }

    }

    if(sameDataChecker == false){
      sameBirthChecker(birthMessage);
    }

    return sameDataChecker;
}

  //명식을 삭제할 때 사용
  DeletePersonData(String num) async {
    int index = int.parse(num.substring(1,4));
    if(index == mapPerson.length-1){  //map의 마지막 파일이면
      String fileNum = '';
      if(index < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
        fileNum = 'a00${index}';
      }
      else if(index < 100){
        fileNum = 'a0${index}';
      }
      else{
        fileNum = 'a${index}';
      }
      File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
      mapPerson.removeLast();
    }
    else{
      for(int i = index; i < mapPerson.length-1; i++){
        String fileNum = '';
        if(i < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
          fileNum = 'a00${i}';
        }
        else if(i < 100){
          fileNum = 'a0${i}';
        }
        else{
          fileNum = 'a${i}';
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
        fileNum = 'a00${mapPerson.length - 1}';
      }
      else if(mapPerson.length < 101){
        fileNum = 'a0${mapPerson.length - 1}';
      }
      else{
        fileNum = 'a${mapPerson.length - 1}';
      }

      File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
      mapPerson.removeLast();
    }

    SortPersonFromMark();

    Fluttertoast.showToast(msg: '명식이 삭제되었습니다');
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
    mapPerson[index]['memo'] = memo;

    UpdatePersonDataFromMap(index);

    Fluttertoast.showToast(msg: '메모가 저장되었습니다');
  }

  //명식을 즐겨찾기 하거나 해제하여 저장할 때 사용
  SavePersonMark(String saveDataNum) async {
    int index = 0;
    if(saveDataNum != '') {
      index = int.parse(saveDataNum.substring(1, 4));
    }
    else{
      index = mapPerson.length - 1;
    }

    if(mapPerson[index]['mark'] == true){
      mapPerson[index]['mark'] = false;
    }
    else{
      mapPerson[index]['mark'] = true;
      Fluttertoast.showToast(msg: '즐겨찾기 되었습니다');
    }

    UpdatePersonDataFromMap(index);
  }

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

  Fluttertoast.showToast(msg: '명식이 수정되었습니다');
}

  //명식의 내용을 수정하여 저장한 후 map에 업데이트 함
  UpdatePersonDataFromMap(int index) async{
    SortPersonFromMark();

    String fileNum = '';
    if(index < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
      fileNum = 'a00${index}';
    }
    else if(index < 100){
      fileNum = 'a0${index}';
    }
    else{
      fileNum = 'a${index}';
    }
    try{
      //File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);  //원래 있던 파일을 삭제하고

      //final file = await CreateSaveFile(fileNum); //같은 파일 이름으로 새로 생성한다

      final file = File('${fileDirPath}/${fileNum}');

      await file.writeAsString(jsonEncode({'num':fileNum, 'name': mapPerson[index]['name'], 'gender':mapPerson[index]['gender'], 'uemYang': mapPerson[index]['uemYang'],
        'birthYear':mapPerson[index]['birthYear'], 'birthMonth':mapPerson[index]['birthMonth'],'birthDay':mapPerson[index]['birthDay'], 'birthHour':mapPerson[index]['birthHour'],
        'birthMin':mapPerson[index]['birthMin'], 'saveDate':mapPerson[index]['saveDate'], 'memo':mapPerson[index]['memo'], 'mark':mapPerson[index]['mark']}));
    }catch(e){return {};} //내용을 덮어쓴다
  }

  //궁합을 최초 저장할 때 사용
  Future<void> SaveMatchData(String name0, String genderString0, int uemYang0, int birthYear0, int birthMonth0, int birthDay0, int birthHour0, int birthMin0,
      String name1, String genderString1, int uemYang1, int birthYear1, int birthMonth1, int birthDay1, int birthHour1, int birthMin1) async {
  bool gender0 = true, gender1 = true;
  if(genderString0 == '여'){
    gender0 = false;
  }
  if(genderString1 == '여'){
    gender1 = false;
  }

  int count = mapMatch.length;
  String fileNum = '';
  if(count < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
    fileNum = 'b00${count}';
  }
  else if(count < 100){
    fileNum = 'b0${count}';
  }
  else{
    fileNum = 'b${count}';
  }
  final file = await CreateSaveFile(fileNum);


  await file.writeAsString(jsonEncode({'num':fileNum, 'name0': name0, 'gender0':gender0, 'uemYang0': uemYang0, 'birthYear0':birthYear0, 'birthMonth0':birthMonth0,
    'birthDay0':birthDay0, 'birthHour0':birthHour0, 'birthMin0':birthMin0, 'name1': name1, 'gender1':gender1, 'uemYang1': uemYang1, 'birthYear1':birthYear1, 'birthMonth1':birthMonth1,
    'birthDay1':birthDay1, 'birthHour1':birthHour1, 'birthMin1':birthMin1, 'saveDate':DateTime.now().toString(), 'memo':'', 'mark':false}));
  mapMatch.add(jsonDecode(await file.readAsString()));
  SortMatchFromMark();

  Fluttertoast.showToast(msg: '궁합이 저장되었습니다');
  }

  //궁합을 삭제할 때 사용
  DeleteMatchData(String num) async {
  int index = int.parse(num.substring(1,4));

  if(index == mapMatch.length-1){  //map의 마지막 파일이면
    String fileNum = '';
    if(index < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
      fileNum = 'b00${index}';
    }
    else if(index < 100){
      fileNum = 'b0${index}';
    }
    else{
      fileNum = 'b${index}';
    }
    File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
    mapMatch.removeLast();
  }
  else{
    for(int i = index; i < mapMatch.length-1; i++){
      String fileNum = '';
      if(i < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
        fileNum = 'b00${i}';
      }
      else if(i < 100){
        fileNum = 'b0${i}';
      }
      else{
        fileNum = 'b${i}';
      }
      mapMatch[i]['name0'] = mapMatch[i+1]['name0'];
      mapMatch[i]['gender0'] = mapMatch[i+1]['gender0'];
      mapMatch[i]['uemYang0'] = mapMatch[i+1]['uemYang0'];
      mapMatch[i]['birthYear0'] = mapMatch[i+1]['birthYear0'];
      mapMatch[i]['birthMonth0'] = mapMatch[i+1]['birthMonth0'];
      mapMatch[i]['birthDay0'] = mapMatch[i+1]['birthDay0'];
      mapMatch[i]['birthHour0'] = mapMatch[i+1]['birthHour0'];
      mapMatch[i]['birthMin0'] = mapMatch[i+1]['birthMin0'];
      mapMatch[i]['name1'] = mapMatch[i+1]['name1'];
      mapMatch[i]['gender1'] = mapMatch[i+1]['gender1'];
      mapMatch[i]['uemYang1'] = mapMatch[i+1]['uemYang1'];
      mapMatch[i]['birthYear1'] = mapMatch[i+1]['birthYear1'];
      mapMatch[i]['birthMonth1'] = mapMatch[i+1]['birthMonth1'];
      mapMatch[i]['birthDay1'] = mapMatch[i+1]['birthDay1'];
      mapMatch[i]['birthHour1'] = mapMatch[i+1]['birthHour1'];
      mapMatch[i]['birthMin1'] = mapMatch[i+1]['birthMin1'];
      mapMatch[i]['saveDate'] = mapMatch[i+1]['saveDate'];
      mapMatch[i]['memo'] = mapMatch[i+1]['memo'];
      mapMatch[i]['mark'] = mapMatch[i+1]['mark'];
      try{
        await File('${fileDirPath}/${fileNum}').writeAsString(jsonEncode({'num':fileNum, 'name0': mapMatch[i+1]['name0'], 'gender0':mapMatch[i+1]['gender0'], 'uemYang0': mapMatch[i+1]['uemYang0'],
          'birthYear0':mapMatch[i+1]['birthYear0'], 'birthMonth0':mapMatch[i+1]['birthMonth0'],'birthDay0':mapMatch[i+1]['birthDay0'], 'birthHour0':mapMatch[i+1]['birthHour0'],
          'birthMin0':mapMatch[i+1]['birthMin0'],
          'name1': mapMatch[i+1]['name1'], 'gender1':mapMatch[i+1]['gender1'], 'uemYang1': mapMatch[i+1]['uemYang1'],
          'birthYear1':mapMatch[i+1]['birthYear1'], 'birthMonth1':mapMatch[i+1]['birthMonth1'],'birthDay1':mapMatch[i+1]['birthDay1'], 'birthHour1':mapMatch[i+1]['birthHour1'],
          'birthMin1':mapMatch[i+1]['birthMin1'],
          'saveDate':mapMatch[i+1]['saveDate'], 'memo':mapMatch[i+1]['memo'], 'mark':mapMatch[i+1]['mark']}));
      }catch(e){return {};}
    }
    String fileNum = '';
    if(mapMatch.length < 11){
      fileNum = 'b00${mapMatch.length - 1}';
    }
    else if(mapMatch.length < 101){
      fileNum = 'b0${mapMatch.length - 1}';
    }
    else{
      fileNum = 'b${mapMatch.length - 1}';
    }

    File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
    mapMatch.removeLast();
  }

  Fluttertoast.showToast(msg: '궁합이 삭제되었습니다');
}

  //궁합의 메모를 최초, 또는 수정하여 저장할 때 사용
  SaveMatchDataMemo(String saveDataNum, String memo) async {
  int index;
  if(saveDataNum == ''){
    index = mapMatch.length - 1;
  }
  else{
    index = int.parse(saveDataNum.substring(1,4));
  }
  mapMatch[index]['memo'] = memo;

  UpdateMatchDataFromMap(index);

  Fluttertoast.showToast(msg: '메모가 저장되었습니다');
}

  //궁합을 즐겨찾기 하거나 해제하여 저장할 때 사용
  SaveMatchMark(String saveDataNum) async {
  int index = 0;

  if(saveDataNum != '') {
    index = int.parse(saveDataNum.substring(1, 4));
  }
  else{
    index = mapMatch.length - 1;
  }

  if(mapMatch[index]['mark'] == true){
    mapMatch[index]['mark'] = false;
  }
  else{
    mapMatch[index]['mark'] = true;
    Fluttertoast.showToast(msg: '즐겨찾기 되었습니다');
  }

  UpdateMatchDataFromMap(index);
}

  //명식의 내용을 수정하여 저장한 후 map에 업데이트 함
  UpdateMatchDataFromMap(int index) async{
  SortMatchFromMark();

  String fileNum = '';
  if(index < 10){ //단일 저장은 a로 시작 궁합은 b로 시작
    fileNum = 'b00${index}';
  }
  else if(index < 100){
    fileNum = 'b0${index}';
  }
  else{
    fileNum = 'b${index}';
  }
  try{
    final file = File('${fileDirPath}/${fileNum}');

    await file.writeAsString(jsonEncode({'num':fileNum, 'name0': mapMatch[index]['name0'], 'gender0':mapMatch[index]['gender0'], 'uemYang0': mapMatch[index]['uemYang0'],
      'birthYear0':mapMatch[index]['birthYear0'], 'birthMonth0':mapMatch[index]['birthMonth0'],'birthDay0':mapMatch[index]['birthDay0'], 'birthHour0':mapMatch[index]['birthHour0'],
      'birthMin0':mapMatch[index]['birthMin0'],
      'name1': mapMatch[index]['name1'], 'gender1':mapMatch[index]['gender1'], 'uemYang1': mapMatch[index]['uemYang1'],
      'birthYear1':mapMatch[index]['birthYear1'], 'birthMonth1':mapMatch[index]['birthMonth1'],'birthDay1':mapMatch[index]['birthDay1'], 'birthHour1':mapMatch[index]['birthHour1'],
      'birthMin1':mapMatch[index]['birthMin1'], 'saveDate':mapMatch[index]['saveDate'], 'memo':mapMatch[index]['memo'], 'mark':mapMatch[index]['mark']}));
  }catch(e){return {};} //내용을 덮어쓴다
}

  //최근 명식 저장
  Future<void> SaveRecentPersonData(String name, String genderString, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, String memo) async {
  bool gender = true;
  if(genderString == '여'){
    gender = false;
  }

  if(mapRecentPerson.isNotEmpty && mapRecentPerson[0]['gender'] == gender && mapRecentPerson[0]['uemYang'] == uemYang && mapRecentPerson[0]['birthYear'] == birthYear && mapRecentPerson[0]['birthMonth'] == birthMonth && mapRecentPerson[0]['birthDay'] == birthDay && mapRecentPerson[0]['birthHour'] == birthHour && mapRecentPerson[0]['birthMin'] == birthMin){
    return;
  }

  int count = min(mapRecentPerson.length, recentDataLimitCount) - 1;
  String fileNum = '';
  if(count > 0){
    for(int i = count; i > -1; i--){
      if(i < 9){ //최근 목록은 r로 시작
        fileNum = 'r00${i+1}';
      }
      else if(i < 30){
        fileNum = 'r0${i+1}';
      }
      final file = await CreateSaveFile(fileNum);

      await file.writeAsString(jsonEncode({'num':fileNum, 'name': mapRecentPerson[i]['name'], 'gender':mapRecentPerson[i]['gender'], 'uemYang': mapRecentPerson[i]['uemYang'],
        'birthYear':mapRecentPerson[i]['birthYear'], 'birthMonth':mapRecentPerson[i]['birthMonth'], 'birthDay':mapRecentPerson[i]['birthDay'], 'birthHour':mapRecentPerson[i]['birthHour'],
        'birthMin':mapRecentPerson[i]['birthMin'], 'saveDate':DateTime.now().toString(), 'memo':mapRecentPerson[i]['memo'], 'mark':false}));
    }
  }

  count = mapRecentPerson.length;
  fileNum = 'r000';
  final file = await CreateSaveFile(fileNum);

  await file.writeAsString(jsonEncode({'num':fileNum, 'name': name, 'gender':gender, 'uemYang': uemYang, 'birthYear':birthYear, 'birthMonth':birthMonth,
    'birthDay':birthDay, 'birthHour':birthHour, 'birthMin':birthMin, 'saveDate':DateTime.now().toString(), 'memo':memo, 'mark':false}));

  mapRecentPerson.insert(0, jsonDecode(await file.readAsString()));
  if(mapRecentPerson.length > recentDataLimitCount){
    mapRecentPerson.removeLast();
  }
}

  //일진일기를 최초 저장할 때 사용
  Future<void> SaveDiaryData(int year, int month, int day, int labelData, List<int> dayPaljaData, String dayString, String memo,{bool isEditDiary = false, String editFileNum = ''}) async {
    if(isEditDiary == true){  //수정할 때
      final file = File('${fileDirPath}/${editFileNum}');
      int index = int.parse(editFileNum.substring(1, 5));

      mapDiary[index]['labelData'] = labelData;
      mapDiary[index]['memo'] = memo;

      await file.writeAsString(jsonEncode({'num':editFileNum,'year': mapDiary[index]['year'], 'month':mapDiary[index]['month'], 'day': mapDiary[index]['day'], 'dayPaljaData': mapDiary[index]['dayPaljaData'],
        'dayString': mapDiary[index]['dayString'], 'labelData':mapDiary[index]['labelData'], 'memo':mapDiary[index]['memo']}));
    }
    else {  //새로 저장할 때
      int count = mapDiary.length;
      int index = 0;
      int saveDayVal = (year * 10000) + (month * 100) + day;  //오늘 저장할 데이터의 날짜를 이용한 값
      int dayVal = 0;
      if(count != 0){
        dayVal = (mapDiary.last['year'] * 10000) + (mapDiary.last['month'] * 100) + mapDiary.last['day']; //이전에 저장되었던 데이터들의 날짜 값/ 가장 최근값
      }

      //새로 저장할 일기의 순서를 조회함
      if(count != 0){
        if(dayVal < saveDayVal){  //가장 최근 날짜로 저장할 때
          index = count;
        }
        //else if(dayVal == saveDayVal){  //가장 최근에 저장했던 걸 수정할 때
        //  index = count - 1;
        //}
        else {  //저장목록 중간에 껴야할 때
          for(int i = 0; i < count; i++){
            dayVal = (mapDiary[i]['year'] * 10000) + (mapDiary[i]['month'] * 100) + mapDiary[i]['day'];
            if(dayVal > saveDayVal){  //새 데이터가 저장 데이터보다 옛날 날짜면
              index = i;
              break;
            }
          }
        }
      }
      //새로 저장할 일기의 순서에 따라 저장하는 방법이 다름
      if(index == count || count == 0){ //가장 최근 날짜의 데이터 저장
        String fileNum = '';
        if(index < 10){ //일기는 d로 시작
          fileNum = 'd000${index}';
        }
        else if(index < 100){
          fileNum = 'd00${index}';
        }
        else if(index < 1000){
          fileNum = 'd0${index}';
        }
        else{
          fileNum = 'd${index}';
        }
        mapDiary.add({'num':fileNum, 'year':year, 'month':month, 'day':day, 'labelData':labelData, 'dayPaljaData':dayPaljaData, 'dayString':dayString, 'memo':memo});
        final file = await CreateSaveFile(fileNum);
        await file.writeAsString(jsonEncode({'num':fileNum,'year':year, 'month':month,
          'day':day, 'labelData':labelData, 'dayPaljaData':dayPaljaData, 'dayString':dayString, 'memo':memo}));
      }
      else { //이전 날짜의 일기라서 맵데이터 중간에 껴야할 때
        Map newOne = {'num':'a', 'year':0, 'month':0, 'day':0, 'labelData':0,'memo':''};
        mapDiary.add(newOne);
        for(int i = mapDiary.length - 1; i > index; i--){
          print(i);
          String fileNum = '';
          if(i < 10){ //일기는 d로 시작
            fileNum = 'd000${i}';
          }
          else if(i < 100){
            fileNum = 'd00${i}';
          }
          else if(i < 1000){
            fileNum = 'd0${i}';
          }
          else{
            fileNum = 'd${i}';
          }
          mapDiary[i]['num'] = fileNum;
          mapDiary[i]['year'] = mapDiary[i-1]['year'];
          mapDiary[i]['month'] = mapDiary[i-1]['month'];
          mapDiary[i]['day'] = mapDiary[i-1]['day'];
          mapDiary[i]['labelData'] = mapDiary[i-1]['labelData'];
          mapDiary[i]['memo'] = mapDiary[i-1]['memo'];
          mapDiary[i]['dayPaljaData'] = mapDiary[i-1]['dayPaljaData'];
          mapDiary[i]['dayString'] = mapDiary[i-1]['dayString'];
          try{
            await File('${fileDirPath}/${fileNum}').writeAsString(jsonEncode({'num':fileNum, 'year': mapDiary[i-1]['year'], 'month':mapDiary[i-1]['month'], 'day': mapDiary[i-1]['day'],
              'dayPaljaData':mapDiary[i-1]['dayPaljaData'], 'dayString':mapDiary[i-1]['dayString'], 'labelData':mapDiary[i-1]['labelData'], 'memo':mapDiary[i-1]['memo']}));
          }catch(e){return;}
          //mapDiary[i] = jsonDecode(await File('${fileDirPath}/${fileNum}').readAsString());
        }
        String fileNum = '';
        if(index < 10){ //일기는 d로 시작
          fileNum = 'd000${index}';
        }
        else if(index < 100){
          fileNum = 'd00${index}';
        }
        else if(index < 1000){
          fileNum = 'd0${index}';
        }
        else{
          fileNum = 'd${index}';
        }
        mapDiary[index]['num'] = fileNum;
        mapDiary[index]['year'] = year;
        mapDiary[index]['month'] = month;
        mapDiary[index]['day'] = day;
        mapDiary[index]['labelData'] = labelData;
        mapDiary[index]['memo'] = memo;
        mapDiary[index]['dayPaljaData'] = dayPaljaData;
        mapDiary[index]['dayString'] = dayString;
        final file = File('${fileDirPath}/${fileNum}');
        await file.writeAsString(jsonEncode({'num':fileNum,'year':year, 'month':month,
          'day':day, 'dayPaljaData':dayPaljaData, 'dayString':dayString, 'labelData':labelData, 'memo':memo}));
      }
    }


}

  //일진일기 쓸 날자에 작성된 파일 있는지 조회
  String FineDiaryNum(int year, int month, int day){
    String fileNum = '';
    for(int i = 0; i < mapDiary.length; i++){
      if(mapDiary[i]['day'] == day){
        if(mapDiary[i]['month'] == month){
          if(mapDiary[i]['year'] == year){
            fileNum = mapDiary[i]['num'];
            break;
          }
        }
      }
    }
    return fileNum;
  }

  //일기 삭제
  DeleteDiaryData(String num) async {
    int index = int.parse(num.substring(1,5));

    if(index == mapDiary.length-1){  //map의 마지막 파일이면
      String fileNum = '';
      if(index < 10){ //일기는 d로 시작
        fileNum = 'd000${index}';
      }
      else if(index < 100){
        fileNum = 'd00${index}';
      }
      else if(index < 1000){
        fileNum = 'd0${index}';
      }
      else{
        fileNum = 'd${index}';
      }
      File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
      mapDiary.removeLast();
    }
    else{
      for(int i = index; i < mapDiary.length-1; i++){
        String fileNum = '';
        if(index < 10){ //일기는 d로 시작
          fileNum = 'd000${i}';
        }
        else if(index < 100){
          fileNum = 'd00${i}';
        }
        else if(index < 1000){
          fileNum = 'd0${i}';
        }
        else{
          fileNum = 'd${i}';
        }
        mapDiary[i]['year'] = mapDiary[i+1]['year'];
        mapDiary[i]['month'] = mapDiary[i+1]['month'];
        mapDiary[i]['day'] = mapDiary[i+1]['day'];
        mapDiary[i]['labelData'] = mapDiary[i+1]['labelData'];
        mapDiary[i]['memo'] = mapDiary[i+1]['memo'];
        mapDiary[i]['dayPaljaData'] = mapDiary[i+1]['dayPaljaData'];
        mapDiary[i]['dayString'] = mapDiary[i+1]['dayString'];
        try{
          await File('${fileDirPath}/${fileNum}').writeAsString(jsonEncode({'num':fileNum, 'year': mapDiary[i]['year'], 'month':mapDiary[i]['month'], 'day': mapDiary[i]['day'],
            'dayPaljaData':mapDiary[i]['dayPaljaData'], 'dayString':mapDiary[i]['dayString'], 'labelData':mapDiary[i]['labelData'], 'memo':mapDiary[i]['memo']}));
        }catch(e){return{};}
      }
      String delFileNum = '';
      if(mapDiary.length < 11){
        delFileNum = 'd000${mapDiary.length - 1}';
      }
      else if(mapDiary.length < 101){
        delFileNum = 'd00${mapDiary.length - 1}';
      }
      else if(mapDiary.length < 1001){
        delFileNum = 'd0${mapDiary.length - 1}';
      }
      else{
        delFileNum = 'd${mapDiary.length - 1}';
      }

      File('${fileDirPath}/${delFileNum}').deleteSync(recursive: true);
      mapDiary.removeLast();
    }

    Fluttertoast.showToast(msg: '일기가 삭제되었습니다');
  }
