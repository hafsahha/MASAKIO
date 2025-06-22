import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const reviewsEndpoint = '${url}reviews/'; // Endpoint untuk review

// Review model
class Review {
  final double rating;
  final String comment;
  final String userName;
  final String recipeName;
  final String email;

  Review({
    required this.rating,
    required this.comment,
    required this.userName,
    required this.recipeName,
    required this.email,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] is int) 
        ? (json['rating'] as int).toDouble() 
        : (json['rating'] as double? ?? 0.0),
      comment: json['komentar'] ?? '',
      userName: json['nama_user'] ?? 'Unknown User',
      recipeName: json['nama_resep'] ?? '',
      email: json['email'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'komentar': comment,
      'nama_user': userName,
      'nama_resep': recipeName,
      'email': email,
    };
  }
}

// Get all reviews for a recipe
Future<List<Review>> getRecipeReviews(int recipeId) async {
  final client = http.Client();
  try {
    final response = await client
        .get(Uri.parse('${reviewsEndpoint}$recipeId'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) throw Exception('Failed to load reviews');

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Review.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching reviews: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Get all reviews by a user
Future<List<Review>> getUserReviews(int userId) async {
  final client = http.Client();
  try {
    final response = await client
        .get(Uri.parse('${reviewsEndpoint}user/$userId'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200)
      throw Exception('Failed to load user reviews');

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Review.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching user reviews: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Add a review
Future<int> addReview({
  required int userId,
  required int recipeId,
  required double rating,
  required String comment,
}) async {
  final client = http.Client();
  try {
    final response = await client
        .post(
          Uri.parse('${reviewsEndpoint}add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_user': userId,
            'id_resep': recipeId,
            'rating': rating,
            'komentar': comment,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Gagal tambah review: ${response.body}');
      throw Exception('Failed to add review');
    }

    final data = json.decode(response.body);
    return data['reviewId'];
  } catch (e) {
    print('Error adding review: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Delete a review
Future<bool> deleteReview(int reviewId, int userId) async {
  final client = http.Client();
  try {
    final response = await client
        .delete(
          Uri.parse('${reviewsEndpoint}$reviewId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id_user': userId}),
        )
        .timeout(const Duration(seconds: 10));

    return response.statusCode == 200;
  } catch (e) {
    print('Error deleting review: $e');
    return false;
  } finally {
    client.close();
  }
}
