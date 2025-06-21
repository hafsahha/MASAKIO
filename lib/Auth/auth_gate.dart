import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:masakio/Auth/masuk.dart';
import 'package:masakio/Auth/daftar.dart';
import 'package:masakio/data/functions.dart';
import 'package:masakio/data/func_profile.dart'; // Add this import for AuthService

/// Widget ini mengecek apakah pengguna sudah login dan menampilkan UI yang sesuai
/// Digunakan sebagai overlay/popup di halaman profil untuk memastikan pengguna telah terautentikasi
/// Untuk penggunaan yang lebih mudah, gunakan AuthGateDialog dari auth_popup.dart
class AuthGate extends StatefulWidget {
  final Widget child; // The authenticated content to display
  
  const AuthGate({
    super.key,
    required this.child,
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
    if (_isLoading) {
      return widget.child;
    }

    if (_isLoggedIn) {
      return widget.child;
    } else {
      // Show child with overlay
      return Stack(
        children: [
          // Original content (blurred)
          widget.child,
          
          // Blurred background overlay
          _buildBlurredOverlay(context),
          
          // Auth popup
          _buildAuthPrompt(context),
        ],
      );
    }
  }
  
  Widget _buildBlurredOverlay(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.4),
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
              color: Colors.black.withOpacity(0.2),
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
                // Icon atau logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF83AEB1).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 60,
                    color: Color(0xFF83AEB1),
                  ),
                ),                const SizedBox(height: 16),
                // Judul
                const Text(
                  "Akses Profil",
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
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _navigateToLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83AEB1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),                const SizedBox(height: 14),
                // Tombol daftar
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _navigateToRegister(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Color(0xFF83AEB1), width: 2),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF83AEB1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),                // Tombol tutup (opsional)
                TextButton(
                  onPressed: () {                    // Cek apakah dalam konteks yang bisa di-pop
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    "Kembali",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Untuk penggunaan komponen dialog, gunakan AuthGateDialog dari auth_popup.dart
// Contoh:
// import 'package:masakio/Auth/auth_popup.dart';
// 
// AuthGateDialog.show(
//   context, 
//   onAuthSuccess: () {
//     // Tindakan setelah autentikasi berhasil
//   }
// );
