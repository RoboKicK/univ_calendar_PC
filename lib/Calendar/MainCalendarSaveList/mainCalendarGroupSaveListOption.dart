import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_calendar_pc/main.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../findGanji.dart' as findGanji;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';

class MainCalendarGroupSaveListOption extends StatefulWidget {
  const MainCalendarGroupSaveListOption({super.key, required this.listMapGroup, required this.refreshListMapGroupLength, required this.closeOption});

  final List<dynamic> listMapGroup;

  final refreshListMapGroupLength;

  final closeOption;

  @override
  State<MainCalendarGroupSaveListOption> createState() => _MainCalendarGroupSaveListOptionState();
}

class _MainCalendarGroupSaveListOptionState extends State<MainCalendarGroupSaveListOption> {

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
  String GetBirthTimeText(int birthHour, int birthMin){
    String birthTimeText = '';

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
        birthTimeText = birthTimeText + ':0${birthMin}';
      }
      else {
        birthTimeText = birthTimeText + ':${birthMin}';
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

  TextEditingController memoController = TextEditingController();

  String groupName = '';
  late DateTime saveDate;

  String prefixMemo = '';
  String editingMemo = '';

  double categoryMargin = 6;

  int isEditingMemo = 0;
  int buttonMode = 0;

  late FocusNode memoFocusNode;

  SetMemo(String memo){
    editingMemo = memo;
  }

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true;

  ShowDialogMessage(String message){
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      //barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  SetEditingMemo(){ //메모 시작과 저장할 때
    if(isEditingMemo == 0){ //메모 시작
      editingMemo = prefixMemo;
      memoController.text = editingMemo;
      isEditingMemo = 1;
      buttonMode = 1;
    }
    else{ //메모 저장 후 종료
      saveDataManager.SaveListMapGroupDataMemo(groupName, saveDate, editingMemo);
      prefixMemo = editingMemo;
      editingMemo = '';
      isEditingMemo = 0;
      buttonMode = 0;
      widget.refreshListMapGroupLength();
    }
  }

  String GetFirstLineText(String text){
    String firstLineText = '';
    int textLengthLimit = 29;
    for(int i = 0; i < text.length; i++){
      if(text.substring(i, i+1) == '\n'){
        break;
      }
      if(i+1 > text.length){
        break;
      }
      if(i > textLengthLimit){
        firstLineText = firstLineText+'..';
        break;
      }
      firstLineText = firstLineText + text.substring(i, i+1);
    }
    return firstLineText;
  }

  List<Widget> GetPersonNameText(String name, int birthData){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == false && isShowPersonalName == false){ //이름 숨김일 때
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("${saveDataManager.GetSelectedDataFromBirthData('gender', birthData) == 1 ? '남성' : '여성'}", style: Theme.of(context).textTheme.titleLarge)));
    }
    else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("${GetNameText(name)}", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("(${saveDataManager.GetSelectedDataFromBirthData('gender', birthData) == 1 ?'남':'여'})", style: Theme.of(context).textTheme.titleLarge)));
    }

    return listPersonalTextData;
  }
  List<Widget> GetPersonBirthText(int birthData){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == true || isShowPersonalBirth == true){
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("${saveDataManager.GetSelectedDataFromBirthData('birthYear', birthData)}년 ${saveDataManager.GetSelectedDataFromBirthData('birthMonth', birthData)}월 ${saveDataManager.GetSelectedDataFromBirthData('birthDay', birthData)}일", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataNameTextLineHeight + 4,
          child:Text("(${saveDataManager.GetSelectedDataFromBirthData('uemYangText', birthData)})",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
      listPersonalTextData.add(Container(
          height: style.saveDataNameTextLineHeight + 4,
          child:Text(" ${GetBirthTimeText(saveDataManager.GetSelectedDataFromBirthData('birthHour', birthData), saveDataManager.GetSelectedDataFromBirthData('birthMin', birthData))}", style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    } else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight,
              child:Text("****.**.** **:**",  style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis)));
    }

    return listPersonalTextData;
  }

  FocusNode maleFocusNode = FocusNode();
  FocusNode femaleFocusNode = FocusNode();
  FocusNode birthTextFocusNode = FocusNode();
  FocusNode birthHourTextFocusNode = FocusNode();

  GetPersonText(){
    List<List<Widget>> listPersonWidget = [];

    for(int i = 1; i < widget.listMapGroup.length; i++){

      listPersonWidget.add(GetPersonNameText(widget.listMapGroup[i]['name'], widget.listMapGroup[i]['birthData']));
      listPersonWidget.add(GetPersonBirthText(widget.listMapGroup[i]['birthData']));

      //List<Widget> personNameWidget = GetPersonNameText(widget.listMapGroup[i]['name'], widget.listMapGroup[i]['birthData']);
      //for(int j = 0; j < personNameWidget.length; j++){
      //  listPersonWidget.add(personNameWidget[j]);
      //}
      //List<Widget> personBirthWidget = GetPersonBirthText(widget.listMapGroup[i]['birthData']);
      //for(int j = 0; j < personBirthWidget.length; j++){
      //  listPersonWidget.add(personBirthWidget[j]);
      //}
    }

    return Container( //저장일자 정보
      width: style.UIButtonWidth,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top:6),
      child: ListView.builder(
        itemCount: listPersonWidget.length,
        shrinkWrap: true,
        itemBuilder: (context, i){
          return Row(
              children:listPersonWidget[i]
          );
        },
      )
    );
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

  @override
  void initState() {
    super.initState();

    memoFocusNode = FocusNode();

    groupName = widget.listMapGroup[0]['groupName'];
    saveDate = widget.listMapGroup[0]['saveDate'];

    prefixMemo = widget.listMapGroup[0]['memo'];

    CheckPersonalDataHide();
  }

  @override
  void didChangeDependencies(){

    super.didChangeDependencies();
  }

  @override
  void deactivate(){
    super.deactivate();

    if(isEditingMemo == 1){
      SetEditingMemo();
    }
  }

  @override
  Widget build(BuildContext context) {

    CheckPersonalDataHide();

    return Container(
      width: style.UIButtonWidth + 30,
      margin: EdgeInsets.only(top:style.UIMarginTop, bottom: style.UIMarginTop),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(  //그룹 이름
                width: style.UIButtonWidth * 0.9,
                height: style.saveDataNameLineHeight,
                child: Text(groupName, style: Theme.of(context).textTheme.titleLarge),
              ),
              Container(  //닫기 버튼
                width: style.UIButtonWidth * 0.1,
                height: style.saveDataNameLineHeight + 22,
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.closeOption(false);
                    });
                  },
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.only(top:20), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                      foregroundColor: style.colorBackGround, surfaceTintColor: Colors.transparent),
                  child: Icon(Icons.close, color:Colors.white, size: style.UIButtonWidth * 0.06),
                ),
              ),
            ],
          ),
          Expanded( //
            child: Column(
              children:[
                GetPersonText(),  //이름
                Container(  //저장일자 제목
                  width: style.UIButtonWidth,
                  height: style.saveDataNameLineHeight,
                  margin: EdgeInsets.only(top: categoryMargin + 10),
                  padding: EdgeInsets.only(top:6),
                  child: Text("저장일자", style: Theme.of(context).textTheme.titleLarge),
                ),
                Container( //저장일자 정보
                  width: style.UIButtonWidth,
                  height: style.saveDataMemoLineHeight,
                  child:Text("${saveDate.year}년 ${saveDate.month}월 ${saveDate.day}일", style: Theme.of(context).textTheme.displayMedium),//Theme.of(context).textTheme.displayMedium),
                ),
                //Container(  //이름
                //  width: style.UIButtonWidth,
                //  child:GetPersonText(),
                //),
                Container(  //메모 제목
                  width: style.UIButtonWidth,
                  height: style.saveDataNameLineHeight,
                  margin: EdgeInsets.only(top: categoryMargin),
                  padding: EdgeInsets.only(top:6),
                  child: Text("메모", style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: [
                        Container( //메모 본문
                          width: style.UIButtonWidth,
                          alignment: Alignment.topLeft,
                          child:Text(prefixMemo, style: Theme.of(context).textTheme.displayMedium),//Theme.of(context).textTheme.displayMedium),
                        ),
                        Container( //메모 본문 수정
                          width: style.UIButtonWidth,
                          height: 1000,
                          color: style.colorNavy,
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: TextField(
                              autofocus: true,
                              controller: memoController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              focusNode: memoFocusNode,
                              onTapOutside: (event) {
                                memoFocusNode.requestFocus();
                              },
                              style: Theme.of(context).textTheme.displayMedium,
                              decoration:InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.only(top: 5),
                                counterText:"",
                                border: InputBorder.none,),
                              onChanged: (text){
                                setState(() {
                                  editingMemo = text;
                                });
                              },
                            ),
                          ),
                        ),
                      ][isEditingMemo],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column( //옵션 버튼들
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              [
                Column(
                  children: [
                    Row(  //수정 삭제 버튼
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(  //메모 버튼
                          width: style.UIButtonWidth * 0.49,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(top:style.UIMarginTop),
                          child:ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  SetEditingMemo();
                                });
                              },
                              style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorNavy, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                              child: Text('메모', style: Theme.of(context).textTheme.headlineSmall)
                          ),
                        ),
                        Container(  //여백
                          width: style.UIButtonWidth * 0.02,
                        ),
                        Container(  //삭제 버튼
                          width: style.UIButtonWidth * 0.49,
                          height: style.fullSizeButtonHeight,
                          margin: EdgeInsets.only(top:style.UIMarginTop),
                          child:ElevatedButton(
                              onPressed: (){
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("그룹을 삭제합니다", textAlign: TextAlign.center),
                                      actionsAlignment: MainAxisAlignment.center,
                                      actions:[
                                        ElevatedButton(
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                                            onPressed: () async {
                                              await saveDataManager.DeleteGroupData(groupName, saveDate);
                                              setState(() {
                                                print(saveDataManager.fileDirPath);
                                              });
                                              widget.closeOption(false);//widget.closeOption(false,0);
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('네')),
                                        ElevatedButton(
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('취소')),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorNavy, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                              child: Text('삭제', style: Theme.of(context).textTheme.headlineSmall)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(  //메모 저장 버튼
                  width: style.UIButtonWidth,
                  height: style.fullSizeButtonHeight,
                  margin: EdgeInsets.only(top:style.UIButtonWidth*0.02),
                  child:ElevatedButton(
                      onPressed: (){
                        setState(() {
                          SetEditingMemo();
                        });
                      },
                      style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorMainBlue, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                      child: Text('메모 저장', style: Theme.of(context).textTheme.headlineSmall)
                  ),
                ),
              ][buttonMode]
            ],
          ),
        ],
      ),
    );
  }
}

class BirthSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue){

    String newText = '';

    if(newValue.selection.baseOffset == 4 || newValue.selection.baseOffset == 7){
      if(newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length-1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length)
      );
    }

    return newValue;
  }
}

class HourSpacer extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue){

    String newText = '';

    if(newValue.selection.baseOffset == 2){
      if(newValue.text.length > oldValue.text.length)
        newText = newValue.text + ' ';
      else
        newText = newValue.text.substring(0, newValue.text.length-1);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length)
      );
    }

    return newValue;
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