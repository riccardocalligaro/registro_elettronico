import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

class ColorUtils {
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
