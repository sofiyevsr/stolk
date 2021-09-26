import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/app/toastService.dart';

typedef ConfirmFunction = Future<dynamic> Function(String);

class ReportDialog extends StatefulWidget {
  final ConfirmFunction onConfirmed;
  const ReportDialog({Key? key, required this.onConfirmed}) : super(key: key);

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _reportMessage = TextEditingController();
  bool _isRequestOn = false;
  bool _hasError = false;

  @override
  void dispose() {
    _reportMessage.dispose();
    super.dispose();
  }

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
          child: Text(
            tr("commons.cancel"),
          ),
        ),
        ElevatedButton(
          onPressed: _isRequestOn == true
              ? null
              : () {
                  if (_reportMessage.text.trim() == "") {
                    setState(() {
                      _hasError = true;
                    });
                    return;
                  }
                  setState(() {
                    _hasError = false;
                    _isRequestOn = true;
                  });
                  widget
                      .onConfirmed(_reportMessage.text.trim())
                      .then((_) {})
                      .catchError((_) {})
                      .whenComplete(() {
                    NavigationService.pop();
                    ToastService.instance.showSuccess(
                      tr("report_dialog.success"),
                    );
                  });
                },
          child: Text(
            tr("commons.confirm"),
          ),
        ),
      ],
      content: Container(
        child: TextField(
          controller: _reportMessage,
          decoration: InputDecoration(
            errorText:
                _hasError == true ? tr("errors.report_message_empty") : null,
            labelText: tr("report_dialog.message_placeholder"),
            border: OutlineInputBorder(),
          ),
          maxLength: 300,
          maxLines: 3,
        ),
      ),
    );
  }
}
