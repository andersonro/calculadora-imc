import 'package:flutter/material.dart';
import 'app/view/splash_screen_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22
          )
        )
      ),
      home: const SplashScreenPage(),
    );
  }
}
