import 'package:bilibili/core/hi_base_tab_state.dart';
import 'package:bilibili/http/dao/ranking_dao.dart';
import 'package:bilibili/model/ranking_model.dart';
import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/widget/video_large_card.dart';
import 'package:flutter/material.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  const RankingTabPage({Key key, @required this.sort}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingModel, VideoModel, RankingTabPage> {

  @override
  // TODO: implement contentChild
  get contentChild =>
      Container(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top:10),
              itemCount: dataList.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) =>
                  VideoLargeCard(videoModel: dataList[index]))
      );

  @override
  Future<RankingModel> getData(int pageIndex) async {
    // TODO: implement getData
    RankingModel result = await RankingDao.get(
        widget.sort, pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    // TODO: implement parseList
    return result.list;
  }
}
