import 'package:flutter/material.dart';

class ResepCard extends StatelessWidget {
  final String title;
  final String rating;
  final String reviews;
  final String? imageUrl;
  final bool isBookmarked; // Parameter baru untuk status bookmark
  final Function()? onBookmarkTap; // Callback untuk aksi bookmark

  const ResepCard({
    Key? key,
    required this.title,
    required this.rating,
    required this.reviews,
    this.imageUrl,
    this.isBookmarked = false, // Default: tidak di-bookmark
    this.onBookmarkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onTap: onBookmarkTap,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 16,
                      color: Colors.black,
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
    );
  }
}
