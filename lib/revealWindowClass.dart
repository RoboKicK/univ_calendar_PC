import 'dart:ui';

import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'SaveData/saveDataManager.dart' as saveDataManager;
import 'Settings/personalDataManager.dart' as personalDataManager;

class RevealWindowClass {

  bool gender = true, cheongan = true;
  int ganjiPosNum = 0, sajuNum = 0, ganjiNum = 0, sibiunseongNum = 0;
  String yugchinString = '';

  bool targetGender = true, targetCheongan = true;
  int targetGanjiPosNum = 0, targetSajuNum = 0, targetGanjiNum = 0, targetSibiunseongNum = 0;
  String targetYugchinString = '';

  late Function setState;

  String revealText = '';

  int prevRevealTypeNum = -1;
  String revealTypeString = '자세히';

  ScrollController revealScrollController = ScrollController();

  Widget revealWidget = SizedBox.shrink();

  Init(Function _setState){
    setState = _setState;
  }

  //인포텍스트
  SetRevealText(){
    if(gender == targetGender && cheongan == targetCheongan && ganjiPosNum == targetGanjiPosNum && sajuNum == targetSajuNum &&  //같은 버튼 누르면 꺼지기
        ganjiNum == targetGanjiNum && yugchinString == targetYugchinString && sibiunseongNum == targetSibiunseongNum && saveDataManager.revealTypeNum == prevRevealTypeNum){
      revealText = '';
      ResetAll();
    }
    else {
      //글자를 눌렀을 때
      if(targetGanjiPosNum != 30){
        if(targetCheongan == true){ //천간
          if(saveDataManager.revealTypeNum == 0){ //자세히
            switch(targetGanjiNum){
              case 0:{
                revealText = '甲(갑)은 '
                    '${GetOhengText(0)}\n';
              }
              case 1:{
                revealText = '乙(을)은 '
                    '${GetOhengText(0)}\n';
              }
              case 2:{
                revealText = '丙(병)은 '
                    '${GetOhengText(1)}\n';
              }
              case 3:{
                revealText = '丁(정)은 '
                    '${GetOhengText(1)}\n';
              }
              case 4:{
                revealText = '戊(무)는 '
                    '${GetOhengText(2)}\n';
              }
              case 5:{
                revealText = '己(기)는 '
                    '${GetOhengText(2)}\n';
              }
              case 6:{
                revealText = '庚(경)은 '
                    '${GetOhengText(3)}\n';
              }
              case 7:{
                revealText = '辛(신)은 '
                    '${GetOhengText(3)}\n';
              }
              case 8:{
                revealText = '壬(임)은 '
                    '${GetOhengText(4)}\n';
              }
              case 9:{
                revealText = '癸(계)는 '
                    '${GetOhengText(4)}\n';
              }
            }
          }
          else {  //간단히
            switch(targetGanjiNum){
              case 0:{
                revealText = '甲(갑)'
                    '${GetOhengText(0)}\n';
              }
              case 1:{
                revealText = '乙(을)'
                    '${GetOhengText(0)}\n';
              }
              case 2:{
                revealText = '丙(병)'
                    '${GetOhengText(1)}\n';
              }
              case 3:{
                revealText = '丁(정)'
                    '${GetOhengText(1)}\n';
              }
              case 4:{
                revealText = '戊(무)'
                    '${GetOhengText(2)}\n';
              }
              case 5:{
                revealText = '己(기)'
                    '${GetOhengText(2)}\n';
              }
              case 6:{
                revealText = '庚(경)'
                    '${GetOhengText(3)}\n';
              }
              case 7:{
                revealText = '辛(신)'
                    '${GetOhengText(3)}\n';
              }
              case 8:{
                revealText = '壬(임)'
                    '${GetOhengText(4)}\n';
              }
              case 9:{
                revealText = '癸(계)'
                    '${GetOhengText(4)}\n';
              }
            }
          }
        } else {  //지지
          if(saveDataManager.revealTypeNum == 0){ //자세히
            switch(targetGanjiNum){
              case 0:{
                revealText = '子(자)는 '
                    '${GetOhengText(4)}\n';
              }
              case 1:{
                revealText = '丑(축)은 '
                    '${GetOhengText(2)}\n';
              }
              case 2:{
                revealText = '寅(인)은 '
                    '${GetOhengText(0)}\n';
              }
              case 3:{
                revealText = '卯(묘)는 '
                    '${GetOhengText(0)}\n';
              }
              case 4:{
                revealText = '辰(진)은 '
                    '${GetOhengText(2)}\n';
              }
              case 5:{
                revealText = '巳(사)는 '
                    '${GetOhengText(1)}\n';
              }
              case 6:{
                revealText = '午(오)는 '
                    '${GetOhengText(1)}\n';
              }
              case 7:{
                revealText = '未(미)는 '
                    '${GetOhengText(2)}\n';
              }
              case 8:{
                revealText = '辛(신)은 '
                    '${GetOhengText(3)}\n';
              }
              case 9:{
                revealText = '酉(유)는 '
                    '${GetOhengText(3)}\n';
              }
              case 10:{
                revealText = '戌(술)은 '
                    '${GetOhengText(2)}\n';
              }
              case 11:{
                revealText = '亥(해)는 '
                    '${GetOhengText(0)}\n';
              }
            }
          }
          else {
            switch(targetGanjiNum){
              case 0:{
                revealText = '子(자)'
                    '${GetOhengText(4)}\n';
              }
              case 1:{
                revealText = '丑(축)'
                    '${GetOhengText(2)}\n';
              }
              case 2:{
                revealText = '寅(인)'
                    '${GetOhengText(0)}\n';
              }
              case 3:{
                revealText = '卯(묘)'
                    '${GetOhengText(0)}\n';
              }
              case 4:{
                revealText = '辰(진)'
                    '${GetOhengText(2)}\n';
              }
              case 5:{
                revealText = '巳(사)'
                    '${GetOhengText(1)}\n';
              }
              case 6:{
                revealText = '午(오)'
                    '${GetOhengText(1)}\n';
              }
              case 7:{
                revealText = '未(미)'
                    '${GetOhengText(2)}\n';
              }
              case 8:{
                revealText = '辛(신)'
                    '${GetOhengText(3)}\n';
              }
              case 9:{
                revealText = '酉(유)'
                    '${GetOhengText(3)}\n';
              }
              case 10:{
                revealText = '戌(술)'
                  '${GetOhengText(2)}\n';
              }
              case 11:{
                revealText = '亥(해)'
                    '${GetOhengText(0)}\n';
              }
            }
          }
        }
        revealText =  revealText + '${GetGanjiText(targetCheongan, targetGanjiNum)}';
        if(targetCheongan == false && targetGanjiPosNum == 3){
          revealText =  revealText + '${GetYongsinText(targetGanjiPosNum)}';
        }
      }
      //사주 타이틀 눌렀을 때
      else if(targetSajuNum != 30){
        if(saveDataManager.revealTypeNum == 0) {
          switch (targetSajuNum) {
            case 0:
              {
                revealText = '연주는 부모, 조상과 연관되어 있습니다.\n국가, 초년기, 과거를 나타냅니다.';
              }
            case 1:
              {
                revealText = '월주는 부모, 형제 연관되어 있습니다.\n직업, 청년기, 과거를 나타냅니다.\n특히 태어난 계절인 월지를 통해 절대용신을 정합니다.';
              }
            case 2:
              {
                revealText = '일주는 나, 배우자와 연관되어 있습니다.\n가정, 장년기, 현재를 나타냅니다.';
              }
            case 3:
              {
                revealText = '시주는 자식과 연관되어 있습니다.\n여가생활, 말년기, 미래를 나타냅니다.\n특히 시지는 태어난 시간을 나타냅니다.';
              }
          }
        } else {
          switch (targetSajuNum) {
            case 0:
              {
                revealText = '연주 : 부모, 조상, 국가, 초년기, 과거';
              }
            case 1:
              {
                revealText = '월주 : 부모, 형제, 직업, 청년기, 과거, 절대용신의 기준';
              }
            case 2:
              {
                revealText = '일주 : 나, 배우자, 가정, 장년기, 현재';
              }
            case 3:
              {
                revealText = '시주 : 자식, 여가생활, 말년기, 미래, 태어난 시간';
              }
          }
        }
      }
      //육친을 눌렀을 때
      else if(targetYugchinString != ''){
          switch(targetYugchinString){
            case '비견':{  //비견
              revealText = GetYugchinCategoryText(0)+GetYugchinText(targetYugchinString);
            }
            case '겁재':{
              revealText = GetYugchinCategoryText(0)+GetYugchinText(targetYugchinString);
            }
            case '식신':{
              revealText = GetYugchinCategoryText(1)+GetYugchinText(targetYugchinString);
            }
            case '상관':{
              revealText = GetYugchinCategoryText(1)+GetYugchinText(targetYugchinString);
            }
            case '편재':{
              revealText = GetYugchinCategoryText(2)+GetYugchinText(targetYugchinString);
            }
            case '정재':{
              revealText = GetYugchinCategoryText(2)+GetYugchinText(targetYugchinString);
            }
            case '편관':{
              revealText = GetYugchinCategoryText(3)+GetYugchinText(targetYugchinString);
            }
            case '정관':{
              revealText = GetYugchinCategoryText(3)+GetYugchinText(targetYugchinString);
            }
            case '편인':{
              revealText = GetYugchinCategoryText(4)+GetYugchinText(targetYugchinString);
            }
            case '정인':{
              revealText = GetYugchinCategoryText(4)+GetYugchinText(targetYugchinString);
            }
            case '일간':{
              revealText = GetYugchinCategoryText(5);
            }
          }
      }

      gender = targetGender; cheongan = targetCheongan; ganjiPosNum =targetGanjiPosNum; sajuNum = targetSajuNum; ganjiNum = targetGanjiNum; yugchinString = targetYugchinString; sibiunseongNum = targetSibiunseongNum;
      setState();
    }

    prevRevealTypeNum = saveDataManager.revealTypeNum;
  }

