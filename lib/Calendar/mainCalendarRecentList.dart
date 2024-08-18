import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:LuciaOneCalendar/main.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';
import '../findGanji.dart' as findGanji;

class MainCalendarRecentList extends StatefulWidget {
  const MainCalendarRecentList({super.key});

  @override
  State<MainCalendarRecentList> createState() => _MainCalendarRecentListState();
}

class _MainCalendarRecentListState extends State<MainCalendarRecentList> {

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true, isShowPersonalOld = true;

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
    int textLengthLimit = 10;
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
  String GetOld(int uemYang, int birthYear, int birthMonth, int birthDay) {
    if(((personalDataManager.etcData % 10000) / 1000).floor() == 3){  //인적사항 숨김
      if(isShowPersonalOld == false){
        return '';
      }
    }
    if(uemYang != 0){
      birthYear = findGanji.LunarToSolar(birthYear, birthMonth, birthDay, uemYang == 1? false:true)[0];//listSolBirth[0];
    }
    int old = DateTime.now().year - birthYear + 1;//widget.birthYear + 1;
    if((personalDataManager.etcData % 10) == 2){ //만으로 표시
      old--;
      if(DateTime.now().month < birthMonth || (DateTime.now().month == birthMonth && DateTime.now().day < birthDay)){
        old--;
      }
      if (old >= 0) {
        return '${old}세(만 나이)';
      }
    } else {
      if (old > 0) {
        return '${old}세';
      }
    }
    return '';
  }

  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextFocusNode = FocusNode();

  int koreanGanji = 0;

  ScrollController scrollController = ScrollController();

  List<Map> mapRecentPerson = [];

  Text GetIlganText(int ilganNum){
    var textColor = style.SetOhengColor(true, ilganNum);
    return Text('  ${style.stringCheongan[koreanGanji][ilganNum]}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, height: 1.2));
  }
  Text GetIljiText(int iljiNum){
    var textColor = style.SetOhengColor(false, iljiNum);
    return Text(style.stringJiji[koreanGanji][iljiNum],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, height: 1.2));
  }

