import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/widgets/HomePage.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
    ),
    home: HomePage(),
  ));
}