  //목화토금수 텍스트
  GetOhengText(int ohengNum){ //0:목, 1:화, 2:토, 3:금, 4:수
    if(saveDataManager.revealTypeNum == 0){ //자세히
      switch (ohengNum) {
        case 0:
          {
            return '오행 중 木(목)입니다.\n木(목)의 물상은 식물, 사람입니다.\n木(목)은 성장하기 때문에 꿈이 있고 희망적이며 활동적으로 나아가는 힘이 있습니다.';
          }
        case 1:
          {
            return '오행 중 火(화)입니다.\n火(화)의 물상은 불입니다.\n火(화)는 빛나고 따뜻합니다. 방송, 연예, 디자인, 법과 연관있으며 본인을 드러내길 원합니다.';
          }
        case 2:
          {
            return '오행 중 土(토)입니다.\n土(토)의 물상은 땅입니다.\n土(토)는 고유한 영역과 신뢰를 의미하며, 나무를 키워내는 교육의 인자를 가지고 있습니다.';
          }
        case 3:
          {
            return '오행 중 金(금)입니다.\n金(금)의 물상은 돌, 쇠입니다.\n金(금)은 결실이며 의리, 정치, 권력과 연관있습니다. 군대, 의료, 요리 방면의 종사자가 많습니다.';
          }
        case 4:
          {
            return '오행 중 水(수)입니다.\n水(수)의 물상은 물입니다.\n水(수)는 생명의 근원이며 사랑, 교육, 지혜, 정신과 연관이 있습니다.';
          }
      }
    }
    else {  //간단히
      switch (ohengNum) {
        case 0:
          {
            return '\n오행 : 木(목)\n물상 : 식물, 사람\n木(목)의 키워드 : 성장, 꿈, 희망, 활동적';
          }
        case 1:
          {
            return '\n오행 : 火(화)\n물상 : 불\n火(화)의 키워드 : 방송, 연예, 디자인, 법, 드러냄';
          }
        case 2:
          {
            return '\n오행 : 土(토)\n물상 : 땅\n土(토)의 키워드 : 영역, 신뢰, 교육';
          }
        case 3:
          {
            return '\n오행 : 金(금)\n물상 : 돌, 쇠\n金(금)의 키워드 : 의리, 정치, 권력, 군대, 의료, 요리';
          }
        case 4:
          {
            return '\n오행 : 水(수)\n물상 : 물\n水(수)의 키워드 : 생명, 사랑, 교육, 지혜, 정신';
          }
      }
    }
  }

