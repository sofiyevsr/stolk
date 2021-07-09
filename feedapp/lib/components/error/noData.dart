import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class NoDataWidget extends StatelessWidget {
  final String text;

  NoDataWidget({this.text = "messages.no_data"});
  @override
  Widget build(ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          tr(this.text),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
