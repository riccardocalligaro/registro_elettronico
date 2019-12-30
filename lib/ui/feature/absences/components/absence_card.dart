import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

/// Single absence card that shows the event type, date
class AbsenceCard extends StatelessWidget {
  final Absence absence;
  final int days;

  const AbsenceCard({Key key, @required this.absence, @required this.days})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: ColorUtils.getColorFromCode(absence.evtCode)),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Container(
              height: 55,
              width: 55,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              child: Text(
                _getLetterFromCode(context, absence.evtCode),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _getDateOfAbsence(context),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _getMessage(context, absence),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getDateOfAbsence(BuildContext context) {
    if (days > 1) {
      final startDateOfAbsence =
          absence.evtDate.subtract(Duration(days: days - 1));
      if (startDateOfAbsence.month != absence.evtDate.month) {
        return "${startDateOfAbsence.day}/${startDateOfAbsence.month} to ${absence.evtDate.day}";
      } else {
        final from = AppLocalizations.of(context).translate('from_absences');
        final to = AppLocalizations.of(context).translate('to_absences');
        return "$from ${startDateOfAbsence.day} $to ${absence.evtDate.day} ${DateUtils.convertMonthLocale(absence.evtDate, AppLocalizations.of(context).locale.toString())}";
      }
    }
    return DateUtils.convertDateLocale(
        absence.evtDate, AppLocalizations.of(context).locale.toString());
  }

  String _getMessage(BuildContext context, Absence absence) {
    final code = absence.evtCode;
    if (code == RegistroConstants.ASSENZA &&
        absence.isJustified == true &&
        absence.justifReasonDesc.length > 0) {
      return absence.justifReasonDesc;
    } else if (code == RegistroConstants.ASSENZA) {
      return AppLocalizations.of(context).translate('absent_all_day');
    } else if (code == RegistroConstants.RITARDO) {
      return AppLocalizations.of(context)
          .translate('you_entered_at')
          .replaceAll('{hour}', "${absence.evtHPos}°");
    } else if (code == RegistroConstants.RITARDO_BREVE) {
      return AppLocalizations.of(context).translate('little_bit_late');
    } else if (code == RegistroConstants.USCITA) {
      return AppLocalizations.of(context)
          .translate('exit_at_hour')
          .replaceAll('{hour}', "${absence.evtHPos}°");
    } else {
      return AppLocalizations.of(context).translate('unricognised_event');
    }
  }

  ////String _getAbsenceNameFromCode(BuildContext context, String code) {
  ////  if (code == RegistroConstants.ASSENZA) {
  ////    return AppLocalizations.of(context).translate('absence');
  ////  } else if (code == RegistroConstants.RITARDO) {
  ////    return AppLocalizations.of(context).translate('late');
  ////  } else if (code == RegistroConstants.RITARDO_BREVE) {
  ////    return AppLocalizations.of(context).translate('little_bit_late');
  ////  } else if (code == RegistroConstants.USCITA) {
  ////    return AppLocalizations.of(context).translate('early_exit');
  ////  } else {
  ////    return AppLocalizations.of(context).translate('unricognised_event');
  ////  }
  ////}

  String _getLetterFromCode(BuildContext context, String code) {
    if (code == RegistroConstants.ASSENZA) {
      return AppLocalizations.of(context).translate('absence')[0];
    } else if (code == RegistroConstants.RITARDO) {
      return AppLocalizations.of(context).translate('late')[0];
    } else if (code == RegistroConstants.RITARDO_BREVE) {
      return AppLocalizations.of(context).translate('rb_code');
    } else if (code == RegistroConstants.USCITA) {
      return AppLocalizations.of(context).translate('early_exit')[0];
    } else {
      return AppLocalizations.of(context).translate('unricognised_event')[0];
    }
  }
}
