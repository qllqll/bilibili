import 'package:bilibili/http/request/hi_base_request.dart';
import 'package:bilibili/http/request/favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequest{
  @override
  HttpMethod httpMethod() {
    // TODO: implement httpMethod
    return HttpMethod.DELETE;
  }



}