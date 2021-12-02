import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/models/home/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: use the code at https://github.com/mbitson/mcg to generate swatch

class Profiler extends StatefulWidget {
  static const String profiles_memory_key = 'profiles';
  static Map<String, Profile> profiles;
  static Profile currentProfile;

  final Widget child;

  const Profiler({Key key, @required this.child}) : super(key: key);

  @override
  _ProfilerState createState() => _ProfilerState();

  static Future<bool> addProfile(Profile profile) async {
    if (profiles?.containsKey(profile.name) == true) return false;
  }

  static Future<bool> saveProfiles() async {
    return (await SharedPreferences.getInstance()).setStringList(
      profiles_memory_key,
      (profiles ?? {})
          .values
          .map<String>((profile) => jsonEncode(profile.toJson()))
          .toList(),
    );
  }
}

class _ProfilerState extends State<Profiler> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Profiler.currentProfile?.themeData ??
          ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
      home: widget.child,
    );
  }
}
