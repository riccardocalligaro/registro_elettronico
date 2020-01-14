import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SpaggiariWebView extends StatefulWidget {
  final String phpSessid;
  final String url;
  final String appBarTitle;

  const SpaggiariWebView({
    Key key,
    @required this.phpSessid,
    @required this.url,
    @required this.appBarTitle,
  }) : super(key: key);

  @override
  _SpaggiariWebViewState createState() => _SpaggiariWebViewState();
}

class _SpaggiariWebViewState extends State<SpaggiariWebView> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  final _channel = const MethodChannel('flutter_webview_plugin');
  StreamSubscription<String> _onUrlChanged;
  bool flag = true;

  @override
  void initState() {
    FLog.info(text: 'Set token in webview ${widget.phpSessid}');
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      FLog.info(text: 'Url changed $url');
      if (flag) {
        _getcookies();
      }
    });
    super.initState();
  }

  Future _getcookies() async {
    setState(() {
      flag = false;
    });
    print("get cookies");

    await evalJavascript('document.cookie="Authority=manager"');
    await evalJavascript(
        'document.cookie="bestimage_dev_access_token=${'ads'}"');

    String cookiesString = await evalJavascript('document.cookie');
    print("just inserted cookie is");
    print(cookiesString.toString());
    await evalJavascript('location.reload();');
  }

  Future<String> evalJavascript(String code) async {
    final res = await _channel.invokeMethod('eval', {'code': code});
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      withJavascript: true,
      debuggingEnabled: true,
      withZoom: true,
      displayZoomControls: true,
      clearCookies: true,
      clearCache: true,
      appCacheEnabled: false,
      url: widget.url,
      appBar: new AppBar(
        title: new Text(
          widget.appBarTitle,
        ),
      ),
    );
  }
}