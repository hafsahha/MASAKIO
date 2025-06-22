import 'package:flutter/material.dart';
import 'package:masakio/data/dummy_resep.dart';

class ReviewAllPage extends StatelessWidget {
  final Resep resep;

  const ReviewAllPage({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    // Dummy review data
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Ayu R.',
        'date': 'Maret 2024',
        'rating': 4.7,
        'comment': 'Resepnya enak dan mudah diikuti. Terima kasih!',
        'image': null, // Using null for default avatar
      },
      {
        'name': 'Budi S.',
        'date': 'April 2024',
        'rating': 5.0,
        'comment':
            'Luar biasa! Semua keluarga saya suka dengan resep ini. Akan sering saya buat lagi.',
        'image': 'assets/images/profile.jpg',
      },
      {
        'name': 'Citra L.',
        'date': 'Februari 2024',
        'rating': 4.0,
        'comment':
            'Rasanya enak, tapi perlu sedikit tambahan garam menurut saya.',
        'image': null,
      },
      {
        'name': 'Deni P.',
        'date': 'Mei 2024',
        'rating': 4.5,
        'comment':
            'Langkah-langkahnya sangat jelas dan mudah diikuti. Hasilnya juga memuaskan!',
        'image': 'assets/images/profile.jpg',
      },
      {
        'name': 'Eva M.',
        'date': 'Juni 2024',
        'rating': 3.5,
        'comment':
            'Lumayan, tapi menurut saya bumbunya kurang terasa. Mungkin perlu ditambahkan.',
        'image': null,
      },
      {
        'name': 'Feri W.',
        'date': 'Mei 2024',
        'rating': 5.0,
        'comment': 'Sempurna! Tidak ada yang perlu diubah dari resep ini.',
        'image': null,
      },
      {
        'name': 'Gita K.',
        'date': 'April 2024',
        'rating': 4.8,
        'comment':
            'Saya suka sekali! Anak-anak juga suka dan minta dibuatkan lagi.',
        'image': 'assets/images/profile.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan ${resep.title}'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter options
          Padding(
            padding: const EdgeInsets.all(16), // diperkecil dari 16
            child: Row(
              children: [
                const Text(
                  'Filter: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ), // diperkecil
                ),
                FilterChip(
                  label: const Text(
                    'Terbaru',
                    style: TextStyle(fontSize: 12),
                  ), // diperkecil
                  selected: true,
                  onSelected: (bool value) {},
                  selectedColor: Colors.teal.withOpacity(0.15),
                  checkmarkColor: Colors.teal,
                  visualDensity: VisualDensity.compact, // lebih rapat
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 6), // diperkecil
                FilterChip(
                  label: const Text(
                    'Rating Tertinggi',
                    style: TextStyle(fontSize: 12),
                  ), // diperkecil
                  selected: false,
                  onSelected: (bool value) {},
                  selectedColor: Colors.teal.withOpacity(0.15),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),

          // Reviews list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                  name: review['name'],
                  date: review['date'],
                  rating: review['rating'],
                  comment: review['comment'],
                  imagePath: review['image'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final double rating;
  final String comment;
  final String? imagePath;

  const ReviewCard({
    super.key,
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    imagePath != null ? AssetImage(imagePath!) : null,
                child:
                    imagePath == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
              ),

              const SizedBox(width: 12),

              // User details and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Bergabung sejak $date',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating.floor()
                                ? Icons.star
                                : (index == rating.floor() && rating % 1 > 0)
                                ? Icons.star_half
                                : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Review date
              Text(
                '15 hari lalu',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review comment
          Text(comment, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
