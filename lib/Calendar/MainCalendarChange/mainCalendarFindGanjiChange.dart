import '../../../findGanji.dart' as findGanji;
import '../../../style.dart' as style;

class MainCalendarFindGanjiChange{

  int startYear = 1900;
  int startCheongan = 6, startJiji = 0; //1900년 연주 경자부터 시작

  //1901년~2049년 사이의 특정 간지일을 찾음
  List<List<int>> FindGanjiChange(List<int> listPalja){ //0연간, 1연지, 2월지, 3일간, 4일지, 5시지

    List<int> listCandYear =[]; //특정 연도 후보군

    //1900년 이후 가장 가까운 천간을 찾음
    int disYearCheongan = (listPalja[0] - startCheongan + style.stringCheongan[0].length) % style.stringCheongan[0].length; //연간이 같은 첫번째 해와의 차이
    int nowJiji = startJiji + disYearCheongan;  //연간이 같은 첫번째 해의 지지
    int disYearJiji = 0;  //
    while(true){
      if(nowJiji == listPalja[1]){
        break;
      }
      else{
        disYearJiji++;
        nowJiji = (nowJiji + 10) % style.stringJiji[0].length;
      }
    }

    if(startYear + disYearCheongan + (disYearJiji * 10) < 1901){
      listCandYear.add(startYear + disYearCheongan + (disYearJiji * 10) + 60);
    }
    else{
      listCandYear.add(startYear + disYearCheongan + (disYearJiji * 10));
    }

    int count = 0;
    while(true){
      if(listCandYear[count] + 60 < 2050){
        listCandYear.add(listCandYear[count] + 60);
      }
      else{
        break;
      }
      count++;
    }
    //여기까지가 연주 찾기

    List<List<int>> listGanjiDay = [];  //간지변환 날짜
    for(int j = 0; j < listCandYear.length; j++) {    //연주가 같은 후보군 만큼 반복
      int seasonStartData, seasonEndData;
      int seasonStartYear, seasonEndYear;
      int seasonStartMonth, seasonEndMonth;

      //해당 월의 절기 시작과 끝 데이터 찾기
      if (listPalja[2] == 0) { //자월 생이면 당해 12월과 다음 해 1월까지
        seasonStartData = findGanji.listSeasonData[listCandYear[j] - findGanji.stanYear][11];
        seasonEndData = findGanji.listSeasonData[listCandYear[j] - findGanji.stanYear + 1][0];
      }
      else if (listPalja[2] == 1) { //축월 생이면 다음 해 1월로 넘어간다
        seasonStartData = findGanji.listSeasonData[listCandYear[j] - findGanji.stanYear + 1][0];
        seasonEndData = findGanji.listSeasonData[listCandYear[j] - findGanji.stanYear + 1][1];
      }
      else { //인월 ~ 해월 생이면
        seasonStartData = findGanji.listSeasonData[listCandYear[j] - findGanji.stanYear][(listPalja[2] - 1 + style.stringJiji[0].length) % style.stringJiji[0].length];
        seasonEndData = findGanji.listSeasonData[listCandYear[j] - findGanji.stanYear][(listPalja[2] - 1 + style.stringJiji[0].length + 1) % style.stringJiji[0].length];
      }
      //해당 월의 시작 연도와 끝 연도 찾기
      if (listPalja[2] == 0) { //자월 생이면 당해에 시작해서 다음 해에 끝
        seasonStartYear = listCandYear[j];
        seasonEndYear = listCandYear[j] + 1;
      }
      else if (listPalja[2] == 1) { //축월 생이면 다음 해에 시작하고 끝
        seasonStartYear = listCandYear[j] + 1;
        seasonEndYear = listCandYear[j] + 1;
      }
      else { //인월 ~ 해월 생이면 당해에 시작과 끝
        seasonStartYear = listCandYear[j];
        seasonEndYear = listCandYear[j];
      }
      //해당 월과 다음 월 찾기
      if (listPalja[2] == 0) { //자월 생이면 당해 12월과 다음 해 1월까지
        seasonStartMonth = 12;
        seasonEndMonth = 1;
      }
      else if (listPalja[2] == 1) { //축월 생
        seasonStartMonth = 1;
        seasonEndMonth = 2;
      }
      else { //인월 ~ 해월 생이면
        seasonStartMonth = listPalja[2];
        seasonEndMonth = listPalja[2] + 1;
      }

      int seasonStartDay = (seasonStartData / 10000).floor();
      int seasonStartHour = ((seasonStartData % 10000) / 100).floor();
      int seasonStartMin = seasonStartData % 100;

      int seasonEndDay = (seasonEndData / 10000).floor();
      int seasonEndHour = ((seasonEndData % 10000) / 100).floor();
      int seasonEndMin = seasonEndData % 100;

      List<int> guessPalja = findGanji.InquireGanji(seasonStartYear, seasonStartMonth, seasonStartDay, -2, -2); //절기 시작 팔자에서부터 비교하여 찾아낸다

      disYearCheongan = (listPalja[3] - guessPalja[4] + style.stringCheongan[0].length) % style.stringCheongan[0].length; //일간의 차이를 구함
      nowJiji = startJiji + disYearCheongan;  //일간의 차이만큼 지지를 뺌

      int finalYear = -2,
          finalMonth = -2,
          finalDay = -2,
          finalHour = -2,
          finalMin = -2;  //최종 날짜

      int solNday = 0;

      for (int i = 0; i < 4; i++) {
        if ((guessPalja[5] + nowJiji + (10 * i)) % style.stringJiji[0].length == listPalja[4]) { //지지가 같고
          if(seasonStartMonth - 1 == 1 && seasonStartYear % 4 == 0){  //2월 윤월 처리
            solNday = 29;
          }
          else{
            solNday = findGanji.listSolNday[seasonStartMonth - 1];
          }
          if (((10 * i) + seasonStartDay + nowJiji) <= solNday) { //절기 시작 월과 같으면
            finalYear = seasonStartYear;
            finalMonth = seasonStartMonth;
            if (((10 * i) + seasonStartDay + nowJiji) == seasonStartDay) { //절기 당일이면 절입시간까지 검사
              if (listPalja[5] == -2) { //시간 모름이면
                finalDay = nowJiji + (10 * i) + seasonStartDay;
              }
              else { //시지를 정했으면
                if (((listPalja[5] * 2) + 1) * 100 + 30 > ((seasonStartHour * 100) + seasonStartMin)) { //절입시간보다 늦은 시간을 선택했으면
                  finalDay = nowJiji + (10 * i) + seasonStartDay;

                  finalHour = (listPalja[5] * 2) + 1;
                  finalMin = 29;
                }
                else { //절입시간 이전으로 시간을 선택했으면
                  finalDay = -2;
                }
              }
            }
            else { //절기 당일이 아니면 날짜와 시지 정함
              finalDay = nowJiji + (10 * i) + seasonStartDay;
              if(listPalja[5] != -2){
                finalHour = (listPalja[5] * 2);
                finalMin = 30;
              }
            }
          }
          else if ((((10 * i) + seasonStartDay + nowJiji) > solNday) &&
              ((((10 * i) + seasonStartDay + nowJiji) % solNday) <= seasonEndDay)) { //절기 시작 월의 다음 달로 넘어가면
            finalYear = seasonEndYear;
            finalMonth = seasonEndMonth;
            if ((((10 * i) + seasonStartDay + nowJiji) % solNday) == seasonEndDay) { //다음 절기 당일이면 절입시간까지 검사
              if (listPalja[5] == -2) { //시간 모름이면
                finalDay = ((10 * i) + seasonStartDay + nowJiji) % solNday;
              }
              else { //시지를 정했으면
                if (((listPalja[5] * 2) - 1) * 100 + 30 < ((seasonEndHour * 100) + seasonEndMin)) { //절입시간보다 이른 시간을 선택했으면
                  finalDay = ((10 * i) + seasonStartDay + nowJiji) % solNday;
                  if(seasonEndMin == 0){
                    if(seasonEndHour == 0){
                      finalDay--;
                      finalHour = 23;
                      finalMin = 59;
                    }
                    else{
                      finalHour = seasonEndHour - 1;
                      finalMin = 59;
                    }
                  }
                  else{
                    if(listPalja[5] == 0){
                      finalHour = 0;
                      finalMin = 0;
                    }
                    else{
                      finalHour = (listPalja[5] * 2) - 1;
                      finalMin = 30;
                    }

                  }
                }
                else { //절입시간 이후로 시간을 선택했으면
                  finalDay = -2;
                }
              }
            }
            else { //다음 절기 당일이 아니면 날짜와 시지 입력
              finalDay = (nowJiji + (10 * i) + seasonStartDay) % solNday;
              if(listPalja[5] != -2){
                finalHour = (listPalja[5] * 2);
                finalMin = 30;
              }
            }
          }
        }
      }

      if(finalDay != -2){
        listGanjiDay.add([finalYear, finalMonth, finalDay, finalHour, finalMin]);
      }
    }

    return listGanjiDay;  //연, 월, 일, 시, 분 순임
  }
}