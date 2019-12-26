import 'package:flutter/material.dart';

import '../app_themes.dart';

class ThemeItem extends StatelessWidget {
  final Function onTap;
  final ThemeData themeData;
  final AppTheme theme;

  ThemeItem({this.onTap, @required this.themeData, @required this.theme});

  @override
  Widget build(BuildContext context) {
    //final appTheme = appThemeData[theme];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: themeData.brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
        child: Text(
          theme.toString().substring(theme.toString().lastIndexOf('.') + 1)[0],
        ),
      ),
      title: Text(
        theme.toString().split('.')[1],
      ),
      onTap: onTap,
    );
  }
}
