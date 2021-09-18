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

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName;
  String password;
  String rePassword;
  String imoocId;
  String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        //自适应键盘弹起，防止遮挡
        child: ListView(
          children: [
            LoginEffect(
              protect: protect,
            ),
            LoginInput(
              '用户名',
              '请输入用户名',
              onChanged: (text) {
                userName = text;
                _checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
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
            LoginInput(
              '确认密码',
              '请再次输入密码',
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
                _checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              '慕课网ID',
              '请输入慕课网用户ID',
              keyboardType: TextInputType.number,
              onChanged: (text) {
                imoocId = text;
                _checkInput();
              },
            ),
            LoginInput(
              '课程订单号',
              '请输入课程订单号后四位',
              keyboardType: TextInputType.number,
              onChanged: (text) {
                orderId = text;
                _checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                '注册',
                enable: loginEnable,
                onPressed: _checkParams,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          _checkParams();
        } else {
          print('不能登录');
        }
      },
      child: Text('注册'),
    );
  }

  Future<void> _send() async {
    try {
      var result =
          await LoginDao.registration(userName, password, imoocId, orderId);
      print(result);
      if (result['code'] == 0) {
        showToast('注册成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    } catch (e) {
      print(e);
    }
  }

  void _checkParams() {
    String tips;
    if (password != rePassword) {
      tips = '两次密码输入不一致';
    } else if (orderId.length != 4) {
      tips = '请输入订单号的后四位';
    }
    if (tips != null) {
      showWarnToast(tips);
      return;
    }
    _send();
  }
}
