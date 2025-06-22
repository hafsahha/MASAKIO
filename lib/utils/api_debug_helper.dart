// Test file untuk memvalidasi koneksi ke API
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:masakio/data/func_recipe.dart' as recipe_api;

class APIDebugHelper {
  // Fungsi untuk memvalidasi koneksi API
  static Future<void> testAPIConnection() async {
    try {
      print("[API TEST] =========== TESTING API CONNECTION ===========");
      print("[API TEST] Attempting to fetch recipes from API...");

      final recipes = await recipe_api.fetchAllRecipes();

      print("[API TEST] Success! Fetched ${recipes.length} recipes");
      print(
          "[API TEST] First recipe: ${recipes.isNotEmpty ? recipes[0] : 'No data'}");

      if (recipes.isNotEmpty) {
        final firstRecipe = recipes[0];
        print("[API TEST] Recipe ID: ${firstRecipe['id']}");
        print("[API TEST] Recipe Title: ${firstRecipe['title']}");
        print("[API TEST] Recipe Image: ${firstRecipe['imageAsset']}");
        print("[API TEST] Recipe Reviews: ${firstRecipe['reviewCount']}");
        print("[API TEST] Recipe Bookmarked: ${firstRecipe['isBookmarked']}");
        print("[API TEST] Recipe Keys: ${firstRecipe.keys.toList()}");
      }

      print("[API TEST] =============== TEST COMPLETE ===============");
    } catch (e) {
      print("[API TEST] ERROR: $e");
      print("[API TEST] ================ TEST FAILED ================");
    }
  }
}
