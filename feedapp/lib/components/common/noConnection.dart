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
          Icon(
            Icons.wifi_off,
            color: Colors.blue[700],
            size: 100,
          ),
          Text(
            tr("errors.network_error"),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (this.onRetry != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(40, 40),
                  ),
                ),
                onPressed: onRetry,
                child: Text(
                  tr("buttons.retry_request"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
