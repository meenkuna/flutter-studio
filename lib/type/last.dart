import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:studio.ifelse/const.dart';
import 'package:studio.ifelse/config.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class PageLast extends StatelessWidget {
  PageLast({this.icon,this.name,this.type,this.cate,this.order,this.article});
  final String name;
  final String icon;
  final String type;
  final String cate;
  final String order;
  final String article;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: MyPageLast(icon: icon, name:name, type:type, cate: cate, order:order, article:article),
    );
  }
}

class MyPageLast extends StatefulWidget {
  MyPageLast({Key key, this.icon,this.name,this.type,this.cate,this.order,this.article}) : super(key: key);
  final String icon;
  final String name;
  final String type;
  final String cate;
  final String order;
  final String article;

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyPageLast> {
  List<News> news = <News>[];
  
  @override
  void initState() {
    super.initState();
    getNews();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  Future getNews() async {    
    var client = new http.Client();
    try {
      var response = await client.get(
        'https://' + Config.Domain + '/api/feed/v1/' + Config.ApiKey + '/' + widget.type,
        headers: {'user-agent': 'app:studio.ifelse'}
      );
      //print('https://' + Config.Domain + '/api/feed/v1/' + Config.ApiKey + '/' + type);
      var load = json.decode(response.body);
      List<News> _news = <News>[];
      load.forEach((b) {
        int id = b['id'];
        String title = b['title'];
        String image = b['image'];
        String link = b['link'];
        _news.add(News(id, title, image, link));
      });
      setState(() => news = _news);
      _refreshController.refreshCompleted();
    } finally {
      client.close();
    }
  }

  
  Future<Timer> getMore() async {    
    var client = new http.Client();
    try {
      var response = await client.get(
        'https://' + Config.Domain + '/api/feed/v1/' + Config.ApiKey + '/last',
        headers: {'user-agent': 'app:studio.ifelse'}
      );
      //print('https://' + Config.Domain + '/api/feed/v1/' + Config.ApiKey + '/' + type);
      var load = json.decode(response.body);
      List<News> _news = <News>[];
      load.forEach((b) {
        int id = b['id'];
        String title = b['title'];
        String image = b['image'];
        String link = b['link'];
        _news.add(News(id, title, image, link));
      });
      setState(() => news = _news);
      //print(news);

      _refreshController.loadComplete();
      print(widget.type);
    } finally {
      client.close();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF),Color(0xFFF0F0F0),]
          )
        ), 
        child: SmartRefresher(        
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                  body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: getNews,
          onLoading: getMore,
          child: ListView.builder(
            itemBuilder: (BuildContext ctxt, int index) {
              return _buildListItem(news[index], ctxt);
            },
            itemCount: news.length,
          )
        )
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

