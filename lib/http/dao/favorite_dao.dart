import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/base_request.dart';
import 'package:bilibili/http/request/cancel_favorite_request.dart';
import 'package:bilibili/http/request/favorite_request.dart';

class FavoriteDao {
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstace().fire(request);
    print(result);
    return result;
  }
}
