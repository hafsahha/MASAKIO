import 'package:flutter/material.dart';
import 'package:masakio/Forum/reply_discussion.dart';
import 'package:masakio/.components/user_avatar.dart';
import 'package:masakio/data/func_forum.dart';

class ForumDetailPage extends StatefulWidget {
  final int id;
  const ForumDetailPage({super.key, required this.id});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final List<String> hashtags = ['#masakio', '#resepmasakan', '#capekbgt', '#provis'];
  Future<ForumDetail>? _forumFuture;
  ForumDetail? forum;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _forumFuture = fetchForumById(widget.id);
    _forumFuture!.then((f) { forum = f; });
    isLikedForumPost(widget.id).then((liked) { setState(() => isLiked = liked); });
  }

  void _refreshForum() => setState(() {
    _forumFuture = fetchForumById(widget.id);
    _forumFuture!.then((f) { forum = f; });
  });
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ForumDetail>(
      future: _forumFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        forum = snapshot.data!;
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
              'Postingan Forum',
              style: TextStyle(
                fontFamily: 'montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Column(
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
                            UserAvatar(imageUrl: forum!.authorPhoto != null ? 'assets/images/${forum!.authorPhoto}' : 'assets/images/avatar.png', size: 40),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  forum!.author,
                                  style: const TextStyle(
                                    fontFamily: 'montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Content
                        Text(
                          forum!.content,
                          style: const TextStyle(
                            fontFamily: 'montserrat',
                            fontSize: 20,
                            height: 1.5,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Hashtags
                        Wrap(
                          spacing: 4,
                          children: hashtags.map((tag) => Text(
                            tag,
                            style: const TextStyle(
                              fontFamily: 'montserrat',
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 8),

                        // Image Content (if exists)
                        if (forum!.image != null)
                            Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                              'assets/images/${forum!.image!}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              ),
                            ),
                            ),
                        const SizedBox(height: 8),
                        
                        // Time ago
                        Text(
                          formatTimestamp(forum!.timestamp),
                          style: const TextStyle(
                            fontFamily: 'montserrat',
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              '${forum!.likes} Suka',
                              () async {
                                await likeForumPost(forum!.id);
                                setState(() {
                                  isLiked = !isLiked;
                                  forum!.likes += isLiked ? 1 : -1;
                                });
                              },
                              liked: isLiked,
                            ),
                            _buildActionButton(
                              Icons.chat_bubble_outline, '${forum!.comments} Balasan',
                              () => showReplyBottomSheet(context, _refreshForum, forum!.id)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              (forum!.replies == null || forum!.replies!.isEmpty)
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Belum ada balasan.',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                )
              : Column(
                children: forum!.replies!.map((reply) {
                  return Column(
                    children: [
                      _buildReply(
                        username: reply.author,
                        userImage: reply.authorPhoto != null ? 'assets/images/${reply.authorPhoto}' : 'assets/images/avatar.png',
                        content: reply.caption,
                        timeAgo: reply.timestamp,
                        replyingTo: forum!.author,
                        hashtags: [],
                        likesCount: reply.likes,
                        repliesCount: reply.comments,
                        id: reply.id,
                        context: context,
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReply({
    required BuildContext context,
    required String username,
    required String userImage,
    required String content,
    required DateTime timeAgo,
    String? replyingTo,
    List<String> hashtags = const [],
    required int likesCount,
    required int repliesCount,
    required id,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForumDetailPage(id: id)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              fontFamily: 'montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '· ${(() {
                              final diff = DateTime.now().difference(timeAgo);
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
                              fontFamily: 'montserrat',
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
                    fontFamily: 'montserrat',
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
                      fontFamily: 'montserrat',
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 16), // Add right padding for spacing
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildReplyActionButton(Icons.favorite_border, count: likesCount, onPressed: () {
                      }),
                      const SizedBox(width: 16), // Add space between buttons
                      _buildReplyActionButton(Icons.chat_bubble_outline, count: repliesCount, onPressed: () {
                      showReplyBottomSheet(context, _refreshForum, forum!.id);
                      }),
                    ],
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

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, {bool liked = false}) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            icon, size: 24,
            color: liked ? Colors.red : Colors.grey
          ),
          if (label.isNotEmpty) const SizedBox(width: 5),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'montserrat',
                fontSize: 15,
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
                  fontFamily: 'montserrat',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String formatTimestamp(DateTime timestamp) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final dt = timestamp.toLocal();
  final hour = twoDigits(dt.hour);
  final minute = twoDigits(dt.minute);
  final day = twoDigits(dt.day);
  final month = months[dt.month - 1];
  final year = dt.year % 100;
  return '$hour:$minute · $day $month $year';
}