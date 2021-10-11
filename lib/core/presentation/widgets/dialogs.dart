import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

Future<double?> showDecimalNumberPicker(
  BuildContext context, {
  int? minValue,
  int? maxValue,
  double? initialValue,
}) async {
  return showDialog<double>(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      double _currentValue = initialValue ?? 1;

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: DecimalNumberPicker(
            minValue: minValue ?? 1,
            maxValue: maxValue ?? 10,
            value: _currentValue,
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
            },
            textStyle: TextStyle(
              color: Theme.of(context).textTheme.headline4?.color,
            ),
            selectedTextStyle: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).textTheme.bodyText1?.color),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!
                  .translate('cancel')!
                  .toUpperCase()),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).textTheme.bodyText1?.color),
              onPressed: () => Navigator.of(context).pop(_currentValue),
              child: Text(
                  AppLocalizations.of(context)!.translate('ok')!.toUpperCase()),
            ),
          ],
        );
      });
    },
  );
}

Future<int?> showNumberPicker(
  BuildContext context, {
  int? minValue,
  int? maxValue,
  int? initialValue,
}) async {
  return showDialog<int>(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      int _currentValue = initialValue ?? 1;

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: NumberPicker(
            minValue: minValue ?? 1,
            maxValue: maxValue ?? 10,
            value: _currentValue,
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
            },
            textStyle: TextStyle(
              color: Theme.of(context).textTheme.headline4?.color,
            ),
            selectedTextStyle: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).textTheme.bodyText1?.color),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!
                  .translate('cancel')!
                  .toUpperCase()),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).textTheme.bodyText1?.color),
              onPressed: () => Navigator.of(context).pop(_currentValue),
              child: Text(
                  AppLocalizations.of(context)!.translate('ok')!.toUpperCase()),
            ),
          ],
        );
      });
    },
  );
}
