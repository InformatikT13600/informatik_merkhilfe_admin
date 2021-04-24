import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';

class Section extends StatefulWidget {

  static Map<String, bool> expanded = {};
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
  final String name;

  Section(this.name, {bool expanded}) {
    // add the button to the map if it has not been done yet
    Section.expanded.putIfAbsent(name, () => expanded);
  }

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              key: Key('${widget.name}-button'),
              onPressed: () {
                // update state
                setState(() {
                  Section.expanded.update(widget.name, (value) => !value, ifAbsent: () => false);
                });
              },
              child: SizedBox(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.name),
                      SvgPicture.asset('assets/icons/arrow_${Section.expanded[widget.name] ? 'up' : 'down'}.svg'),
                    ]
                ),
              ),
            ),
            SizedBox(height: 20,),
            !Section.expanded[widget.name] ? Container() : Container(
              child: TextFormField(
                key: Key('${widget.name}-textfield'),
                minLines: 1,
                maxLines: 20,
                decoration: Section.inputDecoration,
              ),
            ),
            SizedBox(height: 20,),
            !Section.expanded[widget.name] ? Container() : Text('Hier neues widget')
          ],
        ),
      ),
    );
  }
}
