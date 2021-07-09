import "package:flutter/material.dart";

class DotsIndicator extends StatefulWidget {
  final int length;
  final int current;

  DotsIndicator({Key? key, required this.length, required this.current})
      : super(key: key);

  @override
  _DotsIndicatorState createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<DotsIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) => index)
          .map(
            (i) => AnimatedContainer(
              margin: const EdgeInsets.all(10),
              height: widget.current == i ? 10 : 15,
              duration: const Duration(milliseconds: 300),
              width: widget.current == i ? 10 : 15,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
          .toList(),
    );
  }
}
