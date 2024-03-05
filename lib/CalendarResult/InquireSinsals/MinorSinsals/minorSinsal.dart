import 'package:flutter/material.dart';
import '../../../style.dart' as style;

class SibiSinsal{//신살 계산해주는 클래스
  double containerHeight = style.UIBoxLineHeight;

  List<String> listMinorSinsalString = ['','','',''];
  List<int> listContainerHeightCount = [0,0,0,0];

  List<String> FindMinorSinsal(List<int> _listPaljaData){

    int count = (_listPaljaData.length / 2).floor() - 1;
    int topCount = 0;

    for(int a = count; a > -1; a--) { //천간 조회
      if((_listPaljaData[a * 2] == 4 || _listPaljaData[a * 2] == 6 || _listPaljaData[a * 2] == 8) &&
          (_listPaljaData[(a * 2) + 1] == 4 || _listPaljaData[(a * 2) + 1] == 10)){ //괴강살
        listMinorSinsalString[a] = listMinorSinsalString[a] +  '괴강\n';
        listContainerHeightCount[a]++;
      }
    }

    //현침살
    int whileNum = 0;
    while(whileNum < 8){  //천간지지 전체 조회
      if(whileNum % 2 == 0){  //천간
        if(_listPaljaData[whileNum] == 0 || _listPaljaData[whileNum] == 7){
          listMinorSinsalString[(whileNum/2).floor()] = listMinorSinsalString[(whileNum/2).floor()] +  '현침\n';
          listContainerHeightCount[(whileNum/2).floor()]++;
          whileNum++;
        }
      }
      else{
        if(_listPaljaData[whileNum] == 3 || _listPaljaData[whileNum] == 6 || _listPaljaData[whileNum] == 8){
          listMinorSinsalString[(whileNum/2).floor()] = listMinorSinsalString[(whileNum/2).floor()] +  '현침\n';
          listContainerHeightCount[(whileNum/2).floor()]++;
        }
      }
      whileNum++;
    }

    //양인살
    for(int i = 7; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 3){
          listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '양인\n';
          listContainerHeightCount[(i/2).floor()]++;
        }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4) && _listPaljaData[i] == 6){
          listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '양인\n';
          listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 9){
          listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '양인\n';
          listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 0){
          listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '양인\n';
          listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //비인살
    for(int i = 7; i > 0; i = i - 2){
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
    for(int i = 7; i > 0; i = i - 2){
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
    for(int i = 7; i > 0; i = i - 2){
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

    //천을귀인
    for(int i = 7; i > 0; i = i - 2){
      if((_listPaljaData[4] == 0 || _listPaljaData[4] == 4 || _listPaljaData[4] == 6) && (_listPaljaData[i] == 1 || _listPaljaData[i] == 7)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천을귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 1 || _listPaljaData[4] == 5) && (_listPaljaData[i] == 0 || _listPaljaData[i] == 8)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천을귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 3) && (_listPaljaData[i] == 9 || _listPaljaData[i] == 11)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천을귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && (_listPaljaData[i] == 2 || _listPaljaData[i] == 6)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천을귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 8 || _listPaljaData[4] == 9) && (_listPaljaData[i] == 3 || _listPaljaData[i] == 5)){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '천을귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //관귀학관
    for(int i = 7; i > 0; i = i - 2){
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

    //문창귀인
    for(int i = 7; i > 0; i = i - 2){
      if(_listPaljaData[4] == 0 && _listPaljaData[i] == 5){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 1 && _listPaljaData[i] == 6){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 2 || _listPaljaData[4] == 4)&& _listPaljaData[i] == 8){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if((_listPaljaData[4] == 3 || _listPaljaData[4] == 5) && _listPaljaData[i] == 9){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 6 && _listPaljaData[i] == 11){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 7 && _listPaljaData[i] == 0){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 8 && _listPaljaData[i] == 2){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
      if(_listPaljaData[4] == 9 && _listPaljaData[i] == 3){
        listMinorSinsalString[(i/2).floor()] = listMinorSinsalString[(i/2).floor()] +  '문창귀인\n';
        listContainerHeightCount[(i/2).floor()]++;
      }
    }

    //문곡귀인
    for(int i = 7; i > 0; i = i - 2){
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
    for(int i = 7; i > 0; i = i - 2){
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
    for(int i = 5; i > 0; i = i - 4){
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
    for(int i = 7; i > 0; i = i - 2){
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
    for(int i = 6; i > -1; i = i - 2){ //천간 조회
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
    for(int i = 7; i > 0; i = i - 2){ //지지 조회
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

    //마무리하기
    for(int a = count; a > -1; a--) {
      if(topCount < listContainerHeightCount[a]){
        topCount = listContainerHeightCount[a];
      }
    }
    for(int a = count; a > -1; a--) {
      while (listContainerHeightCount[a] < topCount) {
        listMinorSinsalString[a] = listMinorSinsalString[a] + 'ㅡ\n';
        listContainerHeightCount[a]++;
        if(topCount < listContainerHeightCount[a]){
          topCount = listContainerHeightCount[a];
        }
      }
    }
    for(int a = count; a > -1; a--) {
      if(listMinorSinsalString[a] == ''){
        listMinorSinsalString[a] = 'ㅡ';
      }
      else{
        listMinorSinsalString[a] = listMinorSinsalString[a].substring(0, listMinorSinsalString[a].length - 1);
      }
    }

    if(topCount > 0){
      containerHeight = containerHeight + (topCount - 1) * style.UIBoxLineAddHeight;
    }


    return listMinorSinsalString;
  }

  GetMinorSinsal(BuildContext context, Color containerColor, List<int> _listPaljaData){
    List<String> listMinorSinsalString = FindMinorSinsal(_listPaljaData);

    return Container(
      width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2)),
      height: containerHeight,
      margin: EdgeInsets.only(left: style.UIMarginLeft),
      decoration: BoxDecoration(color: containerColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listMinorSinsalString[3], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listMinorSinsalString[2], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listMinorSinsalString[1], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - (style.UIMarginLeft * 2))/4,
            alignment: Alignment.center,
            child: Text(listMinorSinsalString[0], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  }