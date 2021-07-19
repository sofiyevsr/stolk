import 'package:flutter/material.dart';

class SingleNewsActions extends StatelessWidget {
  const SingleNewsActions({Key? key}) : super(key: key);

  Widget _buildIconButton(IconData icon) {
    return IconButton(
      iconSize: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: Icon(icon),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ButtonTheme(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  _buildIconButton(Icons.favorite_border),
                  _buildIconButton(Icons.comment_outlined),
                ],
              ),
            ),
            Container(
              child: _buildIconButton(Icons.share_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
