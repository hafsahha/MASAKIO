import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masakio/data/func_profile.dart';

// Base URL for the API - this should match your backend server address
const String baseUrl = 'https://masakio.up.railway.app';

// Model class for History
class HistoryItem {
  final int id_resep;
  final String nama_resep;
  final String thumbnail;
  final DateTime waktu_dilihat;
  final int review_count;
  final double rating;

  HistoryItem({
    required this.id_resep, 
    required this.nama_resep, 
    required this.thumbnail, 
    required this.waktu_dilihat,
    required this.review_count,
    required this.rating,
  });  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    int idResep;
    if (json['id_resep'] is String) {
      idResep = int.tryParse(json['id_resep']) ?? 0;
    } else {
      idResep = json['id_resep'] ?? 0;
    }
    
    double rating;
    if (json['rating'] is String) {
      rating = double.tryParse(json['rating']) ?? 0.0;
    } else {
      rating = (json['rating'] ?? 0.0).toDouble();
    }
    
    int reviewCount;
    if (json['review_count'] is String) {
      reviewCount = int.tryParse(json['review_count']) ?? 0;
    } else {
      reviewCount = json['review_count'] ?? 0;
    }
    
    return HistoryItem(
      id_resep: idResep,
      nama_resep: json['nama_resep'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      waktu_dilihat: json['waktu_dilihat'] != null 
          ? DateTime.parse(json['waktu_dilihat'].toString()) 
          : DateTime.now(),
      review_count: reviewCount,
      rating: rating,
    );
  }  // Convert to a map format that matches what ResepCard expects
  Map<String, dynamic> toCardFormat() {
    return {      
      'id': id_resep.toString(),  // Convert back to string to match Resep model
      'title': nama_resep,
      'imageAsset': thumbnail.startsWith('http') ? thumbnail : 'assets/images/$thumbnail',
      'reviewCount': review_count,
      'rating': rating,
      'isOwned': false,
    };
  }
}

// Function to fetch user history
Future<List<Map<String, dynamic>>> fetchUserHistory() async {
  try {
    // Get user ID using the new method
    final userId = await AuthService.getUserId();
    
    if (userId == null) {
      return [];
    }
    
    final response = await http.get(Uri.parse('$baseUrl/history/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> historyData = json.decode(response.body);
      
      if (historyData.isEmpty) {
        return [];
      }
      
      final List<HistoryItem> historyItems = historyData.map((item) {
        return HistoryItem.fromJson(item);
      }).toList();
      
      // Convert to format that matches ResepCard expectations
      return historyItems.map((item) => item.toCardFormat()).toList();
    } else {
      print('Failed to fetch history: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching history: $e');
    return [];
  }
}

// Function to add a recipe to history
Future<bool> addToHistory(int recipeId) async {  try {
    // Get user ID using the new method
    final userId = await AuthService.getUserId();
    
    if (userId == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/history'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_user': userId,
        'id_resep': recipeId,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