  //천간 지지 텍스트
  GetGanjiText(bool isCheongan, int ganjiNum){
    if (isCheongan == true) {
      if(saveDataManager.revealTypeNum == 0){ //자세히
      switch (ganjiNum) {
        case 0:
          {
            return '甲(갑)의 물상은 나무입니다. 의지와 추진력이 있고 고집이 강하며 대장 역할을 하려는 경향이 있습니다.';
          }
        case 1:
          {
            return '乙(을)의 물상은 꽃, 풀입니다. 인내심이 있고 속마음을 잘 밝히지 않으며 반항하는 기질이 있습니다.';
          }
        case 2:
          {
            return '丙(병)의 물상은 태양입니다. 밝고 매사에 앞장서는 성향이며 자부심이 강한 편입니다.';
          }
        case 3:
          {
            return '丁(정)의 물상은 달이며 태양을 제외한 모든 불과 빛입니다. 계산적이며 관심 받기를 원하는 편입니다. 庚(경)과 戊(무)일간을 좋아하는 경향이 있습니다.';
          }
        case 4:
          {
            return '戊(무)의 물상은 산입니다. 영역이 넓으며 욕심이 많은 경향이 있습니다.';
          }
        case 5:
          {
            return '己(기)의 물상은 비옥한 땅입니다. 戊(무)보다 상대적으로 좁은 영역에서 가치있는 것을 추구하는 성향입니다.';
          }
        case 6:
          {
            return '庚(경)의 물상은 바위, 원석입니다. 모든 면에서 투박한 스타일이며 丁(정)일간을 좋아하는 경향이 있습니다.';
          }
        case 7:
          {
            return '辛(신)의 물상은 다이아몬드, 완성된 보석입니다. 변하지 않는 의리파 성향입니다.';
          }
        case 8:
          {
            return '壬(임)의 물상은 웅덩이, 바다입니다. 매력적이며 호탕한 편입니다. 무언가 하나에 꽂혀서 평생 지속하는 경우가 많습니다.';
          }
        case 9:
          {
            return '癸(계)의 물상은 수증기, 비입니다. 머리가 좋으면서 겁과 욕심이 많은 편입니다.';
          }
        }
      }
      else {
        switch (ganjiNum) {
          case 0:
            {
              return '甲(갑)의 키워드 : 나무, 의지, 추진력, 고집, 대장';
            }
          case 1:
            {
              return '乙(을)의 키워드 : 꽃, 풀, 인내심, 비밀, 반항';
            }
          case 2:
            {
              return '丙(병)의 키워드 : 태양, 밝음, 앞장섬, 자부심';
            }
          case 3:
            {
              return '丁(정)의 키워드 : 달, 태양을 제외한 모든 불과 빛, 계산적, 관심 받기, 庚(경)과 戊(무)일간을 좋아함';
            }
          case 4:
            {
              return '戊(무)의 키워드 : 산, 넓은 영역, 욕심쟁이';
            }
          case 5:
            {
              return '己(기)의 키워드 : 비옥한 땅, 상대적으로 좁은 영역, 가치있는 것';
            }
          case 6:
            {
              return '庚(경)의 키워드 : 바위, 원석, 투박함, 丁(정)일간을 좋아함';
            }
          case 7:
            {
              return '辛(신)의 키워드 : 다이아몬드, 완성된 보석, 의리';
            }
          case 8:
            {
              return '壬(임)의 키워드 : 웅덩이, 바다, 매력, 호탕함, 꽂힘';
            }
          case 9:
            {
              return '癸(계)의 키워드 : 수증기, 비, 지능, 겁, 욕심';
            }
        }
      }
    }
    else {
      if(saveDataManager.revealTypeNum == 0){ //자세히
        switch (ganjiNum) {
          case 0:
            {
              return '子(자)의 물상은 쥐이며 시간대는 23:30 ~ 01:30입니다. 다산하는 쥐의 특징 처럼 사랑, 생명과 연관이 있습니다. 공자, 맹자 등의 子를 사용하므로 교육, 철학, 전문가와 관련있으며 의학, 철학, 교사 방면의 종사자가 많습니다.';
            }
          case 1:
            {
              return '丑(축)의 물상은 소이며 시간대는 01:30 ~ 03:30입니다. 소는 농사에 큰 도움이 되었던 존재로 생활력, 반복을 상징합니다. 또한 겁이 많고 꿈을 자주 꾸는 편입니다. 컴퓨터, 창고, 금융, 은행, 반도체 방면의 종사자가 많습니다.';
            }
          case 2:
            {
              return '寅(인)의 물상은 아이, 호랑이이며 시간대는 03:30 ~ 05:30입니다. 아이는 활동적이며 하고 싶은 게 많고 사랑받고 싶어합니다. 창조, 목소리와 관련있으며 무역, 통신, 자동차, 법, 정치 방면의 종사자가 많지만 결국 어린아이 처럼 무엇이든 될 수 있는 가능성이 있습니다.';
            }
          case 3:
            {
              return '卯(묘)의 물상은 청소년, 토끼이며 시간대는 05:30 ~ 07:30입니다. 청소년은 관심이 빠르게 바뀌며 여러 가지 경험을 합니다. 귀여움, 꾸밈, 반복을 상징하며 연예, 방송, 패션, 화장 방면의 종사자가 많습니다.';
            }
          case 4:
            {
              return '辰(진)의 물상은 청년, 용이며 시간대는 07:30 ~ 09:30입니다. 청년은 의기양양하여 배포가 큰 경향이 있습니다. 용은 상상 속의 동물로 허상, 허세, 허풍을 의미합니다. 박리다매, 유니폼, 도둑, 더러움과 관련되어 있으며 패션, 공무원 방면의 종사자가 많습니다.';
            }
          case 5:
            {
              return '巳(사)의 물상은 뱀이며 시간대는 09:30 ~ 11:30입니다. ${'뱀의 혀'}라는 말처럼 말을 잘하며 정치, 권력, 첨단기기와 관련이 있습니다. 컴퓨터, 인터넷, 첨단기술, 의사, 정치인, 변호사, 가수, 공무원 방면의 종사자가 많습니다.';
            }
          case 6:
            {
              return '午(오)의 물상은 말이며 시간대는 11:30 ~ 13:30입니다. 보기 좋은 걸 좋아하고 겁이 많으며 정의로운 성향입니다. 방송, 연예, 권력, 디자인, 정치, 종교, 경찰, 판검사, 한의사 방면의 종사자가 많습니다.';
            }
          case 7:
            {
              return '未(미)의 물상은 양, 사막이며 시간대는 13:30 ~ 15:30입니다. 식사 후의 시간대이므로 게으른 편이며 특히 빵을 좋아하고 정치력이 좋은 편입니다. 건강, 의료, 의약, 요리, 종교, 철학, 복지, 교육 방면의 종사자가 많습니다.';
            }
          case 8:
            {
              return '辛(신)의 물상은 원숭이이며 시간대는 15:30 ~ 17:30입니다. 원숭이 처럼 다방면에 재주가 많은 편입니다. 이과, 예체능 계열에 적성이 맞으며 선택, 기술, 창조와 연관이 있습니다. 금융, 전기, 금속, 권력, 방송, 연예 방면의 종사자가 많습니다.';
            }
          case 9:
            {
              return '酉(유)의 물상은 닭, 바늘이며 시간대는 17:30 ~ 19:30입니다. 가장 풍족한 추석의 계절이라 눈이 높아서 가성비를 따집니다. 세밀하고 까칠하며 깔끔한 성향이며 요리사 직업군이 많습니다.';
            }
          case 10:
            {
              return '戌(술)의 물상은 개이며 시간대는 19:30 ~ 21:30입니다. 충성심이 높은 성향입니다. 타격하는 운동, 종교, 창고와 연관되어 있스며 종교인, 운동 선수 방면의 종사자가 많습니다.';
            }
          case 11:
            {
              return '亥(해)의 물상은 돼지이며 시간대는 21:30 ~ 23:30입니다. 블랙홀, 독, 교육, 생명, 사랑, 소리와 연관되어 있습니다. 음악인, 어부, 해운 방면의 종사자가 많습니다.';
            }
        }
      }
      else {
        switch (ganjiNum) {
          case 0:
            {
              return '子(자)의 키워드 : 쥐, 사랑, 생명, 교육, 전문가, 의학, 철학, 교사';
            }
          case 1:
            {
              return '丑(축)의 키워드 : 소, 생활력, 반복, 겁, 꿈, 컴퓨터, 창고, 금융, 은행, 반도체';
            }
          case 2:
            {
              return '寅(인)의 키워드 : 아이, 호랑이, 활동적, 꿈, 사랑 받음, 창조, 목소리, 무역, 통신, 자동차, 법, 정치';
            }
          case 3:
            {
              return '卯(묘)의 키워드 : 청소년, 토끼, 관심이 빠르게 바뀜, 여러 가지, 귀여움, 꾸밈, 반복, 연예, 방송, 패션, 화장';
            }
          case 4:
            {
              return '辰(진)의 키워드 : 청년, 용, 배포가 큼, 허상, 허세, 허풍, 박리다매, 유니폼, 도둑, 더러움, 패션, 공무원';
            }
          case 5:
            {
              return '巳(사)의 키워드 : 뱀, 말을 잘함, 정치, 권력, 컴퓨터, 인터넷, 첨단기기, 첨단기술, 의사, 정치인, 변호사, 가수, 공무원';
            }
          case 6:
            {
              return '午(오)의 키워드 : 말, 겉모습, 겁, 정의로움, 방송, 연예, 권력, 디자인, 정치, 종교, 경찰, 판검사, 한의사';
            }
          case 7:
            {
              return '未(미)의 키워드 : 양, 사막, 게으음, 빵, 정치력, 건강, 의료, 의약, 요리, 종교, 철학, 복지, 교육';
            }
          case 8:
            {
              return '辛(신)의 키워드 : 원숭이, 선택, 기술, 창조, 재능, 이과, 예체능, 금융, 전기, 금속, 권력, 방송, 연예';
            }
          case 9:
            {
              return '酉(유)의 키워드 : 닭, 바늘, 눈이 높음, 세밀함, 까칠함, 깔끔함, 요리사';
            }
          case 10:
            {
              return '戌(술)의 키워드 : 개, 충성, 타격하는 운동, 종교, 창고, 종교인, 운동 선수';
            }
          case 11:
            {
              return '亥(해)의 키워드 돼지, 블랙홀, 독, 교육, 생명, 사랑, 소리, 음악인, 어부, 해운';
            }
        }
      }
    }
  }

