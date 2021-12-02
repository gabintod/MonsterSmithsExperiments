import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile {
  String name;
  ColorSwatch colorSwatch;
  bool isDark;

  Profile(this.name, this.colorSwatch, this.isDark);

  Profile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        colorSwatch = json['colorSwatch'],
        isDark = json['isDark'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'colorSwatch': colorSwatch,
        'isDark': isDark,
      };

  ThemeData get themeData => ThemeData(
    primarySwatch: colorSwatch,
    brightness: isDark == true ? Brightness.dark : Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
