import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

class StringUtils {
  // john doe => John Doe
  static String titleCase(String words) {
    try {
      return _getPascalCase(separator: ' ', input: words.split(' '));
    } catch (e) {
      return words;
    }
  }

  static String removeLastChar(String str) {
    try {
      if (str != null && str.isNotEmpty) {
        str = str.substring(0, str.length - 2);
      }
      return str;
    } catch (_) {
      return str;
    }
  }

  static String reduceSubjectName(String argument) {
    try {
      String reducedName = argument.substring(0, 25);
      reducedName += "...";
      return titleCase(reducedName);
    } catch (_) {
      return argument;
    }
  }

  static String _getPascalCase(
      {required List<String> input, required String separator}) {
    List<String> words = input.map(_upperCaseFirstLetter).toList();
    return words.join(separator);
  }

  static String _upperCaseFirstLetter(String word) {
    try {
      return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
    } catch (_) {
      return word;
    }
  }

  static String beautifyString(String str) {
    try {
      return capitalizeEachWord(str);
    } catch (_) {
      return str;
    }
  }

  static String capitalizeEachWord(String s) {
    try {
      String capitalized = "";
      final words = s.split(' ');
      words.forEach((word) => capitalized +=
          word.substring(0, 1).toUpperCase() +
              word.substring(1).toLowerCase() +
              " ");
      return capitalized.substring(capitalized.length, capitalized.length - 1);
    } catch (_) {
      return s;
    }
  }

  static String capitalize(String s) {
    try {
      return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
    } catch (_) {
      return s;
    }
  }

  static String beautifyStringAndReduce(String string, int length) {
    try {
      String ret;
      try {
        ret = string.substring(
            0, string.length > length ? length : string.length);
      } catch (e) {
        Fimber.i('Coldnt beatufiy string');
        String removedSpaces = string.replaceAll(' ', '');
        ret = string.substring(
            0, removedSpaces.length > length ? length : removedSpaces.length);
      }
      return titleCase(ret);
    } catch (_) {
      return string;
    }
  }
}
