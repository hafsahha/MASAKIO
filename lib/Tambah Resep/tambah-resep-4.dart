import 'package:flutter/material.dart';
import 'validasi-resep.dart';

// This file should be saved as 'tambah_resep_4.dart'
class TambahResep4Page extends StatefulWidget {
  const TambahResep4Page({super.key});

  @override
  State<TambahResep4Page> createState() => _TambahResep4PageState();
}

class _TambahResep4PageState extends State<TambahResep4Page> {
  int _currentStep = 3; // Step keempat (indeks 3)
  final _totalSteps = 5;

  // Kategori yang dipilih
  String? _selectedCategory;

  // List kategori
  final List<String> _categories = [
    'Makanan Berat',
    'Minuman',
    'Hidangan Pembuka',
    'Hidangan Penutup',
    'Jamu',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Buat Resep Baru',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: 24),
                    _buildCategorySection(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(
              
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
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
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        // Search box
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari Kategori',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Category list
        ..._categories.map((category) => _buildCategoryItem(category)),
      ],
    );
  }

  Widget _buildCategoryItem(String category) {
    final bool isSelected = _selectedCategory == category;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          category,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

Widget _buildBottomButton() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, -3),
        ),
      ],
    ),
    child: SafeArea(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Validasi Resep page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ValidasiResepPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF83AEB1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Lanjutkan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}
}