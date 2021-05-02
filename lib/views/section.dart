import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:informatik_merkhilfe_admin/models/SectionType.dart';
import 'package:informatik_merkhilfe_admin/services/jsonService.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';
import 'package:informatik_merkhilfe_admin/views/languageEditor.dart';

class Section extends StatefulWidget {

  static Map<String, bool> expanded = {};
  static Map<String, TextEditingController> controllers = {};

  static final inputDecoration = InputDecoration(
    isDense: true,
    isCollapsed: false,
    border: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: colorContrast,
        width: 2,
      ),
    ),
  );

  final SectionType type;

  Section(this.type, {bool expanded = false}) {
    // add the button to the map if it has not been done yet
    Section.expanded.putIfAbsent(type.name, () => expanded);
    Section.controllers.putIfAbsent(type.name, () => TextEditingController(text: '[]'));
  }

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    print('expanded: ${Section.expanded[widget.type.name]}');

    return Flexible(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              key: Key('${widget.type}-button'),
              onPressed: () {
                // update state
                setState(() {
                  Section.expanded.update(widget.type.name, (value) => !value, ifAbsent: () => false);
                });
              },
              child: SizedBox(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.type.name),
                      SvgPicture.asset('assets/icons/arrow_${Section.expanded[widget.type.name] ? 'up' : 'down'}.svg'),
                    ]
                ),
              ),
            ),
            SizedBox(height: 20,),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  !Section.expanded[widget.type.name] ? Container() : Container(
                    child: TextFormField(
                      controller: Section.controllers[widget.type.name],
                      validator: (value) {
                        if(!JsonService.isJson(value)) return 'Ungültiges Json-Format';
                        if(!isCorrectFormat(value)) return 'Das JsonObject entspricht nicht dem richtigen Format für diesen Typ';

                        return null;
                      },
                      autovalidateMode: AutovalidateMode.always,
                      minLines: 1,
                      maxLines: 5,
                      decoration: Section.inputDecoration,
                      onChanged: (val) => setState(() => {}),

                    ),
                  ),
                  SizedBox(height: 20,),
                  Section.expanded[widget.type.name] && _formKey.currentState.validate() ? getEditor(widget.type.name) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  bool isCorrectFormat(String input) {
    switch(widget.type) {
      case(SectionType.LANGUAGE): return JsonService.validateLanguageJsonString(input);
      default: return false;
    }
}

  Widget getEditor(String key) {
    Widget editor;

    switch(widget.type) {
      case(SectionType.LANGUAGE): editor = LanguageEditor(key); break;
      default: editor = Text('valide');
    }

    print('Editor is: ${widget.type.name}');
    return editor;
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
