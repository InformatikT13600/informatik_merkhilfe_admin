import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:informatik_merkhilfe_admin/models/SectionType.dart';
import 'package:informatik_merkhilfe_admin/models/article.dart';
import 'package:informatik_merkhilfe_admin/models/category.dart';
import 'package:informatik_merkhilfe_admin/models/language.dart';
import 'package:informatik_merkhilfe_admin/services/jsonService.dart';
import 'package:informatik_merkhilfe_admin/views/section.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';

class ArticleEditor extends StatefulWidget {

  final String controllerKey;

  ArticleEditor(this.controllerKey);

  @override
  _ArticleEditorState createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {

  List<Article> articles = [];

  bool valid = true;

  update() => setState(() {});

  @override
  void initState() {
    articles = JsonService.readArticles(Section.controllers[widget.controllerKey].value.text);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> invalidMessages = [];

    // check if there is a valid language json
    if(!JsonService.validateLanguageJsonString(Section.controllers[SectionType.LANGUAGE.name].text)) {
      invalidMessages.add(Container(child: Text('Ungültige Language JSON', style: TextStyle(fontSize: 30, color: colorRed),)));
    }

    // check if there is a valid category json
    if(!JsonService.validateCategoryJsonString(Section.controllers[SectionType.CATEGORY.name].text)) {
      invalidMessages.add(Container(child: Text('Ungültige Category JSON', style: TextStyle(fontSize: 30, color: colorRed),)));
    }

    // if there are any invalid-messages => return messages
    if(invalidMessages.isNotEmpty) return Column(children: invalidMessages,);

    // read Language objects
    List<Language> languages = JsonService.readLanguages(Section.controllers[SectionType.LANGUAGE.name].value.text);

    // read Category objects
    List<Category> categories = JsonService.readCategories(Section.controllers[SectionType.CATEGORY.name].value.text);

    return ReorderableListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      header: Column(
        children: [
          TextButton(
              onPressed: () {
                Section.controllers[widget.controllerKey].text = JsonService.writeArticles(articles);
              },
              child: Text('^ In JSON schreiben ^')
          ),
          IconButton(
            icon: Transform.scale(scale: 1, child: SvgPicture.asset('assets/icons/add.svg'),),
            onPressed: () {

              // check if there already is an article without name
              if(!articles.any((element) => element.name.isEmpty)) {
                setState(() {
                  articles.add(new Article('Sprache', 'Kategorie', 'Name', [], []));
                });
              }
            },
          )
        ],
      ),
      itemCount: articles.length,
      clipBehavior: Clip.hardEdge,
      scrollDirection: Axis.vertical,
      onReorder: (oldIndex, newIndex) {

        // get moved article object
        Article moved = articles[oldIndex];

        // insert it at the new position
        articles.insert(newIndex, moved);

        // remove it from the list
        articles.removeAt(oldIndex);
      },
      itemBuilder: (context, index) {

        Article article = articles[index];

        return Container(
            key: Key('${article.id}'),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 10),
            height: 80,
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
                  child: TextFormField(
                    key: Key('${article.id}-textinput'),
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: false,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    initialValue: article.name,
                    onChanged: (newName) => articles[index].name = newName,
                    style: TextStyle(color: colorMainAppbar, fontSize: 30),
                  ),
                ),
                Container(margin: EdgeInsets.symmetric(horizontal: 10), width: 2, color: colorContrast,),
                Expanded(
                  child: TextFormField(
                    key: Key('${article.id}-languageinput'),
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: false,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    initialValue: article.language,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (input) {
                      // checks if there is any language, that starts with the input
                      return !languages.any((element) => element.name.startsWith(input)) ? 'Unbekannte Sprache' : null;
                    },
                    onChanged: (newLanguage) => articles[index].language = newLanguage,
                    style: TextStyle(color: colorMainAppbar, fontSize: 30),
                  ),
                ),
                Container(margin: EdgeInsets.symmetric(horizontal: 10), width: 2, color: colorContrast,),
                Expanded(
                  child: TextFormField(
                    key: Key('${article.id}-categoryinput'),
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: false,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    initialValue: article.category,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (input) {
                      // checks if there is any category, that starts with the input
                      return !categories.any((element) => element.name.startsWith(input)) ? 'Unbekannte Kategorie' : null;
                    },
                    onChanged: (newCategory) => articles[index].category = newCategory,
                    style: TextStyle(color: colorMainAppbar, fontSize: 30),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/icons/delete.svg'),
                  onPressed: () {
                    articles.remove(article);
                    update();
                  },
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
