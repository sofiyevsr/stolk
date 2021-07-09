import 'package:flutter/widgets.dart';

class IntroPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  IntroPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(ctx) {
    final height = MediaQuery.of(ctx).size.height;
    return SizedBox.expand(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              height: height / 1.5,
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    title,
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
                    subtitle,
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
