import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/feature/intro/components/download_liquid_circle.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

class IntroDownloadPage extends StatefulWidget {
  final Color color;
  IntroDownloadPage({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  _IntroDownloadPageState createState() => _IntroDownloadPageState();
}

class _IntroDownloadPageState extends State<IntroDownloadPage> {
  RepeatStream<String> _textStream;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    _textStream = RepeatStream(
      (int repeatCount) => Stream.fromIterable([
        trans.translate('loading_1_subtitle'),
        trans.translate('loading_2_subtitle'),
        trans.translate('loading_3_subtitle'),
        trans.translate('loading_4_subtitle'),
      ]).interval(Duration(seconds: 4)),
    );

    
    return Scaffold(
      body: Container(
        color: widget.color ?? Theme.of(context),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: IntroDownloadLiquidCircle(),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder(
                  stream: _textStream,
                  initialData: AppLocalizations.of(context)
                      .translate('loading_subtitle_data'),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Container(
                      child: Text(
                        snapshot.data,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
