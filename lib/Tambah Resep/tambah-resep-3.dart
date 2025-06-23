import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'recipe_form_provider.dart';
import 'tambah-resep-4.dart';

class TambahResep3Page extends StatefulWidget {
  const TambahResep3Page({super.key});

  @override
  State<TambahResep3Page> createState() => _TambahResep3PageState();
}

class _TambahResep3PageState extends State<TambahResep3Page> {
  int _currentStep = 2;
  final _totalSteps = 5;

  final TextEditingController _firstSubtitleController =
      TextEditingController();
  final TextEditingController _secondSubtitleController =
      TextEditingController();

  List<Map<String, dynamic>> firstInstructionsList = [
    {'instruction': '', 'subTitle': ''},
    {'instruction': '', 'subTitle': ''},
  ];

  List<Map<String, dynamic>> secondInstructionsList = [
    {'instruction': '', 'subTitle': ''},
  ];

  late List<TextEditingController> firstInstructionControllers;
  late List<TextEditingController> secondInstructionControllers;

  @override
  void initState() {
    super.initState();
    firstInstructionControllers = List.generate(
        firstInstructionsList.length, (index) => TextEditingController());

    secondInstructionControllers = List.generate(
        secondInstructionsList.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
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

  void addNewFirstInstruction() {
    setState(() {
      firstInstructionsList.add({'instruction': '', 'subTitle': ''});
      firstInstructionControllers.add(TextEditingController());
    });
  }

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
        InkWell(
          onTap: () => _showSubtitleDialog(context, true),
          child: Text(
            _firstSubtitleController.text.isEmpty
                ? 'Tambahkan subjudul'
                : _firstSubtitleController.text,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF83AEB1),
              fontWeight: _firstSubtitleController.text.isEmpty
                  ? FontWeight.normal
                  : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: firstInstructionsList.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
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
                true);
          },
        ),
        const SizedBox(height: 8),
        _buildAddButton('Tambahkan instruksi baru', addNewFirstInstruction),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _showSubtitleDialog(context, false),
          child: Text(
            _secondSubtitleController.text.isEmpty
                ? 'Tambahkan subjudul'
                : _secondSubtitleController.text,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF83AEB1),
              fontWeight: _secondSubtitleController.text.isEmpty
                  ? FontWeight.normal
                  : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: secondInstructionsList.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = secondInstructionsList.removeAt(oldIndex);
              secondInstructionsList.insert(newIndex, item);
              final controller =
                  secondInstructionControllers.removeAt(oldIndex);
              secondInstructionControllers.insert(newIndex, controller);
            });
          },
          itemBuilder: (context, index) {
            return _buildDraggableInstructionRow(
                index,
                Key('second-$index'),
                secondInstructionControllers[index],
                secondInstructionsList,
                false);
          },
        ),
        const SizedBox(height: 8),
        _buildAddButton('Tambahkan instruksi baru', addNewSecondInstruction),
      ],
    );
  }

  Widget _buildDraggableInstructionRow(
      int index,
      Key key,
      TextEditingController controller,
      List<Map<String, dynamic>> instructionsList,
      bool isFirstList) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: GestureDetector(
              onTap: () => _deleteInstruction(index, isFirstList),
              child: Container(
                width: 40,
                height: 56, // Increased height
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
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16), // Increased padding
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
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const SizedBox(
              width: 40,
              height: 56, // Increased height
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
              const Icon(Icons.add, size: 20, color: Colors.grey),
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
          // Prepare procedures data for provider
          final List<Map<String, dynamic>> procedures = [];

          // Process first instruction set if it has content
          if (_firstSubtitleController.text.isNotEmpty) {
            final steps = [];
            for (int i = 0; i < firstInstructionsList.length; i++) {
              final instruction = firstInstructionControllers[i].text.trim();
              if (instruction.isNotEmpty) {
                steps.add({'nama_langkah': instruction, 'urutan': i + 1});
              }
            }

            if (steps.isNotEmpty) {
              procedures.add({
                'nama_prosedur': _firstSubtitleController.text,
                'durasi_menit': 0, // We're not tracking this now
                'langkah': steps
              });
            }
          }

          // Process second instruction set if it has content
          if (_secondSubtitleController.text.isNotEmpty) {
            final steps = [];
            for (int i = 0; i < secondInstructionsList.length; i++) {
              final instruction = secondInstructionControllers[i].text.trim();
              if (instruction.isNotEmpty) {
                steps.add({'nama_langkah': instruction, 'urutan': i + 1});
              }
            }

            if (steps.isNotEmpty) {
              procedures.add({
                'nama_prosedur': _secondSubtitleController.text,
                'durasi_menit': 0,
                'langkah': steps
              });
            }
          }

          if (procedures.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tambahkan minimal satu prosedur memasak'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Save to provider
          final provider =
              Provider.of<RecipeFormProvider>(context, listen: false);
          provider.setProcedures(procedures);

          // Navigate to next step
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

  void _showSubtitleDialog(BuildContext context, bool isFirstSubtitle) {
    TextEditingController tempController = TextEditingController(
        text: isFirstSubtitle
            ? _firstSubtitleController.text
            : _secondSubtitleController.text);

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

  void _deleteInstruction(int index, bool isFirstList) {
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
}
