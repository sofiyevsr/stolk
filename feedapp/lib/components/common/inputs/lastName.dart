import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";

class LastNameInput extends StatelessWidget {
  final void Function(String?) _onSaved;
  const LastNameInput({Key? key, required void Function(String?) onSaved})
      : this._onSaved = onSaved,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            isDense: true,
            alignLabelWithHint: true,
            prefixIcon: Icon(
              Icons.person,
              size: 32,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            labelText: tr('fields.last_name'),
            hintText: tr('fields.last_name')),
        onSaved: (s) => _onSaved(s?.trim()),
        validator: (s) {
          if (s != null && s.isNotEmpty) {
            if (s.length >= 2 && s.length <= 30)
              return null;
            else
              return tr('validations.last_name_min2_max30');
          }
          return tr('validations.last_name_empty');
        },
      ),
    );
  }
}
