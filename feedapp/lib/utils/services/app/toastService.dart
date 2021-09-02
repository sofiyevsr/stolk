import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../throttle.dart';

const duration = const Duration(seconds: 7);

class ToastService {
  static final instance = ToastService._();
  static final _key = GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<ScaffoldMessengerState> get key => _key;
  final _throttler = Throttler(duration: duration);

  ToastService._();

  showAlert(String content) {
    _throttler.run(
      () {
        _key.currentState?.showSnackBar(
          SnackBar(
            elevation: 5,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            duration: duration,
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
