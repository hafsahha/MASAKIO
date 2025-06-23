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
    print('[TipsDanTrikCard] Building card for: $title, image: $imageUrl'); // Debug log
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
    print('[TipsDanTrikSectionState] initState called'); // Debug log
    loadTips();
  }

  Future<void> loadTips() async {
    print('[TipsDanTrikSectionState] loadTips() called'); // Debug log
    try {
      final data = await fetchAllTips();
      print('[TipsDanTrikSectionState] fetchAllTips() returned: $data'); // Debug log
      setState(() {
        tipsList = data;
        isLoading = false;
      });
    } catch (e) {
      print('[TipsDanTrikSectionState] Error fetching tips: $e'); // Debug log
      // Tangani error jika perlu
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[TipsDanTrikSectionState] Building widget. isLoading: $isLoading, tipsList.length: ${tipsList.length}'); // Debug log
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
                  print('[TipsDanTrikSectionState] "Lihat Semua" button pressed'); // Debug log
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
                    print('[TipsDanTrikSectionState] Building card at index $index: $tip'); // Debug log
                    return TipsDanTrikCard(
                      imageUrl: tip['imageUrl'], // Use the actual image URL
                      title: tip['title'],
                      author: tip['uploader'],
                      onTap: () {
                        print('[TipsDanTrikSectionState] Card tapped for tip ID: ${tip['id']}'); // Debug log
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