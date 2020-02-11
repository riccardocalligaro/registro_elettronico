import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/bloc/token/bloc.dart';
import 'package:registro_elettronico/ui/feature/scrutini/web/spaggiari_web_view.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

/// A page where there is a [circular progress] loading bar
/// In init state a token is requested to Spaggiari and when loaded
/// A new route with a web view is pushed
class WebViewLoadingPage extends StatefulWidget {
  WebViewLoadingPage({
    Key key,
  }) : super(key: key);

  @override
  _WebViewLoadingPageState createState() => _WebViewLoadingPageState();
}

class _WebViewLoadingPageState extends State<WebViewLoadingPage> {
  @override
  void initState() {
    BlocProvider.of<TokenBloc>(context).add(GetLoginToken());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context).settings.arguments as String;

    return BlocListener<TokenBloc, TokenState>(
      listener: (context, state) {
        print(state.toString());
        if (state is TokenLoadSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpaggiariWebView(
                phpSessid: state.token,
                url: url,
                appBarTitle:
                    AppLocalizations.of(context).translate('last_year'),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          title: Text(url),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            )
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
