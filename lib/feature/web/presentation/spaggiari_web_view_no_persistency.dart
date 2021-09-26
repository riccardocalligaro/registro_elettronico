import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SpaggiariWebViewNoPersistency extends StatefulWidget {
  final String phpSessid;
  final String? url;
  final String? appBarTitle;

  const SpaggiariWebViewNoPersistency({
    Key? key,
    required this.phpSessid,
    required this.url,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  _SpaggiariWebViewNoPersistencyState createState() =>
      _SpaggiariWebViewNoPersistencyState();
}

class _SpaggiariWebViewNoPersistencyState
    extends State<SpaggiariWebViewNoPersistency> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  Map<String, String>? headers;
  @override
  void initState() {
    headers = {
      'Set-Cookie': '${widget.phpSessid}',
      'Cookie': '${widget.phpSessid}',
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey? _scaffoldkey;
    return Scaffold(
      key: _scaffoldkey,
      body: WebviewScaffold(
        debuggingEnabled: false,
        userAgent:
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0',
        withZoom: true,
        displayZoomControls: true,
        clearCache: false,
        clearCookies: true,
        appCacheEnabled: false,
        url: widget.url!,
        hidden: true,
        headers: headers,
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          title: Text(
            widget.appBarTitle ?? '',
          ),
        ),
      ),
    );
  }
}
