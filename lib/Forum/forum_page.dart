import 'package:flutter/material.dart';
import 'package:masakio/Forum/add_discussion_page.dart';
import 'package:masakio/.components/discussion_card.dart';
import 'package:masakio/data/func_forum.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late Future<List<Forum>> _forumsFuture;

  @override
  void initState() {
    super.initState();
    _forumsFuture = fetchForums();
  }

  void _refreshForums() async { setState(() { _forumsFuture = fetchForums(); }); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Forum Diskusi',
          style: TextStyle(
            fontFamily: 'montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Add Discussion Button with dashed border
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => showAddDiscussionSheet(context, _refreshForums),
              child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid, // Changed from none to solid
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                Icon(Icons.add, color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text('Tambahkan Diskusi',
                  style: TextStyle(
                  fontFamily: 'montserrat',
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
          // Discussion List
          Expanded(
            child: FutureBuilder<List<Forum>>(
              future: _forumsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada diskusi.'));
                }
                final forums = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0,  bottom: 110.0),
                  itemCount: forums.length,
                  itemBuilder: (context, index) {
                    final forum = forums[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DiscussionCard(
                        id: forum.id,
                        username: forum.author,
                        userImage: forum.authorPhoto,
                        contentImage: forum.image,
                        content: forum.content,
                        likesCount: forum.likes,
                        repliesCount: forum.comments,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<String> hashtagsFromContent(String content) {
  final hashtagRegExp = RegExp(r'\B#\w\w+');
  return hashtagRegExp.allMatches(content).map((match) => match.group(0)!).toList();
}