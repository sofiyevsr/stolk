import 'package:flutter/material.dart';
import 'package:stolk/utils/constants.dart';

import 'customCachedImage.dart';

class SourceLogo extends StatelessWidget {
  final String logoSuffix;
  final bool isCircle;
  final double? radius;
  const SourceLogo(
      {Key? key, required this.logoSuffix, this.isCircle = true, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCircle == true)
      return Container(
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 50),
          child: CustomCachedImage(
            url: sourceLogosPrefix + logoSuffix,
            fit: BoxFit.cover,
            height: radius ?? 50,
            width: radius ?? 50,
          ),
        ),
      );
    return Container(
      child: CustomCachedImage(
        url: sourceLogosPrefix + logoSuffix,
        fit: BoxFit.cover,
        height: 50,
      ),
    );
  }
}
