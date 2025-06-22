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
  Future<ForumDetail>? _forumFuture;
  ForumDetail? forum;
  final List<String> hashtags = ['#masakio', '#resep', '#masakan'];

  @override
  void initState() {
    super.initState();
    _forumFuture = fetchForumById(widget.id);
    _forumFuture!.then((f) { forum = f; });
  }

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
                        
                        const SizedBox(height: 16),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(Icons.favorite_border, '${forum!.likes} Suka', () async { }),
                            _buildActionButton(Icons.chat_bubble_outline, '${forum!.comments} Balasan', () {
                              showReplyBottomSheet(context, 'Berikan Balasan');
                            }),
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
                        timeAgo: '${DateTime.now().difference(reply.timestamp).inDays}d',
                        replyingTo: forum!.author,
                        hashtags: [],
                        likesCount: reply.likes,
                        repliesCount: reply.comments,
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

  void showReplyBottomSheet(BuildContext context, String originalMessage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReplyBottomSheet(),
    );
  }

  Widget _buildReply({
    required BuildContext context,
    required String username,
    required String userImage,
    required String content,
    required String timeAgo,
    String? replyingTo,
    List<String> hashtags = const [],
    required int likesCount,
    required int repliesCount,
  }) {
    return Padding(
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
                          '· $timeAgo',
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
                    showReplyBottomSheet(context, "Ini isi diskusi yang ingin dibalas.");
                    }),
                  ],
                  ),
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
          Icon(icon, size: 24, color: Colors.grey),
          if (label.isNotEmpty) 
            const SizedBox(width: 5),
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