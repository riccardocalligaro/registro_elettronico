import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:registro_elettronico/component/routes.dart';

class AppNavigator {
  static AppNavigator _instance;

  AppNavigator._();

  static AppNavigator get instance {
    if (_instance == null) {
      _instance = AppNavigator._();
    }
    return _instance;
  }

  void navToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

  void navToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.LOGIN);
  }

  void navToLessons(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.LESSONS);
  }

  void navToGrades(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.GRADES);
  }

  void navToAgenda(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.AGENDA);
  }

  void navToAbsences(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.ABSENCES);
  }

  void navToNoticeboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.NOTICEBOARD);
  }

  void navToSettings(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.SETTINGS);
  }

  Future showMessageDialog(
      BuildContext context, String title, String message) async {
    await showDialog(
        context: context,
        builder: (bCtx) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                RaisedButton(onPressed: () => Navigator.of(bCtx).pop())
              ],
            ));
  }

  void showSnackBar(BuildContext context, String content) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  BuildContext showAlertDialog(BuildContext context,
      {@required Widget content,
      Widget title = const Text("Attention"),
      List<Widget> actions}) {
    if (actions == null) {
      actions = [];
    }
    BuildContext alertContext;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (bCtx) {
          alertContext = bCtx;
          return AlertDialog(
            title: title,
            content: content,
            actions: actions
              ..add(FlatButton(
                onPressed: () => Navigator.of(bCtx).pop(),
                child: Text('Close'),
              )),
          );
        },
      );
    });
    return alertContext;
  }
}