  //용신 텍스트
  GetYongsinText(int ganjiPosNum){
    if(saveDataManager.revealTypeNum == 0) {
      switch (targetGanjiNum) {
        case 0:
          {
            return '\n子(자)월생의 절대용신은 火(화)이며 대운에서의 용신은 辰, 巳, 午, 未, 申입니다. 기구신은 水(수)입니다.';
          }
        case 1:
          {
            return '\n丑(축)월생의 절대용신은 火(화)이며 대운에서의 용신은 辰, 巳, 午, 未, 申입니다. 기구신은 水(수)입니다.';
          }
        case 2:
          {
            return '\n寅(인)월생의 절대용신은 火(화)이며 대운에서의 용신은 辰, 巳, 午, 未, 申입니다. 기구신은 水(수)입니다.';
          }
        case 3:
          {
            return '\n卯(묘)월생의 절대용신은 火(화)이며 대운에서의 용신은 辰, 巳, 午, 未, 申입니다. 기구신은 水(수)입니다.';
          }
        case 4:
          {
            return '\n辰(진)월생의 용신은 火(화)이며 대운에서의 용신은 午, 未, 申입니다.';
          }
        case 5:
          {
            return '\n巳(사)월생의 용신은 火(화)이며 대운에서의 용신은 午, 未, 申입니다.';
          }
        case 6:
          {
            return '\n午(오)월생의 절대용신은 水(수)이며 대운에서의 용신은 酉, 戌, 亥, 子, 丑, 寅, 卯입니다. 기구신은 火(화)입니다.';
          }
        case 7:
          {
            return '\n未(미)월생의 절대용신은 水(수)이며 대운에서의 용신은 酉, 戌, 亥, 子, 丑, 寅, 卯입니다. 기구신은 火(화)입니다.';
          }
        case 8:
          {
            return '\n申(신)월생의 절대용신은 水(수)이며 대운에서의 용신은 酉, 戌, 亥, 子, 丑, 寅, 卯입니다. 기구신은 火(화)입니다.';
          }
        case 9:
          {
            return '\n酉(유)월생의 용신은 水(수)이며 대운에서의 용신은 亥, 子, 丑, 寅, 卯입니다.';
          }
        case 10:
          {
            return '\n戌(술)월생의 용신은 水(수)이며 대운에서의 용신은 亥, 子, 丑, 寅, 卯입니다.';
          }
        case 11:
          {
            return '\n亥(해)월생의 절대용신은 火(화)이며 대운에서의 용신은 辰, 巳, 午, 未, 申입니다.';
          }
      }
    }
    else {
      switch (targetGanjiNum) {
        case 0:
          {
            return '\n절대용신 : 火(화)\n대운 용신 : 辰, 巳, 午, 未, 申';
          }
        case 1:
          {
            return '\n절대용신 : 火(화)\n대운 용신 : 辰, 巳, 午, 未, 申';
          }
        case 2:
          {
            return '\n절대용신 : 火(화)\n대운 용신 : 辰, 巳, 午, 未, 申';
          }
        case 3:
          {
            return '\n절대용신 : 火(화)\n대운 용신 : 辰, 巳, 午, 未, 申';
          }
        case 4:
          {
            return '\n용신 : 火(화)\n대운 용신 : 午, 未, 申';
          }
        case 5:
          {
            return '\n용신 : 火(화)\n대운 용신 : 午, 未, 申';
          }
        case 6:
          {
            return '\n절대용신 : 水(수)\n대운 용신 : 酉, 戌, 亥, 子, 丑, 寅, 卯';
          }
        case 7:
          {
            return '\n절대용신 : 水(수)\n대운 용신 : 酉, 戌, 亥, 子, 丑, 寅, 卯';
          }
        case 8:
          {
            return '\n절대용신 : 水(수)\n대운 용신 : 酉, 戌, 亥, 子, 丑, 寅, 卯';
          }
        case 9:
          {
            return '\n용신 : 水(수)\n대운 용신 : 亥, 子, 丑, 寅, 卯';
          }
        case 10:
          {
            return '\n용신 : 水(수)\n대운 용신 : 亥, 子, 丑, 寅, 卯';
          }
        case 11:
          {
            return '\n절대용신 : 火(화)\n대운 용신 : 辰, 巳, 午, 未, 申';
          }
      }
    }
  }

