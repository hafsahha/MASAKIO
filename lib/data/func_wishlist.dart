import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masakio/data/func_profile.dart';

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/wishlist'; // Endpoint untuk wishlist

// Fetch user wishlist
Future<List<Map<String, dynamic>>> fetchWishlist(int id) async {
  try {
    final response = await http.get(Uri.parse('$url/$id')).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Failed to load wishlist');
      final List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'id': item['id_resep'].toString(),  // Convert to string
      'title': item['nama_resep'],
      'rating': item['rating'] ?? 0.0,
      'reviewCount': item['review_count'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isBookmarked': true,
    }).toList();
  } catch (e) { rethrow; }
}

// Add to wishlist
Future<bool> wish(int recipeId) async {
  final user = await AuthService.getCurrentUser();
  final userId = user!.id;

  try {
    final response = await http.post(Uri.parse('$url/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'recipe_id': recipeId,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) { return false; }
}

// Remove from wishlist
Future<bool> unwish(int recipeId) async {
  final user = await AuthService.getCurrentUser();
  final userId = user!.id;

  try {
    final response = await http.delete(Uri.parse('$url/remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'recipe_id': recipeId,
      }),
    ).timeout(const Duration(seconds: 10));

    return response.statusCode == 200;
  } catch (e) { return false; }
}
