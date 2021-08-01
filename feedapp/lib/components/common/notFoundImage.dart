import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotFoundImage extends StatelessWidget {
  final Color color;
  const NotFoundImage({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Icon(FontAwesomeIcons.newspaper, size: 64, color: Colors.white),
      ),
    );
  }
}
