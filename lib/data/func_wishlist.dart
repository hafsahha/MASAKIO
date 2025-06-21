import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const wishlistEndpoint = '${url}wishlist/'; // Endpoint untuk wishlist

// Fetch user wishlist
Future<List<Map<String, dynamic>>> fetchWishlist(int userId) async {
  final client = http.Client();
  try {
    final response = await http.get(Uri.parse('${wishlistEndpoint}${userId}'))
      .timeout(const Duration(seconds: 10));
      
    if (response.statusCode != 200) throw Exception('Failed to load wishlist');
    
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'id': item['id_resep'].toString(),
      'title': item['nama_resep'],
      'rating': item['rating'] ?? 0.0,
      'reviewCount': item['review_count'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isBookmarked': true,
    }).toList();
  } catch (e) {
    print('Error fetching wishlist: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Add to wishlist
Future<bool> addToWishlist(int userId, int recipeId) async {
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse('${wishlistEndpoint}add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': userId,
        'id_resep': recipeId,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print('Error adding to wishlist: $e');
    return false;
  } finally {
    client.close();
  }
}

// Remove from wishlist
Future<bool> removeFromWishlist(int userId, int recipeId) async {
  final client = http.Client();
  try {
    final response = await client.delete(
      Uri.parse('${wishlistEndpoint}remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': userId,
        'id_resep': recipeId,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200;
  } catch (e) {
    print('Error removing from wishlist: $e');
    return false;
  } finally {
    client.close();
  }
}
