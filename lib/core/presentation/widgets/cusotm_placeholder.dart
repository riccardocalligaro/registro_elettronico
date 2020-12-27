import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

class CustomPlaceHolder extends StatelessWidget {
  final String text;
  final IconData icon;
  final GestureTapCallback onTap;
  final bool showUpdate;
  final String updateMessage;

  const CustomPlaceHolder({
    Key key,
    this.onTap,
    @required this.text,
    @required this.icon,
    @required this.showUpdate,
    this.updateMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Icon(
              icon,
              size: 80,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
          showUpdate
              ? FlatButton(
                  child: Text(
                    updateMessage ??
                        AppLocalizations.of(context).translate('sync'),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  onPressed: onTap,
                )
              : Container(),
        ],
      ),
    );
  }
}
