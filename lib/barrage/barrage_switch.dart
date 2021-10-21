import 'package:bilibili/util/color.dart';
import 'package:flutter/material.dart';

class BarrageSwitch extends StatefulWidget {
  ///初始化是否展开
  final bool initSwitch;

  ///是否为输入中
  final bool inputShowing;

  ///输入框切换回调
  final VoidCallback onShowInput;

  ///展开与伸缩状态回调
  final ValueChanged<bool> onBarrageSwitch;

  const BarrageSwitch(
      {Key key,
      this.initSwitch = true,
      @required this.inputShowing = false,
      @required this.onShowInput,
      this.onBarrageSwitch })
      : super(key: key);

  @override
  _BarrageSwitchState createState() => _BarrageSwitchState();
}

class _BarrageSwitchState extends State<BarrageSwitch> {
  bool _barrageSwitch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _barrageSwitch = widget.initSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(15)),
      child:Row(
        children: [_buildText(),_buildIcon()],
      ),
    );
  }

  _buildIcon() {
    return InkWell(
      onTap: (){
        setState(() {
          _barrageSwitch = !_barrageSwitch;
        });
        widget.onBarrageSwitch(_barrageSwitch);
      },
      child:Icon(
        Icons.live_tv_rounded,
        color: _barrageSwitch? primary:Colors.grey,
      )
    );
  }

  _buildText() {
    var text = widget.inputShowing ? "弹幕输入中":"点我发弹幕";
    return _barrageSwitch ? InkWell(
      onTap: (){
        widget.onShowInput();
      },
      child: Padding(
        padding:EdgeInsets.only(right: 10),
        child: Text(text,style: TextStyle(fontSize: 12,color: Colors.grey),),
      ),
    ):Container();
  }
}
