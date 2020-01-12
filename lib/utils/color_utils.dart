import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

class ColorUtils {

  /// Returns a color by checking the event [code]
  /// 
  /// [Red] for Absence, [Blue] for delay and [yellow] for early exit
  static Color getColorFromCode(String code) {
    if (code == RegistroConstants.ASSENZA) {
      return Colors.red;
    } else if (code == RegistroConstants.RITARDO) {
      return Colors.blue;
    } else if (code == RegistroConstants.RITARDO_BREVE) {
      return Colors.blue;
    } else if (code == RegistroConstants.USCITA) {
      return Colors.yellow[600];
    } else {
      return Colors.blue;
    }
  }
}
