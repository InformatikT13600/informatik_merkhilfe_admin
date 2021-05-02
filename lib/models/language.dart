import 'dart:math';

import 'package:flutter/cupertino.dart';

class Language {

  String name;
  String colorCode;

  // used for the language editor (key)
  int id;

  Language(this.name, this.colorCode) {
    this.id = Random().nextInt(2147483647);
  }

  Language.fromJSON(Map<String, dynamic> json) {
    name = json['name'] == null ? '' : json['name'];
    colorCode = json['colorCode'] == null ? '' : json['colorCode'];
    id = Random().nextInt(2147483647);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'colorCode': colorCode,
    };
  }

  get color => Color(int.parse(this.colorCode, radix: 16));

  bool isValid() => name.isNotEmpty && colorCode.isNotEmpty;

}
