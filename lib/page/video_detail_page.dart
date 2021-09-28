import 'dart:io';

import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/navigation_bar.dart';
import 'package:bilibili/widget/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  黑色状态栏  仅Android
    changeStatusBar(color:Colors.black,statusStyle: StatusStyle.LIGHT_CONTENT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(removeTop: Platform.isIOS,context: context, child: Column(
          children: [
            //iOS状态下的黑色状态栏
              NavigationBar(
                color:Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height:Platform.isAndroid?0:46
              ),
            _videoView()
          ],
        )));
  }

  _videoView() {
    var model = widget.videoModel;
    print("model ---- ${model.cover}");
    return VideoView(model.url, cover: model.cover,
      overlayUI: videoAppBar(),autoPlay: true,
    );
  }
}
