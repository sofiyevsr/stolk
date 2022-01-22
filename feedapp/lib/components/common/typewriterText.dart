import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  const TypewriterText({Key? key, required this.text, required this.textStyle})
      : super(key: key);

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  int _index = 0;
  bool _blink = false;
  late final Timer _timer;

  late final Timer _blinkTimer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), _timerCallback);
    _blinkTimer =
        Timer.periodic(const Duration(milliseconds: 250), _blinkCallback);
  }

  void _timerCallback(_t) {
    if (_index < widget.text.length) {
      setState(() {
        _index++;
      });
    } else {
      _timer.cancel();
      // Blink continues after text is full
      // _blinkTimer.cancel();
    }
  }

  void _blinkCallback(_t) {
    setState(() {
      _blink = !_blink;
    });
  }

  @override
  void dispose() {
    _blinkTimer.cancel();
    _timer.cancel();
    super.dispose();
  }

  String getText() {
    String txt = widget.text.substring(0, _index) + " ";
    if (_blink) {
      txt = txt.replaceFirst(" ", "|");
    }
    return txt;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getText(),
      key: const ValueKey("text"),
      style: widget.textStyle,
    );
  }
}
