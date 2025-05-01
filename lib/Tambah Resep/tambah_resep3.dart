import 'package:flutter/material.dart';

class TambahResep3Page extends StatefulWidget {
  const TambahResep3Page({super.key});

  @override
  State<TambahResep3Page> createState() => _TambahResep3PageState();
}

class _TambahResep3PageState extends State<TambahResep3Page> {
  final _currentStep = 2; // Step ketiga (indeks 2)
  final _totalSteps = 5;

  // List untuk menyimpan instruksi memasak
  List<Map<String, dynamic>> instructionsList = [
    {'instruction': '', 'subTitle': ''},
    {'instruction': '', 'subTitle': ''},
    {'instruction': '', 'subTitle': ''},
    {'instruction': '', 'subTitle': ''},
    {'instruction': '', 'subTitle': ''},
  ];

  // Controllers untuk instruksi
  late List<TextEditingController> instructionControllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    instructionControllers = List.generate(
      instructionsList.length,
      (index) => TextEditingController()
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in instructionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add a new instruction with controller
  void addNewInstruction() {
    setState(() {
      instructionsList.add({'instruction': '', 'subTitle': ''});
      instructionControllers.add(TextEditingController());
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
              _buildInstructionsSection(),
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

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cara Memasak',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tambahkan subjudul',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF83AEB1),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(instructionsList.length, (index) => _buildInstructionRow(index)),
        const SizedBox(height: 8),
        _buildAddButton('Tambahkan instruksi baru', addNewInstruction),
      ],
    );
  }

  Widget _buildInstructionRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Number icon on the left
            Container(
              width: 36,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.grid_3x3,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
            // Text field
            Expanded(
              child: TextFormField(
                controller: instructionControllers[index],
                decoration: InputDecoration(
                  hintText: 'Masukkan instruksi',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    instructionsList[index]['instruction'] = value;
                  });
                },
              ),
            ),
          ],
        ),
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
          // Navigasi ke halaman berikutnya (Step 4)
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const TambahResep4Page()),
          // );
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