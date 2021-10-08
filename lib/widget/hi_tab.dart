import 'package:bilibili/util/color.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

///顶部tab切换组件
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController controller;
  final double fonsize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;

  const HiTab( this.tabs,{
    Key key,
    this.controller,
    this.fonsize = 13,
    this.borderWidth = 2,
    this.insets = 15,
    this.unselectedLabelColor = Colors.grey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor:primary,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle:TextStyle(fontSize: fonsize),
        indicator: UnderlineIndicator(
          strokeCap: StrokeCap.square,
          borderSide: BorderSide(color:primary,width: borderWidth ),
          insets:EdgeInsets.only(left: insets,right: insets)
        ),
        tabs: tabs);
  }
}
