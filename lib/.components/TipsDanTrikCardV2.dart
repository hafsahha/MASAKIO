import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_tips.dart';  // Ensure the path is correct
import 'package:masakio/Tips Trik/detail_tips.dart';  // Page to navigate to for detailed tips

// TipsDanTrikCard widget that takes data and shows it
class TipsDanTrikCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final String authorImage;
  final VoidCallback onTap;

  const TipsDanTrikCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.authorImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image of the tip
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Content of the tip
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the tip
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Author and Avatar
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage(authorImage),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        author,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
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

// Section to display Tips and Tricks vertically (Updated layout)
class TipsDanTrikSectionV2 extends StatelessWidget {
  const TipsDanTrikSectionV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header for the section
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
                onPressed: () {
                  // TODO: Add navigation to "See All" screen
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
        const SizedBox(height: 8),
        // This ListView is now vertically scrollable
        SizedBox(
          height: 180, // Adjust the height to allow for a stack of cards
          child: ListView.builder(
            scrollDirection: Axis.vertical,  // Switch from horizontal to vertical
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dummyTipsList.length,  // Fetch the number of items in dummyTipsList
            itemBuilder: (context, index) {
              final tip = dummyTipsList[index];  // Access each item in the dummyTipsList
              return TipsDanTrikCard(
                imagePath: tip.imageAsset,  // Pass the image asset path
                title: tip.title,           // Pass the title
                author: tip.author,         // Pass the author name
                authorImage: 'assets/images/profile.jpg',  // Example placeholder image for author
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TipsAndTrikPage(tip: tip), // Navigate to detail page
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
