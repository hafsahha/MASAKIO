import 'package:flutter/material.dart';
import 'package:masakio/Tips Trik/detail_tips.dart';
import 'package:masakio/data/func_tips.dart';

class TipsDanTrikCardV2 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final VoidCallback onTap;

  const TipsDanTrikCardV2({
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.only(right: 12, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/images/profile.jpg'), // Ganti jika punya avatar uploader
                    ),
                    const SizedBox(width: 6),
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TipsDanTrikSectionV2 extends StatefulWidget {
  const TipsDanTrikSectionV2({super.key});

  @override
  State<TipsDanTrikSectionV2> createState() => _TipsDanTrikSectionV2State();
}

class _TipsDanTrikSectionV2State extends State<TipsDanTrikSectionV2> {
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
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 640, // Bisa pakai MediaQuery untuk fleksibel
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tipsList.length,
                  itemBuilder: (context, index) {
                    final tip = tipsList[index];
                    return TipsDanTrikCardV2(
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
