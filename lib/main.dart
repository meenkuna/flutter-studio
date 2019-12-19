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

  Future loadData() async {    
    var client = new http.Client();
    try {
      var response = await client.get(
        'https://' + Config.domain + '/api/feed/v1/' + Config.apiKey + '/load',
        headers: {'user-agent': 'app:studio.ifelse'}
      );
      var load = json.decode(response.body);
      
      Site.getData(load);

      //Site.pageBar = <BottomNavigationBarItem>[];
      //Site.pageBody = <Map<String,String>>[];
      Site.pageType = <Widget>[];
      Site.pageTab = <Tab>[];

      List<dynamic> bd = load['tab'];
      bd.forEach((b){
        String name = b['name'];
        String icon = b['icon'];
        String type = b['type'];
        String cate = b['cate'];
        String order = b['order'];
        String article = b['article'];
        /*
        Site.pageBar.add(BottomNavigationBarItem(
          icon: Icon(SIcons.icofont[icon]),
          title: Text(name),
        ));
*/
        //Site.pageBody.add({'icon':icon, 'name':name, 'type':type, 'cate':cate, 'order':order, 'article':article});
        Site.pageType.add(PageLast(icon: icon, name:name, type:type, cate: cate, order:order, article:article));
        Site.pageTab.add(
          Tab(
            icon: icon.isEmpty ? null : Icon(SIcons.icofont[icon]),
            text: name.isEmpty ? null : name,
          ),
        );
      }); 
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage()));
    } finally {
      client.close();
    }
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
