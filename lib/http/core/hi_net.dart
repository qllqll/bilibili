import 'package:bilibili/http/core/dio_adapter.dart';
import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/hi_base_request.dart';

class HiNet {
  HiNet._();
  static HiNet _instance;
  static HiNet getInstace() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

  Future fire(HiBaseRequest request) async {
    HiNetResponse response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      //系统自定义异常
      error = e;
      response = e.data;
      // printLog('error, ${e.message}');
    } catch (e) {
      //其他异常
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response.data;
    printLog(result);
    var status = response.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        return NeedLogin();
      case 403:
        return NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(HiBaseRequest request) async {
    printLog('url：${request.url()}');
    // printLog('url：${request.httpMethod()}');
    // request.addHeader('token', '123');
    // printLog('header:${request.header}');
    // return Future.value({
    //   'statusCode': 200,
    //   'data': {'code': 0, 'message': 'success'}
    // });

    //使用Mock发送请求
    // HiNetAdapter adapter = MockAdapter();
    // return adapter.send(request);

    //  使用Dio发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
