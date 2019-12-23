import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class GradesUtils {
  static double getAverage(int subjectId, List<Grade> grades) {
    double sum = 0;
    int count = 0;

    grades.forEach((grade) {
      if (grade.subjectId == subjectId && grade.decimalValue != -1.00) {
        sum += grade.decimalValue;

        count++;
      }
    });
    return sum / count;
  }

  /// Taken from registro elettroncio github by Simone Luconi, thanks
  static String getGradeMessage(
      double obj, double average, int numberOfGrades, BuildContext context) {
    if (obj > 10 || average > 10) {
      return "Errore nel calcolo";
    }
    if (obj >= 10 && average < obj) {
      return "Obiettivo irragiungibile";
    }

    var array = [0.75, 0.5, 0.25, 0.0];
    var index = 0;
    double sommaVotiDaPrendere;
    var votiMinimi = [0.0, 0.0, 0.0, 0.0, 0.0];
    double diff;
    double diff2;
    double resto = 0.0;
    double parteIntera;
    double parteDecimale;
    try {
      do {
        index += 1;
        sommaVotiDaPrendere =
            obj * (numberOfGrades + index) - average * numberOfGrades;
      } while (sommaVotiDaPrendere / index > 10);
      var i = 0;
      while (i < index) {
        votiMinimi[i] = sommaVotiDaPrendere / index + resto;
        resto = 0.0;
        parteIntera = votiMinimi[i];
        parteDecimale = (votiMinimi[i] - parteIntera) * 100;
        if (parteDecimale != 25.0 &&
            parteDecimale != 50.0 &&
            parteDecimale != 75.0) {
          var k = 0;
          do {
            diff = votiMinimi[i] - (parteIntera + array[k]);
            k++;
          } while (diff < 0);
          votiMinimi[i] = votiMinimi[i] - diff;
          resto = diff;
        }
        if (votiMinimi[i] > 10) {
          diff2 = votiMinimi[i] - 10;
          votiMinimi[i] = 10.0;
          resto += diff2;
        }
        i += 1;
      }
      String returnString;
      final trans = AppLocalizations.of(context);
      if (votiMinimi[0] <= 0)
        return trans
            .translate('dont_worry');
      if (votiMinimi[0] <= obj)
        return "${trans.translate('dont_get_less_than')} ${votiMinimi[0].toStringAsFixed(2)}";
      else {
        returnString = "${trans.translate('get_at_least')} ";

        if (votiMinimi.where((voto) => voto != 0.0).length > 3) {
          return trans.translate('objective_unreacheable');
        }
        votiMinimi.where((votoMinimo) => votoMinimo != 0.0).forEach((voto) {
          returnString += "${voto.toStringAsFixed(2)}, ";
        });
        return returnString.substring(0, returnString.length - 2);
      }
    } catch (e) {
      print(e);
      return AppLocalizations.of(context).translate('objective_unreacheable');
    }
  }
}
