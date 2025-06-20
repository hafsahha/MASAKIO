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
        'comment': 'Luar biasa! Semua keluarga saya suka dengan resep ini. Akan sering saya buat lagi.',
        'image': 'assets/images/profile.jpg',
      },
      {
        'name': 'Citra L.',
        'date': 'Februari 2024',
        'rating': 4.0,
        'comment': 'Rasanya enak, tapi perlu sedikit tambahan garam menurut saya.',
        'image': null,
      },
      {
        'name': 'Deni P.',
        'date': 'Mei 2024',
        'rating': 4.5,
        'comment': 'Langkah-langkahnya sangat jelas dan mudah diikuti. Hasilnya juga memuaskan!',
        'image': 'assets/images/profile.jpg',
      },
      {
        'name': 'Eva M.',
        'date': 'Juni 2024',
        'rating': 3.5,
        'comment': 'Lumayan, tapi menurut saya bumbunya kurang terasa. Mungkin perlu ditambahkan.',
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
        'comment': 'Saya suka sekali! Anak-anak juga suka dan minta dibuatkan lagi.',
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
          // Summary section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rating Rata-rata',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          resep.rating.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.star, color: Colors.amber, size: 22),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Berdasarkan ulasan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${resep.reviewCount} pengguna',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to write review form
                    // This could be implemented later
                  },
                  icon: const Icon(Icons.rate_review, size: 16),
                  label: const Text('Tulis Ulasan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter options
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filter: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                FilterChip(
                  label: const Text('Terbaru'),
                  selected: true,
                  onSelected: (bool value) {},
                  selectedColor: Colors.teal.withOpacity(0.15),
                  checkmarkColor: Colors.teal,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Rating Tertinggi'),
                  selected: false,
                  onSelected: (bool value) {},
                  selectedColor: Colors.teal.withOpacity(0.15),
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
                backgroundImage: imagePath != null ? AssetImage(imagePath!) : null,
                child: imagePath == null ? const Icon(Icons.person, color: Colors.white) : null,
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Review comment
          Text(
            comment,
            style: const TextStyle(fontSize: 15),
          ),
          
          const SizedBox(height: 12),
          
          // Like and reply actions
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                label: const Text('Suka'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  textStyle: const TextStyle(fontSize: 13),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: const Text('Balas'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  textStyle: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
