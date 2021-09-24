import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/widget/hi_banner.dart';
import 'package:bilibili/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel> bannerList;

  const HomeTabPage({this.categoryName,this.bannerList});

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(removeTop: true,context: context, child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,itemCount: videoList.length, itemBuilder: (BuildContext context,int index){
          if(widget.bannerList != null && index == 0){
            return Padding(padding: EdgeInsets.only(bottom: 8),child:_banner());
          } else {
            return VideoCard(videoModel: videoList[index]);
          }
    }, staggeredTileBuilder: (int index){
          if(widget.bannerList!= null && index == 0){
            return StaggeredTile.fit(2);
          } else {
            return StaggeredTile.fit(1);
          }
    }) );
  }
  _banner() {
    return Padding(padding: EdgeInsets.only(left:5,right: 5),child: HiBanner(widget.bannerList));
  }

  void _loadData({loadMore = false}) async {
    if(!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1: 0);
    try {
      HomeModel result = await HomeDao.get(widget.categoryName,pageIndex:currentIndex,pageSize: 20);
      print("loadDate():$result");
      setState(() {
        if(loadMore){
          if(result.videoList.isNotEmpty){
            videoList = [...videoList,...result.videoList];
            pageIndex++;
          }
        }else {
          videoList = result.videoList;
        }
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}


