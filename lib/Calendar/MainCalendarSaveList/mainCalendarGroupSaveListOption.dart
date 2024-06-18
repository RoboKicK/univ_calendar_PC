import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_calendar_pc/main.dart';
import '../../style.dart' as style;
import '../../../SaveData/saveDataManager.dart' as saveDataManager;
import '../../findGanji.dart' as findGanji;
import '../../Settings/personalDataManager.dart' as personalDataManager;
import 'package:provider/provider.dart';
import '../../findGanji.dart' as findGanji;

class MainCalendarGroupSaveListOption extends StatefulWidget {
  const MainCalendarGroupSaveListOption({super.key, required this.listMapGroup, required this.refreshListMapGroupLength, required this.closeOption, required this.refreshGroupName,
    required this.isMemoOpen, required this.saveGroupTempMemo});

  final List<dynamic> listMapGroup;

  final refreshListMapGroupLength;

  final closeOption;
  final refreshGroupName;

  final bool isMemoOpen;
  final saveGroupTempMemo;

  @override
  State<MainCalendarGroupSaveListOption> createState() => _MainCalendarGroupSaveListOptionState();
}

class _MainCalendarGroupSaveListOptionState extends State<MainCalendarGroupSaveListOption> {

  List<dynamic> listMapGroup = [];

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
  TextEditingController groupNameController = TextEditingController();

  String groupName = '';
  late DateTime saveDate;

  String prefixMemo = '';
  String editingMemo = '';

  double categoryMargin = 6;

  int isEditingMemo = 0;
  int buttonMode = 0;

  late FocusNode memoFocusNode;

  bool isEditWorldGroupName = false;
  bool isEditWorldGroupPersonCount = false;

  SetMemo(String memo){
    editingMemo = memo;
  }

  bool isShowPersonalDataAll = true, isShowPersonalName = true, isShowPersonalBirth = true, isShowPersonalOld = true;

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
      if(saveDate != DateTime.utc(3000)) {
        saveDataManager.SaveListMapGroupDataMemo(groupName, saveDate, editingMemo);
        widget.refreshListMapGroupLength();
      }
      prefixMemo = editingMemo;
      editingMemo = '';
      isEditingMemo = 0;
      buttonMode = 0;
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
  String GetSaveDateText(DateTime saveDate){
    return "${saveDate.year}년 ${saveDate.month}월 ${saveDate.day}일";
  }

