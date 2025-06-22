import 'package:flutter/material.dart';
import 'package:masakio/data/func_review.dart';
import 'package:masakio/data/dummy_resep.dart';

class ReviewAllPage extends StatefulWidget {
  final Resep resep;
  const ReviewAllPage({super.key, required this.resep});

  @override
  State<ReviewAllPage> createState() => _ReviewAllPageState();
}

class _ReviewAllPageState extends State<ReviewAllPage> {
  List<Review> _reviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final recipeId = int.tryParse(widget.resep.id) ?? 0;
      final reviews = await getRecipeReviews(recipeId);
      setState(() => _reviews = reviews);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan ${widget.resep.title}'),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filter: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                FilterChip(
                  label: const Text('Terbaru', style: TextStyle(fontSize: 12)),
                  selected: true,
                  onSelected: (bool value) {},
                  selectedColor: Colors.teal.withOpacity(0.15),
                  checkmarkColor: Colors.teal,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text(
                    'Rating Tertinggi',
                    style: TextStyle(fontSize: 12),
                  ),
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
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _reviews.isEmpty
                    ? Center(child: Text('Belum ada ulasan untuk resep ini.'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];                        return ReviewCard(
                          name: review.userName,
                          date: 'Pengguna terdaftar', // Since backend doesn't return date
                          rating: review.rating,
                          comment: review.comment,
                          imagePath: null,
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
