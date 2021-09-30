import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stolk/components/common/scaleButton.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

const _padding = 12.0;

class NewsView extends StatefulWidget {
  final String link;
  NewsView({
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
    _loadingController.animateTo(d).catchError((e) => print(e));
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

  @override
  void dispose() {
    super.dispose();
    _loadingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: Row(
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
                    child: Icon(Icons.arrow_back, size: 32),
                  ),
                ),
              ),
            // A placeholder for Row to place buttons in both case of canBrowseBack
            if (_canBrowseBack == false) Container(height: 0),
            Row(
              children: [
                ScaleButton(
                  onFinish: _share,
                  child: Padding(
                    padding: const EdgeInsets.all(_padding),
                    child: Tooltip(
                      message: tr("tooltips.share"),
                      child: Icon(Icons.share_outlined, size: 32),
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
                      child: Icon(Icons.restore_rounded, size: 32),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                _title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _loadingController.value / 100,
                  strokeWidth: 10,
                  color: Colors.white,
                );
              },
            )
          ],
        ),
        leading: ScaleButton(
          onFinish: () async {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) navigator.pop();
          },
          child: Icon(
            Icons.arrow_back,
            size: 32,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              onWebViewCreated: (c) {
                _controller.complete(c);
              },
              onLoadError: (_, url, code, __) {
                if (code == 404 && url.toString() == widget.link)
                  FirebaseCrashlytics.instance.log(
                    "Url failed to load 404 ${widget.link}",
                  );
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
          ],
        ),
      ),
    );
  }
}
