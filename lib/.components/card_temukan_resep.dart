import 'package:flutter/material.dart';

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
          // ========== BAGIAN KIRI: GAMBAR ==========
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imagePath,
              width: 120, // Ukuran gambar diperbesar
              height: 120, // Ukuran gambar diperbesar
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // ========== BAGIAN KANAN: INFORMASI RESEP ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul dan Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Judul resep
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
                    // Rating dengan ikon bintang
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
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

                // Nama bakery (subtitle)
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

                // Jumlah views dan ikon bookmark
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // View count
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
                    // Bookmark icon
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
  const TemukanResepSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            "Temukan Resep",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Recipe Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: const [
              CardTemukanResep(
                imagePath: 'assets/images/pizza.jpg', // Ganti dengan URL gambar yang sesuai
                title: "Marinated Grilled pizza",
                subtitle: "Brown Bakery",
                views: "700k",
                rating: "4.5",
              ),
              CardTemukanResep(
                imagePath: 'assets/images/pizza.jpg', // Ganti dengan URL gambar yang sesuai
                title: "Marinated Grilled pizza",
                subtitle: "Brown Bakery",
                views: "700k",
                rating: "4.5",
              ),
              CardTemukanResep(
                imagePath: 'assets/images/pizza.jpg', // Ganti dengan URL gambar yang sesuai
                title: "Marinated Grilled pizza",
                subtitle: "Brown Bakery",
                views: "700k",
                rating: "4.5",
              ),
            ],
          ),
        ),
        // "Lihat Semua" button
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
