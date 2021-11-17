import 'dart:io';

import 'package:bilibili/barrage/barrage_input.dart';
import 'package:bilibili/barrage/barrage_item.dart';
import 'package:bilibili/barrage/barrage_switch.dart';
import 'package:bilibili/barrage/hi_barrage.dart';
import 'package:bilibili/barrage/hi_socket.dart';
import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/favorite_dao.dart';
import 'package:bilibili/http/dao/video_detail_dao.dart';
import 'package:bilibili/model/video_detail_model.dart';
import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/provider/theme_provider.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/expandable_content.dart';
import 'package:bilibili/widget/hi_tab.dart';
import 'package:bilibili/widget/navigation_bar.dart';
import 'package:bilibili/widget/video_header.dart';
import 'package:bilibili/widget/video_large_card.dart';
import 'package:bilibili/widget/video_toolbar.dart';
import 'package:bilibili/widget/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:provider/provider.dart';

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
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();
  var _inputShowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  黑色状态栏  仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
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
    var themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
        body: MediaQuery.removePadding(
            removeTop: Platform.isIOS,
            context: context,
            child: videoModel.url != null
                ? Column(
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
                  )
                : Container()));
  }

  _buildVideoView() {
    var model = videoModel;
    print("model ---- ${model.cover}");
    return VideoView(model.url,
        cover: model.cover,
        overlayUI: videoAppBar(),
        autoPlay: true,
        barrageUI: HiBarrage(
          key: _barrageKey,
          vid: model.vid,
          autoPlay: true,
        ));
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
          alignment: Alignment.center,
          height: 39,
          // color: Colors.white,
          padding: EdgeInsets.only(left: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_tabBar(), _buildBarrageBtn()])),
    );
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
      inputShowing: _inputShowing,
      onShowInput:(){
        setState(() {
          _inputShowing = true;
        });
        HiOverlay.show(context, child: BarrageInput(
          onTabClose: () {
            setState(() {
              _inputShowing = false;
            });
          },
        )).then((value){
          print('---input:$value');
          _barrageKey.currentState.send(value);
        });
      } ,onBarrageSwitch:(open){
        if(open){
          _barrageKey.currentState.play();
        } else {
          _barrageKey.currentState.pause();

        }
    } ,
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
      children: [...buildContents(), ...buildVideoList()],
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
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  void _doUnLike() {}

  void _doLike() {}

  //收藏和取消收藏
  void _doFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel.vid, !videoDetailModel.isFavorite);
      videoDetailModel.isFavorite = !videoDetailModel.isFavorite;
      if (videoDetailModel.isFavorite) {
        videoModel.favorite += 1;
      } else {
        videoModel.favorite -= 1;
      }
      setState(() {
        videoDetailModel = videoDetailModel;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  void _doShare() {}

  buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }
}
