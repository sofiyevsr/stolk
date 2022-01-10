import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  final Function()? onRetry;
  const NoConnectionWidget({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              tr("errors.network_error"),
              style: const TextStyle(
                fontSize: 24,
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
