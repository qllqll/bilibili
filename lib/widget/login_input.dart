import 'dart:ui';

import 'package:bilibili/util/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///登录输入框 自定义的widget

class LoginInput extends StatefulWidget {
  //标题
  final String title;
  //提示
  final String hint;
  //输入变化
  final ValueChanged<String> onChanged;
  //焦点变化
  final ValueChanged<bool> focusChanged;
  //下划线是否展开
  final bool lineStretch;
  //是否是密码的输入提示
  final bool obscureText;
  //输入框的类型
  final TextInputType keyboardType;
  //传入默认值
  final String text;

  const LoginInput(this.title, this.hint,
      {Key key,
      this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType,
      this.text})
      : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  是否获取光标的监听
    _focusNode.addListener(() {
      if (widget.focusChanged != null) {
        widget.focusChanged(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(widget.title, style: TextStyle(fontSize: 16)),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: !widget.lineStretch ? 15 : 0,
              right: !widget.lineStretch ? 15 : 0),
          child: Divider(height: 1, thickness: 0.5),
        )
      ],
    );
  }

  _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofocus: !widget.obscureText,
      cursorColor: primary,
      controller: TextEditingController.fromValue(TextEditingValue(
          text: widget.text ?? '',
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream,
              offset: widget.text?.length??0)))),
      style: TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
      //      输入框其他样式
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          border: InputBorder.none,
          hintText: widget.hint ?? '',
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
    ));
  }
}
