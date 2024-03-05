import 'package:flutter/material.dart';
import '../../style.dart' as style;

class YugchinClass{
  List<String> list6chin = ['비견','겁재','식신','상관','편재','정재','편관','정관','편인','정인'];

  int FindJijiYugchin0(int jijiNum, int ilganNum){
    int yugchinNum = 0;
    int ilganRev = 0;
    int jijiRev = 0;

    if(ilganNum == 4 || ilganNum == 5){ //일간이 토일 때
      jijiRev = (jijiNum + 4) % style.stringJiji[0].length;

      if(jijiNum % 3 != 1) { //지지가 토가 아닐 때
        yugchinNum = ((jijiRev - (jijiRev/3).floor() + 2) + list6chin.length) % list6chin.length;//list6chin.length;
        if(ilganNum == 5){
          if(yugchinNum % 2 == 0){
            yugchinNum++;
          }
          else{
            yugchinNum--;
          }
        }
      }
      else{
        if(jijiNum == 4 || jijiNum == 10){
          yugchinNum = ilganNum % 2;
        }
        else{
          yugchinNum = (ilganNum + 1) % 2;
        }
      }
    }
    else{  //일간이 양일 때  // if(ilganNum % 2 == 0)
      bool isYang = true; //true는 양, false는 음
      if(ilganNum % 2 == 1){
        isYang = false;
      }

      if(isYang == true){
        ilganRev = ((ilganNum - 6) + style.stringCheongan[0].length) % style.stringCheongan[0].length;
      }
      else{
        ilganRev = ((ilganNum - 7) + style.stringCheongan[0].length) % style.stringCheongan[0].length;
      }

      jijiRev = ((jijiNum - 8) + style.stringJiji[0].length) % style.stringJiji[0].length;

      if(jijiNum % 3 != 1) {  //지지가 토가 아닐 때
        yugchinNum = (jijiRev - (jijiRev/3).floor() - ilganRev) % list6chin.length;
      }
      else{ //지지가 토일 때
        if(ilganNum < 2 || ilganNum == 6 || ilganNum == 7){//(ilganNum == 0 || ilganNum == 6){ //갑경 일간
          yugchinNum = (((jijiNum + 3) / 3).floor() % 2) + 4 + (ilganNum * (4 / 6)).floor();
        }
        else{ //병임일간
          yugchinNum = (((jijiNum + 3)/ 3).floor() % 2) + 2 + ((ilganNum - 2) * (4 / 6)).floor();
        }
      }

      if(isYang == false){
        if(yugchinNum % 2 == 0){
          yugchinNum++;
        }
        else{
          yugchinNum--;
        }
      }
    }

    return yugchinNum;
  }
}