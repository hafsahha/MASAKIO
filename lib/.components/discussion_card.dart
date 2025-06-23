import 'dart:io';
import 'package:flutter/material.dart';
import 'package:masakio/Forum/forum_page.dart';
import 'package:masakio/Forum/detail_page.dart';
import 'package:masakio/.components/user_avatar.dart';

class DiscussionCard extends StatelessWidget {
  final int id;
  final String username;
  final String? userImage;
  final String? contentImage;
  final String content;
  final int likesCount;
  final int repliesCount;
  final DateTime timestamp;

  const DiscussionCard({
    super.key,
    required this.id,
    required this.username,
    this.userImage,
    this.contentImage,
    required this.content,
    required this.likesCount,
    required this.repliesCount,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForumDetailPage(id: id))),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF83AEB1).withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            contentImage != null
            ? ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset('assets/images/$contentImage', fit: BoxFit.cover),
                ),
              )
            : const SizedBox.shrink(),

            // User info
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 6.0),
              child: Row(
                children: [
                  UserAvatar(imageUrl: 'assets/images/${userImage ?? ''}', size: 30),
                  const SizedBox(width: 10),
                  Text(
                    username,
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '· ${(() {
                      final diff = DateTime.now().difference(timestamp);
                      if (diff.inSeconds < 60) { return '${diff.inSeconds} dtk'; }
                      else if (diff.inMinutes < 60) { return '${diff.inMinutes} mnt'; }
                      else if (diff.inHours < 24) { return '${diff.inHours} j'; }
                      else if (diff.inDays < 7) { return '${diff.inDays} hr'; }
                      else if (diff.inDays < 30) { return '${(diff.inDays / 7).floor()} mg'; }
                      else if (diff.inDays < 365) { return '${(diff.inDays / 30).floor()} bln'; }
                      else { return '${(diff.inDays / 365).floor()} thn'; }
                    })()}',
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 16,
                      color: Colors.white,
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
                  fontFamily: 'montserrat',
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Likes and comments
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.favorite_border, size: 20, color: Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Text(
                    likesCount.toString(),
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 15,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chat_bubble_outline, size: 20, color: Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Text(
                    repliesCount.toString(),
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 15,
                      color: Color(0xFF666666),
                    ),
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
