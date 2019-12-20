import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:studio.ifelse/config.dart';
import 'package:studio.ifelse/const.dart';
import 'package:studio.ifelse/icon.dart';

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
      backgroundColor: Colors.transparent,
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

class MyHomePageState extends State<MyPageLast> with AutomaticKeepAliveClientMixin {
  List<News> news = <News>[];
  String apiUrl;
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    apiUrl = 'https://' + Config.domain + '/api/feed/v1/' + Config.apiKey + '/' + widget.type;
    if(widget.type == 'acate') {
      apiUrl += '/' + widget.cate + '/' + widget.order;
    } else if(widget.type == 'article') {
      apiUrl += '/' + widget.article;
    }
    print(apiUrl);
    if(news == null || news.length == 0) {
      getNews();
    }
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  Future getNews() async {    
    var client = new http.Client();
    try {
      var response = await client.get(apiUrl, headers: {'user-agent': 'app:studio.ifelse'});
      var load = json.decode(response.body);
      List<News> _news = <News>[];
      load.forEach((b) {
        int id = b['id'];
        String title = b['title'];
        String image = b['image'];
        String link = b['link'];
        String added = b['added'];
        _news.add(News(id, title, image, link, added));
      });
      setState(() => news = _news);
      _refreshController.refreshCompleted();
    } finally {
      client.close();
    }
  }
  
  Future getMore() async {    
    var client = new http.Client();
    try {
      var response = await client.get(apiUrl, headers: {'user-agent': 'app:studio.ifelse'});
      var load = json.decode(response.body);
      List<News> _news = <News>[];
      load.forEach((b) {
        int id = b['id'];
        String title = b['title'];
        String image = b['image'];
        String link = b['link'];
        String added = b['added'];
        _news.add(News(id, title, image, link, added));
      });
      setState(() => news = _news);
      _refreshController.loadComplete();
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: SmartRefresher(        
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode) {
              Widget body ;
              if(mode==LoadStatus.idle) {
                body =  Text("pull up load");
              } else if(mode==LoadStatus.loading) {
                body =  CupertinoActivityIndicator();
              } else if(mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if(mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
              } else {
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
    
    BorderRadius radius = BorderRadius.only(
      topLeft: Radius.circular(Site.cardRD1),
      topRight: Radius.circular(Site.cardRD2),
      bottomLeft: Radius.circular(Site.cardRD3),
      bottomRight: Radius.circular(Site.cardRD4)
    );

    BoxDecoration card;   
    if(Site.cardBg == 2) {
      AlignmentGeometry begin = Alignment.centerLeft;
      AlignmentGeometry end = Alignment.centerRight;
      if(Site.cardRange == 2) {
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
      } else if(Site.cardRange == 3) {
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
      } else if(Site.cardRange == 4) {
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
      }
      card = BoxDecoration(
        gradient: LinearGradient(colors: [Site.cardBg1, Site.cardBg2], begin: begin, end: end),
        borderRadius: radius,
      );
    } else if(Site.cardBg == 1) {
      card = BoxDecoration(
        color: Site.cardBg1,
        borderRadius: radius,
      );
    }

    Widget newsCard;
    print(Site.cardType);
    if(Site.cardType == 'bottom1') {
      newsCard = Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, bottom: 5, right: 15),
            child: Text(news.title == null || news.title.isEmpty ? "NA" : news.title, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, fontFamily: "Kanit", color: Site.cardTxt))
          ),
          Container(
            child: news.image == null || news.image.isEmpty ? SizedBox(height: 5,) : Image.network(news.image, fit: BoxFit.fitWidth),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } else if(Site.cardType == 'top1') {
      newsCard = Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Site.cardRD1),
              topRight: Radius.circular(Site.cardRD2),
            ),
            child: news.image == null || news.image.isEmpty ? SizedBox(height: 5,) : Image.network(news.image, fit: BoxFit.fitWidth),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, bottom: 0, right: 15),
            child: Text(news.title == null || news.title.isEmpty ? "NA" : news.title, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, fontFamily: "Kanit", color: Site.cardTxt))
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } else if(Site.cardType == 'right1') {
      newsCard = Row(
        children: <Widget>[
          Container( 
            padding: EdgeInsets.only(top: 15, left:15, right:10, bottom:0),
            alignment: Alignment.topRight,
            width: 140,
            height: 85,
            //color: Colors.cyan,
            child: news.image == null || news.image.isEmpty ? SizedBox(height: 5,) : Image.network(news.image, fit: BoxFit.cover),
          ),
          Expanded( 
            child: Container( 
              padding: EdgeInsets.only(top: 12, right:12, bottom:0),
              alignment: Alignment.topRight,
              height: 85,
              child: Text(news.title == null || news.title.isEmpty ? "NA" : news.title, style: TextStyle(fontWeight: FontWeight.normal, height:1.4, fontSize: 18, fontFamily: "Kanit", color: Site.cardTxt)),
              //color: Colors.amber,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } else {
      newsCard = Row(
        children: <Widget>[
          Container( 
            padding: EdgeInsets.only(top: 15, left:15, right:10, bottom:0),
            alignment: Alignment.topLeft,
            width: 140,
            height: 85,
            //color: Colors.cyan,
            child: news.image == null || news.image.isEmpty ? SizedBox(height: 5,) : Image.network(news.image, fit: BoxFit.cover),
          ),
          Expanded( 
            child: Container( 
              padding: EdgeInsets.only(top: 12, right:12, bottom:0),
              alignment: Alignment.topLeft,
              height: 85,
              child: Text(news.title == null || news.title.isEmpty ? "NA" : news.title, style: TextStyle(fontWeight: FontWeight.normal, height:1.4, fontSize: 18, fontFamily: "Kanit", color: Site.cardTxt)),
              //color: Colors.amber,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
/*
      shape: RoundedRectangleBorder(        
        side: BorderSide(color: Color(0x88CCCCCC), width: 0.5),
        borderRadius: BorderRadius.circular(20.0),        
      ),
*/
    return Card(
      color: Colors.transparent,      
      elevation: Site.cardShadow == 1 ? 1 : 0,
      margin: EdgeInsets.only(top:0, left: 0, right: 0, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Site.cardRD1),
          topRight: Radius.circular(Site.cardRD2),
          bottomLeft: Radius.circular(Site.cardRD3),
          bottomRight: Radius.circular(Site.cardRD4)
        )        
      ),
      child: Container(
        decoration: card,
        //padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            newsCard,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(SIcons.icofont['clocktime']),iconSize: 12, padding: EdgeInsets.all(0), tooltip: "Add", color: Site.cardTxt, onPressed: () async {},),
                    Text(news.added == null || news.added.isEmpty ? "" : news.added, style: TextStyle(fontWeight: FontWeight.normal, height:1.35, fontSize: 12, fontFamily: "Kanit", color: Site.cardTxt)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.remove_red_eye), tooltip: "View", color: Site.cardTxt, onPressed: () async {},),
                    IconButton(icon: Icon(Icons.share), tooltip: "Share", color: Site.cardTxt, onPressed: () {},)
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                )
              ]
            ),
          ]
        ),
      )
    );
  }
}

class News {
  int id;
  String title;
  String image;
  String link;
  String added;
  News(this.id, this.title, this.image, this.link, this.added);
  News.empty();
}