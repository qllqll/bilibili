import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/ranking_request.dart';
import 'package:bilibili/model/ranking_model.dart';

class RankingDao {
  static get(String sort, {int pageIndex = 1, int pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add("sort", sort)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet.getInstace().fire(request);
    return RankingModel.fromJson(result['data']);
  }
}
