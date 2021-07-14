import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/utils/services/app/startupService.dart';
import "package:flutter/material.dart";

class CheckTokenFailScreen extends StatefulWidget {
  const CheckTokenFailScreen({Key? key}) : super(key: key);

  @override
  _CheckTokenFailScreenState createState() => _CheckTokenFailScreenState();
}

class _CheckTokenFailScreenState extends State<CheckTokenFailScreen> {
  bool isLoading = false;
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    isMounted = true;
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  void retryCheckToken() {
    StartupService.instance.checkTokenAndSaveDeviceToken();
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(milliseconds: 5000), () {
      if (isMounted == true)
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      Text(
                        tr("errors.default"),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: isLoading == true ? null : retryCheckToken,
                  child: Text(
                    tr("errors.retry_check_token"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
