import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masakio/data/func_profile.dart';
import '../config/api_config.dart';

// Fetch recipes created by current user
Future<List<Map<String, dynamic>>> fetchMyRecipes() async {
  try {
    final user = await AuthService.getCurrentUser();
    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await http
        .get(Uri.parse('$baseUrl/card_recipe_saya/${user.id}'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load my recipes');
    }

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'id': item['id_resep'],
      'title': item['nama_resep'],
      'rating': double.tryParse(item['rating'].toString()) ?? 0.0,
      'reviewCount': item['jumlah_review'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isOwned': true, // Since these are user's own recipes
      'isBookmarked': false,
      'viewsCount': item['jumlah_view'] ?? 0,
      'author': item['nama_penulis'] ?? '',
      'createdAt': item['tanggal_dibuat'] ?? '',
    }).toList();
  } catch (e) {
    print('Error fetching my recipes: $e');
    rethrow;
  }
}

// Get recipe statistics for current user
Future<Map<String, dynamic>> getMyRecipeStats() async {
  try {
    final user = await AuthService.getCurrentUser();
    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await http
        .get(Uri.parse('$baseUrl/card_recipe_saya/stats/${user.id}'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipe stats');
    }

    final data = json.decode(response.body);
    return {
      'totalRecipes': data['total_resep'] ?? 0,
      'totalViews': data['total_view'] ?? 0,
      'totalLikes': data['total_like'] ?? 0,
      'totalReviews': data['total_review'] ?? 0,
      'averageRating': double.tryParse(data['rating_rata_rata'].toString()) ?? 0.0,
    };
  } catch (e) {
    print('Error fetching recipe stats: $e');
    rethrow;
  }
}
