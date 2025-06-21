import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masakio/Profile/profile.dart';
import 'package:masakio/data/functions.dart';
import 'package:masakio/Auth/daftar.dart';
import 'package:masakio/utils/ui_helper.dart';

// Fungsi untuk debugging login langsung
Future<void> testDirectLogin(BuildContext context, String email, String password) async {
  try {
    final loginUrl = 'https://masakio.up.railway.app/login';
    print('Testing direct login to $loginUrl');
      final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 5));
    
      print('Direct login response status: ${response.statusCode}');
    print('Direct login response body: ${response.body}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status: ${response.statusCode}'),
        duration: const Duration(seconds: 3),
      ),
    );
    } finally {
      client.close(); // Tutup client
  } catch (e) {
    print('Direct login error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  
  // Animasi
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {        final user = await AuthService.login(
          email: _emailC.text.trim(),
          password: _passC.text,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to profile page after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(pageIndex: 0),
            ),
          );
        }      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // Ekstrak pesan error
          String errorMessage = e.toString();
          if (errorMessage.contains('Exception: ')) {
            errorMessage = errorMessage.replaceFirst('Exception: ', '');
          }
          
          print('Login error: $errorMessage');
            // Tambahkan pemeriksaan koneksi
          bool hasInternetConnection = true;
          try {
            final client = http.Client();
            try {
              final result = await client.get(Uri.parse('https://www.google.com'))
                  .timeout(const Duration(seconds: 3));
              hasInternetConnection = result.statusCode == 200;
            } finally {
              client.close();
            }
          } catch (e) {
            hasInternetConnection = false;
          }
          
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Login Gagal"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(errorMessage),
                  if (!hasInternetConnection) 
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Sepertinya Anda tidak terhubung ke internet. '
                        'Silakan periksa koneksi internet Anda.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF83AEB1), width: 2),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background dengan gradient overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Logo atau icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title with nicer typography
                    const Text(
                      "Masuk Akun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Masuk untuk akses semua resep",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Form scrollable dengan form yang lebih bagus
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email field
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "Email ",
                                      style: TextStyle(
                                        color: Color(0xFF444444),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Masukkan Email",
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF83AEB1)),
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: focusedBorder,
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Email wajib diisi";
                                    }
                                    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                                    if (!emailRegExp.hasMatch(v.trim())) {
                                      return "Format email tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Password field
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "Kata Sandi ",
                                      style: TextStyle(
                                        color: Color(0xFF444444),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passC,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    hintText: "Masukkan Kata Sandi",
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF83AEB1)),
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: focusedBorder,
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, 
                                        color: const Color(0xFF83AEB1),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscure = !_obscure;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Kata sandi wajib diisi";
                                    }
                                    if (v.length < 6) {
                                      return "Kata sandi minimal 6 karakter";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Fungsi lupa password
                                    },
                                    child: const Text(
                                      "Lupa Password?",
                                      style: TextStyle(
                                        color: Color(0xFF83AEB1),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Container tombol yang lebih menarik di bawah
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x20000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF83AEB1),
                    )
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83AEB1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                      shadowColor: const Color(0xFF83AEB1).withOpacity(0.5),
                    ),
                    onPressed: _login,
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1.5,
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "atau",
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1.5,
                  )
                ),
              ],
            ),
            const SizedBox(height: 20),            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Belum punya akun? ",
                  style: TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaftarAkunPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      color: Color(0xFF83AEB1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            // Debug section for development - should be removed in production
            const SizedBox(height: 20),
            // Debug tools
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final isAvailable = await checkServerAvailability();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Server ${isAvailable ? 'tersedia' : 'tidak tersedia'}'),
                          backgroundColor: isAvailable ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.network_check, size: 16),
                  label: const Text('Cek Server', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    testDirectLogin(context, _emailC.text.trim(), _passC.text);
                  },
                  icon: const Icon(Icons.bug_report, size: 16),
                  label: const Text('Test Login', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),                TextButton.icon(
                  onPressed: () async {
                    try {
                      final client = http.Client();
                      try {
                        final result = await client.get(Uri.parse('https://www.google.com'))
                            .timeout(const Duration(seconds: 5));
                        final hasConnection = result.statusCode == 200;
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Internet ${hasConnection ? 'connected' : 'disconnected'}'),
                              backgroundColor: hasConnection ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      } finally {
                        client.close();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No internet connection'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.wifi, size: 16),
                  label: const Text('Cek Internet', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
