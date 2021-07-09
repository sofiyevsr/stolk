import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:partner_gainclub/logic/hive/settings.dart';
import 'package:partner_gainclub/utils/constants.dart';

class RemainderBanner extends StatefulWidget {
  final String content;
  final int banner;
  final Icon leadingIcon;
  const RemainderBanner({
    Key? key,
    required this.banner,
    required this.content,
    required this.leadingIcon,
  }) : super(key: key);

  @override
  _RemainderBannerState createState() => _RemainderBannerState();
}

class _RemainderBannerState extends State<RemainderBanner>
    with SingleTickerProviderStateMixin {
  static final gBox = Hive.box<Settings>("settings");
  static final box = gBox.get("main", defaultValue: Settings())!;
  bool isClosing = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        if (_controller.isCompleted && isClosing == true) {
          final banners = {
            ...box.banners,
          };
          banners.add(ClosedBanners.MY_BOOKINGS);
          box.banners = banners.toList();
          gBox.put("main", box);
        }
      });
    final Animation<double> tween = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _animation = Tween(end: 0.0, begin: 1.0).animate(tween);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!box.banners.contains(ClosedBanners.MY_BOOKINGS))
      return SizeTransition(
        sizeFactor: _animation,
        child: Container(
          margin: const EdgeInsets.all(
            10,
          ),
          child: MaterialBanner(
            leading: (widget.leadingIcon),
            actions: [
              IconButton(
                color: Colors.red,
                icon: Icon(Icons.close),
                onPressed: isClosing
                    ? null
                    : () {
                        setState(() {
                          isClosing = true;
                        });
                        _controller.forward();
                      },
              ),
            ],
            content: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: Text(
                widget.content,
              ),
            ),
          ),
        ),
      );
    return Container();
  }
}
