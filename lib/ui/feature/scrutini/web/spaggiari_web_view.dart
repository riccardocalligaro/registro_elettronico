import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpaggiariWebView extends StatelessWidget {
  final String ssid;

  const SpaggiariWebView({
    Key key,
    @required this.ssid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://google.it',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController wvc) {
        wvc.evaluateJavascript('document.cookie = "');
        wvc.evaluateJavascript('sessionStorage.setItem("")');
      },
    );
  }
}
