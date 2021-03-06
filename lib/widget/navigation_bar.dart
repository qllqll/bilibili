import 'package:bilibili/provider/theme_provider.dart';
import 'package:bilibili/util/color.dart';
import 'package:bilibili/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  var _statusStyle;
  var _color;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    if(themeProvider.isDark()){
    _color = HiColor.dark_bg;
    _statusStyle = StatusStyle.LIGHT_CONTENT;
    } else {
      _color = widget.color;
      _statusStyle = widget.statusStyle;
    }
    _statusBarInit();
    var top = MediaQuery.of(context).padding.top;
    print(top);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height + top,
        child: widget.child,
        padding: EdgeInsets.only(top: top),
        decoration: BoxDecoration(color: _color));
  }

  void _statusBarInit() {
  //  沉浸式状态栏
    changeStatusBar(color:_color,statusStyle: _statusStyle);
  }
}
