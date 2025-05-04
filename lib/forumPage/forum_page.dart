import 'package:flutter/material.dart';
import '../components/discussion_card.dart';
import 'add_discussion_page.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

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
                showAddDiscussionSheet(context);
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // First Discussion Card
                DiscussionCard(
                  username: 'malina.psychology',
                  userImage: 'assets/images/avatar.png',
                  contentImage: 'assets/images/profile_image.jpg', // Image shown in the card
                  content: 'In essence, psychology enriches our understanding of human nature, offering insights into behavior, relationships, and personal growth. It\'s a fascinating journey into what makes us who we are.',
                  likesCount: '2.3k likes',
                  repliesCount: '640 replies',
                ),
                const SizedBox(height: 16),
                // Second Discussion Card (same content for demonstration)
                DiscussionCard(
                  username: 'malina.psychology',
                  userImage: 'assets/images/avatar.png',
                  contentImage: 'assets/images/profile_image.jpg', // Image shown in the card
                  content: 'In essence, psychology enriches our understanding of human nature, offering insights into behavior, relationships, and personal growth. It\'s a fascinating journey into what makes us who we are.',
                  likesCount: '2.3k likes',
                  repliesCount: '640 replies',
                ),
                const SizedBox(height: 80), // Space for FAB and bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }
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