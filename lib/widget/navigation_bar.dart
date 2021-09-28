import 'package:bilibili/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

class NavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget child;

  const NavigationBar(
      {Key key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 46,
      this.child})
      : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _statusBarInit();
  }

  @override
  Widget build(BuildContext context) {
    var top = MediaQuery.of(context).padding.top;
    print(top);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height + top,
        child: widget.child,
        padding: EdgeInsets.only(top: top),
        decoration: BoxDecoration(color: widget.color));
  }

  void _statusBarInit() {
  //  沉浸式状态栏
    changeStatusBar(color: widget.color,statusStyle: widget.statusStyle);
  }
}
