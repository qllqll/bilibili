import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/video_detail_request.dart';
import 'package:bilibili/model/video_detail_model.dart';

///视频详情页
class VideoDetailDao{
  static get(String vid) async{
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstace().fire(request);
    return VideoDetailModel.fromJson(result['data']);
  }
}