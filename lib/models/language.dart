import 'package:flutter/cupertino.dart';

class Language {

  String name;
  int orderPriority;
  String colorCode;

  Language(this.name, this.orderPriority, this.colorCode);

  Language.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    orderPriority = json['orderPriority'];
    colorCode = json['colorCode'];
  }

  get color => Color(int.parse(this.colorCode, radix: 16));

  bool isValid() => name.isNotEmpty && colorCode.isNotEmpty;

}
