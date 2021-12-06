import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Map<String, dynamic> toJson() => {
    'primary': this.primary.value,
    'primaryVariant': this.primaryVariant.value,
    'secondary': this.secondary.value,
    'secondaryVariant': this.secondaryVariant.value,
    'surface': this.surface.value,
    'background': this.background.value,
    'error': this.error.value,
    'onPrimary': this.onPrimary.value,
    'onSecondary': this.onSecondary.value,
    'onSurface': this.onSurface.value,
    'onBackground': this.onBackground.value,
    'onError': this.onError.value,
    'brightness': this.brightness == Brightness.light,
  };

  static ColorScheme fromJson(Map<String, dynamic> json) {
    return ColorScheme(
      primary: Color(json['primary']),
      primaryVariant: Color(json['primaryVariant']),
      secondary: Color(json['secondary']),
      secondaryVariant: Color(json['secondaryVariant']),
      surface: Color(json['surface']),
      background: Color(json['background']),
      error: Color(json['error']),
      onPrimary: Color(json['onPrimary']),
      onSecondary: Color(json['onSecondary']),
      onSurface: Color(json['onSurface']),
      onBackground: Color(json['onBackground']),
      onError: Color(json['onError']),
      brightness: json['brightness'] == true ? Brightness.light : Brightness.dark,
    );
  }
}