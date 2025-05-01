import 'dart:io';
import 'package:flutter/material.dart';
import 'package:masakio/Forum/add_discussion_page.dart';
import 'package:masakio/.components/discussion_card.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

List<String> hashtagsFromContent(String content) {
  final hashtagRegExp = RegExp(r'\B#\w\w+');
  return hashtagRegExp.allMatches(content).map((match) => match.group(0)!).toList();
}

class _ForumPageState extends State<ForumPage> {
  // This list will store our discussions
  final List<DiscussionItem> _discussions = [
    // Initial mock data
    DiscussionItem(
      username: 'kokihafas',
      userImage: 'assets/images/avatar.png',
      content: 'Untuk merebus kentang dengan baik dan menjaga nutrisinya, gunakan air secukupnya, jangan kupas kulitnya, tambahkan sedikit garam, rebus dengan api sedang, dan jangan menusuk terlalu sering. Angkat setelah matang. #kentang #masakio #masakioforum',
      contentImage: 'assets/images/kentang.png',
      hashtags: hashtagsFromContent(''),
      likesCount: '2.3k',
      repliesCount: '640',
    ),
    DiscussionItem(
      username: 'shixuka.chef',
      userImage: 'assets/images/avatar.png',
      content: 'To prepare potatoes in a healthier way, consider steaming, boiling them for soup, mashing, baking, or using them in potato salad. Avoid high-heat cooking for extended periods. Boiling potatoes with their skins intact helps retain nutrients. Cutting potatoes into cubes before cooking, such as boiling them with other vegetables like carrots and celery, can also be a healthy choice. These methods prioritize nutrient retention and minimize unhealthy cooking practices. #belanjadapur #kentang #masakfun',
      contentImage: 'assets/images/kentang.png',
      hashtags: hashtagsFromContent(''),
      likesCount: '2.3k',
      repliesCount: '640',
    ),
  ];

  void _addNewDiscussion(String content, File? image) {
    setState(() {
      _discussions.insert(
        0, // Add to the top of the list
        DiscussionItem(
          username: 'current_user', // In a real app, get from user profile
          userImage: 'assets/images/avatar.png', // Default avatar
          content: content,
          contentImage: image, // This will be a File object
          likesCount: '0',
          repliesCount: '0',
          isUserUploadedImage: image != null, 
          hashtags: hashtagsFromContent(content), // Extract hashtags from content
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion Forum',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Add Discussion Button with dashed border
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                showAddDiscussionSheet(
                  context,
                  onAddDiscussion: _addNewDiscussion,
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                    style: BorderStyle.none,
                  ),
                ),
                child: DashedBorder(
                  color: Colors.grey.shade400,
                  strokeWidth: 1,
                  gap: 4,
                  radius: const Radius.circular(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Colors.grey, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Tambahkan Diskusi',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Discussion List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
              itemCount: _discussions.length,
              itemBuilder: (context, index) {
                final discussion = _discussions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DiscussionCard(
                    username: discussion.username,
                    userImage: discussion.userImage,
                    contentImage: discussion.contentImage,
                    content: discussion.content,
                    likesCount: '${discussion.likesCount} likes',
                    repliesCount: '${discussion.repliesCount} replies',
                    isUserUploadedImage: discussion.isUserUploadedImage,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Model class to represent a discussion item
class DiscussionItem {
  final String username;
  final String userImage;
  final String content;
  final dynamic contentImage; // Can be String (asset path) or File (user upload)
  final List<String> hashtags; // List of hashtags
  final String likesCount;
  final String repliesCount;
  final bool isUserUploadedImage;

  DiscussionItem({
    required this.username,
    required this.userImage,
    required this.content,
    required this.contentImage,
    required this.hashtags,
    required this.likesCount,
    required this.repliesCount,
    this.isUserUploadedImage = false,
  });
}

// Custom DashedBorder Widget for the "Tambahkan Diskusi" button
class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double gap;
  final Radius radius;

  const DashedBorder({
    super.key,
    required this.child,
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(radius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(radius),
        ),
        child: CustomPaint(
          painter: DashedRectPainter(
            color: color,
            strokeWidth: strokeWidth,
            gap: gap,
            radius: radius,
          ),
          child: child,
        ),
      ),
    );
  }
}

// Custom Painter for Dashed Border
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final Radius radius;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5;
    final double dashSpace = gap;

    // Top line
    double currentX = 0;
    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, strokeWidth / 2),
        Offset(currentX + dashWidth, strokeWidth / 2),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    // Right line
    double currentY = 0;
    while (currentY < size.height) {
      canvas.drawLine(
        Offset(size.width - strokeWidth / 2, currentY),
        Offset(size.width - strokeWidth / 2, currentY + dashWidth),
        paint,
      );
      currentY += dashWidth + dashSpace;
    }

    // Bottom line
    currentX = 0;
    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, size.height - strokeWidth / 2),
        Offset(currentX + dashWidth, size.height - strokeWidth / 2),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    // Left line
    currentY = 0;
    while (currentY < size.height) {
      canvas.drawLine(
        Offset(strokeWidth / 2, currentY),
        Offset(strokeWidth / 2, currentY + dashWidth),
        paint,
      );
      currentY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}