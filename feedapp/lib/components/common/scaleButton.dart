import 'package:flutter/material.dart';

class ScaleButton extends StatefulWidget {
  final Function onFinish;
  final Widget child;
  final bool? disabled;
  ScaleButton({
    required this.onFinish,
    required this.child,
    this.disabled,
  });

  @override
  _ScaleButton createState() => _ScaleButton();
}

class _ScaleButton extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this, value: 1);
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(ctx) => ScaleTransition(
        scale: _scale,
        child: AbsorbPointer(
          absorbing: widget.disabled == true,
          child: GestureDetector(
            onTap: () {
              widget.onFinish();
            },
            onLongPressStart: (_) {
              _controller.animateTo(.7);
            },
            onLongPressEnd: (_) {
              _controller.animateTo(1);
              widget.onFinish();
            },
            child: widget.child,
          ),
        ),
      );
}
