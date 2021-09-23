import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/utils/constants.dart';
import "package:flutter/material.dart";

class PasswordInput extends StatefulWidget {
  final void Function(String?) _onSaved;
  const PasswordInput({Key? key, required void Function(String?) onSaved})
      : this._onSaved = onSaved,
        super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          suffixIcon: IconButton(
              tooltip: _showPassword
                  ? tr("tooltips.hide_password")
                  : tr("tooltips.show_password"),
              iconSize: 26,
              icon: _showPassword
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              }),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            size: 26,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          labelText: tr('fields.password'),
          hintText: tr('fields.password'),
        ),
        onSaved: (s) => widget._onSaved(s),
        validator: (s) {
          if (s == null || s.isEmpty) {
            return tr('validations.invalid_password');
          }
          if (!passwordRegex.hasMatch(s)) {
            return tr('validations.invalid_regex');
          }
          return null;
        },
      ),
    );
  }
}
