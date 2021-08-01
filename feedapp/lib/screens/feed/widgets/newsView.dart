import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/components/common/scaleButton.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  final _controller = Completer<WebViewController>();
  String _title = "";

  double loadingPer = 0;
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
    _loadingController.addListener(() {
      setState(() {
        loadingPer = _loadingController.value;
      });
    });
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
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScaleButton(
              onFinish: () async {
                final view = await _controller.future;
                await view.goBack();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Tooltip(
                  message: tr("tooltip.go_back_webview"),
                  child: Icon(Icons.arrow_back, size: 32),
                ),
              ),
            ),
            Row(
              children: [
                ScaleButton(
                  onFinish: _share,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Tooltip(
                      message: tr("tooltip.share"),
                      child: Icon(Icons.share_outlined, size: 32),
                    ),
                  ),
                ),
                ScaleButton(
                  onFinish: () async {
                    final view = await _controller.future;
                    await view.loadUrl(widget.link);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Tooltip(
                      message: tr("tooltip.load_news_url"),
                      child: Icon(Icons.refresh, size: 32),
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
            CircularProgressIndicator.adaptive(
              value: loadingPer / 100,
              strokeWidth: 10,
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
            color: theme.cardColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              debuggingEnabled: true,
              onWebViewCreated: (c) {
                _controller.complete(c);
              },
              onProgress: (i) {
                _progressToTarget(i.toDouble());
              },
              onPageFinished: (s) async {
                final view = await _controller.future;
                final title = await view.getTitle();
                if (title != null) {
                  setState(() {
                    _title = title;
                  });
                }
              },
              onWebResourceError: (e) {},
              allowsInlineMediaPlayback: true,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.link,
            ),
          ],
        ),
      ),
    );
  }
}
