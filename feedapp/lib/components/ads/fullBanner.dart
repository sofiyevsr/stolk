import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FullBannerAd extends StatefulWidget {
  final String unitID;
  const FullBannerAd({Key? key, required this.unitID}) : super(key: key);

  @override
  _FullBannerAdState createState() => _FullBannerAdState();
}

class _FullBannerAdState extends State<FullBannerAd> {
  // Ad related
  BannerAd? _banner;
  AdWidget? _adWidget;

  // State related
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      adUnitId: widget.unitID,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdLoaded: (a) {
          if (mounted) {
            _adWidget = AdWidget(ad: _banner!);
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    if (_isAdLoaded == false) {
      return Container();
    }
    return SizedBox(
      child: _adWidget,
      width: media.width,
      height: _banner!.size.height.toDouble(),
    );
  }
}
