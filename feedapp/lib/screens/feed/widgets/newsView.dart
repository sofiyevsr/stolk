import 'dart:async';

import 'package:feedapp/components/common/scaleButton.dart';
import 'package:flutter/material.dart';
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

class _NewsViewState extends State<NewsView> {
  final _controller = Completer<WebViewController>();
  String _title = "";
  bool isLoading = true;
  double loadingPer = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Container(
        color: theme.accentColor,
        child: Row(
          children: [
            ScaleButton(
              onFinish: () async {
                final view = await _controller.future;
                await view.goBack();
              },
              child: Icon(
                Icons.arrow_back,
                size: 44,
                color: theme.cardColor,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // backgroundColor: Colors.red,
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                _title,
                style: TextStyle(
                  color: Colors.black,
                ),
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
              onWebViewCreated: (c) {
                _controller.complete(c);
              },
              onProgress: (i) {
                setState(() {
                  loadingPer = i.toDouble();
                });
              },
              onPageFinished: (s) async {
                final view = await _controller.future;
                final title = await view.getTitle();
                if (title != null) {
                  setState(() {
                    _title = title;
                  });
                }
                setState(() {
                  isLoading = false;
                });
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
