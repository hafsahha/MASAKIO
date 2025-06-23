import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'recipe_form_provider.dart';
import 'tambah-resep-3.dart'; // Import the next page
import 'package:dotted_border/dotted_border.dart';

class TambahResep2Page extends StatefulWidget {
  const TambahResep2Page({super.key});

  @override
  State<TambahResep2Page> createState() => _TambahResep2PageState();
}

class _TambahResep2PageState extends State<TambahResep2Page> {
  int _currentStep = 1; // Step kedua (indeks 1)
  final _totalSteps = 5;

  // List untuk menyimpan bahan
  List<Map<String, dynamic>> bahanList = [
    {'bahan': '', 'kuantitas': 1, 'id_satuan': 1},
    {'bahan': '', 'kuantitas': 1, 'id_satuan': 1},
    {'bahan': '', 'kuantitas': 1, 'id_satuan': 1},
  ];

  // List untuk menyimpan alat
  List<Map<String, dynamic>> alatList = [
    {'alat': '', 'kuantitas': 1},
    {'alat': '', 'kuantitas': 1},
  ];

  // Controllers untuk bahan
  late List<TextEditingController> bahanNameControllers;
  late List<TextEditingController> bahanQuantityControllers;

  // Controllers untuk alat
  late List<TextEditingController> alatNameControllers;
  late List<TextEditingController> alatQuantityControllers;

  // Satuan yang tersedia (bisa ditambahkan sesuai kebutuhan)
  final List<Map<String, dynamic>> satuanList = [
    {'id': 1, 'nama': 'Gram'},
    {'id': 2, 'nama': 'Sendok makan'},
    {'id': 3, 'nama': 'Sendok teh'},
    {'id': 4, 'nama': 'Buah'},
    {'id': 5, 'nama': 'Potong'},
    {'id': 6, 'nama': 'Siung'},
    {'id': 7, 'nama': 'ml'},
    {'id': 8, 'nama': 'Liter'},
    {'id': 9, 'nama': 'Cup'},
  ];

