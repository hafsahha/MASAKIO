import 'func_card_recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app';

// Service untuk rekomendasi resep
class RecommendationService {
  static const int _maxRecommendations = 5;
  
  // Cache untuk rekomendasi
  static List<CardRecipe>? _cachedRecommendations;
  static DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 30);

  // Fetch rekomendasi resep berdasarkan user (dengan disease-based logic di backend)
  static Future<List<CardRecipe>> fetchRecommendations({String? userId}) async {
    try {
      // Check cache first (hanya untuk guest user)
      if (userId == null && 
          _cachedRecommendations != null && 
          _lastFetchTime != null && 
          DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
        print('Using cached recommendations');
        return _cachedRecommendations!;
      }

      print('Fetching fresh recommendations...');
      
      // Build URL dengan parameter
      String requestUrl = '$url/card_recipe/recommendations?limit=$_maxRecommendations';
      if (userId != null) {
        requestUrl += '&user_id=$userId';
      }
      
      final response = await http.get(Uri.parse(requestUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final recommendations = jsonData.map((json) => CardRecipe.fromJson(json)).toList();
        
        // Update cache hanya untuk guest user
        if (userId == null) {
          _cachedRecommendations = recommendations;
          _lastFetchTime = DateTime.now();
        }
        
        print('Found ${recommendations.length} recommendations');
        for (final recipe in recommendations) {
          print('- ${recipe.namaResep}: ${recipe.rating} ⭐ (${recipe.jumlahReview} reviews)');
        }
        
        return recommendations;
      } else {
        throw Exception('Failed to load recommendations: ${response.statusCode}');
      }
      
    } catch (e) {
      print('Error fetching recommendations: $e');
      
      // Return cached data if available for guest users, otherwise empty list
      if (userId == null && _cachedRecommendations != null) {
        print('Returning cached recommendations due to error');
        return _cachedRecommendations!;
      }
      
      return [];
    }
  }

  // Fetch rekomendasi berdasarkan kategori tertentu
  static Future<List<CardRecipe>> fetchRecommendationsByCategory(String category) async {
    try {
      final categoryId = getCategoryId(category);
      
      // Fetch filtered recipes by category
      final categoryRecipes = await fetchFilteredCardRecipes(categoryId: categoryId);
      
      if (categoryRecipes.isEmpty) {
        print('No recipes found for category: $category');
        return [];
      }

      // Sort berdasarkan rating
      categoryRecipes.sort((a, b) {
        final ratingComparison = b.rating.compareTo(a.rating);
        if (ratingComparison != 0) return ratingComparison;
        return b.jumlahReview.compareTo(a.jumlahReview);
      });

      return categoryRecipes.take(_maxRecommendations).toList();
      
    } catch (e) {
      print('Error fetching category recommendations: $e');
      return [];
    }
  }

  // Fetch rekomendasi berdasarkan bahan yang tersedia
  static Future<List<CardRecipe>> fetchRecommendationsByIngredients(List<String> ingredients) async {
    try {
      if (ingredients.isEmpty) {
        return await fetchRecommendations();
      }

      // Fetch recipes yang menggunakan bahan-bahan tersebut
      final ingredientRecipes = await fetchFilteredCardRecipes(includeBahan: ingredients);
      
      if (ingredientRecipes.isEmpty) {
        print('No recipes found with ingredients: ${ingredients.join(', ')}');
        // Fallback ke rekomendasi umum
        return await fetchRecommendations();
      }

      // Sort berdasarkan rating
      ingredientRecipes.sort((a, b) {
        final ratingComparison = b.rating.compareTo(a.rating);
        if (ratingComparison != 0) return ratingComparison;
        return b.jumlahReview.compareTo(a.jumlahReview);
      });

      return ingredientRecipes.take(_maxRecommendations).toList();
      
    } catch (e) {
      print('Error fetching ingredient-based recommendations: $e');
      // Fallback ke rekomendasi umum
      return await fetchRecommendations();
    }
  }

  // Clear cache (berguna untuk refresh)
  static void clearCache() {
    _cachedRecommendations = null;
    _lastFetchTime = null;
    print('Recommendation cache cleared');
  }

  // Get cached recommendations count
  static int getCachedCount() {
    return _cachedRecommendations?.length ?? 0;
  }

  // Check if cache is valid
  static bool isCacheValid() {
    return _cachedRecommendations != null && 
           _lastFetchTime != null && 
           DateTime.now().difference(_lastFetchTime!) < _cacheExpiry;
  }
}
