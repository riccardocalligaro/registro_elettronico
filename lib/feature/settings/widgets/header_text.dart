import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).accentColor),
    );
  }
}
