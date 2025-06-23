import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

// Model untuk Card Recipe dari backend
class CardRecipe {
  final int idResep;
  final String namaResep;
  final int jumlahView;
  final String? thumbnail;
  final String namaPenulis;
  final double rating;
  final int jumlahReview;
  final int porsi;
  final int totalDurasi;
  final int estimasiHarga;
  final bool isBookmarked;

  CardRecipe({
    required this.idResep,
    required this.namaResep,
    required this.jumlahView,
    this.thumbnail,
    required this.namaPenulis,
    required this.rating,
    required this.jumlahReview,
    required this.porsi,
    required this.totalDurasi,
    required this.estimasiHarga,
    required this.isBookmarked,
  });

  factory CardRecipe.fromJson(Map<String, dynamic> json) {
    // Handle thumbnail - convert filename to full Cloudinary URL if needed
    String? thumbnailUrl;
    if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      final thumbnail = json['thumbnail'].toString();
      if (thumbnail.startsWith('http')) {
        // Already a full URL
        thumbnailUrl = thumbnail;
      } else {
        // Convert filename to Cloudinary URL
        thumbnailUrl = 'https://res.cloudinary.com/dve4fhdob/image/upload/$thumbnail';
      }
    }
    
    return CardRecipe(
      idResep: json['id_resep'],
      namaResep: json['nama_resep'] ?? '',
      // Handle both format: 'jumlah_view' (dari /all) dan 'total_views' (dari /filter)
      jumlahView: json['jumlah_view'] ?? json['total_views'] ?? 0,
      thumbnail: thumbnailUrl,
      namaPenulis: json['nama_penulis'] ?? '',
      // Handle both format: 'rating' (dari /all) dan 'rating_rata_rata' (dari /filter)
      rating: double.tryParse((json['rating'] ?? json['rating_rata_rata'] ?? 0).toString()) ?? 0.0,
      // Handle both format: 'jumlah_review' (dari /all) dan 'total_review' (dari /filter)
      jumlahReview: json['jumlah_review'] ?? json['total_review'] ?? 0,
      porsi: json['porsi'] ?? 1,
      totalDurasi: json['total_durasi'] ?? 0,
      estimasiHarga: json['estimasi_harga'] ?? 0,
      isBookmarked: (json['is_bookmarked'] ?? 0) == 1,
    );
  }

  // Convert ke format UI yang bisa digunakan oleh ResepCard
  Map<String, dynamic> toUIFormat() {
    return {
      'id': idResep,
      'title': namaResep,
      'rating': rating,
      'reviewCount': jumlahReview,
      'imageAsset': thumbnail ?? 'assets/images/placeholder.jpg',
      'isOwned': false,
      'isBookmarked': isBookmarked,
      'viewsCount': jumlahView,
      'author': namaPenulis,
      'porsi': porsi,
      'totalDurasi': totalDurasi,
      'estimasiHarga': estimasiHarga,
    };
  }
}

// Fetch all recipes untuk home page
Future<List<CardRecipe>> fetchAllCardRecipes() async {
  final client = http.Client();
  try {
    print('Fetching all card recipes from: $baseUrl/card_recipe/all');
    
    final response = await client.get(
      Uri.parse('$baseUrl/card_recipe/all'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }

    final List<dynamic> data = json.decode(response.body);
    print('Parsed ${data.length} recipes');

    return data.map<CardRecipe>((item) => CardRecipe.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching card recipes: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Fetch recipes with filter untuk discovery page
Future<List<CardRecipe>> fetchFilteredCardRecipes({
  int? categoryId,
  List<String>? includeBahan,
  List<String>? excludeBahan,
  int? limit,
  String? userId,
}) async {
  final client = http.Client();
  try {
    // Build query parameters
    final queryParams = <String, String>{};
    
    if (categoryId != null) {
      queryParams['category_id'] = categoryId.toString();
    }
    
    if (includeBahan != null && includeBahan.isNotEmpty) {
      queryParams['include'] = includeBahan.join(',');
    }
    
    if (excludeBahan != null && excludeBahan.isNotEmpty) {
      queryParams['exclude'] = excludeBahan.join(',');
    }
    
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    
    if (userId != null) {
      queryParams['user_id'] = userId;
    }

    final uri = Uri.parse('$baseUrl/card_recipe/filter').replace(queryParameters: queryParams);
    print('Fetching filtered recipes from: $uri');

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    print('Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load filtered recipes: ${response.statusCode}');
    }

    final List<dynamic> data = json.decode(response.body);
    print('Fetched ${data.length} filtered recipes');

    return data.map<CardRecipe>((item) => CardRecipe.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching filtered recipes: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Fetch recipes untuk user tertentu
Future<List<CardRecipe>> fetchUserCardRecipes(int userId) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse('$baseUrl/card_recipe_saya/$userId'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load user recipes: ${response.statusCode}');
    }

    final List<dynamic> data = json.decode(response.body);
    return data.map<CardRecipe>((item) => CardRecipe.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching user recipes: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Fetch recommendations based on highest rating (max 6 items)
Future<List<CardRecipe>> fetchRecommendations({int? userId}) async {
  final client = http.Client();
  try {
    // For now, use /all endpoint and filter in frontend until backend is updated
    final uri = Uri.parse('$baseUrl/card_recipe/all${userId != null ? '?user_id=$userId' : ''}');
    
    final response = await client.get(uri).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final allRecipes = data.map((item) => CardRecipe.fromJson(item)).toList();
      
      // Filter and sort by rating (highest first), then limit to 6
      final recommendations = allRecipes
          .where((recipe) => recipe.rating > 0) // Only recipes with ratings
          .toList()
        ..sort((a, b) {
          // Sort by rating DESC, then by review count DESC, then by views DESC
          if (b.rating != a.rating) {
            return b.rating.compareTo(a.rating);
          }
          if (b.jumlahReview != a.jumlahReview) {
            return b.jumlahReview.compareTo(a.jumlahReview);
          }
          return b.jumlahView.compareTo(a.jumlahView);
        });
      
      // Return max 6 recommendations
      return recommendations.take(6).toList();
    } else {
      throw Exception('Failed to load recommendations: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching recommendations: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Helper function untuk mapping kategori nama ke ID
int? getCategoryId(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'makanan berat':
      return 1;  // Makanan Berat
    case 'minuman':
      return 2;  // Minuman
    case 'hidangan pembuka':
      return 3;  // Hidangan Pembuka
    case 'hidangan penutup':
      return 4;  // Hidangan Penutup
    default:
      return null; // Semua kategori
  }
}
