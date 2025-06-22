import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart'; // pastikan path ini sesuai
import 'package:masakio/resep_detail.dart';
import 'package:masakio/data/func_temukan_resep.dart'; // Import service baru
import 'package:masakio/data/func_detail_resep.dart'; // Import detail service
import 'package:masakio/data/func_card_recipe.dart'; // Import untuk CardRecipe

class CardTemukanResep extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String views;
  final String rating;
  final Resep? resep; // Add recipe data object
  final TemukanResepCard? temukanResepCard; // TAMBAHAN BARU - untuk data database
  final int? recipeId; // TAMBAHAN BARU - untuk navigation
  final CardRecipe? cardRecipe; // Support untuk CardRecipe data
  final bool isBookmarked; // Status bookmark
  final VoidCallback? onBookmarkTap; // Callback untuk bookmark

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
    this.cardRecipe,
    this.isBookmarked = false,
    this.onBookmarkTap,
  }) : super(key: key);

  @override
  State<CardTemukanResep> createState() => _CardTemukanResepState();
}

class _CardTemukanResepState extends State<CardTemukanResep> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.cardRecipe?.isBookmarked == 1 || widget.isBookmarked;
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    // Call the callback if provided
    if (widget.onBookmarkTap != null) {
      widget.onBookmarkTap!();
    } else {
      // Default bookmark action (you can implement API call here)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isBookmarked ? 'Added to bookmarks!' : 'Removed from bookmarks!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.resep != null) {
          // Navigate to recipe detail page with dummy recipe data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResepDetailPage(resep: widget.resep!),
            ),
          );
        } else if (widget.recipeId != null) {
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
            final detailResep = await fetchDetailResepById(widget.recipeId!);

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
          children: [            // Gambar Resep
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.cardRecipe?.thumbnail != null
                  ? Image.network(
                      widget.cardRecipe!.thumbnail!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
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
                    )
                  : Image.asset(
                      widget.imagePath,
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
                    children: [                      Expanded(
                        child: Text(
                          widget.title,
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
                            widget.rating,
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
                    widget.subtitle,
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
                          const SizedBox(width: 4),                          Text(
                            "${widget.views} views",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          // Show review count from CardRecipe data
                          if (widget.cardRecipe != null) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.rate_review_outlined,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.cardRecipe!.jumlahReview} reviews",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),],
                        ],
                      ),
                      // Tombol Bookmark
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                          size: 16,
                          color: _isBookmarked ? Colors.teal : Colors.grey,
                        ),
                        onPressed: _toggleBookmark,
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
