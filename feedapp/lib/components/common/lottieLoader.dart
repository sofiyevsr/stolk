import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatefulWidget {
  final String asset;
  final Size? size;
  final bool? repeat;
  const LottieLoader({
    required this.asset,
    this.size,
    this.repeat,
    Key? key,
  }) : super(key: key);

  @override
  _LottieLoaderState createState() => _LottieLoaderState();
}

class _LottieLoaderState extends State<LottieLoader> {
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();
    _composition = _loadComposition();
  }

  Future<LottieComposition> _loadComposition() async {
    var assetData = await rootBundle.load(widget.asset);
    return await LottieComposition.fromByteData(assetData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _composition,
      builder: (context, snapshot) {
        var composition = snapshot.data;
        if (composition != null) {
          return Lottie(
            composition: composition,
            width: widget.size?.width,
            height: widget.size?.height,
            repeat: widget.repeat,
          );
        } else {
          return SizedBox(
            height: widget.size?.height,
            width: widget.size?.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
