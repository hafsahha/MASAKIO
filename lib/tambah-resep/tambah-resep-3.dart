import 'package:flutter/material.dart';
import 'package:capi/tambah-resep/tambah-resep-4.dart'; // Import the TambahResep4Page

class TambahResep3Page extends StatefulWidget {
  const TambahResep3Page({super.key});

  @override
  State<TambahResep3Page> createState() => _TambahResep3PageState();
}

class _TambahResep3PageState extends State<TambahResep3Page> {
  int _currentStep = 2; // Step ketiga (indeks 2)
  final _totalSteps = 5;

  // Controller untuk subjudul
  final TextEditingController _firstSubtitleController = TextEditingController();
  final TextEditingController _secondSubtitleController = TextEditingController();

  // List untuk menyimpan instruksi memasak dan subjudul, dipisahkan menjadi dua bagian
  List<Map<String, dynamic>> firstInstructionsList = [
    {'instruction': '', 'subTitle': ''},
    {'instruction': '', 'subTitle': ''},
  ];

  List<Map<String, dynamic>> secondInstructionsList = [
    {'instruction': '', 'subTitle': ''},
  ];

  // Controllers untuk instruksi
  late List<TextEditingController> firstInstructionControllers;
  late List<TextEditingController> secondInstructionControllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for both instruction lists
    firstInstructionControllers = List.generate(
      firstInstructionsList.length,
      (index) => TextEditingController()
    );
    
    secondInstructionControllers = List.generate(
      secondInstructionsList.length,
      (index) => TextEditingController()
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in firstInstructionControllers) {
      controller.dispose();
    }
    for (var controller in secondInstructionControllers) {
      controller.dispose();
    }
    _firstSubtitleController.dispose();
    _secondSubtitleController.dispose();
    super.dispose();
  }

  // Add a new instruction to the first list
  void addNewFirstInstruction() {
    setState(() {
      firstInstructionsList.add({'instruction': '', 'subTitle': ''});
      firstInstructionControllers.add(TextEditingController());
    });
  }

  // Add a new instruction to the second list
  void addNewSecondInstruction() {
    setState(() {
      secondInstructionsList.add({'instruction': '', 'subTitle': ''});
      secondInstructionControllers.add(TextEditingController());
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
        // First "Tambahkan subjudul" clickable text
        InkWell(
          onTap: () {
            // Show dialog to add subtitle
            _showSubtitleDialog(context, true);
          },
          child: Text(
            _firstSubtitleController.text.isEmpty ? 'Tambahkan subjudul' : _firstSubtitleController.text,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF83AEB1),
              fontWeight: _firstSubtitleController.text.isEmpty ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // First set of instructions with ReorderableListView
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: firstInstructionsList.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = firstInstructionsList.removeAt(oldIndex);
              firstInstructionsList.insert(newIndex, item);
              
              final controller = firstInstructionControllers.removeAt(oldIndex);
              firstInstructionControllers.insert(newIndex, controller);
            });
          },
          itemBuilder: (context, index) {
            return _buildDraggableInstructionRow(
              index, 
              Key('first-$index'),
              firstInstructionControllers[index],
              firstInstructionsList,
              true
            );
          },
        ),
        
        const SizedBox(height: 8),
        // Add button for first instruction set
        _buildAddButton('Tambahkan instruksi baru', addNewFirstInstruction),
        
        const SizedBox(height: 16),
        
        // Second "Tambahkan subjudul" clickable text
        InkWell(
          onTap: () {
            // Show dialog to add subtitle
            _showSubtitleDialog(context, false);
          },
          child: Text(
            _secondSubtitleController.text.isEmpty ? 'Tambahkan subjudul' : _secondSubtitleController.text,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF83AEB1),
              fontWeight: _secondSubtitleController.text.isEmpty ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Second set of instructions with ReorderableListView
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: secondInstructionsList.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = secondInstructionsList.removeAt(oldIndex);
              secondInstructionsList.insert(newIndex, item);
              
              final controller = secondInstructionControllers.removeAt(oldIndex);
              secondInstructionControllers.insert(newIndex, controller);
            });
          },
          itemBuilder: (context, index) {
            return _buildDraggableInstructionRow(
              index, 
              Key('second-$index'),
              secondInstructionControllers[index],
              secondInstructionsList,
              false
            );
          },
        ),
        
        const SizedBox(height: 8),
        // Add button for second instruction set
        _buildAddButton('Tambahkan instruksi baru', addNewSecondInstruction),
      ],
    );
  }

  void _showSubtitleDialog(BuildContext context, bool isFirstSubtitle) {
    TextEditingController tempController = TextEditingController(
      text: isFirstSubtitle 
          ? _firstSubtitleController.text 
          : _secondSubtitleController.text
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambahkan Subjudul'),
        content: TextField(
          controller: tempController,
          decoration: const InputDecoration(
            hintText: 'Masukkan subjudul',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (isFirstSubtitle) {
                  _firstSubtitleController.text = tempController.text;
                } else {
                  _secondSubtitleController.text = tempController.text;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Function to delete instruction
  void _deleteInstruction(int index, bool isFirstList) {
    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Instruksi'),
        content: const Text('Apakah Anda yakin ingin menghapus instruksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (isFirstList) {
                  if (firstInstructionsList.length > 1) {
                    firstInstructionsList.removeAt(index);
                    firstInstructionControllers.removeAt(index).dispose();
                  }
                } else {
                  if (secondInstructionsList.length > 1) {
                    secondInstructionsList.removeAt(index);
                    secondInstructionControllers.removeAt(index).dispose();
                  }
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableInstructionRow(
    int index, 
    Key key, 
    TextEditingController controller,
    List<Map<String, dynamic>> instructionsList,
    bool isFirstList
  ) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon delete di ujung kiri yang juga berfungsi sebagai ReorderableDragStartListener
          ReorderableDragStartListener(
            index: index,
            child: GestureDetector(
              onTap: () {
                // Delete instruction when left icon is tapped
                _deleteInstruction(index, isFirstList);
              },
              child: Container(
                width: 40,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          
          // Text field tanpa border kanan karena ada tombol delete
          Expanded(
            child: TextField(
              controller: controller,
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
          
          // Garis 2 (drag handle) di ujung kanan
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: SizedBox(
              width: 40,
              height: 48,
              
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
          // Navigate to the next page (Step 4)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahResep4Page()),
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