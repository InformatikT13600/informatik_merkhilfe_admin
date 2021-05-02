import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:informatik_merkhilfe_admin/models/language.dart';
import 'package:informatik_merkhilfe_admin/services/jsonService.dart';
import 'package:informatik_merkhilfe_admin/views/section.dart';

class LanguageEditor extends StatefulWidget {

  final String controllerKey;

  LanguageEditor(this.controllerKey);

  @override
  _LanguageEditorState createState() => _LanguageEditorState();
}

class _LanguageEditorState extends State<LanguageEditor> {
  
  List<Language> languages = [];
  
  @override
  Widget build(BuildContext context) {
    languages = JsonService.readLanguages(Section.controllers[widget.controllerKey].value.text);

    return ReorderableListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      header: TextButton(
          onPressed: () {
            Section.controllers[widget.controllerKey].text = JsonService.writeLanguages(languages);
          },
          child: Text('JSON updaten')
      ),
      itemCount: languages.length,
      clipBehavior: Clip.hardEdge,
      scrollDirection: Axis.vertical,
      onReorder: (oldIndex, newIndex) {
        // get moved language object
        Language moved = languages[oldIndex];
        // remove it from the list
        languages.remove(moved);
        // insert it at the new position
        languages.insert(newIndex, moved);
      },
      itemBuilder: (context, index) {

        Language lang = languages[index];

        return Container(
          key: Key(lang.name),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: lang.color,
              width: 3,
            )
          ),
          child: Row(
            children: [
              Text(
                lang.name,
                style: TextStyle(color: lang.color, fontSize: 30),
              ),
            ],
          )
        );
      },
    );
  }
}
