import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/constants.dart';

import 'customCachedImage.dart';

class SourceLogo extends StatelessWidget {
  final String logoSuffix;
  final bool isCircle;
  const SourceLogo({
    Key? key,
    required this.logoSuffix,
    this.isCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCircle == true)
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              sourceLogosPrefix + logoSuffix,
            ),
          ),
        ),
      );
    return Container(
      child: CustomCachedImage(
        url: sourceLogosPrefix + logoSuffix,
        fit: BoxFit.cover,
      ),
    );
  }
}
