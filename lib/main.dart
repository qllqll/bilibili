import 'package:bilibili/db/hi_cache.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/bottom_navigator.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/page/dark_mode_page.dart';
import 'package:bilibili/page/login_page.dart';
import 'package:bilibili/page/registration_page.dart';
import 'package:bilibili/page/video_detail_page.dart';
import 'package:bilibili/provider/hi_provider.dart';
import 'package:bilibili/provider/theme_provider.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/hi_defend.dart';
import 'package:bilibili/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/video_model.dart';

void main() {
  HiDefend().run(BiliApp());
}

class BiliApp extends StatefulWidget {
  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  BiliRouteInformationParser _routeInformationParser =
      BiliRouteInformationParser();

  //定义router

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                  // routeInformationParser: _routeInformationParser,
                  //routeInformationParser为null时可缺省，RouteInformation为提供者
                  // routeInformationProvider: PlatformRouteInformationProvider(
                  //     initialRouteInformation: RouteInformation(location: '/'))
                )
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

          return MultiProvider(
              providers: topProviders,
              child: Consumer<ThemeProvider>(builder: (
                BuildContext context,
                ThemeProvider themeProvider,
                Widget child) {
                return MaterialApp(
                  home: widget,
                  theme: themeProvider.getTheme(),
                  darkTheme: themeProvider.getTheme(isDarkMode: true),
                  themeMode: themeProvider.getThemeMode(),
                );
              }));
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //  实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpLister(onJumpTo: (RouteStatus routeStatus, {Map args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args['videoModel'];
      }
      notifyListeners();
    }));
  }

  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel videoModel;

  @override
  Future<Function> setNewRoutePath(BiliRoutePath configuration) async {}

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, _routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
    }

    //管理路由堆栈
    var page;
    if (routeStatus == RouteStatus.home) {
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if(routeStatus == RouteStatus.darkMode){
      page = pageWrap(DarkModePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }
    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    //通知路由发生变化
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (router, result) {
            if (router.settings is MaterialPage) {
              //登录页未登录返回拦截
              if ((router.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast('请先登录');
                  return false;
                }
              }
            }
            //  在这里可以控制是否可以返回
            if (!router.didPop(result)) {
              return false;
            }
            var tempPages = [...pages];
            pages.removeLast();
            //通知路由发生变化
            HiNavigator.getInstance().notify(pages, tempPages);
            return true;
          },
        ),
        // fix android 物理返回键 无法返回上一页的问题
        onWillPop: () async => !await navigatorKey.currentState.maybePop());
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;
}

class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
  @override
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    print('uri:$uri');
    if (uri.pathSegments.length == 0) {
      return BiliRoutePath.home();
    }
    return BiliRoutePath.detail();
  }
}

///定义路由数据  Path
class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}

//创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
