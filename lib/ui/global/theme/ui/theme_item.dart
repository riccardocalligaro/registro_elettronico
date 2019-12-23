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
    return Card(
      color: themeData.backgroundColor,
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: themeData.accentColor,
          child: Text(
            theme
                .toString()
                .substring(theme.toString().lastIndexOf('.') + 1)[0],
            style: themeData.textTheme.title,
          ),
        ),
        title: Text(
          theme.toString(),
          style: themeData.textTheme.title,
        ),
        onTap: onTap,
      ),
    );
  }
}
