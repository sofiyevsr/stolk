import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stolk/components/common/scaleButton.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stolk/utils/services/app/toastService.dart';
import 'package:url_launcher/url_launcher.dart';

const _padding = 12.0;

class NewsView extends StatefulWidget {
  final String link;
  const NewsView({
    Key? key,
    required this.link,
  }) : super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView>
    with SingleTickerProviderStateMixin {
  final _controller = Completer<InAppWebViewController>();
  String _title = "";
  bool _canBrowseBack = false;

  late AnimationController _loadingController;

  void _progressToTarget(double d) {
    _loadingController.animateTo(d);
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0.0,
      upperBound: 100.0,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
  }

  void _share() {
    Share.share(widget.link);
  }

  Future<void> _openInBrowser() async {
    try {
      await launch(widget.link);
    } catch (e) {
      ToastService.instance.showAlert(
        tr("errors.cannot_launch_url"),
      );
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_canBrowseBack == true)
            ScaleButton(
              onFinish: () async {
                final view = await _controller.future;
                await view.goBack();
              },
              child: Padding(
                padding: const EdgeInsets.all(_padding),
                child: Tooltip(
                  message: tr("tooltips.go_back_in_browser"),
                  child: const Icon(Icons.arrow_back, size: 32),
                ),
              ),
            ),
          // A placeholder for Row to place buttons in both case of canBrowseBack
          if (_canBrowseBack == false) Container(height: 0),
          Row(
            children: [
              ScaleButton(
                onFinish: _openInBrowser,
                child: Padding(
                  padding: const EdgeInsets.all(_padding),
                  child: Tooltip(
                    message: tr("tooltips.open_in_browser"),
                    child: const Icon(
                      Icons.open_in_browser_outlined,
                      size: 32,
                    ),
                  ),
                ),
              ),
              ScaleButton(
                onFinish: _share,
                child: Padding(
                  padding: const EdgeInsets.all(_padding),
                  child: Tooltip(
                    message: tr("tooltips.share"),
                    child: const Icon(
                      Icons.share_outlined,
                      size: 32,
                    ),
                  ),
                ),
              ),
              ScaleButton(
                onFinish: () async {
                  final view = await _controller.future;
                  await view.loadUrl(
                    urlRequest: URLRequest(
                      url: Uri.tryParse(widget.link),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(_padding),
                  child: Tooltip(
                    message: tr("tooltips.reload_news_url"),
                    child: const Icon(
                      Icons.restore_rounded,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AutoSizeText(
                    _title,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 14,
                    maxLines: 2,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _loadingController.value / 100,
                    strokeWidth: 8,
                    color: Colors.white,
                  );
                },
              )
            ],
          ),
        ),
        leading: ScaleButton(
          onFinish: () async {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) navigator.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
        ),
      ),
      body: SafeArea(
        child: InAppWebView(
          onWebViewCreated: (c) {
            _controller.complete(c);
          },
          onLoadError: (_, url, code, __) {
            if (code == 404 && url.toString() == widget.link) {
              FirebaseAnalytics.instance.logEvent(
                name: "Url 404",
                parameters: <String, dynamic>{
                  "link": widget.link,
                },
              );
            }
          },
          onProgressChanged: (_, i) {
            _progressToTarget(i.toDouble());
          },
          onLoadStop: (_, s) async {
            final view = await _controller.future;
            final title = await view.getTitle();
            if (title != null) {
              setState(() {
                _title = title;
              });
            }
            // Maybe avoid rerender when value is already target
            if (s != null) {
              if (s.toString() != widget.link)
                setState(() {
                  _canBrowseBack = true;
                });
              else
                setState(() {
                  _canBrowseBack = false;
                });
            }
          },
          initialUrlRequest: URLRequest(
            url: Uri.tryParse(widget.link),
          ),
        ),
      ),
    );
  }
}
