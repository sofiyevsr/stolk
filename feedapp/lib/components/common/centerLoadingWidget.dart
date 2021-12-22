import 'package:flutter/material.dart';

class CenterLoadingWidget extends StatelessWidget {
  const CenterLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
