import 'package:bilibili/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }

//基础请求
abstract class BaseRequest {
  var pathParams;
  var userHttps = true;

  String authority() {
    return 'api.devio.org';
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    //拼接path参数
    var pathStr = path();
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = '${path()}$pathParams';
      } else {
        pathStr = '${path()}/$pathParams';
      }
    }
    //  http和https的切换
    if (userHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      //  需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('uri:${uri.toString()}');
    print('请求头:$header');
    print('请求参:$params');
    return uri.toString();
  }

  //是否需要登录的接口
  bool needLogin();

  Map<String, String> params = Map();

//  添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    'course-flag': 'fa',
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa'
  };

//  添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
