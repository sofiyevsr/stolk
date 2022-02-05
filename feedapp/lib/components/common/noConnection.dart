import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'lottieLoader.dart';

class NoConnectionWidget extends StatelessWidget {
  final Function()? onRetry;
  const NoConnectionWidget({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LottieLoader(
            asset: "assets/lottie/no_connection.json",
            size: Size(150, 150),
            repeat: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AutoSizeText(
              tr("errors.network_error"),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text(
                tr("buttons.retry_request"),
              ),
            ),
        ],
      ),
    );
  }
}
