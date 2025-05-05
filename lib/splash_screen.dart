import 'dart:async';
import 'package:flutter/material.dart';
import 'package:masakio/main_page.dart'; // ganti sesuai lokasi HomePage-mu

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigasi otomatis setelah 2 detik
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage(pageIndex: 0)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // bisa diganti sesuai tema
      body: Center(
        child: Image.asset(
          'assets/images/masakio.png',
          width: 180,
        ),
      ),
    );
  }
}
