import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_smiths_experiments/utils/ColorSchemeExtension.dart';

class Profiler extends StatefulWidget {
  static const _colorSchemeMemoryKey = 'color_scheme_memory_key';

  static ColorScheme _colorScheme;

  static ColorScheme get colorScheme => _colorScheme;

  static set colorScheme(ColorScheme value) {
    _colorScheme = value;
    _state?.update();
  }

  static _ProfilerState _state;

  final Widget child;

  const Profiler({Key key, @required this.child}) : super(key: key);

  @override
  _ProfilerState createState() => _ProfilerState();

  static Future<bool> saveColor() async {
    return (await SharedPreferences.getInstance()).setString(
      _colorSchemeMemoryKey,
      jsonEncode(colorScheme.toJson()),
    );
  }

  /// Get [colorScheme] value from memory
  static Future<ColorScheme> getColorScheme() async {
    String json = (await SharedPreferences.getInstance())
        .getString(_colorSchemeMemoryKey);

    if (json == null)
      return null;

    return ColorSchemeExtension.fromJson(jsonDecode(json));
  }
}

class _ProfilerState extends State<Profiler> {
  ThemeData themeData = ThemeData(colorScheme: Profiler.colorScheme);

  void update() {
    setState(() {
      themeData = ThemeData(
        colorScheme: Profiler.colorScheme,
      );
    });
  }

  @override
  void initState() {
    Profiler._state = this;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: widget.child,
    );
  }
}
