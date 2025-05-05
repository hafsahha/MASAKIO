import 'package:flutter/material.dart';

class ValidasiResepPage extends StatelessWidget {
  const ValidasiResepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Validasi Resep',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Updated Progress indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildStepIndicator(),
                ),
              ),
              
              // Video preview
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 200,
                width: double.infinity,
                 decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/gambar1.jpg'),  // Pastikan path ini benar
                      fit: BoxFit.cover,
                    ),
                  ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Play button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 40,
                        color: Colors.black87,
                      ),
                    ),
                    // Duration indicator
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '12:08',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Recipe information sections
              _buildInfoSection(
                'Nama Resep',
                'Chicken Ramen',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              
              _buildInfoSection(
                'Estimasi Waktu',
                '45 Menit',
              ),
              
              // Ingredients section
              _buildSectionTitle('Bahan'),
              _buildIngredientsTable(),
              
              // Equipment section
              _buildSectionTitle('Alat & Perlengkapan'),
              _buildEquipmentList(),
              
              // Cooking Instructions
              _buildSectionTitle('Cara Memasak'),
              _buildCookingInstructions(),
              
              // Categories
              _buildSectionTitle('Categories'),
              _buildCategoriesChips(),
              
              // Tags
              _buildSectionTitle('Tags'),
              _buildTagsChips(),
              
              // Publish button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle publish action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83AEB1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Publish',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Bottom navigation placeholder
              Container(
                height: 5,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Updated step indicator to match TambahResep4Page but with step 5 colored
  List<Widget> _buildStepIndicator() {
    final _totalSteps = 5;
    final _currentStep = 4; // Step kelima (indeks 4)
    
    return List.generate(
      _totalSteps,
      (index) => Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index <= _currentStep ? const Color(0xFF83AEB1) : Colors.grey[300],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: index <= _currentStep ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (index < _totalSteps - 1)
            Container(
              width: 40,
              height: 1,
              color: index < _currentStep ? const Color(0xFF83AEB1) : Colors.grey[300],
            ),
        ],
      ),
    );
  }
  
  Widget _buildInfoSection(String title, String content, {double fontSize = 16, FontWeight fontWeight = FontWeight.w500}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
  
  Widget _buildIngredientsTable() {
    final ingredients = [
      {'name': 'Kaldu Ayam', 'amount': '8 gelas'},
      {'name': 'Kecap', 'amount': '1 sdt'},
      {'name': 'Miso pasta (Opsional)', 'amount': '1 sdt'},
      {'name': 'Bawang Merah, haluskan', 'amount': '1 pc'},
      {'name': 'Cabai Merah, iris', 'amount': '1 pc'},
    ];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          ...ingredients.map((ingredient) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ingredient['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  ingredient['amount']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )).toList(),
          // "Lihat Lainnya" button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lihat Lainnya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[400],
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.orange[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEquipmentList() {
    final equipment = [
      'Panci masak',
      'Sendok sop',
      'Talenan',
      'Chopper',
      'Mangkok',
    ];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          ...equipment.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          )).toList(),
          // "Lihat Lainnya" button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lihat Lainnya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[400],
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.orange[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCookingInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1. Persiapan (15 Menit)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...const [
            '- Dalam panci besar, panaskan minyak wijen dengan api sedang.',
            '- Tambahkan bawang putih cincang, jahe parut, dan daun bawang cincang. Tumis selama 2-3 menit hingga harum.',
            '- Tuang kaldu ayam dan didihkan.',
          ].map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          )).toList(),
          // "Lihat Lainnya" button
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lihat Lainnya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[400],
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.orange[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoriesChips() {
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        children: [
          _buildCategoryChip('Makanan Berat', true),
        ],
      ),
    );
  }
  
  Widget _buildTagsChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildCategoryChip('Asian', true),
          const SizedBox(width: 10),
          _buildCategoryChip('Halal', true),
          const SizedBox(width: 10),
          _buildAddChip(),
        ],
      ),
    );
  }
  
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isSelected ? const Color(0xFF83AEB1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAddChip() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.add,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}