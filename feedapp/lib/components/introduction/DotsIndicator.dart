import "package:flutter/material.dart";

const margin = 8.0;

class DotsIndicator extends StatefulWidget {
  final int length;
  final int current;

  const DotsIndicator({Key? key, required this.length, required this.current})
      : super(key: key);

  @override
  _DotsIndicatorState createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<DotsIndicator> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    EdgeInsets defineMargin(int index) {
      if (index == widget.length - 1) {
        return const EdgeInsets.only(left: margin);
      }
      if (index == 0) {
        return const EdgeInsets.only(right: margin);
      }
      return const EdgeInsets.symmetric(horizontal: margin);
    }

    return AnimatedContainer(
      height: widget.current == widget.length ? 0 : 15,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(widget.length, (index) => index)
            .map(
              (i) => Expanded(
                child: AnimatedContainer(
                  margin: defineMargin(i),
                  duration: const Duration(milliseconds: 300),
                  color: widget.current == i
                      ? theme.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
