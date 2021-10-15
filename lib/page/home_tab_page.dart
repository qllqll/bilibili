import 'package:bilibili/core/hi_base_tab_state.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/model/video_model.dart';
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

class _HomeTabPageState
    extends HiBaseTabState<HomeModel, VideoModel, HomeTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _banner() {
    return HiBanner(widget.bannerList,
        padding: EdgeInsets.only(left: 5, right: 5));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // TODO: implement contentChild
  get contentChild => StaggeredGridView.countBuilder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      crossAxisCount: 2,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.bannerList != null && index == 0) {
          return Padding(padding: EdgeInsets.only(bottom: 8), child: _banner());
        } else {
          return VideoCard(videoModel: dataList[index]);
        }
      },
      staggeredTileBuilder: (int index) {
        if (widget.bannerList != null && index == 0) {
          return StaggeredTile.fit(2);
        } else {
          return StaggeredTile.fit(1);
        }
      });

  @override
  Future<HomeModel> getData(int pageIndex) async {
    // TODO: implement getData
    HomeModel result = await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeModel result) {
    // TODO: implement parseList
    return result.videoList;
  }
}
