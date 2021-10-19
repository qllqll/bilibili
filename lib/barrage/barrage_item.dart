import 'package:flutter/material.dart';

///弹幕widget
class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  const BarrageItem(
      {Key key, this.id, this.top, this.child, this.onComplete, this.duration=const Duration(minutes: 9000)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top),
      child: child,
    );
  }
}
