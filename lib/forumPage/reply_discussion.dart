import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../components/custom_button.dart';

class ReplyBottomSheet extends StatefulWidget {
  final Function(String, File?)? onReply;

  const ReplyBottomSheet({
    super.key,
    this.onReply,
  });

  @override
  State<ReplyBottomSheet> createState() => _ReplyBottomSheetState();
}

class _ReplyBottomSheetState extends State<ReplyBottomSheet> {
  final TextEditingController _replyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Balas Diskusi',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Reply text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _replyController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Tulis balasan Anda di sini...',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Image Upload Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambahkan Gambar (Opsional)',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, color: Colors.grey[400], size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap untuk memilih gambar',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Display',
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Gambar dipilih',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: 'Kirim Balasan',
                onPressed: () {
                  final replyText = _replyController.text.trim();
                  if (replyText.isNotEmpty) {
                    if (widget.onReply != null) {
                      widget.onReply!(replyText, _selectedImage);
                    }
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Balasan tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
