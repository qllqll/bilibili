import 'dart:io';

import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/video_detail_dao.dart';
import 'package:bilibili/model/video_detail_model.dart';
import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/expandable_content.dart';
import 'package:bilibili/widget/hi_tab.dart';
import 'package:bilibili/widget/navigation_bar.dart';
import 'package:bilibili/widget/video_header.dart';
import 'package:bilibili/widget/video_toolbar.dart';
import 'package:bilibili/widget/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  TabController _controller;
  List tabs = ["简介", "评论288"];
  VideoDetailModel videoDetailModel;
  VideoModel videoModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  黑色状态栏  仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel =widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
            removeTop: Platform.isIOS,
            context: context,
            child:videoModel.url != null ?  Column(
              children: [
                //iOS状态下的黑色状态栏
                NavigationBar(
                    color: Colors.black,
                    statusStyle: StatusStyle.LIGHT_CONTENT,
                    height: Platform.isAndroid ? 0 : 46),
                _buildVideoView(),
                _buildTabNavigation(),
                Flexible(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        _buildDetailList(),
                        Container(
                          child: Text('敬请期待...'),
                        )
                      ],
                    ))
              ],
            ):Container()));
  }

  _buildVideoView() {
    var model = videoModel;
    print("model ---- ${model.cover}");
    return VideoView(
      model.url,
      cover: model.cover,
      overlayUI: videoAppBar(),
      autoPlay: true,
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
          alignment: Alignment.center,
          height: 39,
          color: Colors.white,
          padding: EdgeInsets.only(left: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _tabBar(),
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.live_tv_rounded, color: Colors.grey))
          ])),
    );
  }

  _tabBar() {
    return HiTab(
        tabs.map<Tab>((name) {
          return Tab(text: name);
        }).toList(),
        controller: _controller);
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents()],
    );
  }

  buildContents() {
    return [
      Container(child: VideoHeader(owner: videoModel.owner)),
      ExpandableContent(videoModel: videoModel),
      VideoToolBar(
        detailModel: videoDetailModel,
        videoModel: videoModel,
        onLike: _doLike,
        onUnLike: _doUnLike,
        onFavorite: _doFavorite,
        onShare: _doShare,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailModel result = await VideoDetailDao.get(videoModel.vid);
      print(result);
      setState(() {
        videoDetailModel = result;
        videoModel = result.videoInfo;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  void _doUnLike() {}

  void _doLike() {}

  void _doFavorite() {}

  void _doShare() {
  }
}
