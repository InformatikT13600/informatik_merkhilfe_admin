import 'package:flutter/cupertino.dart';

class Language {

  String name;
  String colorCode;

  Language(this.name, this.colorCode);

  Language.fromJSON(Map<String, dynamic> json) {
    name = json['name'] == null ? '' : json['name'];
    colorCode = json['colorCode'] == null ? '' : json['colorCode'];

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
