import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeFormProvider extends ChangeNotifier {
  // User information
  int? _userId;

  // Basic recipe information (Step 1)
  String _recipeName = '';
  String _description = '';
  int _portions = 1;
  File? _thumbnailImage;
  File? _videoFile;

  // Ingredients and tools (Step 2)
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _tools = [];

  // Procedures (Step 3)
  List<Map<String, dynamic>> _procedures = [];

  // Categories, nutrition, tags (Step 4)
  int? _categoryId;
  Map<String, dynamic> _nutrition = {
    'karbohidrat': 0,
    'protein': 0,
    'lemak': 0,
    'serat': 0
  };
  List<String> _tags = [];

  // Getters
  int? get userId => _userId;
  String get recipeName => _recipeName;
  String get description => _description;
  int get portions => _portions;
  File? get thumbnailImage => _thumbnailImage;
  File? get videoFile => _videoFile;
  List<Map<String, dynamic>> get ingredients => _ingredients;
  List<Map<String, dynamic>> get tools => _tools;
  List<Map<String, dynamic>> get procedures => _procedures;
  int? get categoryId => _categoryId;
  Map<String, dynamic> get nutrition => _nutrition;
  List<String> get tags => _tags;

  // Setters for user info
  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  // Setters for basic info (Step 1)
  void setBasicInfo({
    required String recipeName,
    required String description,
    required int portions,
    File? thumbnailImage,
    File? videoFile,
  }) {
    _recipeName = recipeName;
    _description = description;
    _portions = portions;
    _thumbnailImage = thumbnailImage;
    _videoFile = videoFile;
    notifyListeners();
  }

  // Setters for ingredients and tools (Step 2)
  void setIngredients(List<Map<String, dynamic>> ingredients) {
    _ingredients = ingredients;
    notifyListeners();
  }

  void addIngredient(String name, int amount, int unitId) {
    _ingredients
        .add({'nama_bahan': name, 'jumlah': amount, 'id_satuan': unitId});
    notifyListeners();
  }

  void removeIngredient(int index) {
    if (index >= 0 && index < _ingredients.length) {
      _ingredients.removeAt(index);
      notifyListeners();
    }
  }

  void setTools(List<Map<String, dynamic>> tools) {
    _tools = tools;
    notifyListeners();
  }

  void addTool(String name, int amount) {
    _tools.add({'nama_alat': name, 'jumlah': amount});
    notifyListeners();
  }

  void removeTool(int index) {
    if (index >= 0 && index < _tools.length) {
      _tools.removeAt(index);
      notifyListeners();
    }
  }

  // Setters for procedures (Step 3)
  void setProcedures(List<Map<String, dynamic>> procedures) {
    _procedures = procedures;
    notifyListeners();
  }

  void addProcedure(
      String name, int durationMinutes, List<Map<String, dynamic>> steps) {
    _procedures.add({
      'nama_prosedur': name,
      'durasi_menit': durationMinutes,
      'langkah': steps
    });
    notifyListeners();
  }

  void removeProcedure(int index) {
    if (index >= 0 && index < _procedures.length) {
      _procedures.removeAt(index);
      notifyListeners();
    }
  }

  void updateProcedure(int index, String name, int durationMinutes,
      List<Map<String, dynamic>> steps) {
    if (index >= 0 && index < _procedures.length) {
      _procedures[index] = {
        'nama_prosedur': name,
        'durasi_menit': durationMinutes,
        'langkah': steps
      };
      notifyListeners();
    }
  }

  // Setters for category, nutrition, tags (Step 4)
  void setCategoryId(int id) {
    _categoryId = id;
    notifyListeners();
  }

  void setNutrition(
      {required double carbs,
      required double protein,
      required double fat,
      required double fiber}) {
    _nutrition = {
      'karbohidrat': carbs,
      'protein': protein,
      'lemak': fat,
      'serat': fiber
    };
    notifyListeners();
  }

  void setTags(List<String> tags) {
    _tags = tags;
    notifyListeners();
  }

  void addTag(String tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  // Reset the form
  void resetForm() {
    _recipeName = '';
    _description = '';
    _portions = 1;
    _thumbnailImage = null;
    _videoFile = null;
    _ingredients = [];
    _tools = [];
    _procedures = [];
    _categoryId = null;
    _nutrition = {'karbohidrat': 0, 'protein': 0, 'lemak': 0, 'serat': 0};
    _tags = [];
    notifyListeners();
  } // Submit recipe to the API

  Future<Map<String, dynamic>> submitRecipe() async {
    try {
      if (_userId == null) {
        return {'success': false, 'message': 'User ID is required'};
      }

      if (_recipeName.isEmpty) {
        return {'success': false, 'message': 'Recipe name is required'};
      }

      if (_description.isEmpty) {
        return {'success': false, 'message': 'Description is required'};
      }

      if (_categoryId == null) {
        return {'success': false, 'message': 'Category is required'};
      }

      // Prepare tag data in format expected by API
      final tagData = _tags.map((tag) => {'nama_tag': tag}).toList();

      // Set default thumbnail name (should match a default image on the backend)
      const defaultThumbnailName = 'nasi_goreng.jpeg';

      // Create the request data
      final requestData = {
        'id_user': _userId,
        'nama_resep': _recipeName,
        'id_kategori': _categoryId,
        'deskripsi': _description,
        'porsi': _portions,
        'thumbnail':
            defaultThumbnailName, // Default thumbnail to avoid null error
        'nutrisi': _nutrition,
        'alat': _tools,
        'bahan': _ingredients,
        'prosedur': _procedures,
        'tag': tagData,
      };

      // Try direct form submission, which seems to work better with the backend
      try {
        var request = await http.post(Uri.parse('https://masakio.up.railway.app/recipe/create'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_user': _userId.toString(),
            'nama_resep': _recipeName,
            'id_kategori': _categoryId.toString(),
            'deskripsi': _description,
            'porsi': _portions.toString(),
            'nutrisi': _nutrition,
            'alat': _tools,
            'bahan': _ingredients,
            'prosedur': _procedures,
            'tag': tagData,
            'video': _videoFile?.path,
            'thumbnail': _thumbnailImage?.path ?? defaultThumbnailName,
          })
        );// Send the request
        print('Response received: ${request.statusCode}, ${request.body}');

        if (request.statusCode == 201) {
          final data = json.decode(request.body);
          return {
            'success': true,
            'message': 'Recipe created successfully',
            'id_resep': data['id_resep']
          };
        } else {
          return {
            'success': false,
            'message':
                'Failed to create recipe: ${request.statusCode} - ${request.body}'
          };
        }
      } catch (e) {
        print('Error during recipe creation API call: $e');
        return {'success': false, 'message': 'Network error: $e'};
      }
    } catch (e) {
      print('General error in recipe submission: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
