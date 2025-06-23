import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'tips_validation.dart'; // Pastikan path ini benar

class TambahTipsPage extends StatefulWidget {
  const TambahTipsPage({super.key});

  @override
  State<TambahTipsPage> createState() => _TambahTipsPageState();
}

class _TambahTipsPageState extends State<TambahTipsPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();
  final List<String> _hashtags = [];

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    print('[TambahTipsPage] initState called.'); // Debug log
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    _hashtagController.dispose();
    print('[TambahTipsPage] dispose called. Controllers disposed.'); // Debug log
    super.dispose();
  }

  Future<void> _pickImage() async {
    print('[TambahTipsPage] _pickImage() called. Opening image picker.'); // Debug log
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      print('[TambahTipsPage] Image picked successfully. Image bytes length: ${_imageBytes?.length}'); // Debug log
    } else {
      print('[TambahTipsPage] Image picking cancelled.'); // Debug log
    }
  }

  // Fungsi untuk menambahkan hashtag
  void _addHashtag() {
    final tag = _hashtagController.text.trim();
    print('[TambahTipsPage] Attempting to add hashtag: "$tag"'); // Debug log
    if (tag.isNotEmpty && !_hashtags.contains(tag)) {
      setState(() {
        _hashtags.add(tag);
        _hashtagController.clear();
      });
      print('[TambahTipsPage] Hashtag added: "$tag". Current hashtags: $_hashtags'); // Debug log
    } else if (tag.isEmpty) {
      print('[TambahTipsPage] Hashtag not added: Input is empty.'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hashtag tidak boleh kosong.')),
      );
    } else if (_hashtags.contains(tag)) {
      print('[TambahTipsPage] Hashtag not added: "$tag" already exists.'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hashtag "$tag" sudah ada.')),
      );
    }
  }

  // Fungsi untuk menghapus hashtag
  void _removeHashtag(String tag) {
    setState(() {
      _hashtags.remove(tag);
    });
    print('[TambahTipsPage] Hashtag removed: "$tag". Current hashtags: $_hashtags'); // Debug log
  }


  void _lanjutkan() {
    print('[TambahTipsPage] _lanjutkan() button pressed.'); // Debug log
    print('[TambahTipsPage] Validating inputs...'); // Debug log
    print('  _imageBytes is null: ${_imageBytes == null}');
    print('  _judulController.text.isNotEmpty: ${_judulController.text.isNotEmpty}');
    print('  _isiController.text.isNotEmpty: ${_isiController.text.isNotEmpty}');
    print('  _hashtags.isNotEmpty: ${_hashtags.isNotEmpty}');

    if (_imageBytes != null &&
        _judulController.text.isNotEmpty &&
        _isiController.text.isNotEmpty &&
        _hashtags.isNotEmpty) {
      print('[TambahTipsPage] All inputs are valid. Navigating to TipsValidationPage.'); // Debug log
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TipsValidationPage(
            judul: _judulController.text,
            isi: _isiController.text,
            hashtags: _hashtags,
            imageBytes: _imageBytes!,
          ),
        ),
      );
    } else {
      print('[TambahTipsPage] Validation failed. Showing snackbar.'); // Debug log
      String errorMessage = 'Harap lengkapi semua data:';
      if (_imageBytes == null) errorMessage += '\n- Gambar Cover';
      if (_judulController.text.isEmpty) errorMessage += '\n- Judul Tips & Trik';
      if (_isiController.text.isEmpty) errorMessage += '\n- Isi Tips & Trik';
      if (_hashtags.isEmpty) errorMessage += '\n- Setidaknya satu Hashtag';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[TambahTipsPage] Building widget.'); // Debug log
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () {
                print('[TambahTipsPage] Back button pressed.'); // Debug log
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Buat Tips dan Trik Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload, size: 32, color: Colors.black54),
                          SizedBox(height: 8),
                          Text('Unggah Cover', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                            '(Unggah gambar yang relevan dan menarik)',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Judul Tips & Trik', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildTextField(controller: _judulController, hint: 'Contoh: Tips Menyimpan Kentang'),
            const SizedBox(height: 16),
            const Text('Isi Tips & Trik', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildTextField(controller: _isiController, hint: 'Masukkan detail tips dan trik', maxLines: 5),
            const SizedBox(height: 16),
            const Text('Hashtag', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _hashtagController,
                    hint: 'Contoh: Sayuran',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF83AEB1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addHashtag, // Panggil fungsi _addHashtag
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Bagian menampilkan Chip hashtag yang telah ditambahkan
            Wrap(
              spacing: 8,
              children: _hashtags
                  .map((tag) {
                    print('[TambahTipsPage] Displaying hashtag chip: "$tag"'); // Debug log for each chip
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _removeHashtag(tag), // Panggil fungsi _removeHashtag
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _lanjutkan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF83AEB1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
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
    );
  }
}