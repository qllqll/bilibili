import 'package:bilibili/barrage/barrage_transition.dart';
import 'package:flutter/material.dart';

///弹幕widget
class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  BarrageItem(
      {Key key, this.id, this.top, this.child, this.onComplete, this.duration = const Duration(
          milliseconds: 9000)})
      : super(key: key);

  //fix 动画状态错乱
  var _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(top: top,
        child: BarrageTransition(
            child: child, duration: duration, onComplete: (v) {
          onComplete(id);
        }));
  }
}
