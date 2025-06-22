import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart';
import 'package:masakio/.components/card_temukan_resep.dart';
import 'package:masakio/discovery.dart';

class TemukanResepSectionComponent extends StatelessWidget {
  final String? categoryFilter; // optional category filter

  const TemukanResepSectionComponent({super.key, this.categoryFilter});

  @override
  Widget build(BuildContext context) {
    // Filter kategori jika diberikan
    final List<Resep> temukanResep =
        categoryFilter == null
            ? dummyResepList // Tampilkan semua resep jika kategori null
            : dummyResepList
                .where((resep) => resep.categories.contains(categoryFilter))
                .toList();

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
        // Daftar resep
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children:
                temukanResep.map((resep) {
                  return CardTemukanResep(
                    imagePath: resep.imageAsset,
                    title: resep.title,
                    subtitle: resep.author,
                    views: resep.viewsCount.toString(),
                    rating: resep.rating.toStringAsFixed(1),
                    resep: resep, // Pass the full resep object
                  );
                }).toList(),
          ),
        ),
        // Tombol "Lihat Semua"
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiscoveryResep()),
              );
            },
            child: const Text(
              "Lihat Semua",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
