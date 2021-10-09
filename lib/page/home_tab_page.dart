import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/widget/hi_banner.dart';
import 'package:bilibili/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel> bannerList;

  const HomeTabPage({this.categoryName, this.bannerList});

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  ScrollController _scrollController = ScrollController();
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print("dis$dis");
      if (dis < 300 && !_loading) {
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: StaggeredGridView.countBuilder(
              controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                crossAxisCount: 2,
                itemCount: videoList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.bannerList != null && index == 0) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 8), child: _banner());
                  } else {
                    return VideoCard(videoModel: videoList[index]);
                  }
                },
                staggeredTileBuilder: (int index) {
                  if (widget.bannerList != null && index == 0) {
                    return StaggeredTile.fit(2);
                  } else {
                    return StaggeredTile.fit(1);
                  }
                })),
        onRefresh: _loadData,
        color: primary);
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList));
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      HomeModel result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      print("loadDate():$result");
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(Duration(milliseconds: 300),(){
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      showWarnToast(e.message);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
