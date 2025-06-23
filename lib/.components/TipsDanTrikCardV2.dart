import 'package:flutter/material.dart';
import 'package:masakio/Tips Trik/detail_tips.dart';
import 'package:masakio/data/func_tips.dart';

// Widget TipsDanTrikCardV2 (tidak ada perubahan signifikan, hanya penambahan log)
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
    print('[TipsDanTrikCardV2] Building card for: $title, image: $imageUrl'); // Debug log
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget TipsDanTrikSectionV2 yang telah diperbarui
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
    print('[TipsDanTrikSectionV2State] initState called'); // Debug log
    loadTips();
  }

  Future<void> loadTips() async {
    print('[TipsDanTrikSectionV2State] loadTips() called'); // Debug log
    try {
      final data = await fetchAllTips();
      print('[TipsDanTrikSectionV2State] fetchAllTips() returned: ${data.length} items'); // Debug log
      setState(() {
        tipsList = data;
        isLoading = false;
        print('[TipsDanTrikSectionV2State] State updated: isLoading=$isLoading, tipsList.length=${tipsList.length}'); // Debug log
      });
    } catch (e) {
      print('[TipsDanTrikSectionV2State] Error fetching tips: $e'); // Debug log
      setState(() {
        isLoading = false;
        print('[TipsDanTrikSectionV2State] Error state updated: isLoading=$isLoading'); // Debug log
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[TipsDanTrikSectionV2State] Building widget. isLoading: $isLoading, tipsList.length: ${tipsList.length}'); // Debug log
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header "Tips dan Trik"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  print('[TipsDanTrikSectionV2State] "Lihat Semua" button pressed'); // Debug log
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
        // --- Perubahan utama ada di sini: penggunaan Expanded ---
        Expanded( // Membuat ListView mengisi sisa ruang vertikal yang tersedia
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : tipsList.isEmpty // Tambahkan kondisi jika daftar tips kosong
                  ? const Center(
                      child: Text('Tidak ada tips yang tersedia saat ini.'),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical, // Pastikan ini vertikal
                      padding: const EdgeInsets.symmetric(horizontal: 16), // Padding horizontal untuk ListView
                      itemCount: tipsList.length,
                      itemBuilder: (context, index) {
                        final tip = tipsList[index];
                        print('[TipsDanTrikSectionV2State] Building card at index $index: ${tip['title']}'); // Debug log
                        return TipsDanTrikCardV2(
                          imageUrl: tip['imageUrl'], // Menggunakan URL gambar dari API
                          title: tip['title'],
                          author: tip['uploader'],
                          onTap: () {
                            print('[TipsDanTrikSectionV2State] Card tapped for tip ID: ${tip['id']}'); // Debug log
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
        // --- Akhir perubahan ---
      ],
    );
  }
}