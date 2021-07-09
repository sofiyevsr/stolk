import 'package:easy_localization/easy_localization.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          suffixIcon: IconButton(
              tooltip:
                  _showPassword ? tr("hide_password") : tr("show_password"),
              iconSize: 30,
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
            size: 32,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          labelText: tr('fields.password'),
          hintText: tr('fields.password'),
        ),
        onSaved: (s) => widget._onSaved(s?.trim()),
        validator: (s) {
          if (s != null && s.isNotEmpty && s.trim().length > 8) {
            return null;
          }
          return tr('validations.invalid_password');
        },
      ),
    );
  }
}
