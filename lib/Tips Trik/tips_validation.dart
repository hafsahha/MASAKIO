import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:masakio/data/func_tips.dart';
import 'package:masakio/data/func_profile.dart';

class TipsValidationPage extends StatefulWidget {
  final String judul;
  final String isi;
  final List<String> hashtags;
  final Uint8List imageBytes;

  const TipsValidationPage({
    super.key,
    required this.judul,
    required this.isi,
    required this.hashtags,
    required this.imageBytes,
  });

  @override
  State<TipsValidationPage> createState() => _TipsValidationPageState();
}

class _TipsValidationPageState extends State<TipsValidationPage> {
  bool _isLoading = false;

  Future<void> _submitTips() async {
    setState(() {
      _isLoading = true;
    });

    final user = await AuthService.getCurrentUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendapatkan data user')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    // Upload gambar ke Cloudinary
    String? imageUrl;
    try {
      imageUrl = await uploadImageToCloudinary(widget.imageBytes);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal upload gambar ke Cloudinary')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    // Submit data tips ke backend
    final success = await addTips(
      title: widget.judul,
      description: widget.isi,
      hashtags: widget.hashtags,
      imageUrl: imageUrl,
      userId: user.id,
    );
    

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tips berhasil disimpan!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan tips.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Validasi Tips & Trik',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                widget.imageBytes,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Judul', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.judul, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Isi Tips', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.isi, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Text('Hashtag', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: widget.hashtags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: const Color(0xFF83AEB1),
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitTips,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF83AEB1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Simpan Tips',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
