import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/theme/bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/themes.dart';
import 'package:registro_elettronico/core/infrastructure/theme/ui/theme_item.dart';

class CustomizationSettingsThemeDialog extends StatelessWidget {
  const CustomizationSettingsThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: ThemeType.values.length,
        itemBuilder: (ctx, index) {
          final theme = ThemeType.values.elementAt(index);
          Color? color;

          if (theme == ThemeType.dark) {
            color = Colors.grey[900];
          } else if (theme == ThemeType.black) {
            color = Colors.black;
          } else {
            color = Colors.white;
          }
          return ThemeItem(
            name: theme.toString(),
            color: color,
            onTap: () => BlocProvider.of<ThemeBloc>(context).add(
              ThemeChanged(
                type: theme,
                color: null,
              ),
            ),
          );
        },
      ),
    );
  }
}
