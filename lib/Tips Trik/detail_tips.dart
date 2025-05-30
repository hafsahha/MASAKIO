import 'package:flutter/material.dart';
import 'package:masakio/.components/navbar.dart';
import 'package:masakio/.components/bottom_popup.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/Tambah Resep/tambah-resep-1.dart';
import 'package:masakio/Tips Trik/tambah_tips.dart';
import 'package:masakio/main_page.dart';
import 'package:masakio/data/dummy_tips.dart';
import 'package:intl/intl.dart';

class TipsAndTrikPage extends StatefulWidget {
  final Tips tip;
  const TipsAndTrikPage({super.key, required this.tip});

  @override
  State<TipsAndTrikPage> createState() => _TipsAndTrikPageState();
}

class _TipsAndTrikPageState extends State<TipsAndTrikPage> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _onNavbarItemSelected(int index) {
    if (index != 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(pageIndex: index),
        ),
      );
    }
  }

  void _showBottomPopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomPopup(
          children: [
            const Text(
              'Mau buat apa hari ini?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Button(
              content: 'Buat Resep Baru',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahResep1Page(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Button(
              content: 'Tulis Tips & Trik',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahTipsPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tip = widget.tip;
    final formattedDate = DateFormat('MMMM d, yyyy').format(tip.uploadDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 60,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: tip.hashtags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: const Color(0xFF83AEB1),
                  labelStyle: const TextStyle(color: Colors.white),
                )).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tip.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
              child: Text(
                'Oleh ${tip.author} • Diunggah: $formattedDate',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  tip.imageAsset,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
                    ),
                    child: Text(
                      _isExpanded ? tip.content : tip.content.split('. ').take(3).join('. ') + '.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _toggleExpansion,
                      child: Text(
                        _isExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Selengkapnya',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF83AEB1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, color: Colors.grey),
                  label: const Text(
                    'Bagikan Tips & Trik',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF83AEB1),
        shape: const CircleBorder(),
        onPressed: _showBottomPopup,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(
        idx: 1,
        onItemSelected: _onNavbarItemSelected,
      ),
    );
  }
}
