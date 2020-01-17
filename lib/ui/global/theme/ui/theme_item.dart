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
      leading: Container(
          child: CircleAvatar(
            backgroundColor: themeData.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.white,
            child: Text(
              theme
                  .toString()
                  .substring(theme.toString().lastIndexOf('.') + 1)[0],
            ),
          ),
          padding: const EdgeInsets.all(2.0), // borde width
          decoration: BoxDecoration(
            color: themeData.brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[800], // border color
            shape: BoxShape.circle,
          )),
      title: Text(
        theme.toString().split('.')[1],
      ),
      onTap: onTap,
    );
  }
}
