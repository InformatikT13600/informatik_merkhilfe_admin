import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  update() => setState(() {});

  @override
  void initState() {
    languages = JsonService.readLanguages(Section.controllers[widget.controllerKey].value.text);
  }

  @override
  Widget build(BuildContext context) {
    if(languages.isEmpty) languages = JsonService.readLanguages(Section.controllers[widget.controllerKey].value.text);

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
              IconButton(
                key: Key(lang.name+"-gesture"),
                splashRadius: 20,
                icon: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: lang.color,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        scrollable: true,
                        content: Center(
                          child: Flexible(
                            child: ColorPicker(
                              pickerColor: languages[index].color,
                              onColorChanged: (newColor) {
                                print(newColor.toString());
                                languages.removeAt(index);
                                lang.colorCode = newColor.toString().substring(8,16);
                                languages.insert(index, lang);
                                update();
                              },
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.7,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.rgb,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                          ),
                        ),
                        actions: [TextButton(child: Text('Schließen'), onPressed: () => Navigator.pop(context),)],
                      );
                    },
                  );
                },
              )

            ],
          )
        );
      },
    );
  }
}
