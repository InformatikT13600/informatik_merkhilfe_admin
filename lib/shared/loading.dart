import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'styles.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: colorMainBackground,child: SpinKitHourGlass(color: colorRed, size: 100, duration: const Duration(seconds: 2),));
  }
}
