import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const reviewsEndpoint = '${url}reviews/'; // Endpoint untuk review

// Review model
class Review {
  final int id;
  final int userId;
  final int recipeId;
  final double rating;
  final String comment;
  final String createdAt;
  final String? updatedAt;
  final String? userName;
  final String? recipeName;
  final String? thumbnail;
  
  Review({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
    this.userName,
    this.recipeName,
    this.thumbnail,
  });
  
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id_review'],
      userId: json['id_user'],
      recipeId: json['id_resep'],
      rating: json['rating'].toDouble(),
      comment: json['komentar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userName: json['nama_user'],
      recipeName: json['nama_resep'],
      thumbnail: json['thumbnail'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_review': id,
      'id_user': userId,
      'id_resep': recipeId,
      'rating': rating,
      'komentar': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'nama_user': userName,
      'nama_resep': recipeName,
      'thumbnail': thumbnail,
    };
  }
}

// Get all reviews for a recipe
Future<List<Review>> getRecipeReviews(int recipeId) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse('${reviewsEndpoint}recipe/$recipeId')
    ).timeout(const Duration(seconds: 10));
    
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
    final response = await client.get(
      Uri.parse('${reviewsEndpoint}user/$userId')
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) throw Exception('Failed to load user reviews');
    
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
  required String comment
}) async {
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse(reviewsEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': userId,
        'id_resep': recipeId,
        'rating': rating,
        'komentar': comment,
      }),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200 && response.statusCode != 201) {
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
    final response = await client.delete(
      Uri.parse('${reviewsEndpoint}$reviewId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': userId,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200;
  } catch (e) {
    print('Error deleting review: $e');
    return false;
  } finally {
    client.close();
  }
}
