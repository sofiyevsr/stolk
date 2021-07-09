import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";

class AddressInput extends StatelessWidget {
  final void Function(String?) _onSaved;
  final TextEditingController _textController;
  const AddressInput({
    Key? key,
    required TextEditingController textController,
    required void Function(String?) onSaved,
  })  : this._onSaved = onSaved,
        this._textController = textController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        autofillHints: [AutofillHints.fullStreetAddress],
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.next,
        controller: _textController,
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
          labelText: tr('fields.address'),
          hintText: tr('fields.address'),
        ),
        onSaved: (s) => _onSaved(
          s?.trim(),
        ),
        validator: (s) {
          if (s != null && s.isNotEmpty) {
            if (s.length >= 2 && s.length <= 30)
              return null;
            else
              return tr('validations.address_min2_max30');
          }
          return tr('validations.address_empty');
        },
      ),
    );
  }
}
