import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Container(
        child: InAppWebView(
          initialUrl: widget.url,
          initialHeaders: {
            'cookie': widget.phpSessid,
            'set-cookie': widget.phpSessid,
          },
          initialOptions: InAppWebViewWidgetOptions(
            crossPlatform: InAppWebViewOptions(
              clearCache: true,
              cacheEnabled: false,
              useShouldOverrideUrlLoading: true,
              useOnLoadResource: true,
            ),
            android: AndroidInAppWebViewOptions(
              // supportZoom: true,
              displayZoomControls: true,
              builtInZoomControls: true,
              loadWithOverviewMode: true,
              // useWideViewPort: true,
            ),
          ),
          shouldOverrideUrlLoading: shouldOverrideUrlLoading,
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          // onLoadStart: (InAppWebViewController controller, String url) {},
          // onLoadStop: (InAppWebViewController controller, String url) async {},
          onLoadResource: (
            InAppWebViewController controller,
            LoadedResource resource,
          ) async {
            try {
              await controller.clearCache();
              await controller.evaluateJavascript(
                  source: 'document.cookie = "${widget.phpSessid}"');
            } catch (_) {}
          },
        ),
      ),
    );
  }

  Future<ShouldOverrideUrlLoadingAction> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      ShouldOverrideUrlLoadingRequest request) {
    final Map<String, String> headersVarible = {
      'cookie': widget.phpSessid,
      'set-cookie': widget.phpSessid,
    };

    controller.loadUrl(url: request.url, headers: headersVarible);
  }
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  // Map<String, String> headers;
  // @override
  // void initState() {
  //   headers = {
  //     'Set-Cookie': '${widget.phpSessid}',
  //     'Cookie': '${widget.phpSessid}',
  //   };
  //   super.initState();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   GlobalKey _scaffoldkey;
  //   return Scaffold(
  //     key: _scaffoldkey,
  //     body: WebviewScaffold(
  //       debuggingEnabled: false,
  //       userAgent:
  //           'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0',
  //       withZoom: true,
  //       displayZoomControls: true,
  //       clearCache: false,
  //       clearCookies: true,
  //       appCacheEnabled: false,
  //       url: widget.url,
  //       hidden: true,
  //       headers: headers,
  //       appBar: AppBar(
  //         brightness: Theme.of(context).brightness,
  //         title: Text(
  //           widget.appBarTitle ?? '',
  //         ),
  //         // actions: <Widget>[
  //         //   IconButton(
  //         //     // tooltip: AppLocalizations.of(context).translate('confirm'),
  //         //     icon: Icon(Icons.check),
  //         //  1   onPressed: () {},
  //         //   )
  //         // ],
  //       ),
  //     ),
  //   );
  // }
}
