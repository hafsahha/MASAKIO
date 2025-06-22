import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/data/func_forum.dart';

class AddDiscussionBottomSheet extends StatefulWidget {  
  final Function() onRefresh;
  const AddDiscussionBottomSheet({super.key, required this.onRefresh});

  @override
  State<AddDiscussionBottomSheet> createState() => _AddDiscussionBottomSheetState();
}

class _AddDiscussionBottomSheetState extends State<AddDiscussionBottomSheet> {
  final TextEditingController _detailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _isImageAreaPressed = false;
  bool _isLoading = false;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }


  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() =>_isLoading = true);

      try {
        await addForumPost(_detailController.text.trim(), _selectedImage);
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pop(context);
          widget.onRefresh();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);

          String errorMessage = e.toString();
          if (errorMessage.contains('Exception: ')) errorMessage = errorMessage.replaceFirst('Exception: ', '');

          bool hasInternetConnection = false;
          try {
            final result = await HttpClient().getUrl(Uri.parse('https://www.google.com')).then((req) => req.close());
            hasInternetConnection = result.statusCode == 200;
          } catch (_) { hasInternetConnection = false; }

          if (mounted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Gagal"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(errorMessage),
                    if (!hasInternetConnection)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Sepertinya Anda tidak terhubung ke internet. Silakan periksa koneksi internet Anda.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      }
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
                        fontFamily: 'montserrat',
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email field label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Isi Diskusi',
                          style: TextStyle(
                            fontFamily: 'montserrat',
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _detailController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Masukkan detail hal yang ingin anda sampaikan',
                          hintStyle: TextStyle(
                            fontFamily: 'montserrat',
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF83AEB1)),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Isi diskusi wajib diisi";
                          if (v.trim().length < 10) return "Isi diskusi minimal 10 karakter";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Image Upload Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tambahkan Gambar (Opsional)',
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      onTapDown: (_) => setState(() => _isImageAreaPressed = true),
                      onTapUp: (_) => setState(() => _isImageAreaPressed = false),
                      onTapCancel: () => setState(() => _isImageAreaPressed = false),
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
                                      fontFamily: 'montserrat',
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
                              fontFamily: 'montserrat',
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
                                fontFamily: 'montserrat',
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
              _isLoading
              ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Button(
                  content: 'Tambahkan Diskusi',
                  onPressed: _submit,
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
void showAddDiscussionSheet(BuildContext context, Function() onRefresh) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddDiscussionBottomSheet(onRefresh: onRefresh),
  );
}