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
