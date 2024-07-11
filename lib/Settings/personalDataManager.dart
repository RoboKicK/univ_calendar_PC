import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../style.dart' as style;

String fileDirPath = '';

//mapUserData : 사용자 정보, mapWordData : 단어 설정, calendarData : 만세력 설정, sinsalData : 신살, etcSinsalData : 기타 신살, deunSeunData : 대운세운, etcData : 기타

Map mapUserData = {}; //사용자 정보
int themeData = 1; //테마 데이터

Map mapWordData = {}; //단어 설정 'ilGan', 'yugChin', 'myeongSic', 'geukChung', 'hab'   라디오 버튼 1,2,3

int calendarDataAllOn =  2272222272337;
int calendarDataAllOff =  1191111191119;
int calendarData = 0;  //12개 1자리:천간 합충극  -  1=합, 2=충, 4=극  -  3=합충, 5=합극, 6=충극, 7=합충극, 9=안보기
// 10자리:방위합  -  1은 안보기, 2는 반만 보기, 3은 다 보기
// 100자리:삼합, 1000자리:육합, 만자리:형, 십만자리:충, 백만자리:파, 천만자리:원진, 억자리:귀문, 십억자리:격각, 백억자리:지장간 1=육친, 2=월률분야, 3=둘다, 9=안보기
// 천억자리:십이운성, 조자리: 육친

int sinsalData = 0; //1자리: 공망, 10자리: 십이신살, 100자리: 공망 표시 방법
int etcSinsalDataAllOn =  2222222;
int etcSinsalDataAllOff = 1111111;
int etcSinsalData = 0;  //1자리: 보기 안보기, 10자리: 천을귀인, 100자리: 문창귀인, 1000자리: 백호대살, 만자리: 괴강살, 십만자리: 현심살, 백만자리: 양인살,

int deunSeunDataAllOn = 2272223; //1자리: 간지추가, 10자리: 육친, 100자리: 십이운성, 1000자리: 십이신살, 만자리: 공망
int deunSeunDataAllOff = 1191111;
int deunSeunData = 0; //1자리: 간지 추가, 10자리: 육친, 100자리: 십이운성, 1000자리: 십이신살, 만자리: 공망, 십만자리: 세운에 나이 표시, 백만자리: 월운 표시
int etcDataAllOn = 21273222;
int etcDataAllOff = 11191111;
int etcData = 0;  //1자리: 만 나이, 10자리: 간지 음양 표시, 100자리: 한글 간지, 1000자리: 인적사항 숨기기(1:안숨김, 2:만세력에서만 숨김, 3:항상 숨김)
//만자리:인적사항 숨기기(1:이름과 성별 + 2:나이 + 4:생년월일시), 십만자리: 조회 중 꺼지지 않음, 백만자리: 테마, 백만자리: 저장목록 등에 일주 표시
//테마: 1부터 베이직, 곰돌이

//사용자 정보 저장하는 클래스

SetFileDirectoryPath () async{  //처음 시작할 때 파일 저장하는 폴더의 주소를 초기화함
  final filedirectory = await getApplicationDocumentsDirectory();
  fileDirPath = filedirectory.path;
  await LoadUserData();
}

