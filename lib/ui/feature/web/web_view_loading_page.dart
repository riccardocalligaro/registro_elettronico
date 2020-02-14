import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/bloc/token/bloc.dart';
import 'package:registro_elettronico/ui/feature/web/spaggiari_web_view_no_persistency.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';

/// A page where there is a [circular progress] loading bar
/// In init state a token is requested to Spaggiari and when loaded
/// A new route with a web view is pushed
class WebViewLoadingPage extends StatefulWidget {
  final bool lastYear;
  final String url;
  final String title;

  WebViewLoadingPage({
    @required this.url,
    @required this.title,
    this.lastYear,
    Key key,
  }) : super(key: key);

  @override
  _WebViewLoadingPageState createState() => _WebViewLoadingPageState();
}

class _WebViewLoadingPageState extends State<WebViewLoadingPage> {
  @override
  void initState() {
    BlocProvider.of<TokenBloc>(context)
        .add(GetLoginToken(widget.lastYear ?? false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.url;

    return BlocListener<TokenBloc, TokenState>(
      listener: (context, state) {
        print(state.toString());
        if (state is TokenLoadSuccess) {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpaggiariWebViewNoPersistency(
                phpSessid: state.token,
                url: url,
                appBarTitle: widget.title,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          title: Text(widget.title),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.refresh),
          //     onPressed: () {},
          //   )
          // ],
        ),
        body: BlocBuilder<TokenBloc, TokenState>(
          builder: (context, state) {
            if (state is TokenLoadError) {
              return Center(
                child: CustomPlaceHolder(
                  icon: Icons.error,
                  text: 'Could access this!',
                  showUpdate: false,
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
