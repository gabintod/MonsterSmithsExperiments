import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/widgets/home/HomePage.dart';
import 'package:monster_smiths_experiments/widgets/home/Profiler.dart';

void main() {
  runApp(
    Profiler(
      child: HomePage(),
    ),
  );
}
