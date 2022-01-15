import "package:flutter/material.dart";

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
    return Row(
      children: List.generate(widget.length, (index) => index)
          .map(
            (i) => AnimatedContainer(
              margin: const EdgeInsets.all(10),
              height: 15,
              width: 15,
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.current == i ? theme.primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
          .toList(),
    );
  }
}
