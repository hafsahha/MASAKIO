import 'package:flutter/material.dart';
import 'package:masakio/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: 'MASAKIO | KELOMPOK 20',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF83AEB1),
          primary: const Color(0xFF83AEB1),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}