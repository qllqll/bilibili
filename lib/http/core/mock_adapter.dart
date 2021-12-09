import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/hi_base_request.dart';

///测试适配器，mock数据

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
    // TODO: implement send
    return Future<HiNetResponse>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          data: {"code": 0, "message": "success"}, statusCode: 200);
    });
  }
}
