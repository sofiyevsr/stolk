import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Container(
        color: theme.accentColor,
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                final view = await _controller.future;
                await view.goBack();
              },
              icon: Icon(
                Icons.arrow_back,
                size: 32,
                color: theme.cardColor,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _title,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) navigator.pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SafeArea(
        child: WebView(
          onWebViewCreated: (c) {
            _controller.complete(c);
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
          allowsInlineMediaPlayback: true,
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.link,
        ),
      ),
    );
  }
}
