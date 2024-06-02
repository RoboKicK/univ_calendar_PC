import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:univ_calendar_pc/main.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';

class MainCalendarRecentList extends StatefulWidget {
  const MainCalendarRecentList({super.key});

  @override
  State<MainCalendarRecentList> createState() => _MainCalendarRecentListState();
}

class _MainCalendarRecentListState extends State<MainCalendarRecentList> {

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true;

  String GetUemYangText(int uemYang){
    String uemYangText = '';
    if(uemYang == 0){
      uemYangText = '(양력)';
    }
    else if(uemYang == 1){
      uemYangText = '(음력)';
    }
    else{
      uemYangText = '(음력 윤달)';
    }

    return uemYangText;
  }
  String GetBirthTimeText(int birthHour, int birthMin, bool forMemo){ //forMemo true: 시간 분 사이에 :, false: 시간 분 사이에 .
    String birthTimeText = '';
    String partition = '';
    if(forMemo == true){
      partition = ':';
    }
    else{
      partition = '.';
    }

    if(birthHour == 30){
      return birthTimeText = '시간 모름';
    }
    else {
      if (birthHour < 10) {
        birthTimeText = '0${birthHour}';
      }
      else {
        birthTimeText = '${birthHour}';
      }

      if (birthMin < 10) {
        birthTimeText = birthTimeText + '${partition}0${birthMin}';
      }
      else {
        birthTimeText = birthTimeText + '${partition}${birthMin}';
      }
      return birthTimeText;
    }
  }
  String GetInquireDateText(DateTime saveDateString){
    String saveDateText = "${saveDateString.year}년 ${saveDateString.month}월 ${saveDateString.day}일";

    return saveDateText;
  }
  String GetNameText(String text){
    String nameText = '';
    int textLengthLimit = 6;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        break;
      }
      if(i+1 > text.length){
        break;
      }
      if(i > textLengthLimit){
        nameText = nameText+'..';
        break;
      }
      nameText = nameText + text.substring(i, i+1);
    }
    return nameText;
  }

  String searchText = '';

  ScrollController scrollController = ScrollController();

  List<Map> mapRecentPerson = [];

  List<Widget> GetPersonalNameText(int num){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == true || isShowPersonalName == true){
      listPersonalTextData.add(
        Container(
            height: style.saveDataNameTextLineHeight,
            //color:Colors.green,
            //child:Text("${GetNameText(saveDataManager.mapRecentPerson[num]['name'])}", style: Theme.of(context).textTheme.titleLarge)
            child:Text("${GetNameText(mapRecentPerson[num]['name'])}", style: Theme.of(context).textTheme.titleLarge)
        ),
      );
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              //color:Colors.green,
              //padding:EdgeInsets.only(top:7),
              child:Text("(${saveDataManager.GetSelectedRecentBirthData('gender',num)?'남':'여'})", style: Theme.of(context).textTheme.titleLarge)));
    } else {
       listPersonalTextData.add(Text("${saveDataManager.GetSelectedRecentBirthData('gender',num)?'남성':'여성'}", style: Theme.of(context).textTheme.titleLarge));
    }
    return listPersonalTextData;
  }

  List<Widget> GetPersonalDataText(int num){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == true || isShowPersonalBirth == true){
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameLineHeight,
              //alignment: Alignment.bottomCenter,
              //color:Colors.grey,
              //padding:EdgeInsets.only(top:2),
              child:Text("${saveDataManager.GetSelectedRecentBirthData('birthYear',num)}년 ${saveDataManager.GetSelectedRecentBirthData('birthMonth',num)}월 ${saveDataManager.GetSelectedRecentBirthData('birthDay',num)}일", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(Container(
          height: style.saveDataNameLineHeight,
          //color:Colors.red,
          //padding:EdgeInsets.only(top:7),
          child:Text("${GetUemYangText(saveDataManager.GetSelectedRecentBirthData('uemYang',num))}", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(Container(
          height: style.saveDataNameLineHeight,
          //alignment: Alignment.bottomCenter,
          //color:Colors.blue,
          //padding:EdgeInsets.only(top:saveDataManager.mapRecentPerson[num]['birthHour']==-2?1:2),
          child:Text(" ${GetBirthTimeText(saveDataManager.GetSelectedRecentBirthData('birthHour',num), saveDataManager.GetSelectedRecentBirthData('birthMin',num), true)}", style: Theme.of(context).textTheme.titleLarge)));
    } else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameLineHeight,
              child:Text("****.**.** **:**",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    }
    return listPersonalTextData;
    //return Row(
    //  children: [
    //    Text("${GetNameText(saveDataManager.mapPersonSortedMark[num]['name'])}", style: Theme.of(context).textTheme.labelMedium),
    //    Text("(${saveDataManager.mapPersonSortedMark[num]['gender']?'남':'여'})", style: Theme.of(context).textTheme.titleSmall),
    //    Text(" ${saveDataManager.mapPersonSortedMark[num]['birthYear']}.${saveDataManager.mapPersonSortedMark[num]['birthMonth']}.${saveDataManager.mapPersonSortedMark[num]['birthDay']}", style: Theme.of(context).textTheme.labelMedium),
    //    Text("${GetUemYangText(saveDataManager.mapPersonSortedMark[num]['uemYang'])}", style: Theme.of(context).textTheme.titleSmall),
    //    Text(" ${GetBirthTimeText(saveDataManager.mapPersonSortedMark[num]['birthHour'], saveDataManager.mapPersonSortedMark[num]['birthMin'], true)}", style: Theme.of(context).textTheme.labelMedium),
    //  ],
    //);
  }

  CheckPersonalDataHide(){
    if(((personalDataManager.etcData % 10000) / 1000).floor() == 3){
      isShowPersonalDataAll = false;
      int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
      if(isShowPersonalDataNum == 1 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 7){
        isShowPersonalName = false;
      } else { isShowPersonalName = true; }
      if(isShowPersonalDataNum == 4 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7){
        isShowPersonalBirth = false;
      } else { isShowPersonalBirth = true; }
    } else {
      isShowPersonalDataAll = true;
    }
  }

  ShowSameCheckerMessage(String birth, String name, bool gender, int uemYangType, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin){
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
                  saveDataManager.SavePersonData2(name, gender, uemYangType, birthYear, birthMonth, birthDay, birthHour, birthMin);

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

    CheckPersonalDataHide();
  }

  @override
  Widget build(BuildContext context) {

    CheckPersonalDataHide();

    mapRecentPerson = saveDataManager.mapRecentPerson;
    //mapRecentPerson.sort((a, b) => a['name'].compareTo(b['name']));


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(  //검색창
          height: style.fullSizeButtonHeight,
          width: style.UIButtonWidth,
          margin: EdgeInsets.only(top: style.UIMarginTopTop),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(  //검색 버튼
                      height: style.fullSizeButtonHeight,
                      width: style.UIButtonWidth,
                      decoration: BoxDecoration(
                        color: style.colorNavy,
                        borderRadius: BorderRadius.circular(style.textFiledRadius),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: style.UIButtonWidth,
                            height: 50,
                            child: TextField(
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              maxLength: 10,
                              style: Theme.of(context).textTheme.labelMedium,
                              decoration:InputDecoration(
                                  counterText:"",
                                  border: InputBorder.none,
                                  prefix: Text('    '),
                                  hintText: '이름 또는 날짜',
                                  hintStyle: Theme.of(context).textTheme.labelSmall),
                              onChanged: (value){
                                setState(() {
                                  searchText = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(  //저장목록
            //높이 = 스크린 높이 - 앱바 높이 - 바텀네비 높이 - 헤드라인 높이 - 헤드라인 밑줄 높이 - 검색창 버튼 높이 - 검색창 버튼 마진 높이 - 리스트뷰 마진 높이 - 임의 보정
            height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 44,
            width: style.UIButtonWidth + 38,
            margin: EdgeInsets.only(top: style.UIMarginTop, left:20),
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
              child: RawScrollbar(
                controller: scrollController,
                thumbColor: style.colorDarkGrey,
                thickness: 8,
                radius: Radius.circular(10),
                child: ListView.separated(//builder(//
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  itemCount:saveDataManager.mapRecentPerson.length,
                  itemBuilder: (context, i){
                    bool passVal = false;
                    if(searchText.isEmpty){
                      passVal = true;
                    }
                    else{
                      String data = "${saveDataManager.mapRecentPerson[i]['name']}(${saveDataManager.GetSelectedRecentBirthData('gender',i) == true?'남':'여'}) ${saveDataManager.GetSelectedRecentBirthData('birthYear',i)}년 ${saveDataManager.GetSelectedRecentBirthData('birthMonth', i)}월 ${saveDataManager.GetSelectedRecentBirthData('birthDay',i)}일 ${GetUemYangText(saveDataManager.GetSelectedRecentBirthData('uemYang', i))} ${GetBirthTimeText(saveDataManager.GetSelectedRecentBirthData('birthHour',i), saveDataManager.GetSelectedRecentBirthData('birthMin', i), false)}";
                      if(data.toLowerCase().contains(searchText.toLowerCase())){
                        passVal = true;
                      }
                    }
                    if(passVal == true){
                      return Container(
                        width: style.UIButtonWidth,
                        height: (style.saveDataNameLineHeight * 1.9) + style.saveDataMemoLineHeight,
                        child:Row(
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                context.read<Store>().SetPersonInquireInfo(saveDataManager.mapRecentPerson[i]['name'], saveDataManager.GetSelectedRecentBirthData('gender', i), saveDataManager.GetSelectedRecentBirthData('uemYang',i),
                                    saveDataManager.GetSelectedRecentBirthData('birthYear',i), saveDataManager.GetSelectedRecentBirthData('birthMonth',i),
                                    saveDataManager.GetSelectedRecentBirthData('birthDay',i), saveDataManager.GetSelectedRecentBirthData('birthHour',i), saveDataManager.GetSelectedRecentBirthData('birthMin',i), '', saveDataManager.mapRecentPerson[i]['saveDate']);
                              },
                              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                  foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                              child: Column(
                                children: [
                                  Container(
                                    width: style.UIButtonWidth * 0.9,
                                    height: style.saveDataNameLineHeight,
                                    padding: EdgeInsets.only(top:6),
                                    child: Row(
                                      children:
                                      GetPersonalNameText(i),
                                    ),
                                  ),
                                  Container(
                                    width: style.UIButtonWidth * 0.9,
                                    height: style.saveDataNameLineHeight,
                                    padding: EdgeInsets.only(top:4),
                                    child: Row(
                                      children:
                                      GetPersonalDataText(i),
                                    ),
                                  ),
                                  Container(
                                      width: style.UIButtonWidth * 0.9,
                                      height: style.saveDataNameLineHeight,
                                      //padding: EdgeInsets.only(top:4),
                                      child: Text(GetInquireDateText(saveDataManager.mapRecentPerson[i]['saveDate']), style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)
                                  ),
                              ],
                            ),
                          ),
                            Container(  //저장 버튼
                              width: style.UIButtonWidth * 0.1,
                              height: (style.saveDataNameLineHeight * 1.9) + style.saveDataMemoLineHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    print('save');
                                    bool isSamePerson = saveDataManager.SavePersonIsSameChecker(saveDataManager.mapRecentPerson[i]['name'], saveDataManager.GetSelectedRecentBirthData('gender', i) == true? '남':'여', saveDataManager.GetSelectedRecentBirthData('uemYang', i), saveDataManager.GetSelectedRecentBirthData('birthYear', i),
                                        saveDataManager.GetSelectedRecentBirthData('birthMonth', i), saveDataManager.GetSelectedRecentBirthData('birthDay', i), saveDataManager.GetSelectedRecentBirthData('birthHour', i), saveDataManager.GetSelectedRecentBirthData('birthMin', i), ShowSameCheckerMessage);
                                    if(isSamePerson == true){
                                      saveDataManager.SavePersonData2(saveDataManager.mapRecentPerson[i]['name'], saveDataManager.GetSelectedRecentBirthData('gender', i),
                                          saveDataManager.GetSelectedRecentBirthData('uemYang', i), saveDataManager.GetSelectedRecentBirthData('birthYear', i),
                                          saveDataManager.GetSelectedRecentBirthData('birthMonth', i), saveDataManager.GetSelectedRecentBirthData('birthDay', i),
                                          saveDataManager.GetSelectedRecentBirthData('birthHour', i), saveDataManager.GetSelectedRecentBirthData('birthMin', i));                                         ;}
                                  });
                                },
                                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                    foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                child: Icon(Icons.save, color:Colors.white),
                              ),
                            ),
                          ]
                        ),
                      );}
                    else{
                      return SizedBox.shrink();
                    }
                  },
                    separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1, height: 0, endIndent: 20, color: style.colorBlack,); }
                ),
              ),
            ),
          ),
        ),
      ],
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