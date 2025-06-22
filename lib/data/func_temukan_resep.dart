import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const cardRecipeEndpoint = '${url}card_recipe/all'; // Endpoint untuk card recipe

// Model untuk Temukan Resep
class TemukanResepCard {
  final int id;
  final String nama;
  final int jumlahView;
  final String thumbnail;
  final String namaPenulis;
  final double rating;
  final int jumlahReview;
  
  TemukanResepCard({
    required this.id,
    required this.nama,
    required this.jumlahView,
    required this.thumbnail,
    required this.namaPenulis,
    required this.rating,
    required this.jumlahReview,
  });
  
  factory TemukanResepCard.fromJson(Map<String, dynamic> json) {
    return TemukanResepCard(
      id: json['id_resep'] ?? 0,
      nama: json['nama_resep'] ?? '',
      jumlahView: json['jumlah_view'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      namaPenulis: json['nama_penulis'] ?? '',
      rating: _parseRating(json['rating']), // Gunakan helper function
      jumlahReview: json['jumlah_review'] ?? 0,
    );
  }
  
  // Helper function untuk parsing rating yang bisa String atau number
  static double _parseRating(dynamic rating) {
    if (rating == null) return 0.0;
    if (rating is double) return rating;
    if (rating is int) return rating.toDouble();
    if (rating is String) {
      try {
        return double.parse(rating);
      } catch (e) {
        print('Error parsing rating: $rating, error: $e');
        return 0.0;
      }
    }
    return 0.0;
  }
  
  // Convert ke format yang dibutuhkan UI (sesuai dengan CardTemukanResep)
  Map<String, dynamic> toUIFormat() {
    return {
      'id': id.toString(),
      'imagePath': 'assets/images/$thumbnail',
      'title': nama,
      'subtitle': namaPenulis,
      'views': jumlahView.toString(),
      'rating': rating.toStringAsFixed(1),
    };
  }
}

// Function untuk fetch semua card recipe dari backend
Future<List<TemukanResepCard>> fetchTemukanResepCards() async {
  final client = http.Client();
  try {
    print('Fetching temukan resep cards...');
    
    final response = await client.get(
      Uri.parse(cardRecipeEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load temukan resep cards: ${response.statusCode}');
    }
    
    final List<dynamic> data = json.decode(response.body);
    
    if (data.isEmpty) {
      return [];
    }
    
    return data.map<TemukanResepCard>((item) => TemukanResepCard.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching temukan resep cards: $e');
    rethrow;
  } finally {
    client.close();
  }
}