import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FetchFailWidget extends StatelessWidget {
  final String defaultText = "errors.fetch_failed";
  final String? errorText;
  FetchFailWidget({Key? key, this.errorText}) : super(key: key);

  @override
  Widget build(ctx) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 124,
            ),
            Text(
              tr(errorText ?? defaultText),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      );
}
