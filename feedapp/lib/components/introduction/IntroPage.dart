import 'package:flutter/widgets.dart';

class IntroPage extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  IntroPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(ctx) {
    final height = MediaQuery.of(ctx).size.height;
    return SizedBox.expand(
      child: Column(
        children: [
          Expanded(
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.contain,
                  height: height / 1.65,
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
