import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart'; // pastikan path ini sesuai

class CardRekomendasi extends StatelessWidget {
  final Resep resep;

  const CardRekomendasi({
    Key? key,
    required this.resep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar dengan radius
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                resep.imageAsset,
                height: 95,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Judul
          Text(
            resep.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Rating dan jumlah review
          Row(
            children: [
              const Icon(Icons.star, size: 10, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                resep.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
              const SizedBox(width: 2),
              Text(
                "| ${_getReviewCount(resep.rating)} Reviews",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.visibility, size: 10, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  String _getReviewCount(double rating) {
    if (rating >= 4.9) return "5k";
    if (rating >= 4.8) return "4k";
    if (rating >= 4.7) return "3.5k";
    if (rating >= 4.6) return "3k";
    return "1.5k";
  }
}

class RekomendasiSection extends StatelessWidget {
  const RekomendasiSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rekomendasiList = dummyResepList.take(5).toList(); // ambil 5 teratas atau sesuaikan

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rekomendasi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // aksi lihat semua
                },
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: rekomendasiList.length,
            itemBuilder: (context, index) {
              return CardRekomendasi(resep: rekomendasiList[index]);
            },
          ),
        ),
      ],
    );
  }
}
