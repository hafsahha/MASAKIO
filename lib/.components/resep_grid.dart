import 'package:flutter/material.dart';
import 'resep_card.dart';

class ResepGrid extends StatelessWidget {
  final List<Map<String, dynamic>> reseps; // Updated to match API response format

  const ResepGrid({super.key, required this.reseps});
  
  @override
  Widget build(BuildContext context) {
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
      itemBuilder: (context, index) {
        final resep = reseps[index];
        try {
          // Koreksi: Pastikan ID adalah string
          String recipeId;
          try {
            // Konversi ID ke string untuk konsistensi
            if (resep['id'] != null) {
              recipeId = resep['id'].toString();
            } else {
              recipeId = "0"; // Default ID jika null
            }
          } catch (e) {
            recipeId = "0"; // Default ID jika gagal konversi
          }

          return ClipRect(
            child: ResepCard(
              id: recipeId, // Gunakan ID string untuk konsistensi dengan ResepCard
              title: resep['title'] ?? 'Tidak ada judul',
              rating: resep['rating']?.toString() ?? '0', // Default rating jika tidak tersedia
              reviews: resep['reviewCount']?.toString() ?? '0',
              imageUrl: resep['imageAsset'] ?? 'assets/images/masakio_logo.png',
              isOwned: resep['isOwned'] ?? false, // Default false karena tidak tersedia dari API
              isBookmarked: resep['isBookmarked'] ?? false,
              // Tidak perlu melewatkan resep objek penuh karena format berbeda
            ),
          );
        } catch (e) {
          // Handle error gracefully without logs
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