  List<Widget> GetPersonNameAndGanjiText(int num){
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
              child:Text("(${saveDataManager.GetSelectedRecentBirthData('gender',num)?'남':'여'}) ${GetOld(saveDataManager.GetSelectedRecentBirthData('uemYang', num), saveDataManager.GetSelectedRecentBirthData('birthYear', num), saveDataManager.GetSelectedRecentBirthData('birthMonth', num), saveDataManager.GetSelectedRecentBirthData('birthDay', num))}", style: Theme.of(context).textTheme.titleLarge)));
    } else {
       listPersonalTextData.add(Text("${saveDataManager.GetSelectedRecentBirthData('gender',num)?'남성':'여성'} ${GetOld(saveDataManager.GetSelectedRecentBirthData('uemYang', num), saveDataManager.GetSelectedRecentBirthData('birthYear', num), saveDataManager.GetSelectedRecentBirthData('birthMonth', num), saveDataManager.GetSelectedRecentBirthData('birthDay', num))}", style: Theme.of(context).textTheme.titleLarge));
    }
    if(((personalDataManager.etcData % 10000000) / 1000000).floor() == 2){
      List<int> listPaljaData = [];
      if(saveDataManager.GetSelectedRecentBirthData('uemYang', num) == 0) {
        listPaljaData = findGanji.InquireGanji(saveDataManager.GetSelectedRecentBirthData('birthYear', num), saveDataManager.GetSelectedRecentBirthData('birthMonth', num), saveDataManager.GetSelectedRecentBirthData('birthDay', num), saveDataManager.GetSelectedRecentBirthData('birthHour', num), saveDataManager.GetSelectedRecentBirthData('birthMin', num));
      } else {
        List<int> listBirth = findGanji.LunarToSolar(saveDataManager.GetSelectedRecentBirthData('birthYear', num), saveDataManager.GetSelectedRecentBirthData('birthMonth', num), saveDataManager.GetSelectedRecentBirthData('birthDay', num), saveDataManager.GetSelectedRecentBirthData('uemYang', num) == 1? false:true);
        listPaljaData = findGanji.InquireGanji(listBirth[0], listBirth[1], listBirth[2], saveDataManager.GetSelectedRecentBirthData('birthHour', num), saveDataManager.GetSelectedRecentBirthData('birthMin', num));
      }
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight+4,
              child:GetIlganText(listPaljaData[4])));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight+4,
              child:GetIljiText(listPaljaData[5])));
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

    int personalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();

    if(personalDataNum == 2 || personalDataNum == 3 || personalDataNum == 6 || personalDataNum == 7){
      isShowPersonalOld = false;
    }else {isShowPersonalOld = true;}
  }

  ShowSameCheckerMessage(String birth, String name, bool gender, int uemYangType, int birthYear, int birthMonth, int birthDay, int birthHour, int birthMin){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('같은 ${style.myeongsicString}이 저장되어 있습니다\n그래도 저장하시겠습니까?', textAlign: TextAlign.center),
          content: Text(birth, textAlign: TextAlign.center),
          buttonPadding: EdgeInsets.only(left:20, right:20, top:0),
          actions: [
            ElevatedButton(
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                onPressed: (){
                  saveDataManager.SavePersonData2(name, gender, uemYangType, birthYear, birthMonth, birthDay, birthHour, birthMin, DateTime.now(), '');

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

    koreanGanji = ((personalDataManager.etcData%1000)/100).floor() - 1;

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
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              //width: style.UIButtonWidth,
                              height: 50,
                              child: TextField(
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: searchTextController,
                                focusNode: searchTextFocusNode,
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
                                    searchTextController.text;
                                  });
                                },
                              ),
                            ),
                          ),
                          AnimatedCrossFade(
                            duration: Duration(milliseconds: 130),
                            firstChild: SizedBox(width:40, height:20,),
                            secondChild:  Container(
                              width:40,
                              height:20,
                              child: IconButton(
                                icon: Icon(Icons.cancel, color: style.colorGrey, size: 20,),
                                style: ElevatedButton.styleFrom(visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity), backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, overlayColor: Colors.transparent),
                                onPressed: (){
                                  setState(() {
                                    searchTextController.text = '';
                                    FocusScope.of(context).requestFocus(searchTextFocusNode);
                                  });
                                },
                              ),
                            ),
                            crossFadeState: searchTextController.text.length == 0? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            firstCurve: Curves.easeIn,
                            secondCurve: Curves.easeIn,
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
          child: Stack(
            children: [
            Container(
              //저장목록
              //높이 = 스크린 높이 - 앱바 높이 - 바텀네비 높이 - 헤드라인 높이 - 헤드라인 밑줄 높이 - 검색창 버튼 높이 - 검색창 버튼 마진 높이 - 리스트뷰 마진 높이 - 임의 보정
              //height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 44,
              width: style.UIButtonWidth + 38,
              margin: EdgeInsets.only(top: style.UIMarginTop, left:20),
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                child: RawScrollbar(
                  controller: scrollController,
                  thumbColor: style.colorDarkGrey,
                  thickness: 10,
                  radius: Radius.circular(10),
                  child: ListView.separated(//builder(//
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    itemCount:saveDataManager.mapRecentPerson.length,
                    itemBuilder: (context, i){
                      bool passVal = false;
                      if(searchTextController.text == ''){
                        passVal = true;
                      }
                      else{
                        String data = "${saveDataManager.mapRecentPerson[i]['name']}(${saveDataManager.GetSelectedRecentBirthData('gender',i) == true?'남':'여'}) ${saveDataManager.GetSelectedRecentBirthData('birthYear',i)}년 ${saveDataManager.GetSelectedRecentBirthData('birthMonth', i)}월 ${saveDataManager.GetSelectedRecentBirthData('birthDay',i)}일 ${GetUemYangText(saveDataManager.GetSelectedRecentBirthData('uemYang', i))} ${GetBirthTimeText(saveDataManager.GetSelectedRecentBirthData('birthHour',i), saveDataManager.GetSelectedRecentBirthData('birthMin', i), false)}";
                        if(data.toLowerCase().contains(searchTextController.text.toLowerCase())){
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
                                      saveDataManager.GetSelectedRecentBirthData('birthDay',i), saveDataManager.GetSelectedRecentBirthData('birthHour',i), saveDataManager.GetSelectedRecentBirthData('birthMin',i), '', DateTime.utc(3000));
                                },
                                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                    foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                child: Column(
                                  children: [
                                    Container(
                                      width: style.UIButtonWidth * 0.8,
                                      height: style.saveDataNameLineHeight,
                                      padding: EdgeInsets.only(top:6),
                                      child: Row(
                                        children:
                                        GetPersonNameAndGanjiText(i),
                                      ),
                                    ),
                                    Container(
                                      width: style.UIButtonWidth * 0.8,
                                      height: style.saveDataNameLineHeight,
                                      padding: EdgeInsets.only(top:4),
                                      child: Row(
                                        children:
                                        GetPersonalDataText(i),
                                      ),
                                    ),
                                    Container(
                                        width: style.UIButtonWidth * 0.8,
                                        height: style.saveDataNameLineHeight,
                                        //padding: EdgeInsets.only(top:4),
                                        child: Text(GetInquireDateText(saveDataManager.mapRecentPerson[i]['saveDate']), style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)
                                    ),
                                ],
                              ),
                            ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(  //저장 버튼
                                        width: style.UIButtonWidth * 0.1,
                                        height: ((style.saveDataNameLineHeight * 1.9) + style.saveDataMemoLineHeight) * 0.33333,
                                        alignment: Alignment.topCenter,
                                        padding: EdgeInsets.only(top: 6),
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
                                                    saveDataManager.GetSelectedRecentBirthData('birthHour', i), saveDataManager.GetSelectedRecentBirthData('birthMin', i), DateTime.now(), '');                                         ;}
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                              overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                                          child: Icon(Icons.save, color:Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: style.UIButtonWidth * 0.1,
                                        height: ((style.saveDataNameLineHeight * 1.9) + style.saveDataMemoLineHeight) * 0.66666,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(  //지우기 버튼
                                        width: style.UIButtonWidth * 0.1,
                                        height: ((style.saveDataNameLineHeight * 1.9) + style.saveDataMemoLineHeight) * 0.33333,
                                        alignment: Alignment.topCenter,
                                        padding: EdgeInsets.only(top: 6),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              saveDataManager.DeleteRecentPersonData(i);
                                              mapRecentPerson = saveDataManager.mapRecentPerson;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                              foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                          child: Icon(Icons.close, color:Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: style.UIButtonWidth * 0.1,
                                        height: ((style.saveDataNameLineHeight * 1.9) + style.saveDataMemoLineHeight) * 0.66666,
                                      )
                                    ],
                                  ),
                                ],
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
              Container(
                width: style.UIButtonWidth + 18,
                height: 2,
                margin: EdgeInsets.only(top: style.UIMarginTop),//style.UIMarginLeft
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: style.colorBackGround.withOpacity(0.9),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: Offset(0, -2), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ]
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