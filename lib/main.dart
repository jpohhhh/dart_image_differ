import 'package:dart_image_differ/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/theming/monet_theme.dart';
import 'package:libmonet/theming/monet_theme_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.brightnessOf(context);
    final bgTone = brightness == Brightness.light ? 99.0 : 10.0;
    return MaterialApp(
      home: ProviderScope(
        child: MonetTheme(
          monetThemeData: MonetThemeData.fromColor(
            backgroundTone: bgTone,
            brightness: brightness,
            color: Color(0xff1177aa),
          ),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
