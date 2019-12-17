class StringUtils {
  // john doe => John Doe
  static String titleCase(String words) =>
      _getPascalCase(separator: ' ', input: words.split(' '));

  static String removeLastChar(String str) {
    if (str != null && str.length > 0) {
      str = str.substring(0, str.length - 2);
    }
    return str;
  }

  static String _getPascalCase({List<String> input, String separator}) {
    List<String> words = input.map(_upperCaseFirstLetter).toList();
    return words.join(separator);
  }

  static String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }

  static String beautifyString(String str) {
    return capitalizeEachWord(str);
  }

  static String capitalizeEachWord(String s) {
    String capitalized = "";
    final words = s.split(' ');
    words.forEach((word) => capitalized += word.substring(0, 1).toUpperCase() +
        word.substring(1).toLowerCase() +
        " ");
    return capitalized.substring(capitalized.length, capitalized.length - 1);
  }

  static String capitalize(String s) {
    return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
  }
}
