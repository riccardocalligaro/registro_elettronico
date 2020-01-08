import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class NotificationMessage {
  /// Gets the [title]
  static String getGradeNotificationTitle({@required double grade}) {
    if(grade == -1.00) return '📝 Nuovo voto!';
    if (grade >= 8) return '👌 Novo voto!';
    if (grade >= 6) return '👍 Novo voto!';
    if (grade >= 5.5) return '🤔 Nuovo voto!';
    if (grade < 5.5) return '👎 Nuovo voto!';
    return '👍 Nuovo voto!';
  }

  static String getGradeNotificationSubtitle({@required Grade grade}) {
    return 'Hai preso ${grade.displayValue} in ${grade.subjectDesc.toLowerCase()}';
  }

  static String getAbsenceNotificationTitle(String code) {
    if (code == RegistroConstants.ASSENZA) return "🔴 Nuova assenza";
    if (code == RegistroConstants.RITARDO) return "🔵 Nuovo ritardo";
    if (code == RegistroConstants.RITARDO_BREVE)
      return "🔵 Nuovo ritardo breve";
    if (code == RegistroConstants.USCITA) return "🕐 Nuova uscita";
    return "";
  }

  static String getAbsenceNotificationSubtitle(Absence absence) {
    if (absence.evtCode == RegistroConstants.ASSENZA) {
      return "Assente il giorno ${DateUtils.convertDateForDisplay(absence.evtDate)}";
    } else if (absence.evtCode == RegistroConstants.RITARDO)
      return "Entrato alla ${absence.evtHPos}° ora il giorno ${DateUtils.convertDateForDisplay(absence.evtDate)}";
    else if (absence.evtCode == RegistroConstants.RITARDO_BREVE) {
      return "Giorno: ${DateUtils.convertDateForDisplay(absence.evtDate)}";
    } else if (absence.evtCode == RegistroConstants.USCITA) {
      return "Uscito alla ${absence.evtHPos}° ora il giorno ${DateUtils.convertDateForDisplay(absence.evtDate)}";
    }
    return "";
  }
}
