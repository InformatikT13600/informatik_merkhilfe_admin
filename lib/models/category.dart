class Category {

  String language;
  int orderPriority;
  String name;
  List<Map<String, dynamic>> children = [];
  String parentCategory;
  List<Category> childrenCategories = [];

  Category(this.language, this.children, this.name, this.orderPriority);

  /// deserializes a [json] and creates a [Category]
  Category.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    orderPriority = json['orderPriority'];
    language = json['language'];

    List<dynamic> childrenList = json['children'];
    if(childrenList == null || childrenList.isEmpty) return;
    for(Map<String, dynamic> child in childrenList) children.add(child);
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
