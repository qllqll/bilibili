import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/http/request/hi_base_request.dart';
import 'package:bilibili/util/hi_constants.dart';

abstract class BaseRequest extends HiBaseRequest {
  @override
  String url() {
    if (needLogin()) {
      //  需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return super.url();
  }

  Map<String, dynamic> header = {
    HiConstants.authTokenK: HiConstants.authTokenV,
    HiConstants.courseFlagK: HiConstants.courseFlagV
  };
}
