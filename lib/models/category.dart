import 'dart:math';

class Category {

  String language;
  String name;
  List<Map<String, dynamic>> children = [];
  String parentCategory;
  List<Category> childrenCategories = [];

  // used for the language editor (key)
  int id;

  Category(this.language, this.children, this.name) {
    this.id = Random().nextInt(2147483647);
  }

  /// deserializes a [json] and creates a [Category]
  Category.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    language = json['language'];

    this.id = Random().nextInt(2147483647);

    List<dynamic> childrenList = json['children'];
    if(childrenList == null || childrenList.isEmpty) return;
    for(Map<String, dynamic> child in childrenList) children.add(child);
  }

  Map<String, dynamic> toJson() {

    // convert children to json objects
    List<dynamic> childrenList = [];
    for(Category child in childrenCategories) {
      childrenList.add(child.toJson());
    }

    return {
      'name': name,
      'language': language,
      'children': childrenList,
    };
  }

  /// tells whether or not the [Category] is valid
  bool isValid() => name.isNotEmpty && language.isNotEmpty;

  /// builds the tree of subcategories and articles by reading through all the json objects
  void buildTree() {
    childrenCategories = _readChildren();
  }

  List<Category> _readChildren() {
    List<Category> retList = [];

    for(Map<String, dynamic> childJSON in children) {
      Category childCategory = Category.fromJSON(childJSON);
      childCategory.parentCategory = this.name;
      childCategory.buildTree();
      retList.add(childCategory);
    }

    return retList;
  }

}
