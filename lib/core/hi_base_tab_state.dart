import 'package:bilibili/core/hi_state.dart';
import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/toast.dart';
import 'package:flutter/material.dart';

///通用底层呆分页和刷新的页面框架
///M为Dao返回数据模型，L列表数据模型，T为具体widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  ScrollController scrollController = ScrollController();
  bool loading = false;

  get contentChild;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      var dis = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      //scrollController.position.maxScrollExtent  当列表高度不满屏幕高度时不执行加载更多
      if (dis < 300 && !loading && scrollController.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: MediaQuery.removePadding(
            removeTop: true, context: context, child: contentChild),
        onRefresh: loadData,
        color: primary);
  }

  ///获取对应页码的数据
  Future<M> getData(int pageIndex);

  ///从MO中解析出list数据
  List<L> parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (loading) {
      print("上次加载还没完成...");
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      var result = await getData(currentIndex);
      print("currentIndex:$currentIndex");
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).length != 0) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
      });
      Future.delayed(Duration(milliseconds: 300), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      loading = false;
      showWarnToast(e.message);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
