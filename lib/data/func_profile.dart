import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Base URL untuk backend
const url = 'https://masakio.up.railway.app';

// User model
class User {
  final int id;
  final String name;
  final String email;
  final String? birthDate;
  final String? createdAt;
  final String? photo;
  
  User({
    required this.id, 
    required this.name, 
    required this.email, 
    this.birthDate, 
    this.createdAt,
    this.photo
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      name: json['nama_user'],
      email: json['email'],
      birthDate: json['tanggal_lahir'],
      createdAt: json['created_at'],
      photo: json['foto'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'nama_user': name,
      'email': email,
      'tanggal_lahir': birthDate,
      'created_at': createdAt,
      'foto': photo,
    };
  }
}

// Fungsi untuk mengecek ketersediaan server
Future<bool> checkServerAvailability() async {
  try {
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) { return false; }
}

// Authentication service
class AuthService {
  static const String _userKey = 'user_data';
  
  // Register new user
  static Future<User> register({required String name,  required String email,  required String password, String? birthDate, List<int>? diseases}) async {
    final isServerAvailable = await checkServerAvailability();
    if (!isServerAvailable) throw Exception('Server tidak dapat dijangkau.');

    try {      
      final response = await http.post(Uri.parse('$url/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'password': password,
          'birth_date': birthDate ?? DateTime.now().toIso8601String().split('T')[0],
          'diseases': diseases, // Include diseases in the request body
        }),
      ).timeout(const Duration(seconds: 10), onTimeout: () => throw Exception('Koneksi timeout. Silakan coba lagi nanti.'));
        if (response.statusCode == 201) {
        final userData = json.decode(response.body);
        final user = User.fromJson(userData);
        await _saveUserToLocal(user);
        
        // Ensure the user_id is stored
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user.id);
        
        return user;
      } else {
        final errorData = json.decode(response.body);
        final error = errorData['error'] ?? 'Registrasi gagal: ${response.statusCode}';
        throw Exception(error);
      }
    } catch (e) { rethrow; }
  }
  
  // Login user
  static Future<User> login({required String email, required String password,}) async {
    final isServerAvailable = await checkServerAvailability();
    if (!isServerAvailable) throw Exception('Server tidak dapat dijangkau.');
      
    try {
      final response = await http.post(Uri.parse('$url/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10), onTimeout: () => throw Exception('Koneksi timeout. Silakan coba lagi nanti.'));
        if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        if (userData == null) throw Exception('User data tidak ditemukan');
        final user = User.fromJson(userData);
        await _saveUserToLocal(user);
        
        // Ensure the user_id is stored
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user.id);
        
        return user;
      } else {
        final errorData = json.decode(response.body);
        final error = errorData['error'] ?? 'Login gagal: ${response.statusCode}';
        throw Exception(error);
      }
    } catch (e) { rethrow; }
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null) return false;
      
      return true;
    } catch (e) { return false; }
  }
  
  // Get current user ID (convenience method)
  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
    } catch (e) { 
      return null;
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
    } catch (e) { return null; }
  }
    // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove('user_id'); // Also remove the separate user_id
  }
    // Save user to local storage
  static Future<void> _saveUserToLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setInt('user_id', user.id); // Store user_id separately for easier access
  }
}

// Fetch user profile
Future<User?> fetchUserProfile(int id) async {
  try {
    final response = await http.get(Uri.parse('$url/user/$id')).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return User.fromJson(userData);
    }
    return null;
  } catch (e) { return null; }
}

// Update user profile
Future<bool> updateUserProfile(User user) async {
  try {
    final response = await http.put(Uri.parse('$url/user/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_user': user.name,
        'email': user.email,
        'tanggal_lahir': user.birthDate,
      }),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      await AuthService._saveUserToLocal(user);
      return true;
    }
    return false;
  } catch (e) {return false; }
}
