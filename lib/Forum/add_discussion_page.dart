import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masakio/.components/button.dart';

class AddDiscussionBottomSheet extends StatefulWidget {
  final Function(String, File?)? onAddDiscussion;
  
  const AddDiscussionBottomSheet({
    super.key, 
    this.onAddDiscussion
  });

  @override
  State<AddDiscussionBottomSheet> createState() => _AddDiscussionBottomSheetState();
}

class _AddDiscussionBottomSheetState extends State<AddDiscussionBottomSheet> {
  final TextEditingController _detailController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isImageAreaPressed = false;

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
    _detailController.dispose();
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
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Text(
                      'Tuliskan hal yang anda ingin diskusikan',
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
              
              // Isi Diskusi label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  'Isi Diskusi',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              
              // Textarea for details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _detailController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan detail hal yang ingin anda sampaikan',
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
                    GestureDetector(
                      onTap: _pickImage,
                      onTapDown: (_) {
                        setState(() {
                          _isImageAreaPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isImageAreaPressed = false;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isImageAreaPressed = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _isImageAreaPressed ? Colors.grey[300] : Colors.grey[100],
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
              
              // Add Discussion Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Button(
                  content: 'Tambahkan Diskusi',
                  onPressed: () {
                    if (_detailController.text.isNotEmpty) {
                      if (widget.onAddDiscussion != null) widget.onAddDiscussion!(_detailController.text, _selectedImage);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Isi diskusi tidak boleh kosong'),
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
      ),
    );
  }
}

// Helper method to show the bottom sheet
void showAddDiscussionSheet(BuildContext context, {Function(String, File?)? onAddDiscussion}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddDiscussionBottomSheet(onAddDiscussion: onAddDiscussion),
  );
}