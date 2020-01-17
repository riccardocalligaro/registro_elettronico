import 'package:flutter/material.dart';
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
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  Map<String, String> headers;
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
    GlobalKey _scaffoldkey;
    return Scaffold(
      key: _scaffoldkey,
      body: WebviewScaffold(
        debuggingEnabled: true,
        userAgent:
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0',
        withZoom: true,
        displayZoomControls: true,
        clearCache: false,
        clearCookies: true,
        appCacheEnabled: false,
        url: widget.url,
        hidden: true,
        headers: headers,
        appBar: AppBar(
          title: Text(
            widget.appBarTitle ?? '',
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
