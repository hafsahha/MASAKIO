import 'package:flutter/material.dart';
import 'package:masakio/home.dart';
import 'package:masakio/main_page.dart';
import 'package:provider/provider.dart';
import 'recipe_form_provider.dart';
import 'dart:io';

class ValidasiResepPage extends StatelessWidget {
  const ValidasiResepPage({super.key});
  
  // Helper method to calculate total time from procedures
  int _calculateTotalTime(List<Map<String, dynamic>> procedures) {
    return procedures.fold(0, (sum, procedure) => sum + (procedure['durasi_menit'] as int? ?? 0));
  }

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
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildStepIndicator(),
                ),
              ),              // Video or thumbnail preview
              Consumer<RecipeFormProvider>(
                builder: (context, provider, _) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: provider.thumbnailImage != null
                          ? DecorationImage(
                              image: FileImage(provider.thumbnailImage!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage('assets/images/nasi_goreng.jpeg'),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: provider.videoFile != null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              // Play button for video
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
                            ],
                          )
                        : null,
                  );
                },
              ),
              const SizedBox(height: 20),              // Recipe information sections from provider
              Consumer<RecipeFormProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(
                        'Nama Resep',
                        provider.recipeName,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      
                      _buildInfoSection(
                        'Deskripsi',
                        provider.description,
                      ),

                      _buildInfoSection(
                        'Porsi',
                        '${provider.portions} porsi',
                      ),
                      
                      // Calculate total time based on procedures
                      _buildInfoSection(
                        'Estimasi Waktu',
                        '${_calculateTotalTime(provider.procedures)} menit',
                      ),
                    ],
                  );
                },
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
                    onPressed: () async {
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      try {
                        // Get the provider
                        final provider = Provider.of<RecipeFormProvider>(
                            context,
                            listen: false);

                        // Temporarily hardcode user ID for testing - in a real app, get this from auth
                        provider.setUserId(1);

                        // Submit recipe to backend
                        final result = await provider.submitRecipe();

                        // Close loading dialog
                        Navigator.pop(context);

                        if (result['success']) {
                          // Show success dialog and navigate back to home
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Sukses'),
                              content: const Text('Resep berhasil dipublish!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Clear provider data
                                    provider.resetForm();

                                    // Close dialog
                                    Navigator.pop(context);

                                    // Navigate back to home (or wherever)
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => MainPage(pageIndex: 0,)),
                                      (route) => false,
                                    );

                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Show error dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text(
                                  'Failed to publish recipe: ${result['message']}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        // Close loading dialog
                        Navigator.pop(context);

                        // Show error dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text('An error occurred: $e'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
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
              color: index <= _currentStep
                  ? const Color(0xFF83AEB1)
                  : Colors.grey[300],
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
              color: index < _currentStep
                  ? const Color(0xFF83AEB1)
                  : Colors.grey[300],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content,
      {double fontSize = 16, FontWeight fontWeight = FontWeight.w500}) {
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
  // Updated method to display ingredients from the provider
  Widget _buildIngredientsTable() {
    return Consumer<RecipeFormProvider>(builder: (context, provider, child) {
      if (provider.ingredients.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('No ingredients added',
              style: TextStyle(fontStyle: FontStyle.italic)),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          border: TableBorder.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          children: [
            const TableRow(
              decoration: BoxDecoration(
                color: Color(0xFFE8F3F3),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Bahan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Jumlah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ...provider.ingredients.map((ingredient) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ingredient['nama_bahan'] ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        '${ingredient['jumlah'] ?? 0} ${_getSatuanName(ingredient['id_satuan'])}'),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  String _getSatuanName(int? id) {
    switch (id) {
      case 1:
        return 'gram';
      case 2:
        return 'sdm';
      case 3:
        return 'sdt';
      case 4:
        return 'buah';
      case 5:
        return 'potong';
      case 6:
        return 'siung';
      case 7:
        return 'ml';
      case 8:
        return 'liter';
      case 9:
        return 'cup';
      default:
        return '';
    }
  }

  Widget _buildEquipmentList() {
    return Consumer<RecipeFormProvider>(builder: (context, provider, child) {
      if (provider.tools.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('No equipment added',
              style: TextStyle(fontStyle: FontStyle.italic)),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: provider.tools.map((tool) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    '• ${tool['nama_alat']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${tool['jumlah']} buah)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildCookingInstructions() {
    return Consumer<RecipeFormProvider>(builder: (context, provider, child) {
      if (provider.procedures.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('No procedures added',
              style: TextStyle(fontStyle: FontStyle.italic)),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: provider.procedures.asMap().entries.map((entry) {
            final index = entry.key;
            final procedure = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Procedure title
                if (procedure['nama_prosedur'] != null &&
                    procedure['nama_prosedur'].toString().isNotEmpty)
                  Text(
                    '${index + 1}. ${procedure['nama_prosedur']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                // Procedure steps
                ...((procedure['langkah'] as List?) ?? [])
                    .asMap()
                    .entries
                    .map((entry) {
                  final stepIndex = entry.key;
                  final step = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${stepIndex + 1}. '),
                        Expanded(
                          child: Text(step['nama_langkah'] ?? ''),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildCategoriesChips() {
    return Consumer<RecipeFormProvider>(builder: (context, provider, child) {
      String categoryName = 'Unknown';
      Color chipColor = Colors.grey;

      // Convert category ID to name
      switch (provider.categoryId) {
        case 1:
          categoryName = 'Makanan Berat';
          chipColor = Colors.redAccent;
          break;
        case 2:
          categoryName = 'Minuman';
          chipColor = Colors.blueAccent;
          break;
        case 3:
          categoryName = 'Hidangan Pembuka';
          chipColor = Colors.orangeAccent;
          break;
        case 4:
          categoryName = 'Hidangan Penutup';
          chipColor = Colors.purpleAccent;
          break;
        case 5:
          categoryName = 'Jamu';
          chipColor = Colors.greenAccent;
          break;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text(
                categoryName,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: chipColor,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTagsChips() {
    return Consumer<RecipeFormProvider>(builder: (context, provider, child) {
      if (provider.tags.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('No tags added',
              style: TextStyle(fontStyle: FontStyle.italic)),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      );
    });
  }
}
