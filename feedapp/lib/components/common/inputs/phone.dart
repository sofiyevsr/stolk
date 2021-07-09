import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInput extends StatefulWidget {
  final void Function(String?) _onSaved;
  const PhoneInput({Key? key, required void Function(String?) onSaved})
      : this._onSaved = onSaved,
        super(key: key);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) ###-##-##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          prefixIcon: Icon(
            Icons.phone,
            size: 32,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          labelText: tr('fields.phone'),
          hintText: tr('fields.phone'),
        ),
        onSaved: (s) => widget._onSaved(
          s?.trim(),
        ),
        validator: (phone) {
          if (phone == null) {
            return tr('validations.invalid_phone');
          }
          final p = maskFormatter.unmaskText(phone);
          if (p.isNotEmpty) {
            RegExp phoneRegex =
                RegExp(r'(^((50)|(51)|(55)|(70)|(77)|(99))[0-9]{7}$)');
            return phoneRegex.hasMatch(p)
                ? null
                : tr('validations.invalid_phone');
          }
          return tr('validations.invalid_phone');
        },
        inputFormatters: [maskFormatter],
      ),
    );
  }
}
