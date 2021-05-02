import 'dart:convert';

import 'package:informatik_merkhilfe_admin/models/language.dart';

class JsonService {

  /// checks if a given [jsonString] is indeed a json
  static bool isJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } on FormatException catch (e) {}
    return false;
  }

  /// takes a list of [Language]s and tries to encode it as a jsonString
  static String writeLanguages(List<Language> list) {
    return JsonEncoder.withIndent('  ').convert(list);
  }


  /// takes a [jsonString] and tries to decode it as a [List<Language>]
  static List<Language> readLanguages(String jsonString) {
    if(!validateLanguageJsonString(jsonString)) return [];

    List<Language> list = [];

    // read json array from json file
    List<dynamic> languages = jsonDecode(jsonString);

    // iterate through all language json objects
    for(Map<String, dynamic> map in languages) {

      // generate language object from json object
      Language lang = Language.fromJSON(map);

      list.add(lang);
    }

    return list;
  }

  /// checks if a given [jsonString] is a valid language json
  static bool validateLanguageJsonString(String jsonString) {
    if(!isJson(jsonString)) return false;

    try {
      // check if json is a json array
      if(!(jsonDecode(jsonString) is List<dynamic>)) return false;

      // read json array from json file
      List<dynamic> languages = jsonDecode(jsonString);

      // iterate through all language json objects
      for(Map<String, dynamic> map in languages) {

        // generate language object from json object
        Language lang = Language.fromJSON(map);

        if(!lang.isValid()) return false;

      }
      return true;
    } on FormatException catch(e) {
      return false;
    }
  }

}
