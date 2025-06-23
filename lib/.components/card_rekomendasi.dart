import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart';
import 'package:masakio/resep_detail.dart';
import 'package:masakio/discovery.dart';
import 'package:masakio/data/func_recommendation.dart';
import 'package:masakio/data/func_card_recipe.dart';
import 'package:masakio/data/func_detail_resep.dart';
import 'package:masakio/data/func_profile.dart';

class CardRekomendasi extends StatelessWidget {
  final CardRecipe cardRecipe;

  const CardRekomendasi({Key? key, required this.cardRecipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

          // Fetch detail resep dari database
          final detailResep = await fetchDetailResepById(cardRecipe.idResep);

          // Hide loading indicator
          if (context.mounted) {
            Navigator.pop(context);

            // Navigate to detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResepDetailPage(resep: detailResep),
              ),
            );
          }
        } catch (e) {
          // Hide loading indicator
          if (context.mounted) {
            Navigator.pop(context);
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal memuat detail resep: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan radius
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,                child: cardRecipe.thumbnail != null
                    ? Image.network(
                        cardRecipe.thumbnail!,
                        height: 95,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback ke local asset jika Cloudinary gagal
                          final fileName = cardRecipe.thumbnail!.split('/').last;
                          return Image.asset(
                            'assets/images/$fileName',
                            height: 95,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, assetError, assetStackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image, color: Colors.grey),
                              );
                            },
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            // Judul
            Text(
              cardRecipe.namaResep,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Rating dan jumlah review
            Row(
              children: [
                const Icon(Icons.star, size: 10, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  cardRecipe.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  "| ${cardRecipe.jumlahReview} Reviews",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Views Count
            Row(
              children: [
                const Icon(Icons.visibility, size: 10, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "${cardRecipe.jumlahView} Views",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RekomendasiSection extends StatefulWidget {
  const RekomendasiSection({Key? key}) : super(key: key);

  @override
  State<RekomendasiSection> createState() => _RekomendasiSectionState();
}

class _RekomendasiSectionState extends State<RekomendasiSection> {
  List<CardRecipe> _recommendations = [];
  bool _isLoading = false;
  bool _hasError = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndRecommendations();
  }

  Future<void> _loadCurrentUserAndRecommendations() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Get current user if logged in
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await AuthService.getCurrentUser();
      }
      
      // Load recommendations based on user
      await _loadRecommendations();
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error loading user and recommendations: $e');
    }
  }
  Future<void> _loadRecommendations() async {
    try {
      final recommendations = await fetchRecommendations(
        userId: _currentUser?.id,
      );
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error loading recommendations: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: const Text(
            "Rekomendasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 8),
            const Text('Gagal memuat rekomendasi'),
            const SizedBox(height: 8),            ElevatedButton(
              onPressed: _loadCurrentUserAndRecommendations,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return const Center(
        child: Text('Belum ada rekomendasi tersedia'),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        return CardRekomendasi(cardRecipe: _recommendations[index]);
      },
    );
  }
}
