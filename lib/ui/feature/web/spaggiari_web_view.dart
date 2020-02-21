import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class SpaggiariWebView extends StatefulWidget {
  final String url;
  final String appBarTitle;
  final String email;

  const SpaggiariWebView({
    Key key,
    @required this.url,
    @required this.appBarTitle,
    this.email,
  }) : super(key: key);

  @override
  _SpaggiariWebViewState createState() => _SpaggiariWebViewState();
}

class _SpaggiariWebViewState extends State<SpaggiariWebView> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  bool loggedIn = false;
  Map<String, String> headers;

  @override
  void initState() {
    flutterWebviewPlugin.onUrlChanged.listen((url) {
      if (url != widget.url) {
        loggedIn = true;
      }
    });
    flutterWebviewPlugin.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad && !loggedIn) {
        final userInfo = await RepositoryProvider.of<ProfileRepository>(context)
            .getUserAndPassword();
        await flutterWebviewPlugin.evalJavascript(
            '\$("#login").val("${widget.email ?? userInfo.item1.ident}");');
        await flutterWebviewPlugin
            .evalJavascript('\$("#password").val("${userInfo.item2}");');

        flutterWebviewPlugin.evalJavascript('\$(".check-auth").click();');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _scaffoldkey;

    return WebviewScaffold(
      debuggingEnabled: false,
      key: _scaffoldkey,
      userAgent:
          'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0',
      withZoom: true,
      displayZoomControls: true,
      allowFileURLs: true,
      clearCookies: true,
      useWideViewPort: true,
      withOverviewMode: true,
      url: widget.url,
      hidden: true,
      headers: headers,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          widget.appBarTitle ?? '',
        ),
      ),
    );
  }
}
