import 'package:bilibili/model/home_model.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text(widget.videoModel.vid),
            Text(widget.videoModel.title),
            _videoView()
          ],
        ));
  }

  _videoView() {
    var model = widget.videoModel;
    print("model ---- ${model.cover}");
    return VideoView(model.url, cover: model.cover,autoPlay: true,);
  }
}
