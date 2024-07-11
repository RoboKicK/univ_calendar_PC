import 'package:flutter/material.dart';
import '../../../style.dart' as style;
import '../../../Settings/personalDataManager.dart' as personalDataManager;  //개인설정

class SibiSinsal{//12신살 계산해주는 클래스
  List<String> list12SinsalText = ['화개살', '겁살', '재살', '천살', '지살', '연살', '월살', '망신살', '장성살', '반안살', '역마살', '육해살'];

  double containerHeight = style.UIBoxLineHeight;

  List<String> FindSinsal(List<int> _listPaljaData, int stanYeonjiNum){

    List<String> listMinorSinsalString = [];
    List<int> listContainerHeightCount = [];

    for(int i = 0; i < (_listPaljaData.length / 2).floor(); i++){
      listMinorSinsalString.add('');
      listContainerHeightCount.add(0);
    }

    int count = (_listPaljaData.length / 2).floor();
    int topCount = 0;
    //십이신살
    int startNum = 0;
    for(int i = 0; i < 12; i = i + 3){ //생지 순환(인,사,신,해)
      for(int j = 0; j < count-1; j++){//생지 왕지 종지 순환
        if((2 + (i * 3) + (j * 4)) % list12SinsalText.length == stanYeonjiNum){
          startNum = (10 + (i * 3)) % list12SinsalText.length;
          break;
        }
      }
    }
    for(int i = count-1; i > -1; i--){
      if(_listPaljaData[(i * 2) + 1] == 30){
        listMinorSinsalString[i] = 'ㅡ';
      } else {
        listMinorSinsalString[i] = listMinorSinsalString[i] + list12SinsalText[(_listPaljaData[(i * 2) + 1] - startNum + list12SinsalText.length) % list12SinsalText.length];
      }
    }
    
    if(topCount > 0){
      containerHeight = containerHeight + (topCount) * style.UIBoxLineAddHeight;
    }
    return listMinorSinsalString;
  }

  String Find12Sinsal(int yeonjiNum, int jijiNum){
    int startNum = 0;
    String sinsalText = '';
    for(int i = 0; i < 12; i = i + 3){ //삼합은 4가지니까 4번 반복
      for(int j = 0; j < 3; j++){ //삼합은 글자 3개니까 3번 반복
        if((2 + (i * 3) + (j * 4)) % list12SinsalText.length == yeonjiNum){
          startNum = (10 + (i * 3)) % list12SinsalText.length;
          break;
        }
      }
    }

    sinsalText = list12SinsalText[(jijiNum - startNum + list12SinsalText.length) % list12SinsalText.length];
    return sinsalText;
  }

