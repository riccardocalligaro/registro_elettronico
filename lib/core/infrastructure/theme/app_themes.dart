import 'theme_data/dark_theme.dart' as dark_theme;
import 'theme_data/light_theme.dart' as light_theme;

enum AppTheme { dark, light }

final materialThemeData = {
  AppTheme.dark: dark_theme.material,
  AppTheme.light: light_theme.material,
};

final cupertinoThemeData = {
  AppTheme.dark: dark_theme.cupertino,
  AppTheme.light: light_theme.cupertino,
};
