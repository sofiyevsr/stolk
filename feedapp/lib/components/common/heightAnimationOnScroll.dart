import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    duration: const Duration(milliseconds: 400),
    vsync: this,
    value: 1,
  );

  late final _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      final dir = widget.scrollController.position.userScrollDirection;
      if (dir == ScrollDirection.reverse && !_controller.isAnimating) {
        if (_controller.value != 0) _controller.animateTo(0);
      }
      if (dir == ScrollDirection.forward && !_controller.isAnimating) {
        if (_controller.value != 1) _controller.animateTo(1);
      }
      if (widget.scrollController.offset == 0) {
        if (_controller.value != 1) _controller.animateTo(1);
      }
    });
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