  List<String> FindMinorSinsal(List<int> _listPaljaData, int isShowDrawerSinsal){
    List<String> listMinorSinsalString = [];
    List<int> listContainerHeightCount = [];

    int count = (_listPaljaData.length / 2).floor();
    int topCount = 0;

    for(int i = 0; i < count; i++){
      listMinorSinsalString.add('');
      listContainerHeightCount.add(0);
    }

    int etcSinsalData = personalDataManager.etcSinsalData;

    //천을귀인
    if(((etcSinsalData % 100) / 10).floor() == 2 || isShowDrawerSinsal == 2) {
      for (int i = _listPaljaData.length - 1; i > 0; i = i - 2) {
        if ((_listPaljaData[4] == 0 || _listPaljaData[4] == 4 || _listPaljaData[4] == 6) && (_listPaljaData[i] == 1 || _listPaljaData[i] == 7)) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '천을귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if ((_listPaljaData[4] == 1 || _listPaljaData[4] == 5) && (_listPaljaData[i] == 0 || _listPaljaData[i] == 8)) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '천을귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if ((_listPaljaData[4] == 2 || _listPaljaData[4] == 3) && (_listPaljaData[i] == 9 || _listPaljaData[i] == 11)) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '천을귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 7 && (_listPaljaData[i] == 2 || _listPaljaData[i] == 6)) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '천을귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if ((_listPaljaData[4] == 8 || _listPaljaData[4] == 9) && (_listPaljaData[i] == 3 || _listPaljaData[i] == 5)) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '천을귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
      }
    }

    //문창귀인
    if(((etcSinsalData % 1000) / 100).floor() == 2 || isShowDrawerSinsal == 2) {
      for (int i = _listPaljaData.length - 1; i > 0; i = i - 2) {
        if (_listPaljaData[4] == 0 && _listPaljaData[i] == 5) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 1 && _listPaljaData[i] == 6) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if ((_listPaljaData[4] == 2 || _listPaljaData[4] == 4) && _listPaljaData[i] == 8) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if ((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 9) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 6 && _listPaljaData[i] == 11) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 7 && _listPaljaData[i] == 0) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 8 && _listPaljaData[i] == 2) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 9 && _listPaljaData[i] == 3) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '문창귀인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
      }
    }

    //백호살
    if(((etcSinsalData % 10000) / 1000).floor() == 2 || isShowDrawerSinsal == 2) {
      for (int a = count - 1; a > -1; a--) {
        if (_listPaljaData[a * 2] == 0 && _listPaljaData[(a * 2) + 1] == 4) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        } else if(_listPaljaData[a * 2] == 1 && _listPaljaData[(a * 2) + 1] == 7) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        } else if(_listPaljaData[a * 2] == 2 && _listPaljaData[(a * 2) + 1] == 10) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        } else if(_listPaljaData[a * 2] == 3 && _listPaljaData[(a * 2) + 1] == 1) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        } else if(_listPaljaData[a * 2] == 4 && _listPaljaData[(a * 2) + 1] == 4) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        } else if(_listPaljaData[a * 2] == 8 && _listPaljaData[(a * 2) + 1] == 10) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        } else if(_listPaljaData[a * 2] == 9 && _listPaljaData[(a * 2) + 1] == 1) {
          listMinorSinsalString[a] = listMinorSinsalString[a] + '백호\n';
          listContainerHeightCount[a]++;
        }
      }
    }

    //괴강살
    if(((etcSinsalData % 100000) / 10000).floor() == 2 || isShowDrawerSinsal == 2) {
      for (int a = 0; a < count; a++) {
        //천간 조회
        if ((_listPaljaData[a * 2] == 4 || _listPaljaData[a * 2] == 6 || _listPaljaData[a * 2] == 8) &&
            (_listPaljaData[(a * 2) + 1] == 4 || _listPaljaData[(a * 2) + 1] == 10)) {
          //괴강살
          listMinorSinsalString[a] = listMinorSinsalString[a] + '괴강\n';
          listContainerHeightCount[a]++;
        }
      }
    }

    //현침살
    if(((etcSinsalData % 1000000) / 100000).floor() == 2 || isShowDrawerSinsal == 2) {
      int whileNum = 0;
      while (whileNum < _listPaljaData.length) {
        //천간지지 전체 조회
        if (whileNum % 2 == 0) {
          //천간
          if (_listPaljaData[whileNum] == 0 || _listPaljaData[whileNum] == 7) {
            listMinorSinsalString[(whileNum / 2).floor()] = listMinorSinsalString[(whileNum / 2).floor()] + '현침\n';
            listContainerHeightCount[(whileNum / 2).floor()]++;
            whileNum++;
          }
        } else {
          if (_listPaljaData[whileNum] == 3 || _listPaljaData[whileNum] == 6 || _listPaljaData[whileNum] == 8) {
            listMinorSinsalString[(whileNum / 2).floor()] = listMinorSinsalString[(whileNum / 2).floor()] + '현침\n';
            listContainerHeightCount[(whileNum / 2).floor()]++;
          }
        }
        whileNum++;
      }
    }

    //양인살
    if(((etcSinsalData % 10000000) / 1000000).floor() == 2 || isShowDrawerSinsal == 2) {
      for (int i = _listPaljaData.length - 1; i > 0; i = i - 2) {
        if (_listPaljaData[4] == 0 && _listPaljaData[i] == 3) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '양인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if ((_listPaljaData[4] == 2 || _listPaljaData[4] == 4) && _listPaljaData[i] == 6) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '양인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 6 && _listPaljaData[i] == 9) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '양인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
        if (_listPaljaData[4] == 8 && _listPaljaData[i] == 0) {
          listMinorSinsalString[(i / 2).floor()] = listMinorSinsalString[(i / 2).floor()] + '양인\n';
          listContainerHeightCount[(i / 2).floor()]++;
        }
      }
    }
