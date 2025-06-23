import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart';
import 'package:masakio/.components/card_temukan_resep.dart';
import 'package:masakio/discovery.dart';
import 'package:masakio/data/func_card_recipe.dart'; // Import service baru
import 'package:masakio/data/func_profile.dart';

class TemukanResepSectionComponent extends StatefulWidget {
  final String? categoryFilter; // optional category filter

  const TemukanResepSectionComponent({super.key, this.categoryFilter});

  @override
  State<TemukanResepSectionComponent> createState() =>
      _TemukanResepSectionComponentState();
}

class _TemukanResepSectionComponentState
    extends State<TemukanResepSectionComponent> {
  List<CardRecipe> _cardRecipeList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  User? _currentUser;  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndCardRecipes();
  }

  @override
  void didUpdateWidget(TemukanResepSectionComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data when category filter changes
    if (widget.categoryFilter != oldWidget.categoryFilter) {
      _loadCurrentUserAndCardRecipes();
    }
  }

  Future<void> _loadCurrentUserAndCardRecipes() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Get current user if logged in
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await AuthService.getCurrentUser();
      }
      
      // Load recipes
      await _loadCardRecipes();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error loading user and card recipes: $e');
    }
  }

  Future<void> _loadCardRecipes() async {
    try {
      List<CardRecipe> recipes;
      
      if (widget.categoryFilter != null && widget.categoryFilter != "Semua") {
        // Filter berdasarkan kategori dengan limit 10
        final categoryId = getCategoryId(widget.categoryFilter!);
        recipes = await fetchFilteredCardRecipes(
          categoryId: categoryId, 
          limit: 10,
          userId: _currentUser?.id.toString(),
        );
      } else {
        // Ambil semua resep dengan limit 10
        recipes = await fetchFilteredCardRecipes(
          limit: 10,
          userId: _currentUser?.id.toString(),
        );
      }

      setState(() {
        _cardRecipeList = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error loading card recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Temukan Resep",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiscoveryResep(),
                    ),
                  );
                },
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),        // Content Area
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildContent(),
        ),

        // Tombol "Lihat Semua" (hanya tampil jika ada data)
        if (!_isLoading && !_hasError && _cardRecipeList.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiscoveryResep(),
                  ),
                );
              },
              child: const Text(
                "Lihat Semua",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              const Text(
                'Gagal memuat data resep',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _errorMessage,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),              const SizedBox(height: 12),              ElevatedButton(
                onPressed: _loadCurrentUserAndCardRecipes,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }    if (_cardRecipeList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Belum ada resep tersedia',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }    // Tampilkan resep yang sudah di-limit di backend (maksimal 10)
    return Column(
      children: _cardRecipeList.map<Widget>((cardRecipe) {
        return CardTemukanResep(
          imagePath: cardRecipe.thumbnail ?? 'assets/images/placeholder.jpg',
          title: cardRecipe.namaResep,
          subtitle: cardRecipe.namaPenulis,
          views: cardRecipe.jumlahView.toString(),
          rating: cardRecipe.rating.toStringAsFixed(1),
          recipeId: cardRecipe.idResep, // Pass ID untuk navigation
          cardRecipe: cardRecipe, // Pass full CardRecipe data untuk bookmark
        );
      }).toList(),
    );
  }

  // Helper function untuk mapping nama kategori ke ID
  int getCategoryId(String categoryName) {
    switch (categoryName) {
      case 'Makanan Berat':
        return 1;
      case 'Minuman':
        return 2;
      case 'Hidangan Pembuka':
        return 3;
      case 'Hidangan Penutup':
        return 4;
      default:
        return 1; // Default ke Makanan Berat
    }
  }
}