LoadUserData() async{
  try{mapUserData = await jsonDecode(await File('${fileDirPath}/userData').readAsString());
  }catch(e){
    mapUserData = {};
  } //내용을 덮어쓴다
  try{mapWordData = await jsonDecode(await File('${fileDirPath}/wordData').readAsString());
  }catch(e){    //단어 설정 파일이 없으면 생성한다
    final file = await CreateSaveFile('wordData');
    await file.writeAsString(jsonEncode({'ilGan':0, 'yugChin':0, 'myeongSic':0, 'geukChung':1, 'hab':1}));
    mapWordData = {'ilGan':0, 'yugChin':0, 'myeongSic':0, 'geukChung':1, 'hab':1};
    if(mapWordData['myeongSic'] == 1){
      style.myeongsicString = '원국';
    }
  }
  try{calendarData = await jsonDecode(await File('${fileDirPath}/calendarData').readAsString());
  }catch(e){
    final file = await CreateSaveFile('calendarData');
    await file.writeAsString(jsonEncode(calendarDataAllOn));
    calendarData = calendarDataAllOn;
  }
  try{sinsalData = await jsonDecode(await File('${fileDirPath}/sinsalData').readAsString());
  }catch(e){
    final file = await CreateSaveFile('sinsalData');
    sinsalData = 327;
    await file.writeAsString(jsonEncode(327));
  }
  try{etcSinsalData = await jsonDecode(await File('${fileDirPath}/etcSinsalData').readAsString());
  }catch(e){
    final file = await CreateSaveFile('etcSinsalData');
    await file.writeAsString(jsonEncode(etcSinsalDataAllOn));
    etcSinsalData = etcSinsalDataAllOn;
  }
  try{deunSeunData = await jsonDecode(await File('${fileDirPath}/deunSeunData').readAsString());
  }catch(e){
    final file = await CreateSaveFile('deunSeunData');
    await file.writeAsString(jsonEncode(deunSeunDataAllOn));
    deunSeunData = deunSeunDataAllOn;
  }
  try{etcData = await jsonDecode(await File('${fileDirPath}/etcData').readAsString());
    if(((etcData%1000)/100).floor() == 2){
    style.uemYangStringTypeNum = 1;
  }
  }catch(e){
    final file = await CreateSaveFile('etcData');
    etcData = etcDataAllOff;
    if(etcData < 10000000){
      etcData = etcData + 20000000;
    }
    await file.writeAsString(jsonEncode(etcData));
  }
  try{themeData = await jsonDecode(await File('${fileDirPath}/themeData').readAsString());
  }catch(e){
    final file = await CreateSaveFile('themeData');
    await file.writeAsString(jsonEncode(1));
  }
}

//저장할 때 내용을 저장할 빈 파일을 생성함
Future<File> CreateSaveFile(String fileName) async {
  return File('${fileDirPath}/${fileName}');
}
//사용자 정보를 파일로 저장하고 갱신함
Future<void> SaveUserData(String name, bool gender, int uemYang, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin, List<int> paljaData, {diaryFirstSet = null}) async{

  mapUserData['name'] = name;
  mapUserData['gender'] = gender;
  mapUserData['uemYang'] = uemYang;
  mapUserData['birthYear'] = birthYear;
  mapUserData['birthMonth'] = birthMonth;
  mapUserData['birthDay'] = birthDay;
  mapUserData['birthHour'] = birthHour;
  mapUserData['birthMin'] = birthMin;
  mapUserData['listPaljaData'] = paljaData;

  if(diaryFirstSet != null){
    diaryFirstSet(gender, uemYang, birthYear, birthMonth, birthDay, birthHour, birthMin, paljaData);
  }

  final file = await CreateSaveFile('userData');

  await file.writeAsString(jsonEncode({'name':name, 'gender':gender, 'uemYang': uemYang, 'birthYear':birthYear, 'birthMonth':birthMonth,
    'birthDay':birthDay, 'birthHour':birthHour, 'birthMin':birthMin, 'listPaljaData': paljaData}));
}
//단어 설정 저장
Future<void> SaveWordData(String type, int num) async{

  final file = await CreateSaveFile('wordData');

  if(mapWordData[type] != null){
    mapWordData[type] = num;
  } else {
    mapWordData[type] = 1;
  }
  if(type == 'myeongSic'){
    if(num == 0) {
      style.myeongsicString = '명식';
    } else {
      style.myeongsicString = '원국';
    }
  }
  await file.writeAsString(jsonEncode(mapWordData));
  //mapWordData = jsonDecode(await file.readAsString());
}
//만세력 합충극 등 보기 설정
Future<void> SaveCalendarData(int typeUnit, int num, {bool isAll = false, bool withoutSave = false}) async{

  if(isAll == true){
    if(num == 1){
      calendarData = calendarDataAllOff;
    } else {
      calendarData = calendarDataAllOn;
    }
  } else {
    int largeNum = (calendarData / (typeUnit * 10)).floor();
    int smallNum = calendarData % typeUnit;
    calendarData = (largeNum * (typeUnit * 10)) + (num * typeUnit) + smallNum;
  }

  if(withoutSave == false) {
    final file = await CreateSaveFile('calendarData');

    await file.writeAsString(jsonEncode(calendarData));
  }
}

Future<void> SaveSinsalData(int typeUnit, int num,  {bool isAll = false, bool withoutSave = false}) async{

  if(isAll == true){
    if(num == 1){
      sinsalData = 119;
    } else {
      sinsalData = 327;
    }
  } else {
    int largeNum = (sinsalData / (typeUnit * 10)).floor();
    int smallNum = sinsalData % typeUnit;
    sinsalData = (largeNum * (typeUnit * 10)) + (num * typeUnit) + smallNum;
  }

  if(withoutSave == false) {
    final file = await CreateSaveFile('sinsalData');

    await file.writeAsString(jsonEncode(sinsalData));
  }
}

