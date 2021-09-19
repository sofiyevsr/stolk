import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

typedef ConfirmFunction = void Function();

class ReportDialog extends StatelessWidget {
  final ConfirmFunction onConfirmed;
  const ReportDialog({Key? key, required this.onConfirmed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        tr("report_dialog.title"),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("cancel"),
        ),
        ElevatedButton(
          onPressed: onConfirmed,
          child: Text("ok"),
        ),
      ],
      content: Container(
        child: TextField(),
      ),
    );
  }
}
