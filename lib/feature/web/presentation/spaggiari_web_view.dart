import 'package:flutter/material.dart';

class SpaggiariWebView extends StatefulWidget {
  final String url;
  final String? appBarTitle;
  final String? email;

  const SpaggiariWebView({
    Key? key,
    required this.url,
    required this.appBarTitle,
    this.email,
  }) : super(key: key);

  @override
  _SpaggiariWebViewState createState() => _SpaggiariWebViewState();
}

class _SpaggiariWebViewState extends State<SpaggiariWebView> {
  // final flutterWebviewPlugin = FlutterWebviewPlugin();
  Map<String, String>? headers;

  @override
  void initState() {
    // flutterWebviewPlugin.onStateChanged.listen((state) async {
    //   if (state.type == WebViewState.finishLoad && state.url == widget.url) {
    //     final AuthenticationRepository authenticationRepository = sl();
    //     final userInfo = await authenticationRepository.getCredentials();
//
    //     await flutterWebviewPlugin.evalJavascript(
    //         '\$("#login").val("${widget.email ?? userInfo.profile?.ident}");');
    //     await flutterWebviewPlugin
    //         .evalJavascript('\$("#password").val("${userInfo.password}");');
//
    //     await flutterWebviewPlugin.evalJavascript('\$(".check-auth").click();');
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey? _scaffoldkey;
    return Scaffold();
    // return WebviewScaffold(
    //   debuggingEnabled: false,
    //   key: _scaffoldkey,
    //   userAgent:
    //       'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0',
    //   withZoom: true,
    //   displayZoomControls: true,
    //   allowFileURLs: true,
    //   clearCookies: true,
    //   useWideViewPort: true,
    //   withOverviewMode: true,
    //   url: widget.url,
    //   hidden: true,
    //   headers: headers,
    //   appBar: AppBar(
    //     brightness: Theme.of(context).brightness,
    //     title: Text(
    //       widget.appBarTitle ?? '',
    //     ),
    //   ),
    // );
  }
}
