import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:informatik_merkhilfe_admin/models/SectionType.dart';
import 'package:informatik_merkhilfe_admin/models/category.dart';
import 'package:informatik_merkhilfe_admin/models/language.dart';
import 'package:informatik_merkhilfe_admin/services/jsonService.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';
import 'package:informatik_merkhilfe_admin/views/section.dart';

class CategoryEditor extends StatefulWidget {

  final String controllerKey;

  final Category parentCategory;
  final List<Category> initialChildren;
  final Function updateParent;

  CategoryEditor(this.controllerKey, this.initialChildren, this.parentCategory, {this.updateParent});

  @override
  _CategoryEditorState createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {

  List<Category> categories = [];
  Map<String, bool> showChildren = {};

  bool valid = true;
  bool isChildrenEditor = false;

  update() => setState(() {});

  @override
  void initState() {
    // check if a controller has been passed
    if(widget.controllerKey != null) readJsonInputField();
    else {
      print('no controller');
      // if there is no controller, this is assumed to be a children category editor
      categories = widget.initialChildren;
      isChildrenEditor = true;
    }

    if(categories == null) categories = [];
  }

  void readJsonInputField() {
    setState(() {
      categories = JsonService.readCategories(Section.controllers[widget.controllerKey].value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build category editor with isChildren? : $isChildrenEditor');

    // check if there is a valid language json
    if(!JsonService.validateLanguageJsonString(Section.controllers[SectionType.LANGUAGE.name].text)) {
      return Container(child: Text('Ungültige Language JSON', style: TextStyle(fontSize: 30, color: colorRed),));
    }

    // read Language objects
    List<Language> languages = JsonService.readLanguages(Section.controllers[SectionType.LANGUAGE.name].value.text);

    return ReorderableListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      header: Column(
        children: [
          !isChildrenEditor ? TextButton(
              onPressed: () {
                Section.controllers[widget.controllerKey].text = JsonService.writeCategories(categories);
              },
              child: Text('∧ In JSON schreiben ∧')
          ) : Container(),
          !isChildrenEditor ? TextButton(
              onPressed: () {
                readJsonInputField();
              },
              child: Text('∨ JSON lesen ∨')
          ) : Container(),
          isChildrenEditor ? TextButton(
              onPressed: () {
                readJsonInputField();
              },
              child: Text('Update Parent'),
          ) : Container(),
          IconButton(
            icon: Transform.scale(scale: 1, child: SvgPicture.asset('assets/icons/add.svg'),),
            onPressed: () {

              // check if there already is a category without name
              if(!categories.any((element) => element.name.isEmpty)) {
                setState(() {
                  categories.add(new Category('', [], ''));
                });
              }
            },
          )
        ],
      ),
      itemCount: categories.length,
      clipBehavior: Clip.hardEdge,
      scrollDirection: Axis.vertical,
      onReorder: (oldIndex, newIndex) {

        // get moved Category object
        Category moved = categories[oldIndex];

        // insert it at the new position
        categories.insert(newIndex, moved);

        // remove it from the list
        categories.removeAt(oldIndex);

        // update parent if it's a children Editor
        if(isChildrenEditor) updateParent(widget.parentCategory, categories);

      },
      itemBuilder: (context, index) {

        Category cat = categories[index];

        String showChildrenKey = '${cat.id}showChildren';
        showChildren.putIfAbsent(showChildrenKey, () => false);


        TextEditingController _languageController = TextEditingController(text: cat.language);

        // check if the specified language exists and set it's color as borderColor
        Color borderColor = languages.firstWhere((element) => element.name.startsWith(_languageController.value.text), orElse: () => Language('', colorContrast.toString())).color;

        return Container(
          key: Key('${cat.id}'),
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            key: Key('${cat.id}-section'),
            children: [
              Container(
                  key: Key('${cat.id}-container'),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 10),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: borderColor,
                        width: 3,
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: Key('${cat.id}-textinput'),
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: false,
                            border: UnderlineInputBorder(borderSide: BorderSide.none),
                          ),
                          initialValue: cat.name,
                          onChanged: (newName) => categories[index].name = newName,
                          style: TextStyle(color: colorMainAppbar, fontSize: 25),
                        ),
                      ),
                      Container(margin: EdgeInsets.symmetric(horizontal: 10), width: 2, color: borderColor,),
                      Expanded(
                        child: TextFormField(
                          key: Key('${cat.id}-languageinput'),
                          controller: _languageController,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: false,
                            border: UnderlineInputBorder(borderSide: BorderSide.none),
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (input) {
                            // checks if there is any language, that starts with the input
                            return !languages.any((element) => element.name.startsWith(input)) ? 'Unbekannte Sprache' : null;
                          },
                          onChanged: (newLanguage) => categories[index].language = newLanguage,
                          style: TextStyle(color: colorMainAppbar, fontSize: 25),
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/arrow_${showChildren[showChildrenKey] ? 'up' : 'down'}.svg'),
                        onPressed: () {
                            setState(() {
                              showChildren.update(showChildrenKey, (value) => !value);
                            });
                        },
                      ),
                      SizedBox(width: 30,)
                    ],
                  )
              ),
              !showChildren[showChildrenKey] ? Container() : Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: CategoryEditor(null, cat.childrenCategories, widget.parentCategory, updateParent: updateParent),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void updateParent(Category cat, List<Category> newChildren) {
    setState(() {
      // iterate through categories
      for(int index = 0; index < categories.length; index++) {
        print('iterate through categories: Index $index');
        // check if current category is the modified one
        if(categories[index] == cat) {
          print('found category ${cat.name}');
          categories[index].childrenCategories = newChildren;
          // break
          break;
        }
      }
    });
  }
}

extension on SectionType {

  String get name {
    switch(this) {
      case(SectionType.LANGUAGE): return 'Sprachen'; break;
      case(SectionType.CATEGORY): return 'Kategorien'; break;
      case(SectionType.ARTICLE): return 'Artikel'; break;
      default: return '';
    }
  }

}
