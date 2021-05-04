import 'dart:convert';

import 'package:informatik_merkhilfe_admin/models/article.dart';
import 'package:informatik_merkhilfe_admin/models/category.dart';
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

      List<Language> tempLanguageObjects = [];

      // iterate through all language json objects
      for(Map<String, dynamic> map in languages) {

        // generate language object from json object
        Language lang = Language.fromJSON(map);

        tempLanguageObjects.add(lang);
      }

      // check if any language objects share the same name
      return !tempLanguageObjects.any((element1) => tempLanguageObjects.any((element2) => element1 != element2 && element1.name == element2.name));
    } on FormatException catch(e) {
      return false;
    }
  }

  /// takes a list of [Category]s and tries to encode it as a jsonString
  static String writeCategories(List<Category> list) {
    return JsonEncoder.withIndent('  ').convert(list);
  }

  /// takes a [jsonString] and tries to decode it as a [List<Category>]
  static List<Category> readCategories(String jsonString) {
    if(!validateCategoryJsonString(jsonString)) return [];

    List<Category> list = [];

    // read json array from json file
    List<dynamic> categories = jsonDecode(jsonString);

    // iterate through all language json objects
    for(Map<String, dynamic> map in categories) {

      // generate language object from json object
      Category cat = Category.fromJSON(map);

      // build up children
      cat.buildTree();

      list.add(cat);
    }

    return list;
  }

  /// checks if a given [jsonString] is a valid category json
  static bool validateCategoryJsonString(String jsonString) {
    if(!isJson(jsonString)) return false;

    try {
      // check if json is a json array
      if(!(jsonDecode(jsonString) is List<dynamic>)) return false;

      // read json array from json file
      List<dynamic> categories = jsonDecode(jsonString);

      // iterate through all category json objects
      for(Map<String, dynamic> map in categories) {

        // generate category object from json object
        Category cat = Category.fromJSON(map);
      }

      return true;
    } on FormatException catch(e) {
      return false;
    }
  }

  /// takes a list of [Article]s and tries to encode it as a jsonString
  static String writeArticles(List<Article> list) {
    return JsonEncoder.withIndent('  ').convert(list);
  }


  /// takes a [jsonString] and tries to decode it as a [List<Article>]
  static List<Article> readArticles(String jsonString) {
    if(!validateArticleJsonString(jsonString)) return [];

    List<Article> list = [];

    // read json array from json file
    List<dynamic> articles = jsonDecode(jsonString);

    // iterate through all article json objects
    for(Map<String, dynamic> map in articles) {

      // generate article object from json object
      Article article = Article.fromJSON(map);

      list.add(article);
    }

    return list;
  }

  /// checks if a given [jsonString] is a valid language json
  static bool validateArticleJsonString(String jsonString) {
    if(!isJson(jsonString)) return false;

    try {
      // check if json is a json array
      if(!(jsonDecode(jsonString) is List<dynamic>)) return false;

      // read json array from json file
      List<dynamic> articles = jsonDecode(jsonString);

      // iterate through all article json objects
      for(Map<String, dynamic> map in articles) {

        // generate article object from json object
        Article article = Article.fromJSON(map);
      }

      return true;
    } on FormatException catch(e) {
      return false;
    }
  }

}
