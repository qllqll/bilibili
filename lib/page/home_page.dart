import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/core/hi_state.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/page/home_tab_page.dart';
import 'package:bilibili/page/profile_page.dart';
import 'package:bilibili/page/video_detail_page.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/hi_tab.dart';
import 'package:bilibili/widget/loading_container.dart';
import 'package:bilibili/widget/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int> onJumpTo;

  const HomePage({Key key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
//AutomaticKeepAliveClientMixin 保持页面状态，避免重复请求
//TickerProviderStateMixin tabbar 动画
//WidgetsBindingObserver APP生命周期
class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin,WidgetsBindingObserver{
  var listener;
  List<CategoryModel> categoryList = [];
  List<BannerModel> bannerList = [];
  TabController _tabController;
  bool _isLoading = true;
  Widget _currentPage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //注册生命周期
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListeners(this.listener = (current, pre) {
      this._currentPage = current.page;
      print('current:${current.page}');
      print('current:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页：onResume');
      } else if (widget == pre.page || pre?.page is HomePage) {
        print('打开了首页：onPause');
      }
    //  当页面返回到首页恢复首页的状态栏样式
      if(pre?.page is VideoDetailPage && !(current.page is ProfilePage)){
        changeStatusBar(color:Colors.white, statusStyle:StatusStyle.DARK_CONTENT);
      }
    });
    loadDate();
  }

  //监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print("-----didChangeAppLifecycleState：$state");
    switch(state){
      //处于这种状态的应用程序应该假设他们可能在任何时候暂停。
      case AppLifecycleState.inactive:
        break;
      //从后台到前台，界面可见
      case AppLifecycleState.resumed:
        //fix Android 压后台，状态栏字体颜色变白的问题
      if(!(_currentPage is VideoDetailPage)){
        changeStatusBar(color:Colors.white, statusStyle:StatusStyle.DARK_CONTENT);
      }
        break;
    //从后台到前台，界面可见
      case AppLifecycleState.paused:
        break;
    //App结束调用，APP被销毁
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
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
              decoration:bottomBoxShadow() ,
              // color: Colors.white,
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
    return HiTab(categoryList.map<Tab>((tab){
      return Tab(
        text:tab.name,
      );
    }).toList(),
      controller: _tabController,
      fonsize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );

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
