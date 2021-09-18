import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HiBanner extends StatelessWidget {
  final List<BannerModel> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry padding;


  const HiBanner(this.bannerList,{this.padding, this.bannerHeight = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child:_banner()
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal??0)/2;
    return Swiper(itemCount: bannerList.length,autoplay: true,
    itemBuilder: (BuildContext context,int index){
      return  _image(bannerList[index]);
    },
    //自定义指示器
      pagination: SwiperPagination(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(right: right,bottom:10),
        builder: DotSwiperPaginationBuilder(
          color: Colors.white60,size: 6,activeSize: 6
        )
      ),
    );
  }

  _image(BannerModel bannerModel) {
    return InkWell(onTap: (){
     _handleClick(bannerModel);
    },child:Container(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Image.network(bannerModel.cover,fit: BoxFit.cover)
      ),
    ));
  }

  void _handleClick(BannerModel bannerModel) {
    if(bannerModel.type == 'video'){
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,args: {'videoModel':VideoModel(vid: bannerModel.url)});
    } else {
      print(bannerModel.url);
    }
  }
}
