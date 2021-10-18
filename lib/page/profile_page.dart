import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/profile_dao.dart';
import 'package:bilibili/model/profile_model.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:bilibili/widget/benefit_card.dart';
import 'package:bilibili/widget/course_card.dart';
import 'package:bilibili/widget/hi_banner.dart';
import 'package:bilibili/widget/hi_blur.dart';
import 'package:bilibili/widget/hi_flexible_header.dart';
import 'package:flutter/material.dart';

///我的
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileModel _profileModel;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[_buildAppBar()];
      },
      body: ListView(
        padding: EdgeInsets.only(top: 10),
        children: [..._buildContentList()],
      ),
    ));
  }

  void _loadData() async {
    try {
      var result = await ProfileDao.get();
      setState(() {
        _profileModel = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    } catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if (_profileModel == null) return Container();
    return HiFlexibleHeader(
        face: _profileModel.face,
        name: _profileModel.name,
        controller: _scrollController);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _buildAppBar() {
    return SliverAppBar(
      //  扩展高度
      expandedHeight: 160,
      //  标题栏是否固定
      pinned: true,
      //滚动空间
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          titlePadding: EdgeInsets.only(left: 0),
          title: _buildHead(),
          background: Stack(
            children: [
              Positioned.fill(
                  child: cachedImage(
                      'https://img2.baidu.com/it/u=1095903005,1370184727&fm=26&fmt=auto')),
              Positioned.fill(
                  child: HiBlur(
                sigma: 20,
              )),
              Positioned(
                child: _buildProfileTab(),
                bottom: 0,
                left: 0,
                right: 0,
              )
            ],
          )),
    );
  }

  _buildContentList() {
    if (_profileModel == null) {
      return [];
    }
    return [_buildBanner(),CourseCard(courseList: _profileModel.courseList),BenefitCard(benefitList: _profileModel.benefitList)];
  }

  _buildBanner() {
    return HiBanner(
      _profileModel.bannerList,
      bannerHeight: 120,
      padding: EdgeInsets.only(left: 10, right: 10),
    );
  }

  _buildProfileTab() {
    if (_profileModel == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileModel.favorite),
          _buildIconText('点赞', _profileModel.like),
          _buildIconText('浏览', _profileModel.browsing),
          _buildIconText('金币', _profileModel.coin),
          _buildIconText('分散', _profileModel.fans)
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        )
      ],
    );
  }
}
