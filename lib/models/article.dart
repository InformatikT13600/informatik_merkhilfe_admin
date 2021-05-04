import 'dart:math';

class Article {

  String language;
  String category;
  String name;
  List<String> content = [];
  List<String> tags = [];

  // used for the article editor (key)
  int id;

  Article(this.language, this.category, this.name, this.content, this.tags) {
    id = Random().nextInt(2147483647);
  }

  /// deserializes a [json] and creates an [Article]
  Article.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    language = json['language'];
    category = json['category'];

    id = Random().nextInt(2147483647);

    if(json['content'] != null) content = json['content'].cast<String>();
    if(json['tags'] != null) tags = json['tags'].cast<String>();
  }

  /// serializes an [Article] and creates a [json]
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'language': language,
      'category': category,
      'content': content,
      'tags': tags
    };
  }

  /// tells whether or not the [Article] is valid
  bool isValid() => name.isNotEmpty && content.isNotEmpty && category.isNotEmpty && language.isNotEmpty;

  /// checks whether a term matches the title or any tag of the article
  /// [pattern] the term you want to search for
  /// @return [true] if there is a match, [false] if there is no
  bool hasMatch(String pattern) {

    // pattern => lowercase
    pattern = pattern.toLowerCase();

    // check for name
    if(name.toLowerCase().startsWith(pattern)) return true;

    // check for tags
    if(tags.any((element) => element.toLowerCase().startsWith(pattern))) return true;

    // if nothing above was true => return false
    return false;

  }

}
