import 'dart:convert';

class JsonService {

  /// checks if a given [jsonString]
  validateLanguageJsonString(String jsonString) {

    try {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return true;
    } on FormatException catch (e) {
      return false;
    }

  }

}
