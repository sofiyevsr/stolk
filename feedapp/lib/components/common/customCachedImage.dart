import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double radius;
  CustomCachedImage({
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.radius = 0,
    required this.url,
  }) : super(key: key);
  @override
  Widget build(ctx) {
    return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(),
      errorWidget: (context, url, error) => FittedBox(
        child: Tooltip(
          message: tr("errors.image_fetch_failed"),
          child: Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      ),
      imageBuilder: (ctx, provider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(this.radius),
          image: DecorationImage(image: provider, fit: fit),
        ),
      ),
      imageUrl: url,
      width: width,
      height: height,
    );
  }
}
