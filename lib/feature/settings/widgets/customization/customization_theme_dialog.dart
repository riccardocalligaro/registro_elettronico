import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/theme/app_themes.dart';
import 'package:registro_elettronico/core/infrastructure/theme/bloc/bloc.dart';
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
          return ThemeItem(
            theme: theme,
            themeData: materialThemeData[theme],
            onTap: () => BlocProvider.of<ThemeBloc>(context)
                .add(ThemeChanged(theme: theme)),
          );
        },
      ),
    );
  }
}
