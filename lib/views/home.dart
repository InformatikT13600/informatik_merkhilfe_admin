import 'package:flutter/material.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';
import 'package:informatik_merkhilfe_admin/views/section.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informatik Merkhilfe Adminpanel'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(50),
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: colorContrast,
              width: 3,
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Section('Sprachen', expanded: false,),
              Section('Kategorien', expanded: false,),
              Section('Artikel', expanded: false,),
            ],
          ),
        ),
      ),
    );
  }
}
