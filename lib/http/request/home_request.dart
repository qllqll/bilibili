import 'package:bilibili/http/request/base_request.dart';

import 'hi_base_request.dart';

class HomeRequest extends BaseRequest{
  @override
  HttpMethod httpMethod() {
   return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/home/";
  }

}