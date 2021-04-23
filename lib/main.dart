import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:informatik_merkhilfe_admin/shared/styles.dart';
import 'package:informatik_merkhilfe_admin/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Informatik Merkhilfe Adminpanel',
      theme: ThemeData(

        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: colorMainBackground,

        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
          ),
          backgroundColor: colorMainAppbar,
          titleTextStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          centerTitle: true,
        )

      ),
      home: Home(),
    );
  }
}
