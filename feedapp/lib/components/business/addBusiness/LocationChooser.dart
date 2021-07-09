import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:partner_gainclub/utils/constants.dart';
import 'package:partner_gainclub/utils/services/app/navigationService.dart';

import 'ChooserMap.dart';

class LocationChooser extends FormField<ChooseResult> {
  LocationChooser(
      Function(ChooseResult?) onSaved, TextEditingController _addressController)
      : super(
          onSaved: onSaved,
          validator: (loc) {
            if (loc == null) {
              return tr("choose_loc");
            }
            return null;
          },
          builder: (state) => Column(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  state.value == null ? Colors.red : Colors.green,
                )),
                onPressed: () async {
                  final ChooseResult? data = await NavigationService
                      .key.currentState!
                      .push<ChooseResult?>(
                    NavigationService.wrapRoute<ChooseResult?>(
                      ChooserMap(state.value),
                      RouteNames.CHOOSER_MAP,
                    ),
                  );
                  if (data != null) {
                    if (data.address != null)
                      _addressController.value = TextEditingValue(
                        text: data.address!,
                      );
                    state.didChange(data);
                  }
                },
                child: Icon(
                  Icons.location_pin,
                  size: 32,
                ),
              ),
              if (state.errorText != null)
                Text(
                  state.errorText!,
                  style:
                      Theme.of(state.context).inputDecorationTheme.errorStyle,
                ),
            ],
          ),
        );
}