Future<void> SaveEtcSinsalData(int typeUnit, int num, {bool isAll = false, bool withoutSave = false}) async{

  if(isAll == true){
    if(num == 1){
      etcSinsalData = etcSinsalDataAllOff;
    } else {
      etcSinsalData = etcSinsalDataAllOn;
    }
  } else {
    int largeNum = (etcSinsalData / (typeUnit * 10)).floor();
    int smallNum = etcSinsalData % typeUnit;
    etcSinsalData = (largeNum * (typeUnit * 10)) + (num * typeUnit) + smallNum;
  }

  if(withoutSave == false) {
    final file = await CreateSaveFile('etcSinsalData');

    await file.writeAsString(jsonEncode(etcSinsalData));
  }
}

Future<void> SaveDeunSeunData(int typeUnit, int num, {bool isAll = false, bool withoutSave = false}) async{

  if(isAll == true){
    if(num == 1){
      deunSeunData = deunSeunDataAllOff;
    } else {
      deunSeunData = deunSeunDataAllOn;
    }
  } else {
    int largeNum = (deunSeunData / (typeUnit * 10)).floor();
    int smallNum = deunSeunData % typeUnit;
    deunSeunData = (largeNum * (typeUnit * 10)) + (num * typeUnit) + smallNum;
  }

  if(withoutSave == false) {
    final file = await CreateSaveFile('deunSeunData');

    await file.writeAsString(jsonEncode(deunSeunData));
  }
}

Future<void> SaveEtcData(int typeUnit, int num, {bool withoutSave = false}) async{

  int largeNum = (etcData / (typeUnit * 10)).floor();
  int smallNum = etcData % typeUnit;
  etcData = (largeNum * (typeUnit * 10)) + (num * typeUnit) + smallNum;

  if(typeUnit == 100){  //음양 한글화는 style의 변수도 바꿔준다
    style.uemYangStringTypeNum = num - 1;
  }

  if(withoutSave == false) {
    final file = await CreateSaveFile('etcData');

    await file.writeAsString(jsonEncode(etcData));
  }
}

Future<void> SaveThemeData(int num) async{

  themeData = num;

  final file = await CreateSaveFile('themeData');

  await file.writeAsString(jsonEncode(themeData));
}

Future<void> SaveAllFiles() async{
  final file = await CreateSaveFile('wordData');

  await file.writeAsString(jsonEncode(mapWordData));

  final file0 = await CreateSaveFile('calendarData');

  await file0.writeAsString(jsonEncode(calendarData));

  final file1 = await CreateSaveFile('sinsalData');

  await file1.writeAsString(jsonEncode(sinsalData));

  final file3 = await CreateSaveFile('deunSeunData');

  await file3.writeAsString(jsonEncode(deunSeunData));

  final file4 = await CreateSaveFile('etcData');

  await file4.writeAsString(jsonEncode(etcData));
}

Future<void> ResetAllFiles() async{
  await File('${fileDirPath}/calendarData').delete();
  await File('${fileDirPath}/deunSeunData').delete();
  await File('${fileDirPath}/etcData').delete();
  await File('${fileDirPath}/sinsalData').delete();
  await File('${fileDirPath}/etcSinsalData').delete();
  await File('${fileDirPath}/wordData').delete();
  await File('${fileDirPath}/userData').delete();

  LoadUserData();
  mapUserData.clear();
}

String GetYugchinText(){  //육친 단어를 설정에 따라 반환한다
  String yugchinString = '';
  if(mapWordData['yugChin'] == 0){
    yugchinString = '육친';
  } else if (mapWordData['yugChin'] == 1){
    yugchinString = '육신';
  } else if (mapWordData['yugChin'] == 2){
    yugchinString = '십성';
  }
  return yugchinString;
}

String GetMyeongsicText(){
  String myeongsicString = '';
  if(mapWordData['myeongSic'] == 0){
    myeongsicString = '명식';
  } else if(mapWordData['myeongSic'] == 1){
    myeongsicString = '원국';
  }

  return myeongsicString;
}

String GetIlganText(){
  String ilganString = '';
  if(mapWordData['ilGan'] == 0){
    ilganString = '일간';
  } else if(mapWordData['ilGan'] == 1){
    ilganString = '본원';
  } else if(mapWordData['ilGan'] == 2){
    ilganString = '아신';
  }

  return ilganString;
}


