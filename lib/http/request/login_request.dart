import 'package:bilibili/http/request/base_request.dart';

import 'hi_base_request.dart';

class LoginRequest extends BaseRequest {
  HttpMethod httpMethod() {
    // TODO: implement httpMethod
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    // TODO: implement path
    return '/uapi/user/login';
  }
}
