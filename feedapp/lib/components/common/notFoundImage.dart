import 'package:flutter/material.dart';

class NotFoundImage extends StatelessWidget {
  final Color color;
  const NotFoundImage({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Transform.translate(
        offset: const Offset(
          0,
          12,
        ),
        child: const Icon(
          Icons.image_outlined,
          size: 128,
          color: Colors.white,
        ),
      ),
    );
  }
}
