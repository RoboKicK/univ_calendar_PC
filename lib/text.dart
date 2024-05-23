List<List<int>> listSeasonData = [];  //절기 절입시간 데이터
List<List<int>> listLunNday = []; //음력 월별 일수 데이터
List<int> listSummerTime = [];  //썸머타임 일광시간절약제 데이터
List<int> listSolNday = [31,28,31,30,31,30,31,31,30,31,30,31];


List<String> listCheonGanString = ['갑','을','병','정','무','기','경','신','임','계'];
List<String> listJijiString = ['자','축','인','묘','진','사','오','미','신','유','술','해'];

int stanYear = 1901;
//int stanMonth = 1;
//int stanDay = 1;

int stanYeonganNum = 7; //1901년 '신'부터 시작
int stanYeonjiNum = 1;  //1901년 '축'부터 시작
int stanWolganNum = 5;  //1901년 1월 '기'부터 시작
int stanWoljiNum = 1;  //1901년 1월 '축'부터 시작
int stanIlganNum = 5;  //1901년 1월 1일 '기'부터 시작
int stanIljiNum = 3;      //1901년 1월 1일 '묘'부터 시작

SolarToLunar(int _targetYear, int _targetMonth, int _targetDay){
  int targetYear = _targetYear;
  int targetMonth = _targetMonth;
  int targetDay = _targetDay;
  int days = -49;

  for(int i = 0; i < targetYear - stanYear; i++){ //targetYear의 전년도 까지의 날짜 수 계산
    for(int j = 0; j < listSolNday.length; j++){
      days = days + listSolNday[j];
      if(((i + 1) % 4 == 0) && j == 1){ //2월 윤달에 하루 더함
        days++;
      }
    }
  }
  for(int i = 0; i < (targetMonth - 1); i++){ //당해의 전월까지 계산
    days = days + listSolNday[i];
    if(((targetYear) % 4 == 0) && i == 1){ //2월 윤달에 하루 더함
      days++;
    }
  }

  days = days + targetDay;

  //여기까지가 총 일수 계산

  int lunYear = 1901;
  int lunMonth = 0, lunDay = 0;

  int lunNdayYear = 0, lunNdayMonth = 0;

  while(true){
    if(days > listLunNday[lunNdayYear][lunNdayMonth]){
      days = days - listLunNday[lunNdayYear][lunNdayMonth];

      lunNdayMonth++;
      if(lunNdayMonth > listLunNday[0].length){
        lunNdayMonth = 0;
        lunNdayYear++;
      }
    } else {
      break;
    }
  }

  lunYear = lunYear + lunNdayYear;
  lunMonth = (lunNdayMonth * 0.5).floor() + 1;
  lunDay = days;

  List<int> listLunarBirth = [lunYear, lunMonth, lunDay, lunNdayMonth % 2 == 0? 0:1]; //마지막 변수는 윤월 표시
  print(listLunarBirth);

}