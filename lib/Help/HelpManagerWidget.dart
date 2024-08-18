import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart' as style;
import 'package:url_launcher/url_launcher.dart';

class HelpManagerWidget extends StatefulWidget {
  const HelpManagerWidget({super.key, required this.showHelpPage});

  final showHelpPage;

  @override
  State<HelpManagerWidget> createState() => _HelpManagerWidget();
}

class _HelpManagerWidget extends State<HelpManagerWidget> {
  double widgetWidth = 500;
  double widgetHeight = 560+46+56;  //기본 사이즈 + 설정 공유 + 테마

  Future<void> launchWebView(String url) async {
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height - style.appBarHeight <= 560){
      widgetHeight = MediaQuery.of(context).size.height - 120;
    }

    return Container(
      width: widgetWidth,
      height: widgetHeight,
      decoration: BoxDecoration(
        color: style.colorBackGround.withOpacity(0.98),
        borderRadius: BorderRadius.circular(style.textFiledRadius),
      ),
      child: Stack(
        children:
        [
          Container(
            width: widgetWidth,
            height: widgetHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(style.textFiledRadius),
            ),
            child: Column(
              children: [
                Container(  //도움말 제목
                  width: style.UIButtonWidth,
                  height: style.fullSizeButtonHeight,
                  alignment: Alignment.center,
                  child:Text('도움말', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                ),
                Container(
                    width: (widgetWidth - (style.UIMarginLeft * 2)),
                    height: 100,
                    margin: EdgeInsets.only(bottom: style.UIMarginLeft * 2, top: style.UIMarginLeft),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                      color: style.colorYellow,
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        launchWebView("https://m.blog.naver.com/elflucia77");
                      },
                      child: Text("루시아 원 블로그 방문하기", style: TextStyle(color : Colors.white, fontSize: 26, fontWeight: FontWeight.w500, fontFamily: 'NotoSansKR-Medium')),//Theme.of(context).textTheme.headlineMedium),
                      style: ElevatedButton.styleFrom(overlayColor: Colors.transparent, foregroundColor: Colors.transparent, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),
                    )
                ),
                Container(
                    width: (widgetWidth - (style.UIMarginLeft * 2)),
                    height: 70,
                    margin: EdgeInsets.only(bottom: style.UIMarginLeft * 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                      color: style.colorMainBlue,
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        launchWebView("https://www.youtube.com/watch?v=12EPDAyV7Ys&list=PLVSYYFyGNdbZbHG1k2AyNf0f0Z5SO8lWC");
                      },
                      child: Text("매뉴얼", style: Theme.of(context).textTheme.headlineSmall),
                      style: ElevatedButton.styleFrom(overlayColor: Colors.transparent, foregroundColor: Colors.transparent, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),
                    )
                ),
                Container(
                    width: (widgetWidth - (style.UIMarginLeft * 2)),
                    height: 70,
                    margin: EdgeInsets.only(bottom: style.UIMarginLeft * 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                      color: style.colorMainBlue,
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        launchWebView('https://cafe.naver.com/wujuhaneulbyeol');
                      },
                      child: Text("우주하늘별", style: Theme.of(context).textTheme.headlineSmall),
                      style: ElevatedButton.styleFrom(overlayColor: Colors.transparent, foregroundColor: Colors.transparent, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),
                    )
                ),
                Container(
                    width: (widgetWidth - (style.UIMarginLeft * 2)),
                    height: 70,
                    margin: EdgeInsets.only(bottom: style.UIMarginLeft),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.textFiledRadius),
                      color: style.colorMainBlue,
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        launchWebView("https://cafe.naver.com/wujuhaneulbyeol/5");
                      },
                      child: Text("만세력 소개", style: Theme.of(context).textTheme.headlineSmall),
                      style: ElevatedButton.styleFrom(overlayColor: Colors.transparent, foregroundColor: Colors.transparent, animationDuration: Duration(milliseconds: 0), splashFactory: NoSplash.splashFactory, backgroundColor: Colors.transparent, elevation:0.0, surfaceTintColor: Colors.transparent),
                    )
                ),
              ],
            ),
          ),
          Container(
            width: widgetWidth,
            height: widgetHeight,
            child: Container(  //끄기 버튼
                width: widgetWidth,
                height: style.UIMarginTopTop,
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.shrink(),
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(top: 12,right:10),
                      child: ElevatedButton(

                        onPressed: () {
                            widget.showHelpPage(isCompulsionClose:true);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: Colors.transparent),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
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
