import 'package:flutter/material.dart';
import 'package:masakio/data/func_my_recipes.dart';
import 'package:masakio/.components/future_resep_grid.dart';

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  Future<List<Map<String, dynamic>>>? _myRecipesFuture;
  Future<Map<String, dynamic>>? _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadMyRecipes();
  }

  void _loadMyRecipes() {
    setState(() {
      _myRecipesFuture = fetchMyRecipes();
      _statsFuture = getMyRecipeStats();
    });
  }

  void _refreshMyRecipes() {
    _loadMyRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Saya'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Statistics Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF83AEB1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                
                if (snapshot.hasError) {
                  return const Text(
                    'Gagal memuat statistik',
                    style: TextStyle(color: Colors.white),
                  );
                }
                
                final stats = snapshot.data ?? {};
                return Column(
                  children: [
                    const Text(
                      'Statistik Resep Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Resep',
                          stats['totalRecipes'].toString(),
                          Icons.restaurant_menu,
                        ),
                        _buildStatItem(
                          'Views',
                          stats['totalViews'].toString(),
                          Icons.visibility,
                        ),
                        _buildStatItem(
                          'Rating',
                          stats['averageRating'].toStringAsFixed(1),
                          Icons.star,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Recipes Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshMyRecipes();
              },
              child: _myRecipesFuture != null
                  ? ResepGridF(
                      recipes: _myRecipesFuture!,
                      onRefresh: _refreshMyRecipes,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
