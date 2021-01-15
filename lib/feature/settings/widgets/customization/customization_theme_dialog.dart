import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/theme/app_themes.dart';
import 'package:registro_elettronico/core/infrastructure/theme/bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/dark_theme.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/light_theme.dart';
import 'package:registro_elettronico/core/infrastructure/theme/ui/theme_item.dart';

class CustomizationSettingsThemeDialog extends StatelessWidget {
  const CustomizationSettingsThemeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: AppTheme.values.length,
        itemBuilder: (ctx, index) {
          final theme = AppTheme.values.elementAt(index);
          final Color color = Colors.red;
          ThemeData themeData;

          if (theme == AppTheme.dark) {
            themeData = DarkTheme.getThemeData(color);
          } else {
            themeData = LightTheme.getThemeData(color);
          }

          return ThemeItem(
            theme: theme,
            themeData: themeData,
            onTap: () => BlocProvider.of<ThemeBloc>(context)
                .add(ThemeChanged(theme: theme, color: null)),
          );
        },
      ),
    );
  }
}
