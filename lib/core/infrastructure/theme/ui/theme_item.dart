import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class ThemeItem extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final String name;

  ThemeItem({
    required this.onTap,
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    //final appTheme = appThemeData[theme];

    return ListTile(
      leading: Container(
        child: CircleAvatar(
          backgroundColor: color,
          child: Text(
            name
                .toString()
                .substring(name.toString().lastIndexOf('.') + 1)[0]
                .toUpperCase(),
            style:
                TextStyle(color: _isLight(name) ? Colors.black : Colors.white),
          ),
        ),
        padding: const EdgeInsets.all(2.0), // borde width
        decoration: BoxDecoration(
          color: color, // border color
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        StringUtils.capitalize(name.toString().split('.')[1]),
      ),
      onTap: onTap,
    );
  }

  bool _isLight(String name) {
    return name.toString().substring(name.toString().lastIndexOf('.') + 1)[0] ==
        'l';
  }
}
