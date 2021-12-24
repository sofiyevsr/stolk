import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';

class RectangleBannerAd extends StatefulWidget {
  final String unitID;
  const RectangleBannerAd({Key? key, required this.unitID}) : super(key: key);

  @override
  _RectangleBannerAd createState() => _RectangleBannerAd();
}

class _RectangleBannerAd extends State<RectangleBannerAd>
    with AutomaticKeepAliveClientMixin {
  // Ad related
  BannerAd? _banner;
  AdWidget? _adWidget;

  // State related
  bool _isAdLoaded = false;
  bool _adFailed = false;

  Future<void> _loadAd() async {
    if (_isAdLoaded == true || _banner != null) return;
    _banner = BannerAd(
      adUnitId: widget.unitID,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            _adFailed = true;
          });
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
    super.build(context);
    if (_adFailed == true) {
      return AutoSizeText(
        tr("tooltips.ad_error"),
        minFontSize: 20,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (_isAdLoaded == false) {
      return const CenterLoadingWidget();
    }
    return Container(
      alignment: Alignment.bottomCenter,
      child: _adWidget,
      height: _banner!.size.height.toDouble(),
      width: _banner!.size.width.toDouble(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
