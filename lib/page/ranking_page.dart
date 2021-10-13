import 'package:bilibili/http/dao/ranking_dao.dart';
import 'package:bilibili/page/ranking_tab_page.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/hi_tab.dart';
import 'package:bilibili/widget/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///排行
class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  static const TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"},
  ];

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: TABS.length, vsync: this);
    RankingDao.get("like");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
        body: Column(
          children: [
            _buildNavigationBar(), _buildTabView()
          ],
        ));
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
        child: Container(
          alignment: Alignment.center,
          child: _tabBar(),
          decoration: bottomBoxShadow(),
        ));
  }

  _tabBar() {
    return HiTab(
      TABS.map<Tab>((tab) {
        return Tab(text: tab['name']);
      }).toList(),
      fonsize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      controller: _tabController,
    );
  }

  _buildTabView() {
    return Flexible(child: TabBarView(children: TABS.map((tab) {
      return RankingTabPage(sort: tab['key']);
    }).toList(), controller: _tabController,));
  }
}
