//class FindGanji{

  List<List<int>> listSeasonData = [];  //절기 절입시간 데이터
  List<List<int>> listLunNday = []; //음력 월별 일수 데이터
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

  LunarToSolar(int _targetYear, int _targetMonth, int _targetDay, bool isLeap){
    int targetYear = _targetYear;
    int targetMonth = _targetMonth;
    int targetDay = _targetDay;
    int days = 49;

    if(listLunNday[targetYear - stanYear][((targetMonth - 1) * 2) + 1] > 0){  //윤월인지 확인
      //isLeap = true;
      //print('Leap');
    }

    for(int i = 0; i < targetYear - stanYear; i++){ //당해 전년도만큼 계산
      for(int j = 0; j < listLunNday[i].length; j++){
        days = days + listLunNday[i][j];
      }
    }
    int leapMonth = 0;
    if(isLeap == false){
      leapMonth = (targetMonth * 2) - 3;
    }
    else{
      leapMonth = (targetMonth * 2) - 2;
    }

    for(int i = 0; i <= leapMonth; i++){ //당해의 전월까지 계산
      days = days + listLunNday[targetYear - stanYear][i];
    }
    days = days + targetDay;

    //여기까지가 총 일수 계산

    int solYear = 1901;
    int solMonth = 0, solDay = 0;

    while(days > 366){
      if(solYear % 4 != 0){
        solYear++;
        days = days - 365;
      }
      else{
        solYear++;
        days = days - 366;
      }
    }
    if(solYear % 4 != 0 && days > 366){
      solYear++;
      days = days - 365;
    }
    else if (solYear % 4 == 0 && days > 367){
      solYear++;
      days = days - 366;
    }
    //print(solYear);
    while(true){
      if(days > listSolNday[solMonth]){
        days = days - listSolNday[solMonth];
        solMonth++;
      }
      else{
        break;
      }
    }
    solMonth++;
    solDay = days;

    List<int> listSolarBirth = [solYear, solMonth, solDay];
    return listSolarBirth;
  }

  List<int> InquireGanji(int _targetYear, int _targetMonth, int _targetDay, int _targetHour, int _targetMin){
    int targetYear = _targetYear;
    int targetMonth = _targetMonth;
    int targetDay = _targetDay;
    int targetHour, targetMin;
    if(_targetHour != -2){  //시간 모름이 아니면
      targetHour = _targetHour;
      targetMin = _targetMin;
    }
    else{ //시간 모름이면
      targetHour = 12;
     targetMin = 12;
    }

    bool isSeasonBefore = false;  //절입시간 전인지 표시

    if((targetDay == (listSeasonData[targetYear - stanYear][targetMonth - 1]/10000).floor()) &&
        (targetHour * 100 + targetMin < (listSeasonData[targetYear - stanYear][targetMonth - 1] % 10000))){  //절입시간 들어있는 날이고 절입시간 전에 태어났으면
      isSeasonBefore = true;
    }

    List<int> ganji = [];

    int yeonGan= stanYeonganNum;
    int yeonJi = stanYeonjiNum;
    int wolGan = stanWolganNum;
    int wolJi = stanWoljiNum;
    int ilGan = stanIlganNum;
    int ilJi = stanIljiNum;

    int yearCycle = 0;
    while(yearCycle < targetYear - stanYear){ //연주 찾기
      yeonGan++;
      yeonJi++;

      yearCycle++;
    }

    yeonGan= yeonGan%listCheonGanString.length;
    yeonJi = yeonJi%listJijiString.length;

    //월주 찾기
    for(int i = 0; i < yearCycle; i++){
      wolGan+= 12;
      wolJi+= 12;
    }
    wolGan += targetMonth - 1;
    wolJi += targetMonth - 1;

    wolGan = wolGan%listCheonGanString.length;
    wolJi = wolJi%listJijiString.length;

    if(isSeasonBefore == true){ //절입시간이 있는 날에 태어났고 절입시간 전에 태어났으면 월주 하나 뺌
      wolGan = (wolGan + listCheonGanString.length - 1)%listCheonGanString.length;
      wolJi = (wolJi + listJijiString.length - 1)%listJijiString.length;
      if(targetMonth < 3){  //입춘 전이면 연주도 하나 뺌
        yeonGan = (yeonGan + listCheonGanString.length - 1) %listCheonGanString.length;
        yeonJi = (yeonJi + listJijiString.length - 1)%listJijiString.length;
      }
    }
    else if(targetMonth == 1 || (targetMonth == 2 && targetDay < (listSeasonData[targetYear - stanYear][targetMonth - 1]/10000).floor())){ //입춘 전날에 태어났으면 연주만 하나 뺌
      yeonGan = (yeonGan + listCheonGanString.length - 1) %listCheonGanString.length;
      yeonJi = (yeonJi + listJijiString.length - 1)%listJijiString.length;
    }
    if(targetDay < (listSeasonData[targetYear - stanYear][targetMonth - 1]/10000).floor()){ //절입시간 들어있는 날 전에 태어났으면
      wolGan = (wolGan + listCheonGanString.length - 1)%listCheonGanString.length;
      wolJi = (wolJi + listJijiString.length - 1)%listJijiString.length;
    }
    
    //일주 찾기
    for(int i = 0; i < yearCycle; i++){
      if((i + 1) % 4 != 0){
        ilGan += 365;
        ilJi += 365;
      }
      else{
        ilGan += 366;
        ilJi += 366;
      }
    }
    int dayCycle = 0;
    int days = 0;
    while(dayCycle < targetMonth - 1){
      if(dayCycle == 1 && targetYear%4 == 0){
        days = days + listSolNday[dayCycle] + 1;
      }
      else {
        days = days + listSolNday[dayCycle];
      }

      dayCycle++;
    }
    ilGan += days + targetDay - 1;
    ilJi += days + targetDay - 1;

    if(targetHour == 23 && targetMin >= 30){  //23:30 이후 출생은 다음날로 본다
      ilGan = (ilGan + 1)%listCheonGanString.length;
      ilJi = (ilJi + 1)%listJijiString.length;
    }
    else{
      ilGan = ilGan%listCheonGanString.length;
      ilJi = ilJi%listJijiString.length;
    }

    //시주 찾기
    int editedTime = (((targetHour + ((targetMin + 30)/60) ) / 2).floor()) % 12;

    int siGan = ((ilGan % 5) * 2 + editedTime) % listCheonGanString.length;
    //if(ilGan % 2 == 1)
    //  siGan = siGan+2;
    int siJi = editedTime % listJijiString.length;

    if(_targetHour != -2){  //시간모름이 아니면
      ganji = [yeonGan, yeonJi, wolGan, wolJi, ilGan, ilJi, siGan, siJi];
    }
    else{
      ganji = [yeonGan, yeonJi, wolGan, wolJi, ilGan, ilJi, -2, -2];
    }
    return ganji;
  }

  FindGanjiData(){
    listSeasonData.add([060853,042040,061511,052044,061450,061937,080608,081546,081810,090907,081135,080835]); //1901년
    listSeasonData.add([061452,050238,062108,060238,062039,070120,081146,082122,082347,091445,081718,080941]);
    listSeasonData.add([062044,050831,070259,060826,070225,070707,081737,090816,090542,092042,082313,081535]);
    listSeasonData.add([070237,051424,060852,051419,060819,061301,072332,080912,081138,090236,080505,072125]);
    listSeasonData.add([060827,042016,061446,052015,061414,061854,080520,081457,081722,090820,081050,080311]);
    listSeasonData.add([061414,050204,062036,060207,062009,070049,081115,082052,082316,091415,081647,080910]);
    listSeasonData.add([062011,050759,070227,060755,070154,070633,081659,090236,090502,092003,082236,081500]);
    listSeasonData.add([070201,051347,060814,051340,060738,061219,072248,080827,081052,090151,080422,072044]);
    listSeasonData.add([060745,041933,061401,051930,061331,061814,080444,081423,081647,090743,081013,080235]);
    listSeasonData.add([061338,050127,061957,060123,061919,062356,081021,081957,082222,091321,081554,080817]); //1910년
    listSeasonData.add([061921,050710,070139,060705,070100,070538,081605,090144,090413,091915,082147,081408]);
    listSeasonData.add([070108,051254,060721,051248,060647,061128,072157,080737,081006,090107,080339,071959]);
    listSeasonData.add([060658,041843,061309,051836,061235,061714,080339,081316,081542,090644,080918,080141]);
    listSeasonData.add([061243,050029,061856,060022,061820,062300,080927,081905,082130,091235,081511,080737]);
    listSeasonData.add([061840,050625,070048,060609,070003,070440,081508,090048,090317,091821,082058,081324]);
    listSeasonData.add([070028,051214,060637,051158,060550,061026,072054,080635,080905,090008,080242,071906]);
    listSeasonData.add([060610,041758,061225,051750,061146,061623,080250,081230,081459,090602,080837,080101]);
    listSeasonData.add([061204,042353,061821,052345,061738,062211,080832,081808,082036,091140,081419,080647]);
    listSeasonData.add([061752,050539,070006,060529,062322,070357,081421,082358,090228,091733,082012,081238]);
    listSeasonData.add([062341,051127,060551,051115,060511,060950,072019,080558,080827,082329,080205,071830]); //1920년
    listSeasonData.add([060534,041721,061146,051709,061104,061542,080207,081144,081410,090511,080746,080012]);
    listSeasonData.add([061117,042306,061734,052258,061653,062130,080758,081737,082006,091109,081345,080611]);
    listSeasonData.add([061714,050500,062325,060446,062238,070314,081342,082325,090157,091703,081940,081205]);
    listSeasonData.add([062306,051050,060513,051033,060426,060902,071930,080512,080746,082252,080129,071753]);
    listSeasonData.add([060453,041637,061100,051623,061018,061456,080125,081107,081340,090447,080726,072352]);
    listSeasonData.add([061054,042238,061700,052218,061608,062042,080706,081644,081916,091025,081308,080539]);
    listSeasonData.add([061645,050430,062250,060406,062153,070225,081250,082231,090106,091616,081857,081126]);
    listSeasonData.add([062231,051016,060437,050955,060344,060817,071844,080428,080702,082210,080050,071717]);
    listSeasonData.add([060422,041609,061032,051551,060940,061411,080032,081009,081240,090347,080628,072256]);
    listSeasonData.add([061003,042151,061617,052137,061527,061958,080620,081557,081828,090938,081220,080451]);  //1930년
    listSeasonData.add([061556,050341,062202,060320,062110,070142,081206,082145,090007,091527,081810,081040]);
    listSeasonData.add([062145,050929,060349,050906,060255,060728,071752,080332,080603,082110,072350,071618]);
    listSeasonData.add([060323,041509,060931,051451,060842,061317,072344,080926,081158,090304,080543,072211]);
    listSeasonData.add([060917,042104,061526,052044,061431,061901,080524,081504,081736,090845,081127,080357]);
    listSeasonData.add([061502,050249,062110,060226,062012,070042,081106,082048,082324,091436,081718,080945]);
    listSeasonData.add([062047,050829,060249,050807,060157,060631,071658,080243,080521,082032,072315,071542]);
    listSeasonData.add([060244,041426,060844,051401,060751,061223,072246,080825,081059,090211,080455,072126]);
    listSeasonData.add([060831,042015,061434,051949,061335,061807,080431,081413,081648,090801,081048,080322]);
    listSeasonData.add([061428,050210,062026,060137,061921,062352,081018,082004,082242,091357,081644,080917]);
    listSeasonData.add([062024,050808,060224,050735,060116,060544,071608,080152,080429,081942,072227,071458]);  //1940
    listSeasonData.add([060204,041350,060810,051325,060710,061139,072203,080746,081024,090138,080424,072056]);
    listSeasonData.add([060802,041949,061409,051924,061307,061733,080352,081330,081606,090722,081011,080247]);
    listSeasonData.add([061355,050140,061959,060111,061853,062319,080939,081919,082155,091311,081559,080833]);
    listSeasonData.add([061939,050723,060140,050654,060040,060511,071536,080119,080356,081909,072155,071428]);
    listSeasonData.add([060134,041319,060738,051252,060637,061105,072127,080705,080938,090049,080334,072008]);
    listSeasonData.add([060716,041904,061325,051839,061222,061649,080311,081252,081527,090641,080927,080200]);
    listSeasonData.add([061306,050050,061908,060020,061803,062231,080856,081841,082121,091237,081524,080756]);
    listSeasonData.add([061900,050642,060058,050609,052352,060420,071444,080027,080305,081820,072107,071338]);
    listSeasonData.add([060041,041223,060639,051152,060537,061007,072032,080616,080855,090011,080300,071933]);
    listSeasonData.add([060639,041821,061235,051745,061125,061552,080214,081156,081434,090552,080844,080122]);  //1950
    listSeasonData.add([061230,050013,061827,052333,061709,062133,080754,081737,082018,091136,081427,080702]);
    listSeasonData.add([061810,050553,060007,050515,052254,060320,071345,072331,080214,081732,072022,071256]);
    listSeasonData.add([060002,041146,060602,051113,060452,060916,071935,080515,080753,082310,080201,071837]);
    listSeasonData.add([060545,041731,061149,051659,061038,061501,080119,081059,081338,090457,080751,080029]);
    listSeasonData.add([061136,042318,061731,052239,061618,062043,080706,081650,081932,091052,081345,080623]);
    listSeasonData.add([061730,050512,052324,050431,052210,060236,071258,072240,080119,081637,071926,071202]);
    listSeasonData.add([052310,041055,060510,051019,060359,060825,071848,080432,080712,082230,080120,071756]);
    listSeasonData.add([060504,041649,061105,051612,060949,061412,080033,081017,081259,090419,080712,072350]);
    listSeasonData.add([061058,042242,061657,052203,061539,062000,080620,081604,081848,091010,081302,080537]);
    listSeasonData.add([061642,050423,052236,050344,052123,060149,071213,072200,080045,081609,071902,071138]);  //
    listSeasonData.add([052243,041022,060435,050942,060321,060746,071807,080348,080629,082151,080046,071726]);
    listSeasonData.add([060435,041617,061030,051534,060910,061331,072351,080934,081215,090338,080635,072317]);
    listSeasonData.add([061026,042208,061617,052119,061452,061914,080538,081525,081812,090936,081232,080513]);
    listSeasonData.add([061622,050405,052216,050318,052051,060112,071132,072116,072359,081522,071815,071053]);
    listSeasonData.add([052202,040946,060401,050907,060242,060702,071721,080305,080548,082111,080007,071646]);
    listSeasonData.add([060354,041538,060951,051457,060830,061250,072307,080849,081132,090257,080555,072238]);
    listSeasonData.add([060948,042131,061542,052045,061417,061836,080453,081435,081718,090841,081137,080418]);
    listSeasonData.add([061526,050307,052118,050221,051956,060019,071042,072027,072311,081434,071729,071008]);
    listSeasonData.add([052117,040859,060311,050815,060150,060612,071632,080214,080455,082017,072311,071551]);
    listSeasonData.add([060302,041446,060858,051402,060734,061152,072211,080754,081038,090202,080458,072137]);  //1970
    listSeasonData.add([060845,042025,061435,051936,061308,061729,080351,081340,081630,090759,081057,080336]);
    listSeasonData.add([061442,050220,052028,050129,051901,052322,070943,071929,072215,081342,071639,070919]);
    listSeasonData.add([052025,040804,060213,050714,060046,060507,071527,080113,080359,081927,072228,071510]);
    listSeasonData.add([060220,041400,060807,051305,060634,061052,072111,080657,080945,090115,080418,072105]);
    listSeasonData.add([060818,041959,061406,051902,061227,061642,080259,081245,081533,090702,081003,080246]);
    listSeasonData.add([061357,050139,051948,050046,051814,052231,070851,071838,072128,081258,071559,070841]);
    listSeasonData.add([051951,040733,060144,050646,060016,060432,071448,080030,080316,081844,072146,071431]);
    listSeasonData.add([060143,041327,060738,051239,060609,061023,072037,080618,080902,090031,080334,072020]);
    listSeasonData.add([060732,041912,061320,051818,061147,061605,080225,081211,081500,090630,080933,080218]);
    listSeasonData.add([061329,050109,051917,050015,051745,052204,070824,071809,072053,081219,071518,070801]);  //1980
    listSeasonData.add([051913,040655,060105,050605,052335,060353,071412,072357,080243,081810,072109,071351]);
    listSeasonData.add([060103,041245,060655,051153,060520,060936,071955,080542,080832,090002,080304,071948]);
    listSeasonData.add([060659,041840,061247,051744,061111,061526,080143,081130,081420,090551,080852,080134]);
    listSeasonData.add([061241,050019,051825,042322,051651,052109,070729,071718,072010,081143,071446,070728]);
    listSeasonData.add([051835,040612,060016,050514,052243,060300,071319,072304,080153,081725,072029,071316]);
    listSeasonData.add([060028,041208,060612,051106,060431,060844,071901,080444,080735,082307,080213,071901]);
    listSeasonData.add([060613,041752,061154,051644,061006,061419,080039,081029,081324,090500,080806,080052]);
    listSeasonData.add([061204,042343,051747,042239,051602,052015,070633,071620,071912,081045,071349,070634]);
    listSeasonData.add([051746,040527,052334,050430,052154,060205,071219,072204,080054,081627,071934,071221]);
    listSeasonData.add([052333,041114,060519,051013,060335,060746,071800,080346,080637,082214,080123,071814]);  //1990
    listSeasonData.add([060528,041708,061112,051605,060927,061338,072353,080937,081227,090401,080708,072356]);
    listSeasonData.add([061109,042248,051652,042145,051509,051922,070540,071527,071818,080951,071257,070544]);
    listSeasonData.add([051657,040437,052243,050337,052102,060115,071132,072118,080008,081540,071846,071134]);
    listSeasonData.add([052248,041031,060438,050932,060254,060705,071719,080304,080555,082129,080036,071723]);
    listSeasonData.add([060434,041613,061016,051508,060830,061243,072301,080852,081149,090327,080636,072322]);
    listSeasonData.add([061031,042208,051610,042102,051426,051841,070500,071449,071742,080919,071227,070514]);
    listSeasonData.add([051624,040402,052204,050256,052019,060033,071049,072036,072329,081505,071815,071105]);
    listSeasonData.add([052218,040957,060357,050845,060203,060613,071630,080220,080516,082056,080008,071702]);
    listSeasonData.add([060417,041557,060958,051445,060801,061209,072225,080814,081110,090248,080558,072247]);
    listSeasonData.add([061000,042140,051542,042031,051350,051758,070413,071402,071659,080838,071147,070436]);  //2000
    listSeasonData.add([051549,040328,052132,050224,051944,052353,071006,071952,072246,081424,071736,071028]);
    listSeasonData.add([052143,040923,060327,050818,060137,060544,071556,080139,080430,082009,072321,070614]);
    listSeasonData.add([060327,041505,060904,051352,060710,061119,072135,080724,081020,090200,080512,072204]);
    listSeasonData.add([060918,042055,051455,041943,051302,051713,070331,071319,071612,080749,071058,070348]);
    listSeasonData.add([051502,040242,052044,050134,051852,052301,070916,071903,072156,081333,071642,070932]);
    listSeasonData.add([052046,040827,060228,050715,060030,060436,071451,080040,080338,081921,072234,071526]);
    listSeasonData.add([060239,041417,060817,051304,060620,061026,072041,080630,080929,090111,080423,072113]);
    listSeasonData.add([060824,042000,051358,041845,051203,051611,070226,071215,071513,080656,071010,070302]);
    listSeasonData.add([051413,040149,051947,050033,051750,052158,070813,071800,072057,081239,071555,070851]);
    listSeasonData.add([052008,040747,060146,050630,052343,060349,071402,072348,080244,081826,072142,071438]);  //2010
    listSeasonData.add([060154,041332,060729,051211,060522,060926,071941,080533,080833,090018,080334,072028]);
    listSeasonData.add([060743,041922,051320,041805,051119,051525,070140,071130,071428,080611,070925,070218]);
    listSeasonData.add([051333,040113,051914,050002,051717,052122,070734,071719,072015,081158,071513,070808]);
    listSeasonData.add([051923,040702,060101,050546,052259,060302,071314,072302,080201,081747,072106,071403]);
    listSeasonData.add([060120,041258,060655,051138,060452,060857,071911,080500,080759,082342,080258,071952]);
    listSeasonData.add([060707,041845,051243,041727,051041,051448,070102,071052,071350,080532,070847,070140]);
    listSeasonData.add([051255,040033,051832,042316,051630,052036,070650,071639,071938,081121,071437,070732]);
    listSeasonData.add([051848,040628,060027,050512,052224,060228,071241,072230,080129,081714,072031,071325]);
    listSeasonData.add([060038,041213,060609,051050,060402,060805,071820,080412,080716,082305,080223,071917]);
    listSeasonData.add([060629,041802,051156,041637,050950,051357,070013,071005,071307,080454,070813,070108]);  //2020
    listSeasonData.add([051222,032358,051753,042234,051546,051951,070604,071553,071852,081038,071358,070656]);
    listSeasonData.add([051813,040550,052343,050419,052125,060125,071137,072128,080031,081621,071944,071245]);
    listSeasonData.add([060004,041141,060535,051012,060318,060717,071730,080322,080626,082214,080135,071832]);
    listSeasonData.add([060548,041726,051122,041601,050909,051309,062319,070908,071210,080359,070719,070016]);
    listSeasonData.add([051132,032309,051706,042147,051456,051855,070504,071450,071751,080940,071303,070603]);
    listSeasonData.add([051722,040501,052258,050339,052048,060047,071056,072042,072340,081528,071851,071151]);
    listSeasonData.add([052309,041045,060438,050916,060224,060625,071636,080226,080527,082116,080037,071736]);
    listSeasonData.add([060453,041630,051024,041502,050811,051215,062229,070820,071121,080307,070626,062323]);
    listSeasonData.add([051041,032220,051616,042057,051407,051809,070421,071411,071711,080857,071216,070513]);
    listSeasonData.add([051629,040407,052202,050240,051945,052343,070954,071946,072252,081444,071807,071106]);  //2030
    listSeasonData.add([052222,040957,060350,050827,060134,060534,071548,080142,080449,082042,080004,071702]);
    listSeasonData.add([060415,041548,050939,041416,050725,051127,062140,070731,071037,080229,070553,062252]);
    listSeasonData.add([051007,032140,051531,042007,051312,051712,070324,071314,071619,080813,071140,070444]);
    listSeasonData.add([051603,040340,052131,050205,051908,052305,070916,071908,072213,081406,071732,071035]);
    listSeasonData.add([052154,040930,060320,050752,060054,060449,071500,080053,080401,081956,072322,071624]);
    listSeasonData.add([060342,041519,050910,041345,050648,051046,062056,070648,070954,080148,070513,062215]);
    listSeasonData.add([050933,032110,051505,041943,051248,051645,070254,071242,071544,080736,071103,070406]);
    listSeasonData.add([051525,040302,052054,050128,051830,052224,070831,071820,072125,081320,071649,070955]);
    listSeasonData.add([052115,040851,060242,050714,060017,060414,071425,080017,080323,081916,072241,071544]);
    listSeasonData.add([060302,041438,050830,041304,050608,051007,062018,070609,070913,080104,070428,062129]);  //2040
    listSeasonData.add([050847,032024,051416,041851,051153,051548,070157,071147,071452,080645,071012,070314]);
    listSeasonData.add([051434,040211,052004,050039,051741,052137,070746,071737,072044,081239,071606,070908]);
    listSeasonData.add([052024,040757,060146,050619,052321,060317,071326,072319,080229,081826,072154,071456]);
    listSeasonData.add([060211,041343,050730,041202,050504,050902,061914,070507,070815,080012,070340,062044]);
    listSeasonData.add([050801,031935,051323,041756,051058,051455,070107,071058,071404,080559,070928,070234]);
    listSeasonData.add([051354,040130,051916,042343,051639,052031,070639,071632,071942,081141,071513,070820]);
    listSeasonData.add([051941,040716,060104,050531,052227,060219,071229,072224,080137,081736,072106,071409]);
    listSeasonData.add([060128,041303,050653,041124,050423,050817,061825,070417,070726,072325,070255,061959]);
    listSeasonData.add([050717,031852,051241,041713,051011,051402,070007,070956,071304,080503,070837,070145]);
    listSeasonData.add([051306,040042,051831,042302,051600,051953,070600,071551,071859,081059,071432,070740]);

    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);  //1901년부터
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 29, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 30, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 29, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 29, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 29, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 29, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 29, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 30, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 30, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 30, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 30, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 30, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 29, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 30, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 30, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 29, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 29, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 29, 30, 0, 29, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 30, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 29, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 29, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 29, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 29, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 29, 30, 0, 29, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 29, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 30, 0, 29, 29, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 29, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 29, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 30, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 29, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 29, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 29, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 30, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 30, 0, 29, 0, 30, 0, 30, 29, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 29, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 29, 30, 0, 29, 0, 30, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 30, 0, 29, 30, 29, 0, 30, 0, 29, 0, 29, 0, 30, 0, 29, 0, 30, 0]);
    listLunNday.add([29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 29, 0, 29, 0]);
    listLunNday.add([30, 0, 29, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 30, 0, 29, 0, 30, 0, 29, 0]);
  }
//}