import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/utils/services/app/startupService.dart';
import "package:flutter/material.dart";

class CheckTokenFailScreen extends StatefulWidget {
  const CheckTokenFailScreen({Key? key}) : super(key: key);

  @override
  _CheckTokenFailScreenState createState() => _CheckTokenFailScreenState();
}

class _CheckTokenFailScreenState extends State<CheckTokenFailScreen> {
  bool isLoading = false;

  void retryCheckToken() {
    StartupService.instance.checkTokenAndSaveDeviceToken();
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(milliseconds: 5000), () {
      if (mounted == true)
        setState(() {
          isLoading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 128,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  tr("errors.auth_check_failed"),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ElevatedButton(
                  onPressed: isLoading == true ? null : retryCheckToken,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text(
                    tr("errors.retry_check_token"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
