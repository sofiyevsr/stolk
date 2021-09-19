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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 128,
                      ),
                      Text(
                        tr("errors.auth_check_failed"),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: isLoading == true ? null : retryCheckToken,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      tr("errors.retry_check_token"),
                    ),
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