  List<Widget> GetPersonNameText(String name, int birthData){
    List<Widget> listPersonalTextData = [];
    if(isShowPersonalDataAll == false && isShowPersonalName == false){ //이름 숨김일 때
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("${saveDataManager.GetSelectedDataFromBirthData('gender', birthData) == 1 ? '남성' : '여성'} ${GetOld(saveDataManager.GetSelectedDataFromBirthData('uemYang', birthData), saveDataManager.GetSelectedDataFromBirthData('birthYear', birthData), saveDataManager.GetSelectedDataFromBirthData('birthMonth', birthData), saveDataManager.GetSelectedDataFromBirthData('birthDay', birthData))}", style: Theme.of(context).textTheme.titleLarge)));
    }
    else {
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("${GetNameText(name)}", style: Theme.of(context).textTheme.titleLarge)));
      listPersonalTextData.add(
          Container(
              height: style.saveDataNameTextLineHeight + 4,
              child:Text("(${saveDataManager.GetSelectedDataFromBirthData('gender', birthData) == 1 ?'남':'여'}) ${GetOld(saveDataManager.GetSelectedDataFromBirthData('uemYang', birthData), saveDataManager.GetSelectedDataFromBirthData('birthYear', birthData), saveDataManager.GetSelectedDataFromBirthData('birthMonth', birthData), saveDataManager.GetSelectedDataFromBirthData('birthDay', birthData))}", style: Theme.of(context).textTheme.titleLarge)));
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

    for (int i = 1; i < listMapGroup.length; i++) {
      listPersonWidget.add(GetPersonNameText(listMapGroup[i]['name'], listMapGroup[i]['birthData']));
      listPersonWidget.add(GetPersonBirthText(listMapGroup[i]['birthData']));
    }

    List<Widget> listPersonWidget0 = [];

    for (int i = 1; i < listMapGroup.length; i++) {
      listPersonWidget0.add(Container(
        height: (style.saveDataNameTextLineHeight + 4) * 2,
        child: ElevatedButton(
          onPressed: () {
            context.read<Store>().SetPersonInquireInfo(
                listMapGroup[i]['name'],
                saveDataManager.GetSelectedDataFromBirthData('gender', listMapGroup[i]['birthData']),
                saveDataManager.GetSelectedDataFromBirthData('uemYang', listMapGroup[i]['birthData']),
                saveDataManager.GetSelectedDataFromBirthData('birthYear', listMapGroup[i]['birthData']),
                saveDataManager.GetSelectedDataFromBirthData('birthMonth', listMapGroup[i]['birthData']),
                saveDataManager.GetSelectedDataFromBirthData('birthDay', listMapGroup[i]['birthData']),
                saveDataManager.GetSelectedDataFromBirthData('birthHour', listMapGroup[i]['birthData']),
                saveDataManager.GetSelectedDataFromBirthData('birthMin', listMapGroup[i]['birthData']),
                widget.listMapGroup[i]['memo'] ?? '',
                DateTime.utc(3000));
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              elevation: 0,
              splashFactory: NoSplash.splashFactory,
              foregroundColor: style.colorBackGround,
              surfaceTintColor: Colors.transparent),
          child: Column(
            children: [
              Row(
                children: GetPersonNameText(listMapGroup[i]['name'], listMapGroup[i]['birthData']),
              ),
              Row(
                children: GetPersonBirthText(listMapGroup[i]['birthData']),
              ),
            ],
          ),
        ),
      ));
    }

      return Container(
          //저장일자 정보
          width: style.UIButtonWidth,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemCount: listPersonWidget0.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              //return Row(
              //    children:listPersonWidget[i]
              //);
              return listPersonWidget0[i];
            },
          ));
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

  EditGroupName(){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        //title: Text('성별을 선택해 주세요'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorBlack),
                maxLength: 10,
                cursorColor: style.colorBlack,
                autofocus: true,
                controller: groupNameController,
                onEditingComplete: () {
                  Navigator.of(context).pop();
                  setState(() {
                      saveDataManager.SaveEditedGroupName(groupName, saveDate, groupNameController.text);
                      widget.refreshListMapGroupLength();
                    groupName = groupNameController.text;
                    widget.refreshGroupName(saveDate, groupName);
                  });
                },
                decoration: InputDecoration(
                  labelText: '묶음 이름을 수정합니다', labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: style.colorBlack, height: -0.4),
                  hintText: groupName, hintStyle:  TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: style.colorGrey),
                  counterText:'',
                  focusedBorder:UnderlineInputBorder(
                    borderSide: BorderSide(width:2, color:style.colorDarkGrey),
                  ),
                ),
              ),
            ),
          ],
        ),
        buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0),
        actions: [
          ElevatedButton(
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                  saveDataManager.SaveEditedGroupName(groupName, saveDate, groupNameController.text);
                  widget.refreshListMapGroupLength();
                groupName = groupNameController.text;
                widget.refreshGroupName(saveDate, groupName);
              });
            },
            child: Text('저장'),
          ),
          ElevatedButton(
              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)), shadowColor: MaterialStateProperty.all(Colors.grey), elevation: MaterialStateProperty.all(1.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소')),
        ],
      ),
    );
  }

  SaveGroupTempMemo(){
    if(saveDate == DateTime.utc(3000)) {
      widget.saveGroupTempMemo(memoController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    listMapGroup = widget.listMapGroup;

    memoFocusNode = FocusNode();

    groupName = listMapGroup[0]['groupName'];
    saveDate = widget.listMapGroup[0]['saveDate'];

    prefixMemo = widget.listMapGroup[0]['memo'];
    editingMemo = widget.listMapGroup[0]['memo'];

    CheckPersonalDataHide();

    if(widget.isMemoOpen == true){
      SetEditingMemo();
    }
  }

  @override
  void didChangeDependencies(){

    super.didChangeDependencies();
  }

  @override
  void deactivate(){
    super.deactivate();

    if(isEditingMemo == 1){
      if(saveDate != DateTime.utc(3000)) {
        saveDataManager.SaveListMapGroupDataMemo(groupName, saveDate, editingMemo);
        widget.refreshListMapGroupLength();
      } else {
        SaveGroupTempMemo();
      }
      prefixMemo = editingMemo;
      editingMemo = '';
      isEditingMemo = 0;
      buttonMode = 0;
    }
  }

  @override
  Widget build(BuildContext context) {

    CheckPersonalDataHide();

    if(isEditWorldGroupName != context.watch<Store>().isEditWorldGroupName){
      if(saveDate == context.watch<Store>().groupNameSaveDate){
        groupName = saveDataManager.listMapGroup[saveDataManager.FindListMapGroupIndexWithoutGroupName(saveDate)][0]['groupName'];
      }
      isEditWorldGroupName = context.watch<Store>().isEditWorldGroupName;
    }
    if(isEditWorldGroupPersonCount != context.watch<Store>().isEditWorldGroupPersonCount){
      setState(() {
        listMapGroup = saveDataManager.listMapGroup[saveDataManager.FindListMapGroupIndex(widget.listMapGroup[0]['groupName'], widget.listMapGroup[0]['saveDate'])];
      });
      isEditWorldGroupPersonCount = context.watch<Store>().isEditWorldGroupPersonCount;
    }

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
                child: Text(groupName, style: Theme.of(context).textTheme.headlineSmall),
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
                saveDate == DateTime.utc(3000)? SizedBox.shrink() : GetPersonText(),  //이름
                saveDate == DateTime.utc(3000)? SizedBox.shrink() : Container(  //저장일자 제목
                  width: style.UIButtonWidth,
                  height: style.saveDataNameLineHeight,
                  margin: EdgeInsets.only(top: categoryMargin + 10),
                  padding: EdgeInsets.only(top:6),
                  child: Text("저장일자", style: Theme.of(context).textTheme.titleLarge),
                ),
                saveDate == DateTime.utc(3000)? SizedBox.shrink() : Container( //저장일자 정보
                  width: style.UIButtonWidth,
                  height: style.saveDataMemoLineHeight,
                  child: Text(GetSaveDateText(saveDate), style: Theme.of(context).textTheme.displayMedium),//Theme.of(context).textTheme.displayMedium),
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
                          child:Text(prefixMemo, style: style.memoTextStyle),//Theme.of(context).textTheme.displayMedium),
                        ),
                        Container( //메모 본문 수정
                          width: style.UIButtonWidth,
                          height: 900,
                          color: style.colorNavy,
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Focus(
                              onFocusChange:(focus) {
                                SaveGroupTempMemo();
                              },
                              child: TextField(
                                autofocus: true,
                                controller: memoController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                focusNode: memoFocusNode,
                                onTapOutside: (event) {
                                  memoFocusNode.requestFocus();
                                },
                                style: style.memoTextStyle,
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
                        ),
                      ][isEditingMemo],
                    ),
                  ),
                ),
              ],
            ),
          ),
          saveDate == DateTime.utc(3000)? SizedBox.shrink() : Column( //옵션 버튼들
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              [
                Column(
                  children: [
                    Row(  //수정 삭제 버튼
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(  //수정 버튼
                        width: style.UIButtonWidth * 0.32,
                        height: style.fullSizeButtonHeight,
                        margin: EdgeInsets.only(top:style.UIMarginTop),
                        child:ElevatedButton(
                            onPressed: (){
                              setState(() {
                                EditGroupName();
                              });
                            },
                            style: ElevatedButton.styleFrom(foregroundColor: style.colorBlack, padding:EdgeInsets.only(left:0), backgroundColor: style.colorNavy, elevation:0.0, shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(style.textFiledRadius))),
                            child: Text('수정', style: Theme.of(context).textTheme.headlineSmall)
                        ),
                      ),
                        Container(  //여백
                          width: style.UIButtonWidth * 0.02,
                        ),
                        Container(  //메모 버튼
                          width: style.UIButtonWidth * 0.32,
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
                          width: style.UIButtonWidth * 0.32,
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
                                              if(saveDate != DateTime.utc(3000)) {
                                                await saveDataManager.DeleteGroupData(groupName, saveDate);
                                                setState(() {
                                                  print(saveDataManager.fileDirPath);
                                                });
                                              }
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