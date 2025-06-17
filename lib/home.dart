import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart'; // pastikan path ini sesuai
import 'package:masakio/.components/card_rekomendasi.dart';
import 'package:masakio/.components/card_tips_n_trik.dart';
import 'package:masakio/.components/card_temukan_resep.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;  // Default ke kategori pertama
  final List<String> _categories = [
    'Semua',
    'Makanan',
    'Cemilan',
    'Minuman',
    'Sup',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 120.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== Banner ===========
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/pizza.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xB1000000),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Resep Makanan Terbaik",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Lihat Resep",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ========== Rekomendasi ===========
              const RekomendasiSection(),

              const SizedBox(height: 16),

              // ========== Tips dan Trik ===========
              const TipsDanTrikSection(),

              const SizedBox(height: 16),

              // ========== Kategori ===========
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kategori",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: _selectedCategoryIndex == index
                                    ? Color(0xFF83AEB1)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  _categories[index],
                                  style: TextStyle(
                                    color: _selectedCategoryIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ========== Temukan Resep ===========
              TemukanResepSection(
                categoryFilter: _selectedCategoryIndex == 0
                    ? null  // Jika kategori pertama dipilih, tampilkan semua resep
                    : _categories[_selectedCategoryIndex], // Terapkan filter kategori
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemukanResepSection extends StatelessWidget {
  final String? categoryFilter; // optional category filter

  const TemukanResepSection({
    super.key,
    this.categoryFilter,
  });

  @override
  Widget build(BuildContext context) {
    // Filter kategori jika diberikan
    final List<Resep> temukanResep = categoryFilter == null
        ? dummyResepList // Tampilkan semua resep jika kategori null
        : dummyResepList
            .where((resep) => resep.categories.contains(categoryFilter))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul section
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            "Temukan Resep",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Daftar resep
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: temukanResep.map((resep) {
              return CardTemukanResep(
                imagePath: resep.imageAsset,
                title: resep.title,
                subtitle: resep.author,
                views: resep.viewsCount.toString(),
                rating: resep.rating.toStringAsFixed(1),
              );
            }).toList(),
          ),
        ),
        // Tombol "Lihat Semua"
        Center(
          child: TextButton(
            onPressed: () {
              // aksi lihat semua
            },
            child: const Text(
              "Lihat Semua",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
