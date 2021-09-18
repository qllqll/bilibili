import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/util/string_util.dart';
import 'package:bilibili/util/toast.dart';
import 'package:bilibili/widget/app_bar.dart';
import 'package:bilibili/widget/login_button.dart';
import 'package:bilibili/widget/login_effect.dart';
import 'package:bilibili/widget/login_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName;
  String password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = LoginDao.getUserName();
    password = LoginDao.getPassword();
    _checkInput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户名',
              onChanged: (text) {
                userName = text;
                _checkInput();
              },
              text: userName,
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              text: password,
              onChanged: (text) {
                password = text;
                _checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: LoginButton(
                '登录',
                enable: loginEnable,
                onPressed: _send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void _send() async {
    try {
      var result = await LoginDao.login(userName, password);
      print(result);
      if (result['code'] == 0) {
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
        print('登录成功');
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
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
}
