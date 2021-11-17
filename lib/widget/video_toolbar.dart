import 'package:bilibili/model/video_detail_model.dart';
import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/format_util.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:bilibili/provider/theme_provider.dart';
import 'package:provider/provider.dart';


///视频点赞分享收藏等工具栏import 'package:provider/provider.dart';
class VideoToolBar extends StatelessWidget {
  final VideoDetailModel detailModel;
  final VideoModel videoModel;
  final VoidCallback onLike;
  final VoidCallback onUnLike;
  final VoidCallback onCoin;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const VideoToolBar(
      {Key key,
      @required this.detailModel,
      @required this.videoModel,
      this.onLike,
      this.onUnLike,
      this.onCoin,
      this.onFavorite,
      this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      margin: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(color:  themeProvider.isDark()?null:Colors.white, border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded, videoModel.like,
              onClick: onLike, tint: detailModel?.isLike),
          _buildIconText(Icons.thumb_down_alt_rounded, "不喜欢",
              onClick: onUnLike),
          _buildIconText(Icons.monetization_on, videoModel.coin,
              onClick: onCoin),
          _buildIconText(Icons.grade_rounded, videoModel.favorite,
              onClick: onFavorite, tint: detailModel?.isFavorite),
          _buildIconText(Icons.share_rounded, videoModel.share,
              onClick: onShare),
        ],
      ),
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      //  显示格式化
      text = countFormat(text);
    } else if (text == null) {
      text = '';
    }
    tint = tint == null ? false : tint;
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? primary : Colors.grey,
            size: 20,
          ),
          hiSpace(height: 5),
          Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
