import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:LuciaOneCalendar/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import 'mainCalendarSaveListOption.dart' as mainCalendarSaveListOption;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';
import '../../findGanji.dart' as findGanji;

class MainCalendarSaveList extends StatefulWidget {
  const MainCalendarSaveList({super.key, required this.setSideOptionLayerWidget, required this.setSideOptionWidget, required this.mapPersonLength, required this.refreshMapPersonLengthAndSort});

  final setSideOptionLayerWidget, setSideOptionWidget;
  final int mapPersonLength;
  final refreshMapPersonLengthAndSort;

  @override
  State<MainCalendarSaveList> createState() => _MainCalendarSaveListState();
}

class _MainCalendarSaveListState extends State<MainCalendarSaveList> with TickerProviderStateMixin{

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true, isShowPersonalOld = true;

  Widget mainCalendarSaveListOptionWidget = SizedBox.shrink();

  ScrollController scrollController = ScrollController();

  double sortContainerHeight = 0;

  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextFocusNode = FocusNode();

  int sortNum = 0;
  int koreanGanji = 0;

  String nowSortText = "저장 일자 ↑";

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
  String GetNameText(String text){
    String nameText = '';
    int textLengthLimit = 9;
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

  //SetSaveListOptionWidget(bool onOff, int i){
  //  setState(() {
  //    if(onOff == false){
  //      mainCalendarSaveListOptionWidget = SizedBox.shrink();
  //    } else {
  //      mainCalendarSaveListOptionWidget = Container(
  //        width: style.UIButtonWidth + 30,
  //        height: MediaQuery.of(context).size.height - style.appBarHeight - style.headLineHeight - 4,
  //        color: style.colorBackGround,
  //        child: mainCalendarSaveListOption.MainCalendarSaveListOption(name0: saveDataManager.mapPersonSortedMark[i]['name'], gender0: saveDataManager.mapPersonSortedMark[i]['gender'], uemYang0: saveDataManager.mapPersonSortedMark[i]['uemYang'],
  //            birthYear0: saveDataManager.mapPersonSortedMark[i]['birthYear'], birthMonth0: saveDataManager.mapPersonSortedMark[i]['birthMonth'],
  //            birthDay0: saveDataManager.mapPersonSortedMark[i]['birthDay'], birthHour0: saveDataManager.mapPersonSortedMark[i]['birthHour'], birthMin0: saveDataManager.mapPersonSortedMark[i]['birthMin'],
  //            memo:saveDataManager.mapPersonSortedMark[i]['memo']??'', saveDate: saveDataManager.mapPersonSortedMark[i]['saveDate']??'', isMark: saveDataManager.mapPersonSortedMark[i]['mark']??false,
  //            saveDataNum: saveDataManager.mapPersonSortedMark[i]['num'], listIndex: i, closeOption: SetSaveListOptionWidget),
  //      );
  //    }
  //  });
  //}

  Text GetIlganText(int ilganNum){
    var textColor = style.SetOhengColor(true, ilganNum);
    return Text("  ${style.stringCheongan[koreanGanji][ilganNum]}",
        //    style: Theme.of(context).textTheme.titleLarge);
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, height: 1.2));
  }
  Text GetIljiText(int iljiNum){
    var textColor = style.SetOhengColor(false, iljiNum);
    return Text(style.stringJiji[koreanGanji][iljiNum],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor, height: 1.2));
  }

  List<Widget> GetPersonNameAndGanjiText(int num){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == false && isShowPersonalName == false){ //이름 숨김일 때
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("${saveDataManager.GetSelectedBirthData('gender',num) == true?'남성':'여성'} ${GetOld(saveDataManager.GetSelectedBirthData('uemYang', num), saveDataManager.GetSelectedBirthData('birthYear', num), saveDataManager.GetSelectedBirthData('birthMonth', num), saveDataManager.GetSelectedBirthData('birthDay', num))}", style: Theme.of(context).textTheme.titleLarge)));
    }
    else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("${GetNameText(saveDataManager.mapPerson[num]['name'])}", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("(${saveDataManager.GetSelectedBirthData('gender', num) == true?'남':'여'}) ${GetOld(saveDataManager.GetSelectedBirthData('uemYang', num), saveDataManager.GetSelectedBirthData('birthYear', num), saveDataManager.GetSelectedBirthData('birthMonth', num), saveDataManager.GetSelectedBirthData('birthDay', num))}", style: Theme.of(context).textTheme.titleLarge)));
    }

    if(((personalDataManager.etcData % 10000000) / 1000000).floor() == 2){  //간지 보이기
      List<int> listPaljaData = [];
      if(saveDataManager.GetSelectedBirthData('uemYang', num) == 0) {
        listPaljaData = findGanji.InquireGanji(saveDataManager.GetSelectedBirthData('birthYear', num), saveDataManager.GetSelectedBirthData('birthMonth', num), saveDataManager.GetSelectedBirthData('birthDay', num), saveDataManager.GetSelectedBirthData('birthHour', num), saveDataManager.GetSelectedBirthData('birthMin', num));
      } else {
        List<int> listBirth = findGanji.LunarToSolar(saveDataManager.GetSelectedBirthData('birthYear', num), saveDataManager.GetSelectedBirthData('birthMonth', num), saveDataManager.GetSelectedBirthData('birthDay', num), saveDataManager.GetSelectedBirthData('uemYang', num) == 1? false:true);
        listPaljaData = findGanji.InquireGanji(listBirth[0], listBirth[1], listBirth[2], saveDataManager.GetSelectedBirthData('birthHour', num), saveDataManager.GetSelectedBirthData('birthMin', num));
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
  List<Widget> GetPersonBirthText(int num){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == true || isShowPersonalBirth == true){
      listPersonalTextData.add(
          Container(
              height: style.saveDataMemoLineHeight,
              child:Text("${saveDataManager.GetSelectedBirthData('birthYear',num)}년 ${saveDataManager.GetSelectedBirthData('birthMonth',num)}월 ${saveDataManager.GetSelectedBirthData('birthDay',num)}일", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataMemoLineHeight,
          child:Text("${GetUemYangText(saveDataManager.GetSelectedBirthData('uemYang',num))}",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataMemoLineHeight,
          child:Text(" ${GetBirthTimeText(saveDataManager.GetSelectedBirthData('birthHour',num), saveDataManager.GetSelectedBirthData('birthMin',num), true)}", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    } else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataMemoLineHeight,
              child:Text("****년 **월 **일 **:**",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
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

  SetSortContainerHeight(){
    setState(() {
      sortContainerHeight == 0? sortContainerHeight = style.fullSizeButtonHeight : sortContainerHeight = 0;
    });
  }

  SetNowSortText(){
    switch(sortNum){
      case 0: {
        nowSortText = "저장 일자 ↑";
      }
      case 1: {
        nowSortText = "저장 일자 ↓";
      }
      case 2: {
        nowSortText = "이름 ↑";
      }
      case 3: {
        nowSortText = "이름 ↓";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sortNum = saveDataManager.sortNumMapPerson;
    SetNowSortText();
    CheckPersonalDataHide();
  }

  @override
  Widget build(BuildContext context) {

    sortNum = saveDataManager.sortNumMapPerson;
    SetNowSortText();
    CheckPersonalDataHide();

    koreanGanji = ((personalDataManager.etcData%1000)/100).floor() - 1;

    return Column(
    mainAxisAlignment: MainAxisAlignment.start,
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
                    width: style.UIButtonWidth * 0.60,
                    decoration: BoxDecoration(
                      color: style.colorNavy,
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            //width: style.UIButtonWidth * 0.60,//MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            child: TextField(
                              enableSuggestions: false,
                              controller: searchTextController,
                              focusNode: searchTextFocusNode,
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              maxLength: 10,
                              style: Theme.of(context).textTheme.labelMedium,
                              decoration:InputDecoration(
                                  counterText:"",
                                  border: InputBorder.none,
                                  prefix: Text('    '),
                                  hintText: '이름, 날짜 또는 메모',
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
                Container(
                  height: style.fullSizeButtonHeight,
                  width: style.UIButtonWidth * 0.35,
                  margin: EdgeInsets.only(left: style.UIButtonWidth * 0.05),
                  decoration: BoxDecoration(
                    color: style.colorNavy,
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: (){
                      SetSortContainerHeight();
                    },
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                          foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                      child: Text(nowSortText, style: sortContainerHeight == 0? Theme.of(context).textTheme.labelSmall : Theme.of(context).textTheme.labelMedium)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Stack(
        children: [
          AnimatedOpacity(
            opacity: sortContainerHeight == 0 ? 0.0 : 1.0,
            duration: Duration(milliseconds: 130),
            child: Container(
                width: style.UIButtonWidth,
                height: style.fullSizeButtonHeight,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left:20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width:2, color:style.colorBlack)),
                  boxShadow: [
                    BoxShadow(
                      color: style.colorBackGround,
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                //color:Colors.green,
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      alignment: Alignment.centerLeft,
                      //color:Colors.red,
                      child: ElevatedButton(
                        onPressed: (){
                          sortNum = 0;
                          saveDataManager.SortMapPerson(sortNum);
                          SetSortContainerHeight();
                          SetNowSortText();
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Text('저장 일자 ↑', style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ),
                    Container(
                      width: 90,
                      alignment: Alignment.centerLeft,
                      //color:Colors.yellow,
                      child: ElevatedButton(
                        onPressed: (){
                          sortNum = 1;
                          saveDataManager.SortMapPerson(sortNum);
                          SetSortContainerHeight();
                          SetNowSortText();
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Text('저장 일자 ↓', style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ),
                    Container(
                      width: 55,
                      //color:Colors.green,
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: (){
                          sortNum = 2;
                          saveDataManager.SortMapPerson(sortNum);
                          SetSortContainerHeight();
                          SetNowSortText();
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Text('이름 ↑    ', style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ),
                    Container(
                      width: 55,
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: (){
                          sortNum = 3;
                          saveDataManager.SortMapPerson(sortNum);
                          SetSortContainerHeight();
                          SetNowSortText();
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                            foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                        child: Text('이름 ↓    ', style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ),
                  ],
                )
            ),
          ),
          Column(
            children: [
              AnimatedContainer(  //정렬 열림 박스
                duration: Duration(milliseconds: 170),
                width: style.UIButtonWidth,
                height: sortContainerHeight,
                curve: Curves.fastOutSlowIn,
              ),
              Stack(
                children: [
                  Container(  //저장목록
                  width: style.UIButtonWidth + 38,
                  //alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 44 - sortContainerHeight - 36,
                  margin: EdgeInsets.only(top: style.UIMarginTop, left:20), //,
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                    child: RawScrollbar(
                      controller: scrollController,
                      thumbColor: style.colorDarkGrey,
                      thickness: 10,
                      radius: Radius.circular(10),
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          itemCount:saveDataManager.mapPerson.length,
                          itemBuilder: (context, i){
                            bool passVal = false;
                            //검색 조회
                            if(searchTextController.text == ''){
                              passVal = true;
                            }
                            else{
                              String data = "${saveDataManager.mapPerson[i]['name']}(${saveDataManager.GetSelectedBirthData('gender',i) == true?'남':'여'}) ${saveDataManager.GetSelectedBirthData('birthYear',i)}년 ${saveDataManager.GetSelectedBirthData('birthMonth', i)}월 ${saveDataManager.GetSelectedBirthData('birthDay',i)}일 ${GetUemYangText(saveDataManager.GetSelectedBirthData('uemYang', i))} ${GetBirthTimeText(saveDataManager.GetSelectedBirthData('birthHour',i), saveDataManager.GetSelectedBirthData('birthMin', i), false)}";
                              if(data.toLowerCase().contains(searchTextController.text.toLowerCase()) || saveDataManager.mapPerson[i]['memo'].toLowerCase().contains(searchTextController.text.toLowerCase())){
                                passVal = true;
                              }
                            }
                            //리스트뷰
                            if(passVal == true){
                              return Container(
                                width: style.UIButtonWidth,
                                height: style.saveDataNameLineHeight + style.saveDataMemoLineHeight,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        context.read<Store>().SetPersonInquireInfo(saveDataManager.mapPerson[i]['name'], saveDataManager.GetSelectedBirthData('gender', i), saveDataManager.GetSelectedBirthData('uemYang',i),
                                            saveDataManager.GetSelectedBirthData('birthYear',i), saveDataManager.GetSelectedBirthData('birthMonth',i),
                                            saveDataManager.GetSelectedBirthData('birthDay',i), saveDataManager.GetSelectedBirthData('birthHour',i), saveDataManager.GetSelectedBirthData('birthMin',i),
                                            saveDataManager.mapPerson[i]['memo']??'', saveDataManager.mapPerson[i]['saveDate']);
                                      },
                                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                          foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: style.UIButtonWidth * 0.9,
                                            height: style.saveDataNameLineHeight,
                                            padding: EdgeInsets.only(top:6),
                                            //color:Colors.green,
                                            child:
                                            Row(
                                              children: GetPersonNameAndGanjiText(i),
                                            ),
                                          ),
                                          Container(
                                            width: style.UIButtonWidth * 0.9,
                                            height: style.saveDataMemoLineHeight,
                                            padding: EdgeInsets.only(top:4),
                                            //color:Colors.yellow,
                                            child: Row(
                                              children: GetPersonBirthText(i),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(  //옵션 버튼
                                      width: style.UIButtonWidth * 0.1,
                                      height: style.UIButtonWidth * 0.1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          widget.setSideOptionLayerWidget(true);
                                          //widget.setSideOptionWidget(SetSaveListOptionWidget(true, i));
                                          widget.setSideOptionWidget(Container(
                                            width: style.UIButtonWidth + 30,
                                            height: MediaQuery.of(context).size.height - style.appBarHeight,
                                            child: mainCalendarSaveListOption.MainCalendarSaveListOption(name0: saveDataManager.mapPerson[i]['name'], gender0: saveDataManager.GetSelectedBirthData('gender', i), uemYang0: saveDataManager.GetSelectedBirthData('uemYang',i),
                                                birthYear0: saveDataManager.GetSelectedBirthData('birthYear',i), birthMonth0: saveDataManager.GetSelectedBirthData('birthMonth',i),
                                                birthDay0: saveDataManager.GetSelectedBirthData('birthDay',i), birthHour0: saveDataManager.GetSelectedBirthData('birthHour',i), birthMin0: saveDataManager.GetSelectedBirthData('birthMin',i),
                                                memo:saveDataManager.mapPerson[i]['memo']??'', saveDate: saveDataManager.mapPerson[i]['saveDate']??DateTime.now(),
                                                closeOption: widget.setSideOptionLayerWidget, refreshMapPersonLengthAndSort: widget.refreshMapPersonLengthAndSort, key:UniqueKey()),
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                            overlayColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.textFiledRadius))),
                                        child: SvgPicture.asset('assets/info_icon.svg', width: style.appbarIconSize, height: style.appbarIconSize),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            else{
                              return SizedBox.shrink();
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1, height: 0, endIndent:20, color: style.colorBlack,); }
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
            ],
          ),
        ],
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