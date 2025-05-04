import 'package:flutter/material.dart';
import '../forumPage/detail_page.dart';
import 'user_avatar.dart';

class DiscussionCard extends StatelessWidget {
  final String username;
  final String userImage;
  final String contentImage;
  final String content;
  final String likesCount;
  final String repliesCount;

  const DiscussionCard({
    super.key,
    required this.username,
    required this.userImage,
    required this.contentImage,
    required this.content,
    required this.likesCount,
    required this.repliesCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForumDetailPage(
              username: username,
              userImage: userImage,
              content: content,
              contentImage: contentImage,
              hashtags: ['#dribbble', '#designjobs', '#sydneyux', '#sydneydesigners', '#uxsite'],
              retweetsCount: 6, // Example value based on image
              likesCount: 15, // Example value based on image
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 53, 167, 163).withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content Image (Profile photo)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'assets/images/profil1.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            
            // User info
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 6.0),
              child: Row(
                children: [
                  UserAvatar(imageUrl: userImage, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    username,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 13,
                  color:  Color.fromARGB(255, 255, 255, 255),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Stats and interactions
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // User avatars (small)
                  SizedBox(
                    width: 60,
                    child: Stack(
                      children: [
                        UserAvatar(imageUrl: userImage, size: 18),
                        Positioned(
                          left: 12,
                          child: UserAvatar(imageUrl: userImage, size: 18),
                        ),
                        Positioned(
                          left: 24,
                          child: UserAvatar(imageUrl: userImage, size: 18),
                        ),
                        Positioned(
                          left: 36,
                          child: UserAvatar(imageUrl: userImage, size: 18),
                        ),
                      ],
                    ),
                  ),
                  
                  // Likes
                  const Icon(Icons.favorite_border, size: 14, color:Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Text(
                    likesCount,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Comments
                  const Icon(Icons.chat_bubble_outline, size: 14, color:Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Text(
                    repliesCount,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumDetailPage(
                          username: username,
                          userImage: userImage,
                          content: content,
                          contentImage: contentImage,
                          hashtags: ['#dribbble', '#designjobs', '#sydneyux', '#sydneydesigners', '#uxsite'],
                          retweetsCount: 6,
                          likesCount: 15,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Balas',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:  Color.fromARGB(255, 12, 12, 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}