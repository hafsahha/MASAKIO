import 'func_card_recipe.dart';
import '../config/api_config.dart';

// Service untuk rekomendasi resep
class RecommendationService {
  static const int _maxRecommendations = 6;
  
  // Cache untuk rekomendasi
  static List<CardRecipe>? _cachedRecommendations;
  static DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 30);

  // Fetch rekomendasi resep berdasarkan rating tertinggi
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
      
      // Fetch semua resep dari endpoint utama
      final allRecipes = await fetchAllCardRecipes();
      
      if (allRecipes.isEmpty) {
        print('No recipes found for recommendations');
        return [];
      }
      
      // Filter resep yang memiliki rating > 0 (ada review)
      final ratedRecipes = allRecipes.where((recipe) => 
        recipe.rating > 0 && recipe.jumlahReview > 0
      ).toList();
      
      // Jika tidak ada resep dengan rating, ambil semua resep
      final recipesToSort = ratedRecipes.isNotEmpty ? ratedRecipes : allRecipes;
      
      // Sort berdasarkan rating tertinggi, jumlah review, lalu views
      recipesToSort.sort((a, b) {
        // Priority 1: Rating tertinggi
        final ratingComparison = b.rating.compareTo(a.rating);
        if (ratingComparison != 0) return ratingComparison;
        
        // Priority 2: Jumlah review terbanyak
        final reviewComparison = b.jumlahReview.compareTo(a.jumlahReview);
        if (reviewComparison != 0) return reviewComparison;
        
        // Priority 3: Views terbanyak
        return b.jumlahView.compareTo(a.jumlahView);
      });
      
      // Ambil 6 teratas
      final recommendations = recipesToSort.take(_maxRecommendations).toList();
      
      // Update cache hanya untuk guest user
      if (userId == null) {
        _cachedRecommendations = recommendations;
        _lastFetchTime = DateTime.now();
      }
      
      print('Found ${recommendations.length} recommendations:');
      for (final recipe in recommendations) {
        print('- ${recipe.namaResep}: ${recipe.rating} ⭐ (${recipe.jumlahReview} reviews, ${recipe.jumlahView} views)');
      }
      
      return recommendations;
      
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
