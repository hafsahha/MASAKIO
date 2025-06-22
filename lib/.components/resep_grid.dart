import 'package:flutter/material.dart';
import 'resep_card.dart';

class ResepGrid extends StatelessWidget {
  final List<Map<String, dynamic>>
      reseps; // Updated to match API response format

  const ResepGrid({super.key, required this.reseps});

  @override
  Widget build(BuildContext context) {
    // Log data yang diterima oleh komponen
    print("[DEBUG] ResepGrid: Menerima ${reseps.length} data resep");
    if (reseps.isNotEmpty) {
      print("[DEBUG] ResepGrid: Contoh data resep pertama: ${reseps[0]}");
    }

    // Menghitung jumlah kolom berdasarkan lebar layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
          16.0, 16.0, 16.0, 0), // Menghilangkan padding bawah
      physics:
          const AlwaysScrollableScrollPhysics(), // Memastikan grid dapat di-scroll
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Responsif berdasarkan lebar layar
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // Mengatur rasio untuk menghindari overflow
      ),
      itemCount: reseps.length,
      // Menggunakan ClipRect untuk memastikan tidak ada overflow dari item grid
      itemBuilder: (context, index) {
        final resep = reseps[index];
        print(
            "[DEBUG] ResepGrid: Memproses resep ke-$index: id=${resep['id']}, title=${resep['title']}");

        try {
          // Koreksi: Pastikan ID adalah integer
          int recipeId;
          try {
            // Coba parse ID ke integer, dengan penanganan tipe data yang lebih aman
            if (resep['id'] is int) {
              recipeId = resep['id'];
            } else {
              recipeId = int.tryParse(resep['id'].toString()) ?? 0;
            }
            print("[DEBUG] ResepGrid: ID berhasil dikonversi: $recipeId");
          } catch (e) {
            print("[ERROR] ResepGrid: Gagal mengkonversi ID: ${e}");
            recipeId = 0; // Default ID jika gagal konversi
          }

          return ClipRect(
            child: ResepCard(
              id: recipeId, // Gunakan ID yang sudah dikonversi dengan aman
              title: resep['title'] ?? 'Tidak ada judul',
              rating: '0', // Default rating jika tidak tersedia
              reviews: resep['reviewCount']?.toString() ?? '0',
              imageUrl: resep['imageAsset'] ?? 'assets/images/masakio_logo.png',
              isOwned: false, // Default false karena tidak tersedia dari API
              isBookmarked: resep['isBookmarked'] ?? false,
              // Tidak perlu melewatkan resep objek penuh karena format berbeda
            ),
          );
        } catch (e) {
          print("[ERROR] ResepGrid: Error saat memproses resep ke-$index: $e");
          print("[ERROR] ResepGrid: Data resep: $resep");

          // Fallback jika ada error parsing data
          return const Card(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Error: Data resep tidak valid"),
              ),
            ),
          );
        }
      },
    );
  }
}
