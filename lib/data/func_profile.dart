import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const profileEndpoint = '${url}user/'; // Endpoint untuk profil
const authEndpoint = '${url}user'; // Endpoint untuk autentikasi

// User model
class User {
  final int id;
  final String name;
  final String email;
  final String? birthDate;
  final String? createdAt;
  
  User({
    required this.id, 
    required this.name, 
    required this.email, 
    this.birthDate, 
    this.createdAt
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      name: json['nama_user'],
      email: json['email'],
      birthDate: json['tanggal_lahir'],
      createdAt: json['created_at'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'nama_user': name,
      'email': email,
      'tanggal_lahir': birthDate,
      'created_at': createdAt,
    };
  }
}

// Fungsi untuk mengecek ketersediaan server
Future<bool> checkServerAvailability() async {
  try {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } finally {
      client.close();
    }
  } catch (e) {
    print('Server connectivity error: $e');
    return false;
  }
}

// Authentication service
class AuthService {
  static const String _userKey = 'user_data';
    // Register new user
  static Future<User> register({
    required String name, 
    required String email, 
    required String password,
    String? birthDate,
  }) async {
    final client = http.Client();
    try {
      print('Mencoba register dengan email: $email ke ${authEndpoint}/register');
      
      final response = await client.post(
        Uri.parse('${authEndpoint}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_user': name,
          'email': email,
          'password': password,
          'tanggal_lahir': birthDate ?? DateTime.now().toIso8601String().split('T')[0],
        }),
      ).timeout(const Duration(seconds: 10));
      
      print('Status response: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 201) {
        final userData = json.decode(response.body);
        final user = User.fromJson(userData['user']);
        
        // Save user to local storage
        await _saveUserToLocal(user);
        
        return user;
      } else {
        // Coba parse error message
        try {
          final errorData = json.decode(response.body);
          final error = errorData['error'] ?? 'Registrasi gagal: ${response.statusCode}';
          throw Exception(error);
        } catch (e) {
          throw Exception('Registrasi gagal: ${response.statusCode}. ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    } finally {
      client.close();
    }
  }
    // Login user
  static Future<User> login({
    required String email, 
    required String password,
  }) async {
    try {
      // Cek dulu apakah server tersedia
      final isServerAvailable = await checkServerAvailability();
      if (!isServerAvailable) {
        throw Exception('Server tidak dapat dijangkau. Silakan cek koneksi internet Anda dan coba lagi nanti.');
      }
      
      print('Mencoba login dengan email: $email ke ${authEndpoint}/login');
      
      final client = http.Client();
      try {
        final response = await client.post(
          Uri.parse('${authEndpoint}/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Koneksi timeout. Silakan coba lagi nanti.'),
        );
        
        print('Status response: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          
          // Validasi struktur respons
          if (userData['user'] == null) {
            throw Exception('Format respons server tidak valid: user data tidak ditemukan');
          }
          
          final user = User.fromJson(userData['user']);
          
          // Save user to local storage
          await _saveUserToLocal(user);
          
          return user;
        } else {
          // Coba parse error message
          try {
            final errorData = json.decode(response.body);
            final error = errorData['error'] ?? 'Login gagal: ${response.statusCode}';
            throw Exception(error);
          } catch (e) {
            // Jika tidak bisa parse JSON
            throw Exception('Login gagal: ${response.statusCode}. ${response.reasonPhrase}');
          }
        }
      } finally {
        client.close(); // Tutup client HTTP
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null) return null;
      
      final userData = json.decode(userJson);
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }
  
  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
  
  // Save user to local storage
  static Future<void> _saveUserToLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}

// Fetch user profile
Future<User?> fetchUserProfile(int userId) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse('${profileEndpoint}${userId}')
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return User.fromJson(userData);
    }
    return null;
  } catch (e) {
    print('Error fetching profile: $e');
    return null;
  } finally {
    client.close();
  }
}

// Update user profile
Future<bool> updateUserProfile(User user) async {
  final client = http.Client();
  try {
    final response = await client.put(
      Uri.parse('${profileEndpoint}${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_user': user.name,
        'email': user.email,
        'tanggal_lahir': user.birthDate,
      }),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      // Update local user data
      await AuthService._saveUserToLocal(user);
      return true;
    }
    return false;
  } catch (e) {
    print('Error updating profile: $e');
    return false;
  } finally {
    client.close();
  }
}

// Note: Wishlist functions have been moved to func_wishlist.dart
