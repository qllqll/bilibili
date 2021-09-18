import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/page/favorite_page.dart';
import 'package:bilibili/page/home_page.dart';
import 'package:bilibili/page/profile_page.dart';
import 'package:bilibili/page/ranking_page.dart';
import 'package:bilibili/util/color.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  //初始化界面
  static int initiaPage = 0;
  final PageController _controller = PageController(initialPage: 0);
  List<Widget> _pages;
  bool _hasBuild = false;
  @override
  Widget build(BuildContext context) {
    _pages = [HomePage(onJumpTo: (index)=>_onJumpTo(index,pageChange:false)), RankingPage(), FavoritePage(), ProfilePage()];
    if (!_hasBuild) {
      //也没第一个打开时通知打开的是哪个tab
      HiNavigator.getInstance()
          .onBottomTabChange(initiaPage, _pages[initiaPage]);
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        //禁止页面滚动
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        //底部tabbar的类型，设置为不动
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3)
        ],
      ),
    );
  }

  _bottomItem(String title, IconData iconData, int index) {
    return BottomNavigationBarItem(
        icon: Icon(iconData, color: _defaultColor),
        activeIcon: Icon(iconData, color: _activeColor),
        label: title);
  }

  void _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      //让PageView展示对应的tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      //控制选中第一个tab
      _currentIndex = index;
    });
  }
}