/*
    //비인살
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 1 || _listPaljaData[i] == 10){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4)&& _listPaljaData[i] == 0){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 1){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 4){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 || _listPaljaData[i] == 7){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '비인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //천의성
    for(int a = count; a > -1; a--) { //지지 조회
      if(_listPaljaData[(a * 2) + 1] == (_listPaljaData[3] - 1 + style.stringJiji[0].length) % style.stringJiji[0].length){
        listMinorSinsalString[a] = listMinorSinsalString[a] +  '천의\n';
        listContainerHeightCount[a]++;
      }
    }

    //건록
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 1 && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4) && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 11){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 && _listPaljaData[i] == 0){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '건록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //암록
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 11){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 1 && _listPaljaData[i] == 10){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4)&& _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 7){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 4){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 && _listPaljaData[i] == 1){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '암록\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //관귀학관
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if((_listPaljaData[4] == 0 || _listPaljaData[4] == 1) && (_listPaljaData[i] == 5 || _listPaljaData[i] == 8)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '관귀학관\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 3) && (_listPaljaData[i] == 8 || _listPaljaData[i] == 11)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '관귀학관\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 4 || _listPaljaData[4] == 5) && (_listPaljaData[i] == 11 || _listPaljaData[i] == 2)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '관귀학관\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 6 || _listPaljaData[i] == 7 || _listPaljaData[4] == 8 || _listPaljaData[4] == 9) && (_listPaljaData[i] == 2 || _listPaljaData[i] == 5)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '관귀학관\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //문곡귀인
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 11){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 1 && _listPaljaData[i] == 0){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4) && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문곡귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //학당귀인
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if((_listPaljaData[4] == 0 || _listPaljaData[4] == 6) && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 1 && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4) && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 0){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '학당귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //태극귀인
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 4){
      if((_listPaljaData[4] == 0 || _listPaljaData[4] == 1) && (_listPaljaData[i] == 0 || _listPaljaData[i] == 6)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '태극귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 3) && (_listPaljaData[i] == 3 || _listPaljaData[i] == 9)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '태극귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 4 || _listPaljaData[4] == 5) && (_listPaljaData[i] % 3 == 1)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '태극귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 6 || _listPaljaData[4] == 7) && (_listPaljaData[i] == 2 || _listPaljaData[i] == 11)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '태극귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 8 || _listPaljaData[4] == 9) && (_listPaljaData[i] == 5 || _listPaljaData[i] == 8)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '태극귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //천관귀인
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 7){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 1 || _listPaljaData[4] == 3) && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 2 && _listPaljaData[i] == 4){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 4 && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 5 && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 10){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천관귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //천덕귀인
    for(int i = _listPaljaData.length - 1; i > -1; i = i - 2){ //천간 조회
      if(_listPaljaData[3] == 1 && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 2 && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 4 && _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 5 && _listPaljaData[i] == 7){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 7 && _listPaljaData[i] == 0){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 8 && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 10 && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 11 && _listPaljaData[i] == 1){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }
    for(int i = _listPaljaData.length - 1; i > 0; i = i - 2){ //지지 조회
      if(_listPaljaData[3] == 0 && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 3 && _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 6 && _listPaljaData[i] == 11){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[3] == 9 && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천덕귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }
*/
    //마무리하기
    for(int a = count - 1; a > -1; a--) {
      if(topCount < listContainerHeightCount[a]){
        topCount = listContainerHeightCount[a];
      }
    }
    for(int a = count - 1; a > -1; a--) {
      while (listContainerHeightCount[a] < topCount) {
        listMinorSinsalString[a] = listMinorSinsalString[a] + 'ㅡ\n';
        listContainerHeightCount[a]++;
        if(topCount < listContainerHeightCount[a]){
          topCount = listContainerHeightCount[a];
        }
      }
    }
    for(int a = count - 1; a > -1; a--) {
      if(listMinorSinsalString[a] == ''){
        listMinorSinsalString[a] = 'ㅡ';
      }
      else{
        listMinorSinsalString[a] = listMinorSinsalString[a].substring(0, listMinorSinsalString[a].length - 1);
      }
    }

    if(topCount == 0){
      topCount = 1;
    }
    if(topCount > 0){
      int val = 0;
      if(((personalDataManager.sinsalData % 100) / 10).floor() == 2 || isShowDrawerSinsal == 2) {
        val = 1;  //12신살 보기면 한 칸 넓힌다
      }
      containerHeight = containerHeight + (val + topCount - 1) * style.UIBoxLineAddHeight;
    }

    return listMinorSinsalString;
  }

  List<Widget> Get12SinsalWidget(BuildContext context, List<int> _listPaljaData, int stanYeonjiNum, bool isManseroc, int isShowDrawerSinsal, double widgetWidth){
    List<Widget> list12SinsalWidget = [];
    List<String> list12Sinsal = [];

    int divideVal = (_listPaljaData.length / 2).floor();

    for(int i = 0; i < divideVal; i++){
      list12Sinsal.add('');
    }

    //12신살 추가
    if(isManseroc == false || (((personalDataManager.sinsalData % 100) / 10).floor() == 2 && isShowDrawerSinsal == 1) || isShowDrawerSinsal == 2) {
      list12Sinsal = FindSinsal(_listPaljaData, stanYeonjiNum);
    }

    //기타 신살 추가
    if(isManseroc == true && ((isShowDrawerSinsal == 1 && (personalDataManager.etcSinsalData %10 ).floor() != (personalDataManager.etcSinsalDataAllOff%10).floor()))){
      List<String> listMinorSinsal = [];

      listMinorSinsal = FindMinorSinsal(_listPaljaData, isShowDrawerSinsal);

      for(int i = 0; i < list12Sinsal.length; i++){
        if(list12Sinsal[i] == ''){
          list12Sinsal[i] = listMinorSinsal[i];
        } else {
          list12Sinsal[i] = list12Sinsal[i] + '\n' + listMinorSinsal[i];
        }
      }
    }

    if(_listPaljaData.length > 10){
      list12SinsalWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(list12Sinsal[5], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    if(_listPaljaData.length > 8){
      list12SinsalWidget.add(Container(
        width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
        alignment: Alignment.center,
        child: Text(list12Sinsal[4], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
      ));
    }
    list12SinsalWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(list12Sinsal[3], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    list12SinsalWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(list12Sinsal[2], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    list12SinsalWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(list12Sinsal[1], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));
    list12SinsalWidget.add(Container(
      width: (widgetWidth - (style.UIMarginLeft * 2))/divideVal,
      alignment: Alignment.center,
      child: Text(list12Sinsal[0], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
    ));

    return list12SinsalWidget;
  }

  Get12Sinsal(BuildContext context, Color containerColor, List<int> _listPaljaData, int stanYeonjiNum, bool isManseroc, int isShowDrawerSinsal, bool isLastWidget, double widgetWidth){

    List<Widget> list12SinsalWidget= [];
    if(isManseroc == false || (((personalDataManager.sinsalData % 100) / 10).floor() == 2 && isShowDrawerSinsal == 1)
        || (isShowDrawerSinsal == 1 && (personalDataManager.etcSinsalData/10).floor() != (personalDataManager.etcSinsalDataAllOff/10).floor()) || isShowDrawerSinsal == 2) {
      list12SinsalWidget = Get12SinsalWidget(context, _listPaljaData, stanYeonjiNum, isManseroc, isShowDrawerSinsal, widgetWidth);
    }

    return Container(
      width: (widgetWidth - (style.UIMarginLeft * 2)),
      height: containerHeight,
      decoration: BoxDecoration(color: containerColor,
          //border: Border(top: BorderSide(width:1, color:style.colorDarkGrey)),
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
        children: list12SinsalWidget,
      ),
    );
  }
}