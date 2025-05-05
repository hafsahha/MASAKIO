import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart';

class CardTemukanResep extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String views;
  final String rating;

  const CardTemukanResep({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.views,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Resep
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Detail Resep
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Penulis
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Jumlah Views
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$views views",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    // Tombol Bookmark
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.bookmark_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TemukanResepSection extends StatelessWidget {
  final String? categoryFilter; // optional category filter

  const TemukanResepSection({Key? key, this.categoryFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter kategori jika diberikan
    final List<Resep> temukanResep = categoryFilter == null
        ? dummyResepList.take(3).toList()
        : dummyResepList
            .where((resep) => resep.categories.contains(categoryFilter))
            .take(3)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul section
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            "Temukan Resep",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Daftar resep
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: temukanResep.map((resep) {
              return CardTemukanResep(
                imagePath: resep.imageAsset,
                title: resep.title,
                subtitle: resep.author,
                views: resep.reviewCount.toString(),
                rating: resep.rating.toStringAsFixed(1),
              );
            }).toList(),
          ),
        ),
        // Tombol "Lihat Semua"
        Center(
          child: TextButton(
            onPressed: () {},
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
}
