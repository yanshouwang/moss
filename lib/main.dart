import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'styles.dart';
import 'views.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('MOSS');
    setWindowMinSize(kMinimumWindowSize);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData.from(
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: Colors.red,
                ),
          ).customize(),
          darkTheme: ThemeData.from(
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: Colors.red,
                ),
          ).customize(),
          home: const HomeView(),
          // home: Feed(currentUser: user_0),
          debugShowCheckedModeBanner: false,
          // debugShowMaterialGrid: true,
        );
      },
    );
  }
}

extension on ThemeData {
  ThemeData customize() {
    return copyWith(
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
