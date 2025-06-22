import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masakio/data/func_disease.dart'; // Import for Disease model and functions
import 'package:masakio/data/func_profile.dart'; // Add this import for AuthService
import 'package:masakio/Auth/masuk.dart';
import 'package:masakio/main_page.dart';

class DaftarAkunPage extends StatefulWidget {
  const DaftarAkunPage({super.key});

  @override
  State<DaftarAkunPage> createState() => _DaftarAkunPageState();
}

class _DaftarAkunPageState extends State<DaftarAkunPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _riwayatController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  
  final List<String> _riwayatList = [];
  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _obscurePassword = true;
  // Untuk autocomplete
  List<Disease> _allDiseases = []; // Menyimpan semua penyakit dari database
  List<Disease> _suggestedDiseases = []; // Penyakit yang disaring berdasarkan pencarian
  bool _isLoadingDiseases = false;
  final FocusNode _riwayatFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Animasi
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    // Load all diseases immediately when the page is opened
    _fetchDiseases();
    
    // Setup disease suggestions
    _riwayatFocusNode.addListener(() {
      if (_riwayatFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
    
    _riwayatController.addListener(() {
      if (_riwayatFocusNode.hasFocus) {
        if (_riwayatController.text.isNotEmpty) {
          // Filter locally instead of making a new API call
          _filterDiseases(_riwayatController.text);
        } else {
          // Reset to show all diseases
          _resetDiseases();
        }
      }
    });
  }
  
  // Filter diseases locally based on search text
  void _filterDiseases(String query) {
    if (_allDiseases.isEmpty) return;
    
    setState(() {
      if (query.isEmpty) {
        _suggestedDiseases = List.from(_allDiseases);
      } else {
        _suggestedDiseases = _allDiseases
            .where((disease) => disease.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    
    // Update overlay if visible
    if (_overlayEntry != null) {
      _hideOverlay();
      _showOverlay();
    }
  }
  
  // Reset to show all diseases
  void _resetDiseases() {
    setState(() {
      _suggestedDiseases = List.from(_allDiseases);
    });
    
    // Update overlay if visible
    if (_overlayEntry != null) {
      _hideOverlay();
      _showOverlay();
    }
  }  // Fetch all diseases from the database once
  void _fetchDiseases() async {
    setState(() {
      _isLoadingDiseases = true;
    });
    
    try {
      // Import fetchDiseases from functions.dart - fetch all diseases without filter
      final diseases = await fetchDiseases();
      
      if (mounted) {
        setState(() {
          _allDiseases = diseases; // Store all diseases for local filtering
          _suggestedDiseases = diseases; // Initially show all diseases
          _isLoadingDiseases = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDiseases = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load disease suggestions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 110, // Adjusted width to match the field
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 56.0), // Position below the text field
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              constraints: BoxConstraints(
                maxHeight: 200.0, // Limit the height of suggestions
              ),
              child: _isLoadingDiseases
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _suggestedDiseases.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Tidak ada saran penyakit"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _suggestedDiseases.length,
                          itemBuilder: (context, index) {
                            final disease = _suggestedDiseases[index];                            final bool isAlreadySelected = _riwayatList.contains(disease.name);
                            return ListTile(
                              title: Text(disease.name),
                              trailing: isAlreadySelected 
                                  ? const Icon(Icons.check_circle, color: Color(0xFF83AEB1))
                                  : const Icon(Icons.add_circle_outline),
                              onTap: () {
                                // Langsung menambahkan penyakit ketika diklik (tidak perlu set ke text field)
                                _tambahRiwayat(disease.name);
                                // Clear focus setelah item dipilih
                                FocusScope.of(context).unfocus();
                              },
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -2),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                            );
                          },
                        ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
  );

  final OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Color(0xFF83AEB1), width: 2),
  );

  final RegExp emailRegExp = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
  );

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _riwayatController.dispose();
    _tanggalLahirController.dispose();
    _animationController.dispose();
    _riwayatFocusNode.dispose();
    _hideOverlay();
    super.dispose();
  }
  // Menambahkan riwayat penyakit dengan validasi database
  void _tambahRiwayat(String text) {
    final newText = text.trim();
    if (newText.isEmpty) return;
    
    // Jika penyakit sudah ada di list, tidak perlu ditambahkan lagi
    if (_riwayatList.contains(newText)) return;
    
    // Periksa apakah penyakit terdapat dalam database (dari _suggestedDiseases)
    final bool isValidDisease = _suggestedDiseases.any((disease) => disease.name.toLowerCase() == newText.toLowerCase());
    
    if (isValidDisease) {
      setState(() {
        _riwayatList.add(newText);
        _riwayatController.clear();
      });
    } else {
      // Tampilkan pesan jika penyakit tidak ada di database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penyakit tidak terdaftar dalam database. Silakan pilih dari daftar yang tersedia.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF83AEB1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF83AEB1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalLahirController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon pilih tanggal lahir'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (_riwayatList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Minimal 1 riwayat penyakit harus diisi'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final user = await AuthService.register(
          name: _namaController.text,
          email: _emailController.text,
          password: _passwordController.text,
          birthDate: _selectedDate?.toString(),
          diseases: _riwayatList.map((disease) => _allDiseases.firstWhere((d) => d.name == disease).id).toList(), // Send disease IDs
        );

        // Add disease history for each disease in the list
        if (_riwayatList.isNotEmpty) for (final disease in _riwayatList) { await addDiseaseHistory(user.id, disease); }

        if (mounted) {
          setState(() => _isLoading = false);

          // Navigate to profile page after successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage(pageIndex: 3)),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Registrasi Gagal"),
              content: Text("$e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF83AEB1),
                  ),
                  child: const Text("OK"),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }
      }
    }
  }

  // Memeriksa apakah teks yang dimasukkan terdapat dalam database penyakit
  bool _isValidInput() {
    final inputText = _riwayatController.text.trim();
    if (inputText.isEmpty) return false;
    
    return _allDiseases.any(
      (disease) => disease.name.toLowerCase() == inputText.toLowerCase()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image dengan gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/daftar.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0x4D000000),
                    const Color(0xB3000000),
                  ],
                ),
              ),
            ),
          ),
          
          // Main content dengan animasi
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo atau icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0x33FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.app_registration_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title dengan typography lebih bagus
                    const Text(
                      "Daftar Akun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Bergabunglah dengan MASAKIO",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Form scrollable yang lebih estetik
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildLabel("Nama Lengkap", true),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _namaController,
                                  decoration: _buildInputDecoration(
                                    "Masukkan nama lengkap", 
                                    Icons.person_outline
                                  ),
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty ? 'Nama wajib diisi' : null,
                                ),
                                const SizedBox(height: 20),

                                _buildLabel("Email", true),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _buildInputDecoration(
                                    "Masukkan email", 
                                    Icons.email_outlined
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email wajib diisi';
                                    }
                                    if (!emailRegExp.hasMatch(value.trim())) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                _buildLabel("Tanggal Lahir", true),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _tanggalLahirController,
                                  readOnly: true,
                                  onTap: _pickDate,
                                  decoration: InputDecoration(
                                    hintText: "Pilih tanggal lahir",
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF83AEB1)),
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: focusedBorder,
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  ),
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty ? 'Tanggal lahir wajib diisi' : null,
                                ),
                                const SizedBox(height: 20),

                                _buildLabel("Riwayat Penyakit", false),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CompositedTransformTarget(
                                        link: _layerLink,                                          child: TextFormField(
                                          controller: _riwayatController,
                                          focusNode: _riwayatFocusNode,
                                          decoration: InputDecoration(
                                            hintText: "Pilih dari daftar penyakit",
                                            hintStyle: TextStyle(color: Colors.grey.shade400),
                                            prefixIcon: const Icon(Icons.medical_information_outlined, color: Color(0xFF83AEB1)),
                                            border: border,
                                            enabledBorder: border,
                                            focusedBorder: focusedBorder,
                                            filled: true,
                                            fillColor: const Color(0xFFF9FAFB),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            helperText: "Hanya penyakit dalam database yang dapat dipilih",
                                            helperStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          onFieldSubmitted: (value) {
                                            if (_isValidInput()) {
                                              _tambahRiwayat(value);
                                              _hideOverlay();
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Silakan pilih penyakit dari daftar yang tersedia'),
                                                  backgroundColor: Colors.red,
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        color: _isValidInput() ? const Color(0xFF83AEB1) : Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white, size: 24),
                                        onPressed: _isValidInput() 
                                          ? () {
                                              _tambahRiwayat(_riwayatController.text);
                                              _hideOverlay();
                                            }
                                          : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (_riwayatList.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F7F7),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFD0E6E6)),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _riwayatList
                                            .map(
                                              (e) => Chip(
                                                label: Text(
                                                  e,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                deleteIcon: const Icon(Icons.close, color: Colors.white, size: 18),
                                                onDeleted: () {
                                                  setState(() {
                                                    _riwayatList.remove(e);
                                                  });
                                                },
                                                backgroundColor: const Color(0xFF83AEB1),
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                side: BorderSide.none,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                
                                _buildLabel("Kata Sandi", true),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: "Masukkan kata sandi",
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF83AEB1)),
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: focusedBorder,
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: const Color(0xFF83AEB1),
                                      ),
                                      onPressed: () {
                                        setState(() => _obscurePassword = !_obscurePassword);
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Kata sandi wajib diisi';
                                    }
                                    if (value.length < 6) {
                                      return 'Minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                // Password hint
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Kata sandi harus minimal 6 karakter",
                                    style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Desain bottom navigation bar yang lebih menarik
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x20000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF83AEB1),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83AEB1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                      shadowColor: const Color(0x8083AEB1),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1.5,
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "atau",
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1.5,
                  )
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sudah punya akun? ",
                  style: TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Color(0xFF83AEB1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isRequired) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Color(0xFF444444),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: const Color(0xFF83AEB1)),
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
