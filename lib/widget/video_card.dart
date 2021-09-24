import 'package:bilibili/model/home_model.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoModel;
  const VideoCard({Key key,this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.network(videoModel.cover),
      onTap: (){
        print(videoModel.cover);
      },
    );
  }
}
