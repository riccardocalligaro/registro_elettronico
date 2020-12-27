import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

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
        color: ColorUtils.getColorFromCode(absence.evtCode),
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
          onTap: () {
            _showAbsenceDialog(context);
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      height: 55,
                      width: 55,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: AutoSizeText(
                        GlobalUtils.getAbsenceLetterFromCode(
                            context, absence.evtCode),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            GlobalUtils.getDateOfAbsence(
                                context, days, absence),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            GlobalUtils.getAbsenceMessage(context, absence),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  void _showAbsenceDialog(BuildContext context) {
    if (absence.isJustified) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(AppLocalizations.of(context)
                    .translate('justified_singular')),
                Text(
                  AppLocalizations.of(context)
                      .translate('justify_code')
                      .replaceAll(
                        '{code}',
                        absence.justifiedReasonCode,
                      ),
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate('justify_description')
                      .replaceAll(
                        '{desc}',
                        absence.justifReasonDesc,
                      ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate('not_justified_singular'),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

// return Container(
//   decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(4.0),
//       color: ColorUtils.getColorFromCode(absence.evtCode)),
//   padding: const EdgeInsets.all(16.0),
//   child: Row(
//     children: <Widget>[
//       ClipOval(
//         child: Container(
//           height: 55,
//           width: 55,
//           color: Colors.white,
//           padding:
//               const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
//           child: AutoSizeText(
//             GlobalUtils.getAbsenceLetterFromCode(context, absence.evtCode),
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 20),
//           ),
//         ),
//       ),
//       Flexible(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 GlobalUtils.getDateOfAbsence(context, days, absence),
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 GlobalUtils.getAbsenceMessage(context, absence),
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           ),
//         ),
//       )
//     ],
//   ),
// );
