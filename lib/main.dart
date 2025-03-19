import 'package:finance_tracker/widgets/expenses.dart';
// import 'package:flutter/services.dart';
// for setting device orientation
import 'package:flutter/material.dart';

var kcolorscheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kdarkcolorscheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(
      255,
      5,
      99,
      125,
    ),
    brightness: Brightness.dark);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Expenses(),
      ),
    );
  }
}

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((fn){
  // this is for device orientation
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kdarkcolorscheme,
        cardTheme: const CardTheme().copyWith(
          color: kdarkcolorscheme.primaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kdarkcolorscheme.primaryContainer,
            foregroundColor: kdarkcolorscheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kcolorscheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kcolorscheme.onPrimaryContainer,
            foregroundColor: kcolorscheme.primaryContainer,
            elevation: double.maxFinite),
        cardTheme: const CardTheme().copyWith(
          color: kcolorscheme.primaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kcolorscheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.normal,
                color: kcolorscheme.onSecondaryContainer,
                fontSize: 14,
              ),
            ),
      ),
      home: const MyApp(),
    ),
  );
//   });
}
