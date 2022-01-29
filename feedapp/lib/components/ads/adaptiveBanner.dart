import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const maxRetries = 3;

class AdaptiveBannerAd extends StatefulWidget {
  final String unitID;
  final bool disabled;
  const AdaptiveBannerAd(
      {Key? key, required this.unitID, this.disabled = false})
      : super(key: key);

  @override
  _AdaptiveBannerAdState createState() => _AdaptiveBannerAdState();
}

class _AdaptiveBannerAdState extends State<AdaptiveBannerAd> {
  // Retries
  int tries = 0;
  // Ad related
  BannerAd? _banner;
  AdWidget? _adWidget;

  // State related
  bool _isAdLoaded = false;

  Future<void> _loadAd() async {
    if (widget.disabled == true) return;
    if (tries >= maxRetries) {
      return;
    }
    tries++;
    if (_isAdLoaded == true || _banner != null) return;
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    ).catchError((_) {});

    if (size == null) {
      return _loadAd();
    }
    _banner = BannerAd(
      adUnitId: widget.unitID,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          print("failed $error");
          ad.dispose();
          _banner = null;
          _loadAd();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded == false || widget.disabled == true) {
      return Container();
    }
    return Container(
      color: Colors.black,
      alignment: Alignment.bottomCenter,
      child: _adWidget,
      height: _banner!.size.height.toDouble(),
      width: _banner!.size.width.toDouble(),
    );
  }
}
