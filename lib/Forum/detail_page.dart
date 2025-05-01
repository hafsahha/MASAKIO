import 'package:flutter/material.dart';
import 'package:masakio/Forum/reply_discussion.dart';
import 'package:masakio/.components/user_avatar.dart';

class ForumDetailPage extends StatelessWidget {
  final String username;
  final String userImage;
  final String content;
  final String contentImage;
  final List<String> hashtags;
  final int repliesCount;
  final int likesCount;

  const ForumDetailPage({
    super.key,
    required this.username,
    required this.userImage,
    required this.content,
    required this.contentImage,
    required this.hashtags,
    required this.repliesCount,
    required this.likesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Discussion Forum',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Main post
          _buildMainPost(context),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          // Replies
          _buildReply(
            username: 'kiero_d',
            userHandle: '@kiero_d',
            userImage: 'assets/images/avatar2.png',
            content: 'Mantap sekali chef ilmunya, terima kasih besok besok mau dicoba......👌',
            timeAgo: '2d',
            replyingTo: '@kokihafas',
            retweetsCount: 1,
            likesCount: 1,
            context: context,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          _buildReply(
            username: 'karennne',
            userHandle: '@karennne',
            userImage: 'assets/images/avatar.png',
            content: 'Walah begitu toh',
            timeAgo: '2d',
            hashtags: ['#barutahu', '#masak'],
            retweetsCount: 1,
            likesCount: 1,
            context: context,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                onPressed: () {},
                child: const Text(
                  'Lihat 1 balasan lainnya',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showReplyBottomSheet(BuildContext context, String originalMessage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReplyBottomSheet(),
    );
  }

  Widget _buildMainPost(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                UserAvatar(imageUrl: userImage, size: 30),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      '@$username',
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF666666),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              content,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),

            // Image Content (if exists)
            if (contentImage.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  contentImage,
                  fit: BoxFit.cover,
                  width: double.infinity, // You can adjust the height as needed
                ),
              ),
            
            const SizedBox(height: 8),

            // Hashtags
            Wrap(
              spacing: 4,
              children: hashtags.map((tag) => Text(
                tag,
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  color: Colors.blue,
                  fontSize: 14,
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                // User avatars (small)
                SizedBox(
                  width: 60,
                  child: Stack(
                    children: [
                      UserAvatar(imageUrl: userImage, size: 20),
                      Positioned(
                        left: 12,
                        child: UserAvatar(imageUrl: userImage, size: 20),
                      ),
                      Positioned(
                        left: 24,
                        child: UserAvatar(imageUrl: userImage, size: 20),
                      ),
                    ],
                  ),
                ),
                
                Text(
                  '$repliesCount Replies',
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFF666666),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$likesCount Likes',
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: Color(0xFF666666),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.chat_bubble_outline, '', () {
                  showReplyBottomSheet(context, 'Berikan Balasan');
                }),
                _buildActionButton(Icons.repeat, '', () {
                }),
                _buildActionButton(Icons.favorite_border, '', () {
                }),
                _buildActionButton(Icons.share_outlined, '', () {
                }),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildReply({
    required BuildContext context,
    required String username,
    required String userHandle,
    required String userImage,
    required String content,
    required String timeAgo,
    String? replyingTo,
    List<String> hashtags = const [],
    required int retweetsCount,
    required int likesCount,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info with timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(imageUrl: userImage, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          userHandle,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Color(0xFF666666),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '· $timeAgo',
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Color(0xFF666666),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (replyingTo != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Membalas kepada $replyingTo',
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Colors.blue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Content
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF333333),
                  ),
                ),
                if (hashtags.isNotEmpty) 
                  const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: hashtags.map((tag) => Text(
                    tag,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildReplyActionButton(Icons.chat_bubble_outline, onPressed: () {
                    showReplyBottomSheet(context, "Ini isi diskusi yang ingin dibalas.");                      
                    }),
                    _buildReplyActionButton(Icons.repeat, count: retweetsCount, onPressed: () {
                    }),
                    _buildReplyActionButton(Icons.favorite_border, count: likesCount, onPressed: () {
                    }),
                    _buildReplyActionButton(Icons.share_outlined, onPressed: () {
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          if (label.isNotEmpty) 
            const SizedBox(width: 5),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReplyActionButton(IconData icon, {int count = 0, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          if (count > 0)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}