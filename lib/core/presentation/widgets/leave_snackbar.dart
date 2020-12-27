import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

class LeaveSnackBar extends StatelessWidget {
  const LeaveSnackBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        AppLocalizations.of(context).translate('leave_snackbar'),
      ),
    );
  }
}
