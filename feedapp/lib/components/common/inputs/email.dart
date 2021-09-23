import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";

class EmailInput extends StatelessWidget {
  final TextEditingController? _controller;
  final void Function(String?)? _onSaved;
  const EmailInput({
    Key? key,
    void Function(String?)? onSaved,
    TextEditingController? controller,
  })  : this._onSaved = onSaved,
        this._controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
          hintText: tr('fields.email'),
        ),
        controller: _controller,
        onSaved: (s) => _onSaved == null ? null : _onSaved!(s?.trim()),
        validator: (value) {
          final s = value?.trim();
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
