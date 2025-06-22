import 'package:flutter/material.dart';
import 'package:masakio/Tips Trik/detail_tips.dart';
import 'package:masakio/data/func_tips.dart';

class TipsDanTrikCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final VoidCallback onTap;

  const TipsDanTrikCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        height: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(imageUrl), // Gunakan URL dari API
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
                Colors.black.withOpacity(0.6),
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/profile.jpg'), // Placeholder
                  ),
                  const SizedBox(width: 6),
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TipsDanTrikSection extends StatefulWidget {
  const TipsDanTrikSection({super.key});

  @override
  State<TipsDanTrikSection> createState() => _TipsDanTrikSectionState();
}

class _TipsDanTrikSectionState extends State<TipsDanTrikSection> {
  List<Map<String, dynamic>> tipsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTips();
  }

  Future<void> loadTips() async {
    try {
      final data = await fetchAllTips();
      setState(() {
        tipsList = data;
        isLoading = false;
      });
    } catch (e) {
      // Tangani error jika perlu
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tips dan Trik",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Tambah navigasi ke halaman "Lihat Semua"
                },
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tipsList.length,
                  itemBuilder: (context, index) {
                    final tip = tipsList[index];
                    return TipsDanTrikCard(
                      imageUrl: tip['imageUrl'],
                      title: tip['title'],
                      author: tip['uploader'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TipsAndTrikPage(idTips: tip['id']),
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
