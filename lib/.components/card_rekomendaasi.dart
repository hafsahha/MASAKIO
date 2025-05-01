import 'package:flutter/material.dart';

class CardRekomendasi extends StatelessWidget {
  final String imagePath;
  final String title;
  final String reviews;
  final String rating;

  const CardRekomendasi({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.reviews,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
              imagePath,
              height: 95,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ),
          ),
          const SizedBox(height: 4),
          // Title
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
          // Rating and reviews
          Row(
            children: [
              // Star icons
              const Icon(
                Icons.star,
                size: 10,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              // Rating text
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
          // Eye icon
          const Row(
            children: [
              Icon(
                Icons.visibility,
                size: 10,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RekomendasiSection extends StatelessWidget {
  const RekomendasiSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rekomendasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              CardRekomendasi(
                imagePath: 'assets/images/scrambled_egg.jpg',
                title: "Scrambled Egg",
                reviews: "5k",
                rating: "4.9",
              ),
              CardRekomendasi(
                  imagePath: 'assets/images/grilled_cheese.jpg',
                title: "Grilled Cheese Sandwich",
                reviews: "4k",
                rating: "4.9",
              ),
              CardRekomendasi(
                  imagePath: 'assets/images/pizza.jpg',
                title: "Pasta with Olive",
                reviews: "3.5k",
                rating: "4.8",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
