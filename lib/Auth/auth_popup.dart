import 'package:flutter/material.dart';
import 'package:masakio/Auth/auth_gate.dart';

/// Komponen dialog yang menampilkan AuthGate sebagai popup
class AuthGateDialog extends StatelessWidget {
  final VoidCallback? onAuthSuccess;
  
  const AuthGateDialog({
    super.key,
    this.onAuthSuccess,
  });
  
  /// Menampilkan auth popup dialog
  static Future<void> show(BuildContext context, {VoidCallback? onAuthSuccess}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthGateDialog(
        onAuthSuccess: onAuthSuccess,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: AuthGate(
        childPage: Container(), // Container kosong karena yang dibutuhkan hanya auth popup
        pageName: "Autentikasi",
        icon: Icons.lock,
      ),
    );
  }
}
