import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/model/barrage_model.dart';
import 'package:bilibili/util/hi_constants.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

///负责与后端进行websocket通信
class HiSocket implements ISocket{
  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel _channel;
  ValueChanged<List<BarrageModel>> _callBack;
  ///心跳间隔秒数，根据服务器实际timneout时间来调整，这里nginx服务器的timeout为60s
  int _intervalSeconds = 50;
  @override
  void close() {
    if(_channel != null) {
      _channel.sink.close();
    }
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callBack) {
   _callBack = callBack;
   return this;
  }

  @override
  ISocket open(String vid) {
   _channel = IOWebSocketChannel.connect(_URL + vid,headers:_headers(),pingInterval: Duration(seconds: _intervalSeconds));
    _channel.stream.handleError((error){print('连接发生错误：$error');}).listen((message) {
      _handleMessage(message);
    });
    return this;
  }

  @override
  ISocket send(String message) {
   _channel.sink.add(message);
   return this;
  }

  _headers() {
    Map<String,dynamic> header ={
      HiConstants.authTokenK: HiConstants.authTokenV,
      HiConstants.courseFlagK: HiConstants.courseFlagV,
    };
    header[LoginDao.BOARDING_PASS] = LoginDao.getBoardingPass();
    return header;
  }

  ///处理服务器的返回
  void _handleMessage(message) {
    print("received:$message");
    var result = BarrageModel.fromJsonString(message);
    if(result != null &&_callBack != null) {
      _callBack(result);
    }
  }
}


///抽象类
abstract class ISocket {
  ///和服务器建立连接
  ISocket open(String vid);

  /// 发送弹幕
  ISocket send(String message);

  ///关闭连接
  void close();

  ///接收弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}