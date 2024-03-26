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
  await LoadRecentPeople();
  await LoadSavedDiary();
  await LoadSavedGroup();
}
// 저장번호 - 단일명식 p001, 최근명식 l001, 일기 j001, 단체명식 g001
int saveDataLimitCount = 3000; //단일,궁합 공용
int recentDataLimitCount = 1000;  //최근목록
int diaryDataLimitCount = 1000; //일진일기
int groupDataLimitCount = 1000; //단체명식

//int savedPersonDataCount = 0;
List<Map> mapPerson = []; //String name, bool gender, int uemYang, int birth---, String saveDate, String memo, bool mark
List<Map> mapPersonSortedMark = []; //즐겨찾기로 정렬된 리스트
List<List<dynamic>> listMapGroup = []; //String name, bool gender, int uemYang, int birth---, String saveDate, String memo, bool mark
List<Map> mapGroupSortedMark = []; //즐겨찾기로 정렬된 리스트

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
              jsonDecode(await File('${fileDirPath}/p00${i}').readAsString()));
        } catch(e){break;}
      }
      else if(i < 100){
        try{mapPerson.add(jsonDecode(await File('${fileDirPath}/p0${i}').readAsString()));}
            catch(e){break;}
      }
      else{
        try{mapPerson.add(jsonDecode(await File('${fileDirPath}/p${i}').readAsString()));}
            catch(e){break;}
      }
    }
    SortPersonFromMark();
  }
  LoadRecentPeople() async {
  if(mapRecentPerson.length != 0)
    return;

  for(int i = 0; i <= recentDataLimitCount; i++){
    if(i < 10){
      try {
        mapRecentPerson.add(
            jsonDecode(await File('${fileDirPath}/l00${i}').readAsString()));
      } catch(e){break;}
    }
    else if(i < 100){
      try{mapRecentPerson.add(jsonDecode(await File('${fileDirPath}/l0${i}').readAsString()));}
      catch(e){break;}
    }
    else{
      try{mapRecentPerson.add(jsonDecode(await File('${fileDirPath}/l${i}').readAsString()));}
      catch(e){break;}
    }
  }
}
  LoadSavedGroup() async {
  if(listMapGroup.length != 0)
    return;

  for(int i = 0; i <= groupDataLimitCount; i++){
    if(i < 10){
      try {
        listMapGroup.add(
            jsonDecode(await File('${fileDirPath}/g00${i}').readAsString()));
      } catch(e){break;}
    }
    else if(i < 100){
      try{listMapGroup.add(jsonDecode(await File('${fileDirPath}/g0${i}').readAsString()));}
      catch(e){break;}
    }
    else{
      try{listMapGroup.add(jsonDecode(await File('${fileDirPath}/g${i}').readAsString()));}
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
            jsonDecode(await File('${fileDirPath}/j000${i}').readAsString()));
      } catch(e){break;}
    }
    else if(i < 100){
      try{mapDiary.add(jsonDecode(await File('${fileDirPath}/j00${i}').readAsString()));}
      catch(e){break;}
    }
    else if(i < 1000){
      try{mapDiary.add(jsonDecode(await File('${fileDirPath}/j0${i}').readAsString()));}
      catch(e){break;}
    }
    else{
      try{mapDiary.add(jsonDecode(await File('${fileDirPath}/j${i}').readAsString()));}
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
  SortGroupFromMark(){

  }

  //저장할 때 내용을 저장할 빈 파일을 생성함
  Future<File> CreateSaveFile(String fileNum) async {
        return File('${fileDirPath}/${fileNum}');
  }

  //그룹을 최초 저장할 때 사용
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
    SortGroupFromMark();
    Fluttertoast.showToast(msg: '단체 명식이 저장되었습니다');
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
      fileNum = 'p00${index}';
    }
    else if(index < 100){
      fileNum = 'p0${index}';
    }
    else{
      fileNum = 'p${index}';
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

  //최근 명식 저장
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
      if(i < 9){ //최근 목록은 r로 시작
        fileNum = 'l00${i+1}';
      }
      else if(i < 30){
        fileNum = 'l0${i+1}';
      }
      final file = await CreateSaveFile(fileNum);

      await file.writeAsString(jsonEncode({'num':fileNum, 'name': mapRecentPerson[i]['name'], 'gender':mapRecentPerson[i]['gender'], 'uemYang': mapRecentPerson[i]['uemYang'],
        'birthYear':mapRecentPerson[i]['birthYear'], 'birthMonth':mapRecentPerson[i]['birthMonth'], 'birthDay':mapRecentPerson[i]['birthDay'], 'birthHour':mapRecentPerson[i]['birthHour'],
        'birthMin':mapRecentPerson[i]['birthMin'], 'saveDate':DateTime.now().toString(), 'memo':mapRecentPerson[i]['memo'], 'mark':false}));
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
          fileNum = 'j000${index}';
        }
        else if(index < 100){
          fileNum = 'j00${index}';
        }
        else if(index < 1000){
          fileNum = 'j0${index}';
        }
        else{
          fileNum = 'j${index}';
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
          String fileNum = '';
          if(i < 10){ //일기는 d로 시작
            fileNum = 'j000${i}';
          }
          else if(i < 100){
            fileNum = 'j00${i}';
          }
          else if(i < 1000){
            fileNum = 'j0${i}';
          }
          else{
            fileNum = 'j${i}';
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
          fileNum = 'j000${index}';
        }
        else if(index < 100){
          fileNum = 'j00${index}';
        }
        else if(index < 1000){
          fileNum = 'j0${index}';
        }
        else{
          fileNum = 'j${index}';
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
        fileNum = 'j000${index}';
      }
      else if(index < 100){
        fileNum = 'j00${index}';
      }
      else if(index < 1000){
        fileNum = 'j0${index}';
      }
      else{
        fileNum = 'j${index}';
      }
      File('${fileDirPath}/${fileNum}').deleteSync(recursive: true);
      mapDiary.removeLast();
    }
    else{
      for(int i = index; i < mapDiary.length-1; i++){
        String fileNum = '';
        if(index < 10){ //일기는 d로 시작
          fileNum = 'j000${i}';
        }
        else if(index < 100){
          fileNum = 'j00${i}';
        }
        else if(index < 1000){
          fileNum = 'j0${i}';
        }
        else{
          fileNum = 'j${i}';
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
        delFileNum = 'j000${mapDiary.length - 1}';
      }
      else if(mapDiary.length < 101){
        delFileNum = 'j00${mapDiary.length - 1}';
      }
      else if(mapDiary.length < 1001){
        delFileNum = 'j0${mapDiary.length - 1}';
      }
      else{
        delFileNum = 'j${mapDiary.length - 1}';
      }

      File('${fileDirPath}/${delFileNum}').deleteSync(recursive: true);
      mapDiary.removeLast();
    }

    Fluttertoast.showToast(msg: '일기가 삭제되었습니다');
  }
