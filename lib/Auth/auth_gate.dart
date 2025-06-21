import 'package:flutter/material.dart';
import 'package:masakio/.components/button.dart';
import 'dart:ui';
import 'package:masakio/Auth/masuk.dart';
import 'package:masakio/Auth/daftar.dart';
import 'package:masakio/data/func_profile.dart';

/// Widget ini mengecek apakah pengguna sudah login dan menampilkan UI yang sesuai
/// Digunakan sebagai overlay/popup di halaman profil untuk memastikan pengguna telah terautentikasi
/// Untuk penggunaan yang lebih mudah, gunakan AuthGateDialog dari auth_popup.dart
class AuthGate extends StatefulWidget {
  final Widget childPage; // The authenticated content to display
  final String pageName; // Name of the page for the auth prompt
  final IconData icon; // Icon to display in the auth prompt
  
  const AuthGate({
    super.key,
    required this.childPage,
    required this.pageName,
    required this.icon,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const LoginPage())
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const DaftarAkunPage())
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return widget.childPage;

    if (_isLoggedIn) { return widget.childPage; }
    else {
      return Stack(
        children: [
          widget.childPage, // Original content
          _buildBlurredOverlay(context), // Blurred background overlay
          _buildAuthPrompt(context), // Auth prompt dialog
        ],
      );
    }
  }
  
  Widget _buildBlurredOverlay(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Color(0x66000000),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
  
  Widget _buildAuthPrompt(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0x33000000),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0x3383AEB1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 60,
                    color: const Color(0xFF83AEB1),
                  ),
                ),
                const SizedBox(height: 16),
                // Judul
                Text(
                  "Akses ${widget.pageName}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                // Deskripsi
                const Text(
                  "Silakan masuk atau daftar untuk mengakses halaman ini",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol masuk
                Button(
                  onPressed: () => _navigateToLogin(context),
                  content: "Masuk",
                ),
                const SizedBox(height: 14),
                // Tombol daftar
                Button(
                  onPressed: () => _navigateToRegister(context),
                  content: "Daftar",
                  textColor: 0xFF83AEB1,
                  backgroundColor: 0xFFFFFFFF,
                  borderColor: 0xFF83AEB1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
