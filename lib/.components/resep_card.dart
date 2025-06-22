import 'package:flutter/material.dart';
import 'package:masakio/data/func_wishlist.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/.components/bottom_popup.dart';
import 'package:masakio/data/dummy_resep.dart'; // Added import for Resep model
import 'package:masakio/resep_detail.dart'; // Added import for ResepDetailPage

class ResepCard extends StatelessWidget {
  final String id;  // Changed from int to String
  final String title;
  final String rating;
  final String reviews;
  final String? imageUrl;
  final bool isOwned;
  bool isBookmarked; // Parameter baru untuk status bookmark
  final void Function()? onRefresh; // Callback untuk refresh jika diperlukan
  final Resep? resep; // Added full Resep object

  ResepCard({
    super.key,
    required this.id,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.isOwned = false, // Default: bukan milik pengguna
    this.isBookmarked = false, // Default: tidak di-bookmark
    this.onRefresh,
    this.resep, // Added parameter for Resep object
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (resep != null) {
          // Navigate to recipe detail page with recipe data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResepDetailPage(resep: resep!),
            ),
          );
        }
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan rounded corners dan tombol bookmark
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: imageUrl != null
                        ? Image.asset(
                      imageUrl!,
                      height: 95,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                // Tombol bookmark di pojok kanan bawah
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: isOwned
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return BottomPopup(
                              children: [
                                Text('Apakah anda yakin ingin menghapus resep ini dari resep milikmu?'),
                                const SizedBox(height: 30),
                                Button(
                                  onPressed: () => { },
                                  content: 'Ya',
                                  backgroundColor: 0xFFFF0000,
                                ),
                                const SizedBox(height: 20),
                                Button(
                                  onPressed: () => { },
                                  content: 'Tidak',
                                ),
                              ]
                            );
                          },
                        );
                    }
                    : () async{
                        if (isBookmarked) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomPopup(
                                children: [
                                  Text('Apakah anda yakin ingin menghapus resep ini dari wishlist?'),
                                  const SizedBox(height: 30),
                                  Button(                                    onPressed: () async {
                                      await unwish(int.parse(id));  // Parse string to int
                                      Navigator.pop(context); // Close bottom sheet
                                      if (context.mounted) showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                        title: const Text("Resep Dihapus"),
                                        content: const Text("Resep berhasil dihapus dari wishlist."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              this.isBookmarked = true;
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                        ),
                                      );
                                    },
                                    content: 'Ya',
                                    backgroundColor: 0xFFCC0000,
                                  ),
                                  const SizedBox(height: 20),
                                  Button(
                                    onPressed: () { Navigator.pop(context); },
                                    content: 'Tidak',
                                  ),
                                ]
                              );
                            }
                          );                        } else {
                          await wish(int.parse(id));  // Parse string to int
                          if (context.mounted) showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Resep Tersimpan"),
                              content: const Text("Resep berhasil ditambahkan ke wishlist."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    if (onRefresh != null) onRefresh!();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOwned
                            ? Icons.delete 
                            : isBookmarked // Gunakan status bookmark
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        size: 16,
                        color: isOwned ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Judul
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Rating dan reviews
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 10,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                Text(
                  " | $reviews Reviews",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Icon visibility
            const Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 10,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  "Dilihat",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
