import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'recipe_form_provider.dart';
import 'tambah-resep-2.dart';

class TambahResep1Page extends StatefulWidget {
  const TambahResep1Page({super.key});

  @override
  State<TambahResep1Page> createState() => _TambahResep1PageState();
}

class _TambahResep1PageState extends State<TambahResep1Page> {
  int _currentStep = 0;
  final _totalSteps = 5;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _portionsController =
      TextEditingController(text: "1");

  // Variables for video upload
  XFile? _videoFile;
  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  String? _videoError;

  // Variables for thumbnail image
  XFile? _thumbnailFile;
  bool _isThumbnailLoading = false;
  String? _thumbnailError;

  @override
  void initState() {
    super.initState();
    // Initialize form with any existing data from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RecipeFormProvider>(context, listen: false);
      _nameController.text = provider.recipeName;
      _descriptionController.text = provider.description;
      _portionsController.text = provider.portions.toString();
      if (provider.videoFile != null) {
        _videoFile = XFile(provider.videoFile!.path);
        _initializeVideoController(provider.videoFile!);
      }
      if (provider.thumbnailImage != null) {
        _thumbnailFile = XFile(provider.thumbnailImage!.path);
      }
    });
  }

  void _initializeVideoController(File file) {
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _videoError = 'Failed to load video: $error';
        });
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _timeController.dispose();
    _portionsController.dispose();
    super.dispose();
  }

  // Function to pick video from gallery or camera
  Future<void> _pickVideo(ImageSource source) async {
    try {
      setState(() {
        _isVideoLoading = true;
        _videoError = null;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? pickedVideo = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 10), // Optional: set max duration
      );

      if (pickedVideo != null) {
        // Check video size
        final File file = File(pickedVideo.path);
        final int fileSizeInBytes = await file.length();
        final double fileSizeInGB = fileSizeInBytes / (1024 * 1024 * 1024);

        if (fileSizeInGB > 1.0) {
          setState(() {
            _videoError = 'Video size exceeds 1 GB limit';
            _isVideoLoading = false;
          });
          return;
        }

        // Initialize video controller
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {
              _videoFile = pickedVideo;
              _isVideoLoading = false;

              // Auto-extract thumbnail (if needed) - uncomment and implement this
              // if you want to extract a real thumbnail from the video
              /*
              _extractThumbnail(file).then((thumbnailFile) {
                if (thumbnailFile != null) {
                  final provider = Provider.of<RecipeFormProvider>(context, listen: false);
                  provider.setThumbnailImage(thumbnailFile);
                }
              });
              */
            });
          }).catchError((error) {
            setState(() {
              _videoError = 'Failed to load video: $error';
              _isVideoLoading = false;
            });
          });
      } else {
        setState(() {
          _isVideoLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _videoError = 'Error picking video: $e';
        _isVideoLoading = false;
      });
    }
  }

  // Function to show video source selection dialog
  void _showVideoSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.camera);
                },
              ),
              if (_videoFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Video',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _videoController?.dispose();
                      _videoController = null;
                      _videoFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Function to pick thumbnail image from gallery or camera
  Future<void> _pickThumbnail(ImageSource source) async {
    try {
      setState(() {
        _isThumbnailLoading = true;
        _thumbnailError = null;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        // Check image size
        final File file = File(pickedImage.path);
        final int fileSizeInBytes = await file.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5.0) {
          setState(() {
            _thumbnailError = 'Image size exceeds 5 MB limit';
            _isThumbnailLoading = false;
          });
          return;
        }

        setState(() {
          _thumbnailFile = pickedImage;
          _isThumbnailLoading = false;
        });
      } else {
        setState(() {
          _isThumbnailLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _thumbnailError = 'Error picking image: $e';
        _isThumbnailLoading = false;
      });
    }
  }

  // Function to show thumbnail source selection dialog
  void _showThumbnailSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickThumbnail(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickThumbnail(ImageSource.camera);
                },
              ),
              if (_thumbnailFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Image',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _thumbnailFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
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
              _buildVideoUploadSection(),
              const SizedBox(height: 24),
              _buildThumbnailUploadSection(),
              const SizedBox(height: 24),
              _buildRecipeFormSection(),
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
                color: index == _currentStep
                    ? const Color(0xFF83AEB1)
                    : Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: index == _currentStep ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index < _totalSteps - 1)
              Container(
                width: 40,
                height: 1,
                color: Colors.grey[300],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoUploadSection() {
    if (_videoFile != null &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      // Video is uploaded and initialized
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_videoController!.value.isPlaying) {
                        _videoController!.pause();
                      } else {
                        _videoController!.play();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                File(_videoFile!.path).uri.pathSegments.last,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              TextButton(
                onPressed: _showVideoSourceSelector,
                child: const Text('Change Video'),
              ),
            ],
          ),
        ],
      );
    } else {
      // No video or video is loading
      return InkWell(
        onTap: _showVideoSourceSelector,
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey[300]!, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isVideoLoading)
                const CircularProgressIndicator(
                  color: Color(0xFF83AEB1),
                )
              else
                const Icon(
                  Icons.videocam,
                  size: 40,
                  color: Colors.black54,
                ),
              const SizedBox(height: 8),
              Text(
                _isVideoLoading
                    ? 'Loading video...'
                    : (_videoError != null ? 'Upload Error' : 'Upload Video'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _videoError != null ? Colors.red : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _videoError ?? '(Video size limit is 1 GB)',
                style: TextStyle(
                  fontSize: 12,
                  color: _videoError != null ? Colors.red : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildThumbnailUploadSection() {
    if (_thumbnailFile != null) {
      // Thumbnail is uploaded
      return Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Thumbnail Image',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(_thumbnailFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: _showThumbnailSourceSelector,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                File(_thumbnailFile!.path).uri.pathSegments.last,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              TextButton(
                onPressed: () => setState(() => _thumbnailFile = null),
                child: const Text('Remove'),
              ),
            ],
          ),
        ],
      );
    } else {
      // No thumbnail or thumbnail is loading
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thumbnail Image',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _showThumbnailSourceSelector,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isThumbnailLoading)
                    const CircularProgressIndicator(
                      color: Color(0xFF83AEB1),
                    )
                  else
                    const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.black54,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _isThumbnailLoading
                        ? 'Loading image...'
                        : (_thumbnailError != null
                            ? 'Upload Error'
                            : 'Upload Thumbnail'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          _thumbnailError != null ? Colors.red : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _thumbnailError ?? '(Optional, size limit: 5MB)',
                    style: TextStyle(
                      fontSize: 12,
                      color: _thumbnailError != null
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildRecipeFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          label: 'Nama Resep',
          hintText: 'Masukkan nama resepmu',
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama resep tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'Deskripsi',
          hintText: 'Masukkan deskripsi resepmu',
          controller: _descriptionController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Deskripsi tidak boleh kosong';
            }
            return null;
          },
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'Pengeluaran Masak (General)',
          hintText: 'Contoh: Rp100.000',
          controller: _costController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildLabelText('Lama Memasak & Porsi Resep'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextFieldWithoutLabel(
                hintText: 'Contoh: 60 Menit',
                controller: _timeController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextFieldWithoutLabel(
                hintText: 'Jumlah porsi',
                controller: _portionsController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Porsi tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Porsi harus berupa angka > 0';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(label),
        const SizedBox(height: 8),
        _buildTextFieldWithoutLabel(
          hintText: hintText,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildTextFieldWithoutLabel({
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
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
          // Validate data
          if (_nameController.text.isEmpty ||
              _descriptionController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nama resep dan deskripsi tidak boleh kosong'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Get portions as integer
          final portions = int.tryParse(_portionsController.text) ?? 1;
          if (portions < 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Porsi harus lebih dari 0'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Save to provider
          final provider =
              Provider.of<RecipeFormProvider>(context, listen: false);
          provider.setBasicInfo(
            recipeName: _nameController.text,
            description: _descriptionController.text,
            portions: portions,
            videoFile: _videoFile != null ? File(_videoFile!.path) : null,
            thumbnailImage:
                _thumbnailFile != null ? File(_thumbnailFile!.path) : null,
          );

          // Navigate to next page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahResep2Page()),
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
