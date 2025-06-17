import 'package:flutter/material.dart';
import 'resep_card.dart';

class ResepGridF extends StatelessWidget {
  final Future<List> recipes;
  final void Function()? onRefresh;

  const ResepGridF({
    super.key,
    required this.recipes,
    this.onRefresh
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung jumlah kolom berdasarkan lebar layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return FutureBuilder<List>(
      future: recipes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data resep.'));
        }
        final resepList = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: resepList.length,
          itemBuilder: (context, index) {
            final resep = resepList[index];
            return ClipRect(
              child: ResepCard(
                id: resep['id'],
                title: resep['title'],
                rating: resep['rating'].toString(),
                reviews: resep['reviewCount'].toString(),
                imageUrl: resep['imageAsset'],
                isOwned: resep['isOwned'] ?? false,
                isBookmarked: resep['isBookmarked'] ?? false,
                onRefresh: onRefresh, // Callback untuk refresh jika diperlukan
              ),
            );
          },
        );
      },
    );
  }
}
