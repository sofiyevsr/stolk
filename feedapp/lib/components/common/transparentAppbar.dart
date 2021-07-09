import 'package:partner_gainclub/utils/services/app/navigationService.dart';
import "package:flutter/material.dart";

class TransparentAppbar extends StatelessWidget {
  final Widget child;
  final String? text;
  const TransparentAppbar({Key? key, required this.child, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        AppBar(
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Icon(
              Icons.arrow_back_sharp,
              size: 30,
            ),
            onPressed: () {
              NavigationService.pop();
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
