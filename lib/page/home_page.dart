import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_state.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/page/home_tab_page.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/widget/loading_container.dart';
import 'package:bilibili/widget/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int> onJumpTo;

  const HomePage({Key key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  List<CategoryModel> categoryList = [];
  List<BannerModel> bannerList = [];
  TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: categoryList.length, vsync: this);
    super.initState();
    HiNavigator.getInstance().addListeners(this.listener = (current, pre) {
      print('current:${current.page}');
      print('current:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页：onResume');
      } else if (widget == pre.page || pre?.page is HomePage) {
        print('打开了首页：onPause');
      }
    });
    loadDate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    HiNavigator.getInstance().removeListeners(this.listener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        // appBar: AppBar(),
        body: LoadingContainer(
      cover: true,
      isLoading: _isLoading,
      child: Container(
        child: Column(
          children: [
            NavigationBar(
              height: 50,
              child: _appBar(),
              color: Colors.white,
              statusStyle: StatusStyle.DARK_CONTENT,
            ),
            Container(
              color: Colors.white,
              child: _tabBar(),
            ),
            Flexible(
                child: TabBarView(
              controller: _tabController,
              children: categoryList.map((tab) {
                return HomeTabPage(
                    categoryName: tab.name,
                    bannerList: tab.name == "推荐" ? bannerList : null);
              }).toList(),
            ))
          ],
        ),
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.black,
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.round,
            borderSide: BorderSide(color: primary, width: 3),
            insets: EdgeInsets.only(left: 15, right: 15)),
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
              child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ));
        }).toList());
  }

  void loadDate() async {
    try {
      HomeModel result = await HomeDao.get("推荐");
      print("loadDate():$result");
      if (result.categoryList != null) {
        _tabController =
            TabController(length: result.categoryList.length, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList;
        bannerList = result.bannerList;
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      setState(() {
        _isLoading = false;
      });
      showWarnToast(e.message);
    }
  }

  _appBar() {
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (widget.onJumpTo != null) {
                  widget.onJumpTo(3);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Image(
                  height: 46,
                  width: 46,
                  image: AssetImage('images/avatar.png'),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                ),
              ),
            )),
            Icon(Icons.explore_outlined, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.mail_outline, color: Colors.grey),
            )
          ],
        ));
  }
}