  //육친 카테고리 텍스트
  GetYugchinCategoryText(int yugchinTypeNum){
    if(saveDataManager.revealTypeNum == 0){ //자세히
      switch (yugchinTypeNum) {
        case 0:
          {
            return '비견과 겁재를 합쳐서 비겁이라 합니다.\n비겁은 나, 친구, 형제, 욕망, 주체성과 독립성을 유지하는 힘입니다.';
          }
        case 1:
          {
            return '식신과 상관을 합쳐서 식상이라 합니다.\n식상은 이성을 유혹하기 위한 수단입니다. 기술, 예술, 표현력, 호기심, 추종자, 손님을 뜻합니다.\n남자에겐 학생, 손님, 제자 등이 되며 여자에겐 자식입니다.';
          }
        case 2:
          {
            return '정재와 편재를 합쳐서 재성이라 합니다.\n재성은 돈, 대인관계, 아버지입니다.\n남자에겐 여자도 포함됩니다.\n재성이 많은 사람은 연예인의 기질을 갖습니다.';
          }
        case 3:
          {
            return '정관과 편관을 합쳐서 관성이라 합니다.\n관성은 가치관, 자존심, 직업입니다.\n남자에겐 자식이 되며 여자에겐 남자가 됩니다.';
          }
        case 4:
          {
            return '정인과 편인을 합쳐서 인성이라 합니다.\n인성은 엄마, 선생님, 공부, 문서입니다.\n남자에겐 누나도 포함됩니다.';
          }
        case 5:
          {
            return '${personalDataManager.GetIlganText()}은 나를 나타냅니다. ${personalDataManager.GetIlganText()}을 기준으로 ${personalDataManager.GetYugchinText()}을 정합니다.';
          }
      }
    }
    else {  //간단히
      switch (yugchinTypeNum) {
        case 0:
          {
            return '비겁 : 나, 친구, 형제, 욕망, 주체성, 독립성';
          }
        case 1:
          {
            return '식상 : 이성을 유혹하기 위한 수단, 기술, 예술, 표현력, 호기심, 추종자, 손님\n남자에게 : 학생, 손님, 제자\n여자에게 : 자식';
          }
        case 2:
          {
            return '재성 : 돈, 대인관계, 아버지\n남자에게 : 여자\n재다자 : 연예인';
          }
        case 3:
          {
            return '관성 : 가치관, 자존심, 직업\n남자에게 : 자식\n여자에게 : 남자';
          }
        case 4:
          {
            return '인성 : 엄마, 선생님, 공부, 문서\n남자에게 : 누나';
          }
        case 5:
          {
            return '${personalDataManager.GetIlganText()} : ${personalDataManager.GetYugchinText()}을 정하는 기준';
          }
      }
    }
  }

