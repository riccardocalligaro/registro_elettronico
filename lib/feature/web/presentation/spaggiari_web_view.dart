import 'dart:io';

import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/grades/grades_container.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

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
  WebViewController? _controller;

  @override
  void initState() {
    /// This is for hybrid composition
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

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
    return WebView(initialUrl: widget.url);
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: widget.url,
        userAgent:
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          // setState(() {
          //   _controller = webViewController;
          // });
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        javascriptChannels: <JavascriptChannel>{},
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) async {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        key: _scaffoldkey,
      ),
    );
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
