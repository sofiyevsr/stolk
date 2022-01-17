import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/constants.dart';

class CustomBottomSheet<T> extends StatefulWidget {
  final List<CustomBottomSheetOption<T>> options;
  final T defaultValue;
  final Function(T? v) onSubmit;
  final String title;
  const CustomBottomSheet({
    Key? key,
    required this.onSubmit,
    required this.options,
    required this.defaultValue,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomBottomSheet<T>> createState() => _CustomBottomSheetState<T>();
}

class _CustomBottomSheetState<T> extends State<CustomBottomSheet<T>> {
  late T? current = widget.defaultValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          height: 8,
          width: 80,
          margin: const EdgeInsets.only(top: 4.0, bottom: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColorScheme.main,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Text(widget.title, style: theme.textTheme.headline6),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ...widget.options.map<RadioListTile<T>>(
                    (e) => RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      key: ValueKey<T>(e.value),
                      value: e.value,
                      title: e.title,
                      onChanged: (v) {
                        setState(() {
                          current = v;
                        });
                      },
                      groupValue: current,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              widget.onSubmit(current);
              Navigator.pop(context);
            },
            child: Text(
              tr("commons.confirm"),
            ),
          ),
        )
      ],
    );
  }
}

class CustomBottomSheetOption<T> {
  final Widget title;
  final T value;
  final Widget? leading;
  CustomBottomSheetOption(
      {required this.value, required this.title, this.leading});
}
