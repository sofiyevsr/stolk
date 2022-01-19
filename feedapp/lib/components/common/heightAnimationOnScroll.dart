import 'package:flutter/material.dart';

const scrollThreshold = 150;

class AnimationOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final double maxHeight;
  const AnimationOnScroll({
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

  void revealContainer() {
    final value = _controller.value;
    if (value != 1) _controller.animateTo(1);
  }

  void animateContainer(double diff) {
    final offset =
        ((widget.maxHeight - diff) / widget.maxHeight).clamp(0.0, 1.0);
    final value = _controller.value;
    if (offset != value) _controller.animateTo(offset);
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      final value = widget.scrollController.offset;
      if (value == 0) {
        return revealContainer();
      }
      if (_controller.isAnimating) return;
      animateContainer(value);
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
      builder: (ctx, child) => SizedBox(
        height: widget.maxHeight * _curve.value,
        child: child,
      ),
    );
  }
}
