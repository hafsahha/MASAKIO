import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app';

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
    return CardRecipe(
      idResep: json['id_resep'],
      namaResep: json['nama_resep'] ?? '',
      jumlahView: json['jumlah_view'] ?? 0,
      thumbnail: json['thumbnail'],
      namaPenulis: json['nama_penulis'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      jumlahReview: json['jumlah_review'] ?? 0,
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
    print('Fetching all card recipes from: $url/card_recipe/all');
    
    final response = await client.get(
      Uri.parse('$url/card_recipe/all'),
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

    final uri = Uri.parse('$url/card_recipe/filter').replace(queryParameters: queryParams);
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
      Uri.parse('$url/card_recipe_saya/$userId'),
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
