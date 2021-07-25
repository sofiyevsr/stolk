import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";

class EmailInput extends StatelessWidget {
  final void Function(String?) _onSaved;
  const EmailInput({Key? key, required void Function(String?) onSaved})
      : this._onSaved = onSaved,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            isDense: true,
            alignLabelWithHint: true,
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 26,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            labelText: tr('fields.email'),
            hintText: tr('fields.email')),
        onSaved: (s) => _onSaved(s?.trim()),
        validator: (s) {
          if (s != null && s.isNotEmpty) {
            RegExp emailRegex =
                RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
            return emailRegex.hasMatch(s)
                ? null
                : tr('validations.invalid_email');
          }
          return tr('validations.invalid_email');
        },
      ),
    );
  }
}
