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
      body: Container(
          child: Column(
        children: [
          NavigationBar(
            height: 50,
            child: _tabBar(),
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
          )
        ],
      )),
    );
  }

  _tabBar() {
    return Material(
      elevation: 5,
      color:Colors.white,
      shadowColor: Colors.grey[100],
      child:Container(alignment: Alignment.center, child: HiTab(
        TABS.map<Tab>((tab) {
          return Tab(text: tab['name']);
        }).toList(),
        fonsize: 16,
        borderWidth: 3,
        unselectedLabelColor: Colors.black54,
        controller: _tabController,
      ))
    );
  }
}
