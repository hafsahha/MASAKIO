import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masakio/Tambah Resep/tambah_resep3.dart';

class TambahResep2Page extends StatefulWidget {
  const TambahResep2Page({super.key});

  @override
  State<TambahResep2Page> createState() => _TambahResep2PageState();
}

class _TambahResep2PageState extends State<TambahResep2Page> {
  final _currentStep = 1; // Step kedua (indeks 1)
  final _totalSteps = 5;
  
  // List untuk menyimpan bahan
  List<Map<String, dynamic>> bahanList = [
    {'bahan': '', 'kuantitas': 1},
    {'bahan': '', 'kuantitas': 1},
    {'bahan': '', 'kuantitas': 1},
  ];
  
  // List untuk menyimpan alat
  List<Map<String, dynamic>> alatList = [
    {'alat': '', 'kuantitas': 1},
    {'alat': '', 'kuantitas': 1},
  ];

  // Controllers untuk kuantitas
  late List<TextEditingController> bahanQuantityControllers;
  late List<TextEditingController> alatQuantityControllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    bahanQuantityControllers = List.generate(
      bahanList.length,
      (index) => TextEditingController(text: bahanList[index]['kuantitas'].toString())
    );
    
    alatQuantityControllers = List.generate(
      alatList.length,
      (index) => TextEditingController(text: alatList[index]['kuantitas'].toString())
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in bahanQuantityControllers) {
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
      bahanList.add({'bahan': '', 'kuantitas': 1});
      bahanQuantityControllers.add(TextEditingController(text: '1'));
    });
  }

  // Add a new alat with controller
  void addNewAlat() {
    setState(() {
      alatList.add({'alat': '', 'kuantitas': 1});
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
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  borderSide: const BorderSide(color: Color(0xFF83AEB1), width: 1),
                ),
              ),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  borderSide: const BorderSide(color: Color(0xFF83AEB1), width: 1),
                ),
              ),
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

  // New custom quantity field widget with up/down arrows on the right
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            height: 48,
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
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
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the next page (TambahResep3Page)
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