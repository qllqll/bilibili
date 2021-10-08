import 'dart:io';

import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/hi_tab.dart';
import 'package:bilibili/widget/navigation_bar.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  黑色状态栏  仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
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
            removeTop: Platform.isIOS, context: context, child: Column(
          children: [
            //iOS状态下的黑色状态栏
            NavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46
            ),
            _buildVideoView(),
            _buildTabNavigation()
          ],
        )));
  }

  _buildVideoView() {
    var model = widget.videoModel;
    print("model ---- ${model.cover}");
    return VideoView(model.url, cover: model.cover,
      overlayUI: videoAppBar(), autoPlay: true,
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabBar(),
                  Padding(padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.live_tv_rounded, color: Colors.grey))
                ])),
    );
  }

  _tabBar() {
    return HiTab(tabs.map<Tab>((name) {
      return Tab(
          text: name
      );
    }).toList(), controller: _controller);
  }




}
