import 'theme_data/dark_theme.dart' as darkTheme;
import 'theme_data/light_theme.dart' as lightTheme;

enum AppTheme { Dark, Light }

final materialThemeData = {
  AppTheme.Dark: darkTheme.material,
  AppTheme.Light: lightTheme.material,
};

final cupertinoThemeData = {
  AppTheme.Dark: darkTheme.cupertino,
  AppTheme.Light: lightTheme.cupertino,
};
