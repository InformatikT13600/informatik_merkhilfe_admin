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

  CategoryEditor(this.controllerKey);

  @override
  _CategoryEditorState createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {

  List<Category> categories = [];

  bool valid = true;

  update() => setState(() {});

  @override
  void initState() {
    categories = JsonService.readCategories(Section.controllers[widget.controllerKey].value.text);
  }

  @override
  Widget build(BuildContext context) {

    // check if there is a valid language json
    if(!JsonService.validateLanguageJsonString(Section.controllers[SectionType.LANGUAGE.name].text)) {
      return Container(child: Text('Ungültige Language JSON', style: TextStyle(fontSize: 30, color: colorRed),));
    }

    // if list of Category objects is empty => check if there are any that can be read from the json input
    if(categories.isEmpty) categories = JsonService.readCategories(Section.controllers[widget.controllerKey].value.text);

    // read Languag objects
    List<Language> languages = JsonService.readLanguages(Section.controllers[SectionType.LANGUAGE.name].value.text);

    return ReorderableListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      header: Column(
        children: [
          TextButton(
              onPressed: () {
                Section.controllers[widget.controllerKey].text = JsonService.writeCategories(categories);
              },
              child: Text('^ In JSON schreiben ^')
          ),
          IconButton(
            icon: Transform.scale(scale: 1, child: SvgPicture.asset('assets/icons/add.svg'),),
            onPressed: () {

              // check if there alraedy is a category without name
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

      },
      itemBuilder: (context, index) {

        Category cat = categories[index];

        return Container(
            key: Key('${cat.id}'),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: colorContrast,
                  width: 3,
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: TextFormField(
                      key: Key('${cat.id}-textinput'),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: false,
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                      initialValue: cat.name,
                      onChanged: (newName) => categories[index].name = newName,
                      style: TextStyle(color: colorMainAppbar, fontSize: 30),
                    ),
                  ),
                ),
                Container(margin: EdgeInsets.symmetric(horizontal: 10), width: 2, color: colorContrast,),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: TextFormField(
                      key: Key('${cat.id}-languageinput'),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: false,
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                      initialValue: cat.language,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (input) {
                        // checks if there is any language, that starts with the input
                        return !languages.any((element) => element.name.startsWith(input)) ? 'Unbekannte Sprache' : null;
                      },
                      onChanged: (newLanguage) => categories[index].language = newLanguage,
                      style: TextStyle(color: colorMainAppbar, fontSize: 30),
                    ),
                  ),
                ),
                SizedBox(width: 30,)
              ],
            )
        );
      },
    );
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
