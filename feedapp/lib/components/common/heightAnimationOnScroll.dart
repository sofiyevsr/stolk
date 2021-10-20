import 'package:flutter/material.dart';

const scrollThreshold = 150;

class AnimationOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final double maxHeight;
  AnimationOnScroll({
    Key? key,
    required this.scrollController,
    required this.child,
    required this.maxHeight,
  }) : super(key: key);

  @override
  _AnimationOnScrollState createState() => _AnimationOnScrollState();
}

class _AnimationOnScrollState extends State<AnimationOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
    value: 1,
  );

  late final _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  double _scrollY = 0;

  void hideContainer() {
    final value = _controller.value;
    if (value != 0) _controller.animateTo(0);
  }

  void revealContainer() {
    final value = _controller.value;
    if (value != 1) _controller.animateTo(1);
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (_controller.isAnimating) return;
      final value = widget.scrollController.offset;
      if (value == 0 || _scrollY - value > scrollThreshold) {
        revealContainer();
        _scrollY = value;
      } else if (value - _scrollY > scrollThreshold) {
        hideContainer();
        _scrollY = value;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (ctx, child) => SizeTransition(
        sizeFactor: _curve,
        child: Container(
          height: widget.maxHeight,
          child: child,
        ),
      ),
    );
  }
}
