import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart'; // pastikan path ini sesuai
import 'package:masakio/resep_detail.dart';
import 'package:masakio/data/func_temukan_resep.dart'; // Import service baru
import 'package:masakio/data/func_detail_resep.dart'; // Import detail service

class CardTemukanResep extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String views;
  final String rating;
  final Resep? resep; // Add recipe data object
  final TemukanResepCard?
  temukanResepCard; // TAMBAHAN BARU - untuk data database
  final int? recipeId; // TAMBAHAN BARU - untuk navigation

  const CardTemukanResep({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.views,
    required this.rating,
    this.resep, // Optional parameter
    this.temukanResepCard, // TAMBAHAN BARU - Optional parameter
    this.recipeId, // TAMBAHAN BARU - Optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (resep != null) {
          // Navigate to recipe detail page with dummy recipe data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResepDetailPage(resep: resep!),
            ),
          );
        } else if (recipeId != null) {
          // Navigate dengan fetch detail dari database
          try {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => const Center(child: CircularProgressIndicator()),
            );

            // Fetch detail resep dari database
            final detailResep = await fetchDetailResepById(recipeId!);

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
        }
      },
      child: Padding(
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
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika gambar tidak ditemukan
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
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
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                          // TAMBAHAN BARU - Tampilkan review count jika ada data database
                          if (temukanResepCard != null) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.rate_review_outlined,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${temukanResepCard!.jumlahReview} reviews",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
