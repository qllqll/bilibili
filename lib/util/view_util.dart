import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///带缓存的image
Widget cachedImage(String url, {double width, double height}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(color: Colors.grey[200]),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.transparent
      ]);
}
