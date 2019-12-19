
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class Site {
  static String navName = '';
  static Color navTxt;
  static Color navBg ;
  static Color menuTxt;
  static Color menuFocus;
  static Color menuBg;
  static String menuType = 'bottom';
  static List<BottomNavigationBarItem> pageBar = <BottomNavigationBarItem>[];
  static List<Map<String,String>> pageBody = <Map<String,String>>[];
  static List<Widget> pageType = <Widget>[];
  static List<Widget> pageTab = <Widget>[];
}


class News {
  int id;
  String title;
  String image;
  String link;
  News(this.id, this.title, this.image, this.link);
  News.empty();
}