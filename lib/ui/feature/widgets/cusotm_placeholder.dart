import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class CustomPlaceHolder extends StatelessWidget {
  final String text;
  final IconData icon;
  final GestureTapCallback onTap;
  const CustomPlaceHolder({
    Key key,
    this.onTap,
    @required this.text,
    @required this.icon,
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
          Text(text),
          FlatButton(
            child: Text(
              AppLocalizations.of(context).translate('sync'),
              style: TextStyle(color: Colors.grey[600]),
            ),
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}
