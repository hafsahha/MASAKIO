import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart';
import 'package:masakio/.components/card_temukan_resep.dart'; // Path sesuai struktur folder Anda
import 'package:masakio/discovery.dart';
import 'package:masakio/data/func_temukan_resep.dart'; // Import service baru

class TemukanResepSectionComponent extends StatefulWidget {
  final String? categoryFilter; // optional category filter

  const TemukanResepSectionComponent({super.key, this.categoryFilter});

  @override
  State<TemukanResepSectionComponent> createState() =>
      _TemukanResepSectionComponentState();
}

class _TemukanResepSectionComponentState
    extends State<TemukanResepSectionComponent> {
  List<TemukanResepCard> _temukanResepList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTemukanResep();
  }

  Future<void> _loadTemukanResep() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final temukanResepCards = await fetchTemukanResepCards();
      setState(() {
        _temukanResepList = temukanResepCards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error loading temukan resep: $e'); // Debug
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
        ),

        // Content Area
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildContent(),
        ),

        // Tombol "Lihat Semua" (hanya tampil jika ada data)
        if (!_isLoading && !_hasError && _temukanResepList.isNotEmpty)
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
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadTemukanResep,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_temukanResepList.isEmpty) {
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
    }

    // Tampilkan maksimal 4 resep di home page
    final displayedReseps = _temukanResepList.take(4).toList();

    return Column(
      children:
          displayedReseps.map<Widget>((temukanResepCard) {
            final uiData = temukanResepCard.toUIFormat();
            return CardTemukanResep(
              imagePath: uiData['imagePath'],
              title: uiData['title'],
              subtitle: uiData['subtitle'],
              views: uiData['views'],
              rating: uiData['rating'],
              temukanResepCard: temukanResepCard,
              recipeId: temukanResepCard.id, // <-- ini penting!
            );
          }).toList(),
    );
  }
}
