import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/recipes';

// Recipe model
class Recipe {
  final int id;
  final String name;
  final String? description;
  final int? duration;
  final String? difficulty;
  final int? servings;
  final int userId;
  final int categoryId;
  final String? thumbnail;
  final double? rating;
  final int? reviewCount;
  final List<Ingredient>? ingredients;
  final List<Step>? steps;
  
  Recipe({
    required this.id,
    required this.name,
    this.description,
    this.duration,
    this.difficulty,
    this.servings,
    required this.userId,
    required this.categoryId,
    this.thumbnail,
    this.rating,
    this.reviewCount,
    this.ingredients,
    this.steps,
  });
  
  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Ingredient>? ingredients;
    if (json['ingredients'] != null) {
      ingredients = List<Ingredient>.from(
        json['ingredients'].map((x) => Ingredient.fromJson(x))
      );
    }
    
    List<Step>? steps;
    if (json['steps'] != null) {
      steps = List<Step>.from(
        json['steps'].map((x) => Step.fromJson(x))
      );
    }
    
    return Recipe(
      id: json['id_resep'],
      name: json['nama_resep'],
      description: json['deskripsi'],
      duration: json['durasi'],
      difficulty: json['tingkat_kesulitan'],
      servings: json['porsi'],
      userId: json['id_user'],
      categoryId: json['id_kategori'],
      thumbnail: json['thumbnail'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      ingredients: ingredients,
      steps: steps,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_resep': id,
      'nama_resep': name,
      'deskripsi': description,
      'durasi': duration,
      'tingkat_kesulitan': difficulty,
      'porsi': servings,
      'id_user': userId,
      'id_kategori': categoryId,
      'thumbnail': thumbnail,
      'rating': rating,
      'review_count': reviewCount,
      'ingredients': ingredients?.map((x) => x.toJson()).toList(),
      'steps': steps?.map((x) => x.toJson()).toList(),
    };
  }
  
  // Convert to UI display format
  Map<String, dynamic> toUIFormat() {
    return {
      'id': id.toString(),
      'title': name,
      'rating': rating ?? 0.0,
      'reviewCount': reviewCount ?? 0,
      'imageAsset': 'assets/images/$thumbnail',
      'isBookmarked': false,
    };
  }
}

class Ingredient {
  final int recipeId;
  final int ingredientId;
  final String amount;
  final String unit;
  final String name;
  
  Ingredient({
    required this.recipeId,
    required this.ingredientId,
    required this.amount,
    required this.unit,
    required this.name,
  });
  
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      recipeId: json['id_resep'],
      ingredientId: json['id_bahan'],
      amount: json['jumlah'],
      unit: json['satuan'],
      name: json['nama_bahan'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_resep': recipeId,
      'id_bahan': ingredientId,
      'jumlah': amount,
      'satuan': unit,
      'nama_bahan': name,
    };
  }
}

class Step {
  final int recipeId;
  final int order;
  final String description;
  
  Step({
    required this.recipeId,
    required this.order,
    required this.description,
  });
  
  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      recipeId: json['id_resep'],
      order: json['urutan'],
      description: json['deskripsi'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_resep': recipeId,
      'urutan': order,
      'deskripsi': description,
    };
  }
}

// Fetch all recipes
Future<List<Map<String, dynamic>>> fetchAllRecipes() async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) throw Exception('Failed to load recipes');
    
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'id': item['id_resep'],
      'title': item['nama_resep'],
      'rating': item['rating'] ?? 0.0,
      'reviewCount': item['review_count'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isOwned': false,
      'isBookmarked': false,
    }).toList();
  } catch (e) { throw Exception('Failed to load recipes: $e'); }
}

// Fetch recipe details by ID
Future<Recipe> fetchRecipeById(int id) async {
  try {
    final response = await http.get(Uri.parse('$url/$id')).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Failed to load recipe details');
    
    final data = json.decode(response.body);
    return Recipe.fromJson(data);
  } catch (e) { rethrow; }
}

// Add a new recipe
Future<int> addRecipe(Recipe recipe) async {
  try {
    final response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    ).timeout(const Duration(seconds: 15));
    
    if (response.statusCode != 201) throw Exception('Failed to add recipe');
    
    final data = json.decode(response.body);
    return data['recipeId'];
  } catch (e) { rethrow; }
}
