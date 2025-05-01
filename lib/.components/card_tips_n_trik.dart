import 'package:flutter/material.dart';

class TipsDanTrikCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final String authorImage;

  const TipsDanTrikCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.authorImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // Lebar card
      height: 160, // Tinggi card
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(authorImage),
                ),
                const SizedBox(width: 6),
                Text(
                  author,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TipsDanTrikSection extends StatelessWidget {
  const TipsDanTrikSection({super.key});

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
                "Tips dan Trik",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
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
        const SizedBox(height: 8),
        // Horizontal scroll card
        SizedBox(
          height: 180, // Lebih tinggi sedikit dari card
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              TipsDanTrikCard(
                imagePath: 'assets/images/scrambled_egg.jpg',
                title: "Asian white noodle with extra seafood",
                author: "James Spader",
                authorImage: "https://via.placeholder.com/150",
              ),
              TipsDanTrikCard(
                imagePath: 'assets/images/scrambled_egg.jpg',
                title: "Simple scrambled egg breakfast",
                author: "Anna Belle",
                authorImage: "https://via.placeholder.com/150",
              ),
              TipsDanTrikCard(
                imagePath: 'assets/images/pizza.jpg',
                title: "How to slice vegetables like a pro",
                author: "Chef M",
                authorImage: "https://via.placeholder.com/150",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
