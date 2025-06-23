import 'package:flutter/material.dart';
import 'package:masakio/Forum/add_discussion_page.dart';
import 'package:masakio/.components/discussion_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masakio/cubit/forum_cubit.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForumCubit()..fetchAllForums(),
      child: const ForumView(),
    );
  }
}

class ForumView extends StatelessWidget {
  const ForumView({super.key});

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => showAddDiscussionSheet(context, () {
                context.read<ForumCubit>().refresh();
              }),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'Tambahkan Diskusi',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ForumCubit, ForumState>(
              builder: (context, state) {
                if (state is ForumLoading) return const Center(child: CircularProgressIndicator());
                if (state is ForumError) return Center(child: Text('Error: ${state.message}'));
                if (state is ForumLoaded) {
                  final forums = state.forums;
                  if (forums.isEmpty) return const Center(child: Text('Belum ada diskusi.'));
                  return RefreshIndicator(onRefresh: () async => context.read<ForumCubit>().refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 110.0),
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
                            timestamp: forum.timestamp,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              }
            )
          )
        ],
      ),
    );
  }
}