  //육친 텍스트
  GetYugchinText(String yugchinString){
    if(saveDataManager.revealTypeNum == 0) {  //자세히
      switch (yugchinString) {
        case '비견':
          {
            return '\n비견은 겁재에 비해 나, 친구, 동료일 확률이 높고 함께 나누는 성향이 있습니다.';
          }
        case '겁재':
          {
            return '\n겁재은 비견에 비해 형제일 확률이 높고 독식하며 주체성과 독립성이 강한 경향 있습니다.';
          }
        case '식신':
          {
            return '\n식신은 말하기 보다는 글쓰기를 선호하며 탐구심이 있고, 긍정적이며 게으르고 느긋한 면이 있습니다. 연기자 보다는 가수와 어울립니다.\n여자에게는 아들일 확률이 높습니다.';
          }
        case '상관':
          {
            return '\n상관은 글쓰기 보다는 말하기를 선호하며 반발심이 있고, 급하며 즉흥적인 면이 있습니다. 가수 보다는 연기자와 어울립니다.\n여자에게는 딸일 확률이 높습니다.';
          }
        case '편재':
          {
            return '\n편재는 즉흥적이고 큰 돈을 추구하며 주변에 베푸는 경향이 있습니다. 따라서 자기 사업을 추구할 확률이 높습니다.\n남자에게는 애인일 확률이 높습니다.';
          }
        case '정재':
          {
            return '\n정재는 계획적이고 안정적인 것을 추구하며 체계적인 스타일입니다. 따라서 월급을 받는 근로자를 추구할 확률이 높습니다.\n남자에게는 아내일 확률이 높습니다.';
          }
        case '편관':
          {
            return '\n편관은 집단주의적 성향입니다. 즉흥적이고 비합리적인 면이 있으며 작은 규칙은 잘 지키지만 가치관을 넘어서는 유혹에 취약합니다. 군인 같은 공무원이 어울립니다.\n남자에게는 아들, 여자에게는 애인일 확률이 높습니다.';
          }
        case '정관':
          {
            return '\n정관은 개인주의적 성향입니다. 계산적이고 합리적인 면이 있으며 작은 규칙은 잘 지키지 않지만 가치관을 넘어서는 유혹에 강합니다. 사무직 공무원이 어울립니다.\n남자에게는 딸, 여자에게는 남편일 확률이 높습니다.';
          }
        case '편인':
          {
            return '\n편인은 말괄량이이며 타인을 잘 챙겨주는 집단주의 스타일입니다. 파격적이고 급진적인 면이 있습니다. 문과 보다는 이과에 어울리며 천재성을 가집니다.';
          }
        case '정인':
          {
            return '\n정인은 착하지만 자기 것은 확실히 챙기는 개인주의 스타일입니다. 보수적이며 전통적인 것을 좋아하는 경향이 있습니다.';
          }
      }
    }
    else {
      switch (yugchinString) {
        case '비견':
          {
            return '\n비견 : 나, 친구, 동료, 함께 나눔';
          }
        case '겁재':
          {
            return '\n겁재 : 형제, 독식, 주체성, 독립성';
          }
        case '식신':
          {
            return '\n식신 : 글쓰기, 탐구심, 긍정적, 게으름, 느긋함, 가수\n여자에게 : 아들';
          }
        case '상관':
          {
            return '\n상관 : 말하기, 반발심, 급함, 즉흥적, 연기자,\n여자에게 : 딸';
          }
        case '편재':
          {
            return '\n편재 : 즉흥적, 큰 돈, 베품, 자기 사업\n남자에게 : 애인';
          }
        case '정재':
          {
            return '\n정재 : 계획적, 안정적, 체계적, 근로자\n남자에게 : 아내';
          }
        case '편관':
          {
            return '\n편관 : 집단주의, 즉흥적, 비합리적, 군인\n남자에게 : 아들\n 여자에게 : 애인';
          }
        case '정관':
          {
            return '\n정관 : 개인주의, 계산적, 합리적, 사무직 공무원\n남자에게 : 딸\n여자에게 : 남편';
          }
        case '편인':
          {
            return '\n편인 : 말괄량이, 집단주의, 파격적, 급진적, 이과, 천재성';
          }
        case '정인':
          {
            return '\n정인 : 착함, 개인주의, 보수적, 전통적';
          }
      }
    }
  }

