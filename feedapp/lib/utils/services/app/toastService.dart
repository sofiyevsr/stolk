import 'package:flutter/material.dart';

import '../../throttle.dart';

const throttleDuration = const Duration(seconds: 6);

class ToastService {
  static final instance = ToastService._();
  static final _key = GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<ScaffoldMessengerState> get key => _key;
  final _alertThrottler = Throttler(duration: throttleDuration);
  final _throttler = Throttler(duration: throttleDuration);

  ToastService._();

  showSuccess(String content) {
    _throttler.run(
      () {
        _key.currentState?.showSnackBar(
          SnackBar(
            elevation: 5,
            padding: EdgeInsets.zero,
            content: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.done,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration(milliseconds: 3500),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  showAlert(String content) {
    _alertThrottler.run(
      () {
        _key.currentState?.showSnackBar(
          SnackBar(
            elevation: 5,
            padding: EdgeInsets.zero,
            content: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration(milliseconds: 3500),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
