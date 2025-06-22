import 'package:flutter/material.dart';
import 'package:masakio/.components/future_resep_grid.dart';
import 'package:masakio/data/func_profile.dart';
import 'package:masakio/data/func_recipe.dart' as recipe_api;

class ResepSayaPage extends StatefulWidget {
  const ResepSayaPage({super.key});

  @override
  State<ResepSayaPage> createState() => _ResepSayaPageState();
}

class _ResepSayaPageState extends State<ResepSayaPage> {
  Future<List>? _myRecipesFuture;
  User? user;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
  }
  Future<void> _loadUserRecipes() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      print('[DEBUG] Loading user recipes...');
      final currentUser = await AuthService.getCurrentUser();
      
      if (currentUser != null) {
        print('[DEBUG] User authenticated: ID=${currentUser.id}, Name=${currentUser.name}');
        
        setState(() {
          user = currentUser;
          _myRecipesFuture = recipe_api.fetchUserRecipes(user!.id);
        });
        
        // Test with a fixed user ID to check if it works
        final testRecipes = await recipe_api.fetchUserRecipes(1);
        print('[DEBUG] Test fetch for user ID=1: ${testRecipes.length} recipes found');
        
      } else {
        print('[DEBUG] No user authenticated');
        setState(() {
          _hasError = true;
          _errorMessage = 'Silakan login untuk melihat resep Anda';
        });
      }
    } catch (e) {
      print('[DEBUG] Error loading user recipes: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Gagal memuat data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _refreshMyRecipes() {
    if (user != null) {
      setState(() => _myRecipesFuture = recipe_api.fetchUserRecipes(user!.id));
    } else {
      _loadUserRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserRecipes,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resep Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMyRecipes,
            tooltip: 'Refresh',
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: _myRecipesFuture != null
          ? ResepGridF(
              recipes: _myRecipesFuture!,
              onRefresh: _refreshMyRecipes,
            )
          : const Center(
              child: Text('Anda belum membuat resep apapun'),
            ),
      ),
    );
  }
}
