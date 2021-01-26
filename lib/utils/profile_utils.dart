import 'dart:convert';
import 'dart:math';

class ProfileUtils {
  static final Random _random = Random.secure();

  /// Generates a random secure string for the key in the database
  static String createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  static String dbNameFromIdent(String ident) {
    return 'registro_${getIdFromIdent(ident)}';
  }

  /// Classeviva in the request requires and id, that you can
  /// obtain by removing the letters and keeping onyl the numbers
  ///  S6102171X -> 6102171
  static String getIdFromIdent(String ident) {
    return ident.replaceAll(RegExp('[A-Za-z]'), '');
  }
}
