class Article {

  String language;
  String category;
  int orderPriority;
  String name;
  List<String> content = [];
  List<String> tags = [];

  Article(this.language, this.category, this.name, this.content, this.orderPriority);

  /// deserializes a [json] and creates an [Article]
  Article.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    orderPriority = json['orderPriority'];
    language = json['language'];
    category = json['category'];

    List<dynamic> contentList = json['content'];
    contentList.forEach((contentLine) => content.add(contentLine));

    List<dynamic> tagList = json['tags'];
    tagList.forEach((tag) => tags.add(tag));
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
