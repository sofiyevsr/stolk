import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";

class FirstNameInput extends StatelessWidget {
  final void Function(String?) _onSaved;
  const FirstNameInput({Key? key, required void Function(String?) onSaved})
      : this._onSaved = onSaved,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            isDense: true,
            alignLabelWithHint: true,
            prefixIcon: Icon(
              Icons.person_outlined,
              size: 32,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            labelText: tr('fields.first_name'),
            hintText: tr('fields.first_name')),
        onSaved: (s) => _onSaved(s?.trim()),
        validator: (value) {
          final s = value?.trim();
          if (s != null && s.isNotEmpty) {
            if (s.length >= 2 && s.length <= 30)
              return null;
            else
              return tr('validations.first_name_min2_max30');
          }
          return tr('validations.first_name_empty');
        },
      ),
    );
  }
}
