import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {
  final int newsID;
  const ReportDialog({Key? key, required this.newsID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("report"),
      content: Container(
        child: TextField(),
      ),
    );
  }
}
