import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_tips.dart';  // Ensure this path is correct
import 'package:masakio/Tips Trik/detail_tips.dart';  // Page to navigate to for detailed tips

// Updated Version of Tips Card (V2) for wider display
class TipsDanTrikCardV2 extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final String authorImage;
  final VoidCallback onTap;

  const TipsDanTrikCardV2({
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
      onTap: onTap, // Navigate to the detailed page
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,  // Make the card span the width of the screen
          height: 120,  // Adjust the height to make it bigger
          margin: const EdgeInsets.only(right: 12, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),  // Image as the background
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
                  Colors.black.withOpacity(0.6),  // Darken the background for text visibility
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
                    fontSize: 16,  // Larger font size for the title
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,  // Adjust size of avatar
                      backgroundImage: AssetImage(authorImage),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,  // Slightly larger author text
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Section to display Tips and Tricks (V2) with a wider layout
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
          ),
        ),
        const SizedBox(height: 8),
        // Display the tips in a vertically stacked list
        SizedBox(
          height: 720,  // Increase the height to show cards more prominently
          child: ListView.builder(
            scrollDirection: Axis.vertical,  // Vertical scroll for a stack of cards
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dummyTipsList.length,  // Populate based on the dummy data list
            itemBuilder: (context, index) {
              final tip = dummyTipsList[index];
              return TipsDanTrikCardV2(
                imagePath: tip.imageAsset,
                title: tip.title,
                author: tip.author,
                authorImage: 'assets/images/profile.jpg',  // Replace with dynamic author image
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TipsAndTrikPage(tip: tip),
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
