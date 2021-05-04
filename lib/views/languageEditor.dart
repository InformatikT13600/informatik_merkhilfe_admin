import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:informatik_merkhilfe_admin/models/language.dart';
import 'package:informatik_merkhilfe_admin/services/jsonService.dart';
import 'package:informatik_merkhilfe_admin/views/section.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';

class LanguageEditor extends StatefulWidget {

  final String controllerKey;

  LanguageEditor(this.controllerKey);

  @override
  _LanguageEditorState createState() => _LanguageEditorState();
}

class _LanguageEditorState extends State<LanguageEditor> {
  
  List<Language> languages = [];

  bool valid = true;

  update() => setState(() {});

  @override
  void initState() {
    readJsonInputField();
  }

  void readJsonInputField() {
    setState(() {
      languages = JsonService.readLanguages(Section.controllers[widget.controllerKey].value.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      header: Column(
        children: [
          TextButton(
              onPressed: () {
                Section.controllers[widget.controllerKey].text = JsonService.writeLanguages(languages);
              },
              child: Text('∧ In JSON schreiben ∧')
          ),
          TextButton(
              onPressed: () {
                readJsonInputField();
              },
              child: Text('∨ JSON lesen ∨')
          ),
          IconButton(
            icon: Transform.scale(scale: 1, child: SvgPicture.asset('assets/icons/add.svg'),),
            onPressed: () {

              // check if there already is a language without name
              if(!languages.any((element) => element.name.isEmpty)) {
                setState(() {
                  languages.add(new Language('', 'ffffffff'));
                });
              }
            },
          )
        ],
      ),
      itemCount: languages.length,
      clipBehavior: Clip.hardEdge,
      scrollDirection: Axis.vertical,
      onReorder: (oldIndex, newIndex) {

        // get moved language object
        Language moved = languages[oldIndex];

        // insert it at the new position
        languages.insert(newIndex, moved);

        // remove it from the list
        languages.removeAt(oldIndex);
      },
      itemBuilder: (context, index) {

        Language lang = languages[index];

        return Container(
          key: Key('${lang.id}'),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: TextFormField(
                    key: Key('${lang.id}-textinput'),
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: false,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    initialValue: lang.name,
                    onChanged: (newName) => languages[index].name = newName,
                    style: TextStyle(color: lang.color, fontSize: 30),
                  ),
                ),
              ),
              IconButton(
                key: Key('${lang.id}-gesture'),
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
                        backgroundColor: colorMainAppbar,
                        content: Flexible(
                          child: ColorPicker(
                            pickerColor: languages[index].color,
                            onColorChanged: (newColor) {
                              languages[index].colorCode = newColor.toString().substring(8,16);
                              update();
                            },
                            colorPickerWidth: 300.0,
                            pickerAreaHeightPercent: 0.7,
                            enableAlpha: true,
                            displayThumbColor: true,
                            showLabel: true,
                            paletteType: PaletteType.rgb,
                            pickerAreaBorderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                          ),
                        ),
                        actions: [TextButton(child: Text('Schließen'), onPressed: () => Navigator.pop(context),)],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset('assets/icons/delete.svg'),
                onPressed: () {
                  languages.remove(lang);
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
