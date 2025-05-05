import 'package:flutter/material.dart';
import 'resep_card.dart';

class ResepGrid extends StatelessWidget {
  final List reseps;

  const ResepGrid({
    Key? key,
    required this.reseps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menghitung jumlah kolom berdasarkan lebar layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0), // Menghilangkan padding bawah
      physics: const AlwaysScrollableScrollPhysics(), // Memastikan grid dapat di-scroll
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
        return ClipRect(
          child: ResepCard(
            title: resep.title,
            rating: resep.rating.toString(),
            reviews: resep.reviewCount.toString(),
            imageUrl: resep.imageAsset,
          ),
        );
      },
    );
  }
}
