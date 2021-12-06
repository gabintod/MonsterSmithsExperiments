import 'package:flutter/material.dart';

extension MaterialColorExtension on MaterialColor {
  ColorSwatch toSwatch() => ColorSwatch(
        this.value,
        {
          50: this.shade50,
          100: this.shade100,
          200: this.shade200,
          300: this.shade300,
          400: this.shade400,
          500: this.shade500,
          600: this.shade600,
          700: this.shade700,
          800: this.shade800,
          900: this.shade900,
        },
      );
}
