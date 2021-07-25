import 'package:flutter/material.dart';

class CenterLoadingWidget extends StatelessWidget {
  const CenterLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
