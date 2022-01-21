import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/screens/home.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class IntroPage extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final Function() nextPage;
  const IntroPage({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.nextPage,
    Key? key,
  }) : super(key: key);

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
    final theme = Theme.of(ctx);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          flex: 5,
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Image.asset(
                widget.image,
                fit: BoxFit.contain,
                height: height / 1.5,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    AutoSizeText(
                      widget.title,
                      style: theme.textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: AutoSizeText(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText1,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: widget.nextPage,
                      child: Text(
                        tr("intro.next"),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(140, 50),
                        ),
                      ),
                      onPressed: () {
                        NavigationService.replaceAll(
                          const Home(),
                          RouteNames.HOME,
                        );
                      },
                      child: Text(
                        tr("commons.skip"),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
