import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToastService {
  static final _key = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get key => _key;

  static showAlert(String content) {
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
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}
