import 'package:flutter/material.dart';

class TilesHeader extends StatelessWidget {
  final String title;

  TilesHeader({required this.title});

  @override
  Widget build(context) {
    final headline = Theme.of(context).textTheme.headline6;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          this.title,
          style: headline?.copyWith(fontWeight: FontWeight.normal),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
