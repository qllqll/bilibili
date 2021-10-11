import 'package:bilibili/http/request/base_request.dart';
import 'package:bilibili/http/request/favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequest{
  @override
  HttpMethod httpMethod() {
    // TODO: implement httpMethod
    return HttpMethod.DELETE;
  }



}