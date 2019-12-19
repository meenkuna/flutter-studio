import 'package:flutter/material.dart';
import 'const.dart';


class MyPage extends StatelessWidget {
  MyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.navName, home: MyPagefulWidget(),
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
    controller = TabController(length: Site.pageTab.length, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text(Site.navName, style: TextStyle(color: Site.navTxt, fontFamily: "Kanit")),
      backgroundColor: Site.navBg,
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