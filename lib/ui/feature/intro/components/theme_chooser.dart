import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/global/theme/app_themes.dart';
import 'package:registro_elettronico/ui/global/theme/bloc/bloc.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroThemeChooser extends StatefulWidget {
  IntroThemeChooser({Key key}) : super(key: key);

  @override
  _IntroThemeChooserState createState() => _IntroThemeChooserState();
}

class _IntroThemeChooserState extends State<IntroThemeChooser> {
  double _lightHeight;
  double _darkHeight;

  @override
  void initState() {
    restore();
    super.initState();
  }

  void restore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final theme = sharedPreferences.getBool(PrefsConstants.DARK_THEME) ?? true;
    if (mounted) {
      setState(() {
        if (theme) {
          _darkHeight = 90;
          _lightHeight = 65;
        } else {
          _darkHeight = 65;
          _lightHeight = 90;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () async {
            BlocProvider.of<ThemeBloc>(context)
                .add(ThemeChanged(theme: AppTheme.values.elementAt(0)));
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setBool(PrefsConstants.DARK_THEME, true);
            setState(() {
              _lightHeight = 60;
              _darkHeight = 90;
            });
          },
          shape: CircleBorder(
            side: BorderSide(color: Colors.white, width: 3),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: _darkHeight,
          ),
          elevation: 0,
          fillColor: Colors.grey[900],
        ),
        SizedBox(
          height: 20,
        ),
        RawMaterialButton(
          onPressed: () async {
            BlocProvider.of<ThemeBloc>(context)
                .add(ThemeChanged(theme: AppTheme.values.elementAt(1)));
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setBool(PrefsConstants.DARK_THEME, false);
            setState(() {
              _lightHeight = 90;
              _darkHeight = 60;
            });
          },
          shape: CircleBorder(
            side: BorderSide(color: Colors.grey[900], width: 3),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: _lightHeight,
          ),
          elevation: 0,
          fillColor: Colors.white,
        ),
      ],
    );
  }
}
