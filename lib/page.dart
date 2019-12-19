import 'package:flutter/material.dart';
import 'package:studio.ifelse/icon.dart';
//import 'package:native_share/native_share.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'const.dart';
import 'config.dart';
import 'type/last.dart';


class MyPage extends StatelessWidget {
  MyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Site.navName,
      home: MyPagefulWidget(),
    );
  }
}

class MyPagefulWidget extends StatefulWidget {
  MyPagefulWidget({Key key}) : super(key: key);
  @override
  _MyPagefulWidgetState createState() => _MyPagefulWidgetState();
}


class _MyPagefulWidgetState extends State<MyPagefulWidget> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = TabController(length: Site.pageTab.length, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  AppBar getAppBar() {
    return AppBar(
        title: Text(Site.navName, style: TextStyle(color: Site.navTxt, fontFamily: "Kanit")),
        backgroundColor: Site.navBg,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share,color: Site.navTxt,),onPressed: () => Navigator.pop(context),),
        ],
        bottom: (Site.menuType == 'bottom') ? null : getTabBar(),
      );
  }

  TabBar getTabBar() {
    return TabBar(
          indicatorWeight: 0.1,
          labelPadding: EdgeInsets.all(0),
          labelColor: Site.menuFocus,
          labelStyle: TextStyle(fontSize: 14.0, fontFamily: "Kanit"),
          unselectedLabelColor: Site.menuTxt,
          unselectedLabelStyle: TextStyle(fontSize: 14.0, fontFamily: "Kanit"),
          tabs: Site.pageTab,
          controller: controller,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: TabBarView(        
        children: Site.pageType,
        controller: controller,
      ),
      bottomNavigationBar: (Site.menuType == 'bottom') ? Material(
        color: Site.menuBg,
        child: getTabBar()
      ) : null,
    );
  }
}


/*

class _NavigationPage  {
  _NavigationPage({
    this.name,
    this.icon,
    this.type,
    this.cate,
    this.order,
    this.article,
    TickerProvider vsync,
  }) : controller = AnimationController(
    duration: kThemeAnimationDuration,
    vsync: vsync
  ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));

    news = <News>[];
    getNews();
  }
  final String name;
  final Widget icon;
  final String type;
  final String cate;
  final String order;
  final String article;
  //final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  List<News> news;

  Future<Timer> getNews() async {    
    var client = new http.Client();
    try {
      var response = await client.get(
        'https://' + Config.Domain + '/api/feed/v1/' + Config.ApiKey + '/' + type,
        headers: {'user-agent': 'app:studio.ifelse'}
      );
      var load = json.decode(response.body);
      List<News> _news = <News>[];
      load.forEach((b) {
        int id = b['id'];
        String title = b['title'];
        String image = b['image'];
        String link = b['link'];
        news.add(News(id, title, image, link));
      });
      //setState(() => news = _news);
    } finally {
      client.close();
    }
    return null;
  }
  FadeTransition transition(BuildContext context) {
    return FadeTransition(
      opacity: _animation,    
        child: ListView.builder(
          itemBuilder: (BuildContext ctxt, int index) {
            return _buildListItem(news[index], ctxt);
          },
          itemCount: news.length,
      )
    );
  }

  _buildListItem(News news, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0x88CCCCCC), width: 0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),

      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5, left: 15, bottom: 5, right: 5),
              child: Text(
                  news.title == null || news.title.isEmpty ? "NA" : news.title,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, fontFamily: "Kanit"))),
            Container(
              margin: EdgeInsets.only(bottom: 0, top: 0),
              decoration: BoxDecoration(color: Colors.grey),
              child: news.image == null || news.image.isEmpty
                  ? SizedBox(
                      height: 10,
                    )
                  : Image.network(news.image, fit: BoxFit.fitWidth),
            ),
            /*
            Divider(
              height: 0,
              color: Colors.grey,
            ),
            */
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  tooltip: "View",
                  onPressed: () async {
                   
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  tooltip: "Share",
                  onPressed: () {
                    NativeShare.share({
                      'title': news.title == null || news.title.isEmpty
                          ? "NA"
                          : news.title,
                      'url': news.link == null || news.link.isEmpty
                          ? null
                          : news.link,
                    });
                  },
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
    );
  }
}

*/