  @override
  void initState() {
    super.initState();

    // Load data from provider if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RecipeFormProvider>(context, listen: false);

      if (provider.ingredients.isNotEmpty) {
        setState(() {
          bahanList = provider.ingredients
              .map((item) => {
                    'bahan': item['nama_bahan'] ?? '',
                    'kuantitas': item['jumlah'] ?? 1,
                    'id_satuan': item['id_satuan'] ?? 1
                  })
              .toList();
        });
      }

      if (provider.tools.isNotEmpty) {
        setState(() {
          alatList = provider.tools
              .map((item) => {
                    'alat': item['nama_alat'] ?? '',
                    'kuantitas': item['jumlah'] ?? 1
                  })
              .toList();
        });
      }

      // Initialize controllers
      _initializeControllers();
    });

    // Initialize controllers with default values
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize bahan controllers
    bahanNameControllers = List.generate(
        bahanList.length,
        (index) =>
            TextEditingController(text: bahanList[index]['bahan'].toString()));

    bahanQuantityControllers = List.generate(
        bahanList.length,
        (index) => TextEditingController(
            text: bahanList[index]['kuantitas'].toString()));

    // Initialize alat controllers
    alatNameControllers = List.generate(
        alatList.length,
        (index) =>
            TextEditingController(text: alatList[index]['alat'].toString()));

    alatQuantityControllers = List.generate(
        alatList.length,
        (index) => TextEditingController(
            text: alatList[index]['kuantitas'].toString()));
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in bahanNameControllers) {
      controller.dispose();
    }
    for (var controller in bahanQuantityControllers) {
      controller.dispose();
    }
    for (var controller in alatNameControllers) {
      controller.dispose();
    }
    for (var controller in alatQuantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add a new bahan with controller
  void addNewBahan() {
    setState(() {
      bahanList.add({'bahan': '', 'kuantitas': 1, 'id_satuan': 1});
      bahanNameControllers.add(TextEditingController(text: ''));
      bahanQuantityControllers.add(TextEditingController(text: '1'));
    });
  }

  // Add a new alat with controller
  void addNewAlat() {
    setState(() {
      alatList.add({'alat': '', 'kuantitas': 1});
      alatNameControllers.add(TextEditingController(text: ''));
      alatQuantityControllers.add(TextEditingController(text: '1'));
    });
  }

  // Increment quantity for bahan
  void incrementBahanQuantity(int index) {
    setState(() {
      int currentValue = int.parse(bahanQuantityControllers[index].text);
      currentValue++;
      bahanList[index]['kuantitas'] = currentValue;
      bahanQuantityControllers[index].text = currentValue.toString();
    });
  }

  // Decrement quantity for bahan
  void decrementBahanQuantity(int index) {
    setState(() {
      int currentValue = int.parse(bahanQuantityControllers[index].text);
      if (currentValue > 1) {
        currentValue--;
        bahanList[index]['kuantitas'] = currentValue;
        bahanQuantityControllers[index].text = currentValue.toString();
      }
    });
  }

  // Increment quantity for alat
  void incrementAlatQuantity(int index) {
    setState(() {
      int currentValue = int.parse(alatQuantityControllers[index].text);
      currentValue++;
      alatList[index]['kuantitas'] = currentValue;
      alatQuantityControllers[index].text = currentValue.toString();
    });
  }

  // Decrement quantity for alat
  void decrementAlatQuantity(int index) {
    setState(() {
      int currentValue = int.parse(alatQuantityControllers[index].text);
      if (currentValue > 1) {
        currentValue--;
        alatList[index]['kuantitas'] = currentValue;
        alatQuantityControllers[index].text = currentValue.toString();
      }
    });
  }

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
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 24),
              _buildBahanSection(),
              const SizedBox(height: 24),
              _buildAlatSection(),
              const SizedBox(height: 32),
              _buildContinueButton(),
              const SizedBox(height: 24),
            ],
          ),
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
      ),
    );
  }

  Widget _buildBahanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bahan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(bahanList.length, (index) => _buildBahanRow(index)),
        const SizedBox(height: 8),
        _buildAddButton('Tambahkan bahan baru', addNewBahan),
      ],
    );
  }

  Widget _buildAlatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alat & Perlengkapan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(alatList.length, (index) => _buildAlatRow(index)),
        const SizedBox(height: 8),
        _buildAddButton('Tambahkan peralatan baru', addNewAlat),
      ],
    );
  }

  Widget _buildBahanRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Masukkan bahan',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Adjusted padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF83AEB1), width: 1),
                ),
              ),
              controller: bahanNameControllers[index],
              onChanged: (value) {
                setState(() {
                  bahanList[index]['bahan'] = value;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildQuantityField(
              controller: bahanQuantityControllers[index],
              onIncrement: () => incrementBahanQuantity(index),
              onDecrement: () => decrementBahanQuantity(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlatRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Masukkan peralatan',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Adjusted padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF83AEB1), width: 1),
                ),
              ),
              controller: alatNameControllers[index],
              onChanged: (value) {
                setState(() {
                  alatList[index]['alat'] = value;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildQuantityField(
              controller: alatQuantityControllers[index],
              onIncrement: () => incrementAlatQuantity(index),
              onDecrement: () => decrementAlatQuantity(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityField({
    required TextEditingController controller,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Input field
          Expanded(
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Adjusted padding
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Kuantitas",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Up and Down arrows in a column
          Container(
            width: 32,
            height: 56, // Adjusted height to match new padding
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Up arrow button
                Expanded(
                  child: InkWell(
                    onTap: onIncrement,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                ),

                // Down arrow button
                Expanded(
                  child: InkWell(
                    onTap: onDecrement,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        dashPattern: const [5, 3],
        color: Colors.grey[300]!,
        strokeWidth: 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Update bahan and alat from controllers
          for (int i = 0; i < bahanList.length; i++) {
            bahanList[i]['bahan'] = bahanNameControllers[i].text;
            try {
              bahanList[i]['kuantitas'] =
                  int.parse(bahanQuantityControllers[i].text);
            } catch (e) {
              bahanList[i]['kuantitas'] = 1;
            }
          }

          for (int i = 0; i < alatList.length; i++) {
            alatList[i]['alat'] = alatNameControllers[i].text;
            try {
              alatList[i]['kuantitas'] =
                  int.parse(alatQuantityControllers[i].text);
            } catch (e) {
              alatList[i]['kuantitas'] = 1;
            }
          }

          // Filter out empty entries
          final validBahanList = bahanList
              .where((item) => item['bahan'].toString().trim().isNotEmpty)
              .toList();
          final validAlatList = alatList
              .where((item) => item['alat'].toString().trim().isNotEmpty)
              .toList();

          if (validBahanList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tambahkan minimal satu bahan'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Save to provider
          final provider =
              Provider.of<RecipeFormProvider>(context, listen: false);

          // Convert to format expected by API
          final ingredientsList = validBahanList
              .map((item) => {
                    'nama_bahan': item['bahan'],
                    'jumlah': item['kuantitas'],
                    'id_satuan': item['id_satuan'] ?? 1
                  })
              .toList();

          final toolsList = validAlatList
              .map((item) =>
                  {'nama_alat': item['alat'], 'jumlah': item['kuantitas']})
              .toList();

          // Update the provider
          provider.setIngredients(ingredientsList);
          provider.setTools(toolsList);

          // Navigate to next page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahResep3Page()),
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
    );
  }
}
