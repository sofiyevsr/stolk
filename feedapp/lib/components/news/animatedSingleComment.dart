import 'package:flutter/material.dart';

import 'singleComment.dart';

class AnimatedSingleComment extends StatelessWidget {
  final SingleCommentView child;
  final Function() onEnd;
  final bool shouldAnimate;
  AnimatedSingleComment(
      {Key? key,
      required this.child,
      required this.shouldAnimate,
      required this.onEnd})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return shouldAnimate == false
        ? child
        : TweenAnimationBuilder<int>(
            onEnd: onEnd,
            duration: const Duration(milliseconds: 300),
            tween: IntTween(begin: -100, end: 0),
            builder: (_, int val, __) => Transform.translate(
              offset: Offset(val.toDouble(), 0),
              child: child,
            ),
          );
  }
}
