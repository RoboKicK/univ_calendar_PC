import 'dart:ui';

import 'package:flutter/material.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import 'mainCalendarSaveListOption.dart' as mainCalendarSaveListOption;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class MainCalendarSaveList extends StatefulWidget {
  const MainCalendarSaveList({super.key, required this.SetInquireInfo, required this.SetCalendarResultWidget});

  final SetInquireInfo;
  final SetCalendarResultWidget;
  @override
  State<MainCalendarSaveList> createState() => _MainCalendarSaveListState();
}

class _MainCalendarSaveListState extends State<MainCalendarSaveList> with TickerProviderStateMixin{

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true;

  Widget mainCalendarSaveListOptionWidget = SizedBox.shrink();

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

    if(birthHour == -2){
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

  SetSaveListOptionWidget(bool onOff, int i){
    setState(() {
      if(onOff == false){
        mainCalendarSaveListOptionWidget = SizedBox.shrink();
      } else {
        mainCalendarSaveListOptionWidget = Container(
          width: style.UIButtonWidth + 30,
          height: MediaQuery.of(context).size.height - style.appBarHeight - style.headLineHeight - 4,
          color: style.colorBackGround,
          child: mainCalendarSaveListOption.MainCalendarSaveListOption(name0: saveDataManager.mapPersonSortedMark[i]['name'], gender0: saveDataManager.mapPersonSortedMark[i]['gender'], uemYang0: saveDataManager.mapPersonSortedMark[i]['uemYang'],
              birthYear0: saveDataManager.mapPersonSortedMark[i]['birthYear'], birthMonth0: saveDataManager.mapPersonSortedMark[i]['birthMonth'],
              birthDay0: saveDataManager.mapPersonSortedMark[i]['birthDay'], birthHour0: saveDataManager.mapPersonSortedMark[i]['birthHour'], birthMin0: saveDataManager.mapPersonSortedMark[i]['birthMin'],
              memo:saveDataManager.mapPersonSortedMark[i]['memo']??'', saveDate: saveDataManager.mapPersonSortedMark[i]['saveDate']??'', isMark: saveDataManager.mapPersonSortedMark[i]['mark']??false,
              saveDataNum: saveDataManager.mapPersonSortedMark[i]['num'], listIndex: i, SetInquireInfo: widget.SetInquireInfo, SetCalendarResultWidget: widget.SetCalendarResultWidget, closeOption: SetSaveListOptionWidget),
        );
      }
    });
  }

  List<Widget> GetPersonNameText(int num){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == false && isShowPersonalName == false){ //이름 숨김일 때
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("${saveDataManager.mapPersonSortedMark[num]['gender']?'남성':'여성'}", style: Theme.of(context).textTheme.titleLarge)));
    }
    else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("${GetNameText(saveDataManager.mapPersonSortedMark[num]['name'])}", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("(${saveDataManager.mapPersonSortedMark[num]['gender']?'남':'여'})", style: Theme.of(context).textTheme.titleLarge)));
    }

    return listPersonalTextData;
  }
  List<Widget> GetPersonBirthText(int num){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == true || isShowPersonalBirth == true){
      listPersonalTextData.add(
          Container(
              height: style.saveDataMemoLineHeight,
              child:Text("${saveDataManager.mapPersonSortedMark[num]['birthYear']}.${saveDataManager.mapPersonSortedMark[num]['birthMonth']}.${saveDataManager.mapPersonSortedMark[num]['birthDay']}", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataMemoLineHeight,
          child:Text("${GetUemYangText(saveDataManager.mapPersonSortedMark[num]['uemYang'])}",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataMemoLineHeight,
          child:Text(" ${GetBirthTimeText(saveDataManager.mapPersonSortedMark[num]['birthHour'], saveDataManager.mapPersonSortedMark[num]['birthMin'], true)}", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    } else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataMemoLineHeight,
              child:Text("****.**.** **:**",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    }

    return listPersonalTextData;
  }

  String searchText = '';

  @override
  void initState() {
    super.initState();

    if(((personalDataManager.etcData % 10000) / 1000).floor() == 3){
      isShowPersonalDataAll = false;
      int isShowPersonalDataNum = ((personalDataManager.etcData % 100000) / 10000).floor();
      if(isShowPersonalDataNum == 1 || isShowPersonalDataNum == 3 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 7){
        isShowPersonalName = false;
      }
      if(isShowPersonalDataNum == 4 || isShowPersonalDataNum == 5 || isShowPersonalDataNum == 6 || isShowPersonalDataNum == 7){
        isShowPersonalBirth = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
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
                          width: style.UIButtonWidth,// * 0.83,
                          decoration: BoxDecoration(
                            color: style.colorNavy,
                            borderRadius: BorderRadius.circular(style.textFiledRadius),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: style.UIButtonWidth,//MediaQuery.of(context).size.width * 0.4,
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
                                      hintText: '이름, 날짜 또는 메모',
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
                width: style.UIButtonWidth,
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height - style.appBarHeight - 16 - 50 - 44,
                margin: EdgeInsets.only(top: style.UIMarginTop),
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount:saveDataManager.mapPersonSortedMark.length,
                    itemBuilder: (context, i){
                      bool passVal = false;
                      //검색 조회
                      if(searchText.isEmpty){
                        passVal = true;
                      }
                      else{
                        String data = "${saveDataManager.mapPersonSortedMark[i]['name']}(${saveDataManager.mapPersonSortedMark[i]['gender']?'남':'여'}) ${saveDataManager.mapPersonSortedMark[i]['birthYear']}.${saveDataManager.mapPersonSortedMark[i]['birthMonth']}.${saveDataManager.mapPersonSortedMark[i]['birthDay']} ${GetUemYangText(saveDataManager.mapPersonSortedMark[i]['uemYang'])} ${GetBirthTimeText(saveDataManager.mapPersonSortedMark[i]['birthHour'], saveDataManager.mapPersonSortedMark[i]['birthMin'], false)}";
                        if(data.toLowerCase().contains(searchText.toLowerCase()) || saveDataManager.mapPersonSortedMark[i]['memo'].toLowerCase().contains(searchText.toLowerCase())){
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
                                    widget.SetInquireInfo(saveDataManager.mapPersonSortedMark[i]['name'], saveDataManager.mapPersonSortedMark[i]['gender'], saveDataManager.mapPersonSortedMark[i]['uemYang'],
                                        saveDataManager.mapPersonSortedMark[i]['birthYear'], saveDataManager.mapPersonSortedMark[i]['birthMonth'], saveDataManager.mapPersonSortedMark[i]['birthDay'],
                                        saveDataManager.mapPersonSortedMark[i]['birthHour'], saveDataManager.mapPersonSortedMark[i]['birthMin'], saveDataManager.mapPersonSortedMark[i]['memo'],
                                        saveDataManager.mapPersonSortedMark[i]['num']);
                                    widget.SetCalendarResultWidget();
                                },
                                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                    foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                child: Column(
                                  children: [
                                    Container(
                                      width: style.UIButtonWidth * 0.8,
                                      height: style.saveDataNameLineHeight,
                                      padding: EdgeInsets.only(top:6),
                                      //color:Colors.green,
                                      child:
                                      Row(
                                        children: GetPersonNameText(i),
                                      ),
                                    ),
                                    Container(
                                        width: style.UIButtonWidth * 0.8,
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
                              Container(  //즐겨찾기 버튼
                                width: style.UIButtonWidth * 0.1,
                                height: style.saveDataNameLineHeight + style.saveDataMemoLineHeight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      saveDataManager.SavePersonMark(saveDataManager.mapPersonSortedMark[i]['num']);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                      foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                  child: Icon(saveDataManager.mapPersonSortedMark[i]['mark']? Icons.check_circle : Icons.check_circle_outline, size:style.UIButtonWidth * 0.06, color:Colors.white),//Image.asset('assets/readingGlass.png', width: style.iconSize, height: style.iconSize),
                                ),
                              ),
                              Container(  //옵션 버튼
                                width: style.UIButtonWidth * 0.1,
                                height: style.saveDataNameLineHeight + style.saveDataMemoLineHeight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    SetSaveListOptionWidget(true, i);
                                  },
                                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                                      foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                                  child: Image.asset('assets/readingGlass.png', width: style.iconSize, height: style.iconSize),
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
                      separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1, height: 0, color: style.colorBlack,); }
                  ),
                ),
              ),
            ),
          ],
        ),
          mainCalendarSaveListOptionWidget,
        ]
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