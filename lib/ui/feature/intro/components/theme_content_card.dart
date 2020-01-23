import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/feature/intro/intro_download_page.dart';
import 'package:registro_elettronico/ui/feature/widgets/circle_page_transition/circular_reveal_route.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/ui/global/theme/app_themes.dart';
import 'package:registro_elettronico/ui/global/theme/bloc/bloc.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeContentCard extends StatefulWidget {
  final int index;
  final String title;
  final String subtitle;

  const ThemeContentCard({
    Key key,
    @required this.index,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  _ThemeContentCardState createState() => _ThemeContentCardState();
}

class _ThemeContentCardState extends State<ThemeContentCard> {
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
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _getBrightnessColor(context),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 129.0, bottom: 25.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () async {
                            BlocProvider.of<ThemeBloc>(context).add(
                                ThemeChanged(
                                    theme: AppTheme.values.elementAt(0)));
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setBool(
                                PrefsConstants.DARK_THEME, true);
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
                            BlocProvider.of<ThemeBloc>(context).add(
                                ThemeChanged(
                                    theme: AppTheme.values.elementAt(1)));
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setBool(
                                PrefsConstants.DARK_THEME, false);
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
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: _buildBottomContent(context),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 35),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < 4; i++)
                if (i == widget.index) ...[circleBar(true, context)] else
                  circleBar(false, context),
            ],
          ),
        ),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.2,
            fontSize: 30.0,
          ),
        ),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: MaterialButton(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: _getBrightnessColor(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                AppLocalizations.of(context).translate('get_started_button'),
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: .8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CircularRevealRoute(
                  page: IntroDownloadPage(
                    color: _getBrightnessColor(context),
                  ),
                  maxRadius: 800,
                  centerAlignment: Alignment.center,
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget circleBar(bool isActive, BuildContext context) {
    Color color;
    Color buttonsColor;

    color = isActive
        ? Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black
        : Colors.transparent;

    buttonsColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 9,
      width: 9,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.transparent,
        border: Border.all(color: buttonsColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Color _getBrightnessColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return Colors.grey[900];
    } else {
      return Colors.white;
    }
  }
}
