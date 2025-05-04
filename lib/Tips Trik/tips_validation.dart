import 'package:flutter/material.dart';
import 'dart:typed_data';

class TipsValidationPage extends StatelessWidget {
  final String judul;
  final String isi;
  final String hashtag;
  final Uint8List imageBytes;

  const TipsValidationPage({
    super.key,
    required this.judul,
    required this.isi,
    required this.hashtag,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Validasi Tips & Trik',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(imageBytes,
                  height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            const Text('Judul', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(judul, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Isi Tips', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(isi, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Text('Hashtag', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF83AEB1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                hashtag,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tips berhasil disimpan!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF83AEB1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Simpan Tips',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}