  ResetAll(){
    gender = true; cheongan = true; ganjiPosNum = 0; sajuNum = 0; ganjiNum = 0; yugchinString = ''; sibiunseongNum = 0;
  }

  //위젯 끄기
  CloseRevealWidget(){
    revealWidget = SizedBox.shrink();
    ResetAll();
    setState();
  }

  //간단히 자세히 버튼
  SetRevealType(){
      saveDataManager.SetRevealType();

      if(saveDataManager.revealTypeNum == 0){
        revealTypeString = '간단히';
      } else {
        revealTypeString = '자세히';
      }
      SetRevealText();
      SetRevealWidget();
  }

  //인포 위젯 갱신
  SetRevealWidget(){
    if(revealText != '') {
      revealWidget = Container(
        width: 280,
        height: 140+26,
        margin: EdgeInsets.only(right: 8, bottom: 14),
        child: Column(
          children: [
            Row(  //닫기 버튼
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(  //자세히 간단히 버튼
                  width: 50,
                  height: 22,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top:0, right:8, bottom: 4),
                  decoration: BoxDecoration(
                    color: Color(0xffA0A0A1),//style.colorDarkGrey,
                    borderRadius: BorderRadius.circular(style.textFiledRadius),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      SetRevealType();
                    },//Text('×', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),Icon(Icons.close),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        surfaceTintColor: Colors.black, foregroundColor: Colors.black, overlayColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius))),
                    child: Text(revealTypeString, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, height: 1.64, fontFamily: 'NotoSansKR-Regular'),),
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: style.colorDarkGrey,
                    borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
                  ),
                  margin: EdgeInsets.only(top:0, right:4, bottom: 4),
                  child:
                  ElevatedButton(
                    onPressed: (){
                      CloseRevealWidget();
                    },
                    child: Icon(Icons.close, color: Colors.white, size: 16),//Text('×', style: TextStyle(fontSize: 24, color: Colors.white)),//Icon(Icons.b),Icon(Icons.close),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), backgroundColor: Colors.transparent, elevation: 0, splashFactory: NoSplash.splashFactory,
                        surfaceTintColor: Colors.black, foregroundColor: Colors.black, overlayColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.deunSeunGanjiRadius))),
                  ),
                )
              ],
            ),
            Container(
              width: 280,
              height: 140,
              padding: EdgeInsets.only(left: 8, top: 4, bottom: 8),
              decoration: BoxDecoration(
                color: Color(0xffffefa7),//style.colorBoxGray1,
                border: Border.all(
                  width: 1,
                  color: Colors.white,//style.colorDarkGrey,
                ),
                //boxShadow: [BoxShadow(color: style.colorNavy.withOpacity(0.8), spreadRadius: 1, blurRadius: 2)],
                borderRadius: BorderRadius.all(Radius.circular(style.textFiledRadius)),
              ),
              child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
                  child: Scrollbar(
                    //thumbVisibility: true,
                    notificationPredicate: (notification) => notification.depth >= 0,
                    thickness: 4,
                    radius: Radius.circular(2),
                    controller: revealScrollController,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: revealScrollController,
                        physics: ClampingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(revealText,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff222222), height: 1.64, fontFamily: 'NotoSansKR-Regular')),
                        )
                    ),
                  )
              ),
            ),
          ],
        ), //Color(0xff222222)
      );
    } else {
      revealWidget = SizedBox.shrink();
    }
  }

  GetRevealWindow(bool _targetGender, int _targetGanjiPosNum, bool _targetCheongan, int _targetGanjiNum, int _targetSajuNum, String _targetYugchinString, int _targetSibiunseongNum) {

    return;
    if(((personalDataManager.etcData % 100000000) / 10000000).floor() == 2) {
      targetGender = _targetGender;
      targetCheongan = _targetCheongan;
      targetGanjiPosNum = _targetGanjiPosNum;
      targetSajuNum = _targetSajuNum;
      targetGanjiNum = _targetGanjiNum;
      targetYugchinString = _targetYugchinString;
      targetSibiunseongNum = _targetSibiunseongNum;

      if (saveDataManager.revealTypeNum == 0) {
        revealTypeString = '간단히';
      } else {
        revealTypeString = '자세히';
      }

      SetRevealText();
      SetRevealWidget();

      //WidgetsBinding.instance!.addPostFrameCallback((_){
      //  revealScrollController.jumpTo(revealScrollController.position.minScrollExtent);
      //});

      return revealWidget;
    } else {
      return SizedBox.shrink();
    }
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