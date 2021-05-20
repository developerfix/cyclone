import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String url;
  ArticleView({this.url});
  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  bool _isLoading = true;
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  void initState() {
    print('url ' + widget.url);
    if (widget.url != null) {
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox(
                height: height,
                width: width,
                child: WebView(
                  initialUrl: widget.url,
                  onWebViewCreated: (WebViewController webViewController) {
                    _completer.complete(webViewController);
                  },
                ),
              ),
      ),
    );
  }
}
