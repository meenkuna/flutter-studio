import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'config.dart';
import 'const.dart';
import 'icon.dart';
import 'page.dart';
import 'tab.dart';

void main() {
  //setTargetPlatformForDesktop();
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {    
    var client = new http.Client();
    try {
      var response = await client.get(
        'https://' + Config.domain + '/api/feed/v1/' + Config.apiKey + '/load',
        headers: {'user-agent': 'app:studio.ifelse'}
      );
      var load = json.decode(response.body);
      Site.navName = load['nav']['name'];
      Site.navTxt = HexColor(load['nav']['txt'], '#ffffff');
      Site.navBg = HexColor(load['nav']['bg'], '#008ad5');
      Site.menuType = load['menu']['type'];
      Site.menuTxt = HexColor(load['menu']['txt'], '#444444');
      Site.menuFocus = HexColor(load['menu']['focus'], '#ff4400');
      Site.menuBg = HexColor(load['menu']['bg'], '#f5f5f5');
      
      Site.pageBar = <BottomNavigationBarItem>[];
      Site.pageBody = <Map<String,String>>[];
      Site.pageType = <Widget>[];
      Site.pageTab = <Tab>[];

      List<dynamic> bd = load['body'];
      //int i = 0;
      bd.forEach((b){
        String name = b['name'];
        String icon = b['icon'];
        String type = b['type'];
        String cate = b['cate'];
        String order = b['order'];
        String article = b['article'];
        
        Site.pageBar.add(BottomNavigationBarItem(
          icon: Icon(SIcons.icofont[icon]),
          title: Text(name),
        ));

        Site.pageBody.add({'icon':icon, 'name':name, 'type':type, 'cate':cate, 'order':order, 'article':article});
        Site.pageType.add(PageLast(icon: icon, name:name, type:type, cate: cate, order:order, article:article));
        Site.pageTab.add(
          Tab(
            icon: icon.isEmpty ? null : Icon(SIcons.icofont[icon]),
            text: name.isEmpty ? null : name,
          ),
        );
        //Site.TabPage.add()
        
        /*
        Site.dRoutes['/'+type] = (BuildContext context) => RandomScreen(
            icon: icon,
            name: name,
            type: type,
            cate: cate,
            order: order,
            article: article,
          );
        Site.dTabs.add(DynamicTab(
          child: RandomScreen(
            icon: icon,
            name: name,
            type: type,
            cate: cate,
            order: order,
            article: article,
          ),
          tab: BottomNavigationBarItem(
            icon: Icon(SIcons.icofont[icon]),
            title: Text(name),
          ),
          tag: "tab-" + icon + "-" + i.toString(), // Must Be Unique
        ));
        i++;
        */
      });
      
      //return new Timer(Duration(seconds: 3), onDoneLoading);   
    } finally {
      client.close();
    }
    return Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(      
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF),Color(0xFFDDDDDD),]
        )
      ),    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/splash-logo.png'),
          SizedBox(
            height: 50.0,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ]
      )
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor, String defaultColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 3) {
      String tmp = "";
      for(int i=0;i<3;i++) {
        var h = hexColor.substring(i,i+1);
        tmp += h + h;
      }
      hexColor = "FF" + tmp;
    } else if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    } else {
      hexColor = "FF" + defaultColor.toUpperCase().replaceAll("#", "");
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor, final String defaultColor) : super(_getColorFromHex(hexColor, defaultColor));
}