import 'package:flutter/material.dart';
import '../../style.dart' as style;
import 'dart:math' as math;
import '../../Settings/personalDataManager.dart' as personalDataManager;

class HabChungHyeongPaWidget extends StatefulWidget {
  const HabChungHyeongPaWidget({super.key});

  @override
  State<HabChungHyeongPaWidget> createState() => _HabChungHyeongPaWidgetState();
}

class _HabChungHyeongPaWidgetState extends State<HabChungHyeongPaWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HabChungHyeongPa {  //합충형파 계산해주는 클래스

  List<String> habChungString = ['합','충','형','파','격각'];

  List<List<int>> listHabChungCheongan = [];
  List<List<int>> listHabChungJiji = [];

  double containerHeight = style.UIBoxLineHeight;

  List<String> FindHabChungCheongan(List<int> _listPaljaData, bool isAllShow){
    List<String> listHabChungString = [];
    List<int> listContainerHeightCount = [];

    int count = (_listPaljaData.length / 2).floor() - 1;

    for(int i = 0; i <= count; i++){
      listHabChungString.add('');
      listContainerHeightCount.add(0);
    }

    if(personalDataManager.deunSeunData % 10 != 3){ //간지만 추가하고 합충형파 제외함
      count = 3;
    }

    int topCount = 0;

    int saveDataNum = personalDataManager.calendarData;
    //합 찾기
    int switchNum = saveDataNum % 10;
    if(switchNum == 1 || switchNum == 3 || switchNum == 5 || switchNum == 7 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[a * 2] + 5) % style.stringCheongan[0].length == _listPaljaData[b * 2]
                && a * 2 != b * 2) {
              if (listHabChungString[a].length > 3) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length - 3) !=
                    '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]}') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[(b * 2)]]} 합\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[(b * 2)]]} 합\n';
                listContainerHeightCount[a]++;
              }
              if (topCount < listContainerHeightCount[a]) {
                topCount = listContainerHeightCount[a];
              }
            }
          }
        }
      }
      for (int a = count; a > -1; a--) {
        while (listContainerHeightCount[a] < topCount) {
          listHabChungString[a] = listHabChungString[a] + style.emptySinsalText + '\n';
          listContainerHeightCount[a]++;
        }
      }
    }

    //충 찾기
    if(switchNum == 2 || switchNum == 3 || switchNum == 6 || switchNum == 7 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[a * 2] + 4) % style.stringCheongan[0].length == _listPaljaData[b * 2]
                && a * 2 != b * 2) {
              if (_listPaljaData[a * 2] > 3) { //갑을병정이 아니면 충
                if (listHabChungString[a].length > 3) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length - 3) !=
                      '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]}') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]} 충\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]} 충\n';
                  listContainerHeightCount[a]++;
                }

                if (listHabChungString[b].length > 3) {
                  if (listHabChungString[b].substring(listHabChungString[b].length - 4, listHabChungString[b].length - 3) !=
                      '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[a * 2]]}') {
                    listHabChungString[b] = listHabChungString[b] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[a * 2]]} 충\n';
                    listContainerHeightCount[b]++;
                  }
                }
                else {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[a * 2]]} 충\n';
                  listContainerHeightCount[b]++;
                }

                if (topCount < listContainerHeightCount[a]) {
                  topCount = listContainerHeightCount[a];
                }
                if (topCount < listContainerHeightCount[b]) {
                  topCount = listContainerHeightCount[b];
                }
              }
            }
          }
        }
      }
      for (int a = count; a > -1; a--) {
        while (listContainerHeightCount[a] < topCount) {
          listHabChungString[a] = listHabChungString[a] + style.emptySinsalText + '\n';
          listContainerHeightCount[a]++;
        }
      }

    }

    String geucString = '';
    if(personalDataManager.mapWordData['geukChung'] == 1){
      geucString = '극';
    } else {
      geucString = '충'; }

    //극 찾기
    if(switchNum == 4 || switchNum == 5 || switchNum == 6 || switchNum == 7 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[a * 2] + 4) % style.stringCheongan[0].length == _listPaljaData[b * 2]
                && a * 2 != b * 2) {
              if (_listPaljaData[a * 2] < 4) { //갑을병정이면 극
                if (listHabChungString[a].length > 3) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length - 3) !=
                      '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]}') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]} ${geucString}\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[b * 2]]} ${geucString}\n';
                  listContainerHeightCount[a]++;
                }

                if (listHabChungString[b].length > 3) {
                  if (listHabChungString[b].substring(listHabChungString[b].length - 4, listHabChungString[b].length - 3) !=
                      '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[a * 2]]}') {
                    listHabChungString[b] = listHabChungString[b] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[a * 2]]} ${geucString}\n';
                    listContainerHeightCount[b]++;
                  }
                }
                else {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringCheongan[style.uemYangStringTypeNum][_listPaljaData[a * 2]]} ${geucString}\n';
                  listContainerHeightCount[b]++;
                }

                if (topCount < listContainerHeightCount[a]) {
                  topCount = listContainerHeightCount[a];
                }
                if (topCount < listContainerHeightCount[b]) {
                  topCount = listContainerHeightCount[b];
                }
              }
            }
          }
        }
      }
      if(topCount == 0){
        topCount = 1;
      }
      for (int a = count; a > -1; a--) {
        while (listContainerHeightCount[a] < topCount) {
          listHabChungString[a] = listHabChungString[a] + style.emptySinsalText + '\n';
          listContainerHeightCount[a]++;
        }
      }
      //for (int a = count; a > -1; a--) { //마무리하기
      //  if (listHabChungString[a] == '') {
      //    listHabChungString[a] = style.emptySinsalText;
      //  }
      //  else {
      //    listHabChungString[a] = listHabChungString[a].substring(0, listHabChungString[a].length - 1);
      //  }
      //}
    }

    count = (_listPaljaData.length / 2).floor() - 1;

    if(personalDataManager.deunSeunData % 10 != 3) { //간지만 추가할 때
      for (int a = count; a > 3; a--) {
        while (listContainerHeightCount[a] < topCount) {
          listHabChungString[a] = listHabChungString[a] + style.emptySinsalText + '\n';
          listContainerHeightCount[a]++;
        }
      }
    }

    for (int a = count; a > -1; a--) { //마무리하기
      if (listHabChungString[a] == '') {
        listHabChungString[a] = style.emptySinsalText;
      }
      else {
        listHabChungString[a] = listHabChungString[a].substring(0, listHabChungString[a].length - 1);
      }
    }

    if(topCount > 0){
      containerHeight = containerHeight + (topCount - 1) * style.UIBoxLineAddHeight;
    }

    return listHabChungString;
  }

  List<String> FindHabChungJiji(List<int> _listPaljaData, bool isAllShow){
    List<String> listHabChungString = [];
    List<int> listContainerHeightCount = [];

    int count = (_listPaljaData.length / 2).floor() - 1;

    for(int i = 0; i <= count; i++){
      listHabChungString.add('');
      listContainerHeightCount.add(0);
    }

    if(personalDataManager.deunSeunData % 10 != 3){ //간지만 추가하고 합충형파 제외함
      count = 3;
    }

    int topCount = 0;

    int saveDataNum = personalDataManager.calendarData;
    String habString = '합';

    //육합 찾기
    int switchNum = ((saveDataNum % 10000) / 1000).floor(); //육합
    if(personalDataManager.mapWordData['hab'] == 1){
      habString = '육합';
    }
    if(switchNum == 2 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if (((_listPaljaData[(a * 2) + 1] - 1) % style.stringJiji[0].length) + ((_listPaljaData[(b * 2) + 1] - 1) % style.stringJiji[0].length) == 11) {
              if (listHabChungString[a].length > 3) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length - 3) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]}') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n';
                listContainerHeightCount[a]++;
              }
            }
          }
        }
      }
    }

    //방합 찾기
    switchNum = ((saveDataNum % 100) / 10).floor(); //방합
    if(personalDataManager.mapWordData['hab'] == 1){
      habString = '방합';
    }
    if(switchNum != 1 || isAllShow == true) {  //방합 안 보기가 아닐 때
      bool isShowAll = true;
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30 && a != b && _listPaljaData[(a * 2) + 1] != _listPaljaData[(b * 2) + 1]) { //모름이 아니고 같은 지지를 비교하지 않을 때
            if ((((_listPaljaData[(a * 2) + 1] + 1) % style.stringJiji[0].length)/3).floor() == (((_listPaljaData[(b * 2) + 1] + 1) % style.stringJiji[0].length)/3).floor()) {
              isShowAll = switchNum == 3? true : false;  //다보기 : 왕지가 있을 때만 보기
              if(isShowAll == false) {  //왕지가 있어야 보기
                for (int c = 0; c <= count; c++) {
                  if (_listPaljaData[(b * 2) + 1] % 3 == 0 || //3으로 나눈 정수가 같으면 방합
                      ((((_listPaljaData[(a * 2) + 1] + 1) % style.stringJiji[0].length)/3).floor() == (((_listPaljaData[(b * 2) + 1] + 1) % style.stringJiji[0].length)/3).floor() && _listPaljaData[(c * 2) + 1] % 3 == 0)) {
                    isShowAll = true;
                    break;
                  }
                }
              }
              if(isShowAll == true || isAllShow == true){  //다보기
                if (listHabChungString[a].length > 4) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                      '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {   //처음 작성이면
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n';
                  listContainerHeightCount[a]++;
                }
              }
            }
          }
        }
      }
    }

    //삼합 찾기
    switchNum = ((saveDataNum % 1000) / 100).floor(); //삼합
    if(personalDataManager.mapWordData['hab'] == 1){
      habString = '삼합';
    }
    if(switchNum != 1 || isAllShow == true) {  //삼합 안 보기가 아닐 때
      bool isShowAll = true;
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30 && a != b) { //모름이 아니고 같은 지지를 비교하지 않을 때
            if ((_listPaljaData[(a * 2) + 1] - _listPaljaData[(b * 2) + 1]).abs() == 4 || (_listPaljaData[(a * 2) + 1] - _listPaljaData[(b * 2) + 1]).abs() == 8) {
              isShowAll = switchNum == 3? true : false;  //다보기 : 왕지가 있을 때만 보기
              if(isShowAll == false) {
                for (int c = 0; c <= count; c++) {
                  if (_listPaljaData[(b * 2) + 1] % 3 == 0 ||
                      (((_listPaljaData[(b * 2) + 1] - _listPaljaData[(c * 2) + 1]).abs() == 4 ||
                          (_listPaljaData[(b * 2) + 1] - _listPaljaData[(c * 2) + 1]).abs() == 8) && _listPaljaData[(c * 2) + 1] % 3 == 0)) {
                    isShowAll = true;
                    break;
                  }
                }
              }
              if(isShowAll == true || isAllShow == true){
                if (listHabChungString[a].length > 4) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                      '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {   //처음 작성이면
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} $habString\n';
                  listContainerHeightCount[a]++;
                }
              }
            }
          }
        }
      }
    }

    //충 찾기
    switchNum = ((saveDataNum % 1000000) / 100000).floor(); //충
    if(switchNum != 1 || isAllShow == true) { //충 안 보기가 아닐 때
      for (int a = count; a > -1; a--) {
        for (int b = count - 1; b > -1; b--) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[(a * 2) + 1] + 6) % style.stringJiji[0].length == _listPaljaData[(b * 2) + 1]
                && a != b) {
              if (listHabChungString[a].length > 3) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 충\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 충\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 충\n';
                listContainerHeightCount[a]++;
              }
              if (listHabChungString[b].length > 3) {
                if (listHabChungString[b].substring(listHabChungString[b].length - 4, listHabChungString[b].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 충\n') {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 충\n';
                  listContainerHeightCount[b]++;
                }
              }
              else {
                listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 충\n';
                listContainerHeightCount[b]++;
              }
            }
          }
        }
      }
    }

    //형 찾기
    switchNum = ((saveDataNum % 100000) / 10000).floor(); //형
    if(switchNum != 9 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[(a * 2) + 1] == 0 && _listPaljaData[(b * 2) + 1] == 3) ||
                (_listPaljaData[(a * 2) + 1] == 3 && _listPaljaData[(b * 2) + 1] == 0)) { //자묘형
              if(switchNum == 1 || switchNum == 3 || switchNum == 5 || switchNum == 7 || isAllShow == true) {
                if (listHabChungString[a].length > 3) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length) !=
                      '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n';
                  listContainerHeightCount[a]++;
                }
              }
            }
            if ((_listPaljaData[(a * 2) + 1] != 4 && _listPaljaData[(a * 2) + 1] % 3 == 1 && _listPaljaData[(b * 2) + 1] != 4 &&
                _listPaljaData[(b * 2) + 1] % 3 == 1) //축술미형
                && _listPaljaData[(a * 2) + 1] != _listPaljaData[(b * 2) + 1]) {
              if(switchNum == 2 || switchNum == 3 || switchNum == 6 || switchNum == 7 || isAllShow == true) {
                if (listHabChungString[a].length > 3) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length) !=
                      '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n';
                  listContainerHeightCount[a]++;
                }
              }
            }
            if ((_listPaljaData[(a * 2) + 1] == 2 || _listPaljaData[(a * 2) + 1] == 5 || _listPaljaData[(a * 2) + 1] == 8) //인사신형
                && (_listPaljaData[(b * 2) + 1] == 2 || _listPaljaData[(b * 2) + 1] == 5 || _listPaljaData[(b * 2) + 1] == 8)
                && _listPaljaData[(a * 2) + 1] != _listPaljaData[(b * 2) + 1]) {
              if(switchNum == 4 || switchNum == 5 || switchNum == 6 || switchNum == 7 || isAllShow == true) {
                if (listHabChungString[a].length > 3) {
                  if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length) !=
                      '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n') {
                    listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n';
                    listContainerHeightCount[a]++;
                  }
                }
                else {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 형\n';
                  listContainerHeightCount[a]++;
                }
              }
            }
          }
        }
      }
    }

    //원진 찾기
    switchNum = ((saveDataNum % 100000000) / 10000000).floor(); //원진
    if(switchNum == 2 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[(a * 2) + 1] == 0 || _listPaljaData[(a * 2) + 1] == 2 || _listPaljaData[(a * 2) + 1] == 4)
                && _listPaljaData[(a * 2) + 1] + 7 == _listPaljaData[(b * 2) + 1]) { //자미원진, 인유원진, 진해원진
              if (listHabChungString[a].length > 4) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 원진\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 원진\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 원진\n';
                listContainerHeightCount[a]++;
              }
              if (listHabChungString[b].length > 4) {
                if (listHabChungString[b].substring(listHabChungString[b].length - 5, listHabChungString[b].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 원진\n') {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 원진\n';
                  listContainerHeightCount[b]++;
                }
              }
              else {
                listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 원진\n';
                listContainerHeightCount[b]++;
              }
            }
            if ((_listPaljaData[(a * 2) + 1] == 1 || _listPaljaData[(a * 2) + 1] == 3 || _listPaljaData[(a * 2) + 1] == 5)
                && _listPaljaData[(a * 2) + 1] + 5 == _listPaljaData[(b * 2) + 1]) { //축오원진, 묘신원진, 사술원진
              if (listHabChungString[a].length > 4) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 원진\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 원진\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 원진\n';
                listContainerHeightCount[a]++;
              }
              if (listHabChungString[b].length > 4) {
                if (listHabChungString[b].substring(listHabChungString[b].length - 5, listHabChungString[b].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 원진\n') {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 원진\n';
                  listContainerHeightCount[b]++;
                }
              }
              else {
                listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 원진\n';
                listContainerHeightCount[b]++;
              }
            }
          }
        }
      }
    }

    //귀문 찾기
    switchNum = ((saveDataNum % 1000000000) / 100000000).floor(); //귀문
    if(switchNum == 2 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[(a * 2) + 1] == 0 && _listPaljaData[(b * 2) + 1] == 9) ||
                (_listPaljaData[(a * 2) + 1] == 9 && _listPaljaData[(b * 2) + 1] == 0)) { //자유귀문
              if (listHabChungString[a].length > 4) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n';
                listContainerHeightCount[a]++;
              }
              if (listHabChungString[b].length > 4) {
                if (listHabChungString[b].substring(listHabChungString[b].length - 5, listHabChungString[b].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n') {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n';
                  listContainerHeightCount[b]++;
                }
              }
              else {
                listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n';
                listContainerHeightCount[b]++;
              }
            }
            //if ((_listPaljaData[(a * 2) + 1] == 10 && _listPaljaData[(b * 2) + 1] == 6) ||
            //    (_listPaljaData[(a * 2) + 1] == 6 && _listPaljaData[(b * 2) + 1] == 10)) { //오술귀문
            //  if (listHabChungString[a].length > 4) {
            //    if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
            //        '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n') {
            //      listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n';
            //      listContainerHeightCount[a]++;
            //    }
            //  }
            //  else {
            //    listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n';
            //    listContainerHeightCount[a]++;
            //  }
            //  if (listHabChungString[b].length > 4) {
            //    if (listHabChungString[b].substring(listHabChungString[b].length - 5, listHabChungString[b].length) !=
            //        '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n') {
            //      listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n';
            //      listContainerHeightCount[b]++;
            //    }
            //  }
            //  else {
            //    listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n';
            //    listContainerHeightCount[b]++;
            //  }
            //}
            if ((_listPaljaData[(a * 2) + 1] == 2 && _listPaljaData[(b * 2) + 1] == 7) ||
                (_listPaljaData[(a * 2) + 1] == 7 && _listPaljaData[(b * 2) + 1] == 2)) { //인미귀문
              if (listHabChungString[a].length > 4) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 귀문\n';
                listContainerHeightCount[a]++;
              }
              if (listHabChungString[b].length > 4) {
                if (listHabChungString[b].substring(listHabChungString[b].length - 5, listHabChungString[b].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n') {
                  listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n';
                  listContainerHeightCount[b]++;
                }
              }
              else {
                listHabChungString[b] = listHabChungString[b] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(a * 2) + 1]]} 귀문\n';
                listContainerHeightCount[b]++;
              }
            }
          }
        }
      }
    }

    //격각 찾기
    switchNum = ((saveDataNum % 10000000000) / 1000000000).floor(); //격각
    if(switchNum == 2 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[(a * 2) + 1] + 2) % style.stringJiji[0].length == _listPaljaData[(b * 2) + 1]
                || (_listPaljaData[(a * 2) + 1] - 2) % style.stringJiji[0].length == _listPaljaData[(b * 2) + 1]) {
              if (listHabChungString[a].length > 4) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 5, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 격각\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 격각\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 격각\n';
                listContainerHeightCount[a]++;
              }
            }
          }
        }
      }
    }

    //파 찾기
    switchNum = ((saveDataNum % 10000000) / 1000000).floor(); //파
    if(switchNum == 2 || isAllShow == true) {
      for (int a = count; a > -1; a--) {
        for (int b = 0; b <= count; b++) {
          if (_listPaljaData[a * 2] != 30 && _listPaljaData[b * 2] != 30) {
            if ((_listPaljaData[(a * 2) + 1] + 3) % style.stringJiji[0].length == _listPaljaData[(b * 2) + 1]
                || (_listPaljaData[(a * 2) + 1] - 3) % style.stringJiji[0].length == _listPaljaData[(b * 2) + 1]) {
              if (listHabChungString[a].length > 3) {
                if (listHabChungString[a].substring(listHabChungString[a].length - 4, listHabChungString[a].length) !=
                    '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 파\n') {
                  listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 파\n';
                  listContainerHeightCount[a]++;
                }
              }
              else {
                listHabChungString[a] = listHabChungString[a] + '${style.stringJiji[style.uemYangStringTypeNum][_listPaljaData[(b * 2) + 1]]} 파\n';
                listContainerHeightCount[a]++;
              }
            }
          }
        }
      }
    }
    for(int a = count; a > -1; a--) {
      if(topCount < listContainerHeightCount[a]){
        topCount = listContainerHeightCount[a];
      }
    }
    for(int a = count; a > -1; a--) {
      if(topCount > listContainerHeightCount[a]){
        for(int b = 0; b < topCount - listContainerHeightCount[a]; b++) {
          listHabChungString[a] = '${listHabChungString[a]}${style.emptySinsalText}\n';
        }
      }
    }
    count = (_listPaljaData.length / 2).floor() - 1;
    if(personalDataManager.deunSeunData % 10 != 3) { //간지만 추가할 때
      for (int a = count; a > 3; a--) {
        while (listContainerHeightCount[a] < topCount) {
          listHabChungString[a] = listHabChungString[a] + style.emptySinsalText + '\n';
          listContainerHeightCount[a]++;
        }
      }
    }

    for(int a = count; a > -1; a--) { //마무리하기
      if(listHabChungString[a] == ''){
        listHabChungString[a] = style.emptySinsalText;
      }
      else{
        listHabChungString[a] = listHabChungString[a].substring(0, listHabChungString[a].length - 1);
      }
    }

    if(topCount > 0){
      containerHeight = containerHeight + (topCount - 1) * style.UIBoxLineAddHeight;
    }

    return listHabChungString;
  }

  List<Widget> GetCheonganHabChungWidget(BuildContext context, List<int> listPaljaData, bool isAllShow, double widgetWidth){
    List<String> listHabChungString = FindHabChungCheongan(listPaljaData, isAllShow);
    List<Widget> listCheonganHabChung = [];

    int divideVal = (listPaljaData.length / 2).floor();

    if(listPaljaData.length > 10){
      listCheonganHabChung.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listHabChungString[5], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(listPaljaData.length > 8){
      listCheonganHabChung.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listHabChungString[4], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    listCheonganHabChung.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listHabChungString[3], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listCheonganHabChung.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(listHabChungString[2], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listCheonganHabChung.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(listHabChungString[1], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listCheonganHabChung.add(Container(
    width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
    alignment: Alignment.center,
    child: Text(listHabChungString[0], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return listCheonganHabChung;
  }

  List<Widget> GetJijiHabChungWidget(BuildContext context, List<int> listPaljaData, bool isAllShow, double widgetWidth){
    List<String> listHabChungString = FindHabChungJiji(listPaljaData, isAllShow);
    List<Widget> listJijiHabChung = [];

    int divideVal = (listPaljaData.length / 2).floor();

    if(listPaljaData.length > 10){
      listJijiHabChung.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listHabChungString[5], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(listPaljaData.length > 8){
      listJijiHabChung.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(listHabChungString[4], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    listJijiHabChung.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listHabChungString[3], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listJijiHabChung.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listHabChungString[2], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listJijiHabChung.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listHabChungString[1], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    listJijiHabChung.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(listHabChungString[0], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return listJijiHabChung;
  }

  GetHabChungHyeongPaCheongan(BuildContext context, Color containerColor, List<int> _listPaljaData, bool isAllShow, double widgetWidth){

    List<Widget> listCheonganHabChungWidget = GetCheonganHabChungWidget(context, _listPaljaData, isAllShow, widgetWidth);

    return Container(
      width: (widgetWidth - (style.UIMarginLeft * 2)),
      height: containerHeight,
      //margin: EdgeInsets.only(left: style.UIMarginLeft),
      decoration: BoxDecoration(color: containerColor,
        boxShadow: [
        BoxShadow(
          color: containerColor,
          blurRadius: 0.0,
          spreadRadius: 0.0,
          offset: Offset(0, 0),
        ),
      ],),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: listCheonganHabChungWidget,
    ),
    );
  }

  GetHabChungHyeongPaJiji(BuildContext context, Color containerColor, List<int> _listPaljaData, bool isAllShow, bool isLastWidget, double widgetWidth){

    List<Widget> listJijiHabChungWidget = GetJijiHabChungWidget(context, _listPaljaData, isAllShow, widgetWidth);

    return Container(
      width: (widgetWidth - (style.UIMarginLeft * 2)),
      height: containerHeight,
      //margin: EdgeInsets.only(left: style.UIMarginLeft),
      decoration: BoxDecoration(color: containerColor,
          boxShadow: [
            BoxShadow(
              color: containerColor,
              blurRadius: 0.0,
              spreadRadius: 0.0,
              offset: Offset(0, 0),
            ),
          ],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(isLastWidget==false? 0:style.textFiledRadius), bottomRight: Radius.circular(isLastWidget==false? 0:style.textFiledRadius))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: listJijiHabChungWidget,
      ),
    );
  }
}