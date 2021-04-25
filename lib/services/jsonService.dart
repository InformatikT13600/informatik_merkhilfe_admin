import 'dart:convert';

class JsonService {

  /// checks if a given [jsonString] is indeed a json
  static bool isJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      print('valid json');
      return true;
    } on FormatException catch(e) {}
    print('invalid json');
    return false;
  }

  /// checks if a given [jsonString] is a valid language json
  static bool validateLanguageJsonString(String jsonString) {
    return false;
  }

}
