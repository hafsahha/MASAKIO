import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masakio/.components/bottom_popup.dart';
import 'package:masakio/.components/user_avatar.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/data/func_disease.dart'; // Add import for disease functions

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController(text: 'Kucing Sedih');
  final _emailController = TextEditingController(text: 'tungtungtung@gmail.com');
  final _passwordController = TextEditingController();
  final _tanggalLahirController = TextEditingController(text: '23/05/1995');
  final List<String> _riwayatList = ['Alergi Kacang'];
  DateTime? _selectedDate;
  bool _obscurePassword = true;
    // For disease search and selection
  final TextEditingController _searchController = TextEditingController();
  List<Disease> _allDiseases = [];
  List<Disease> _filteredDiseases = [];
  bool _isLoadingDiseases = false;

  // ID pengguna dari session/login
  final int _userId = 1; // TODO: Ganti dengan ID pengguna yang sesungguhnya dari session

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _tanggalLahirController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 5, 23),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalLahirController.text =
            DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Data berhasil disimpan.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }  void _showAddRiwayatModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BottomPopup(
              children: [
                const Text(
                  "Tambahkan Riwayat Penyakit",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Text(
                  "Pilih dari daftar penyakit yang tersedia:",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari penyakit...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setModalState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setModalState(() {
                      _filterDiseases(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Disease list
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: _isLoadingDiseases
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredDiseases.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty 
                              ? "Tidak ada penyakit tersedia" 
                              : "Tidak ada penyakit yang sesuai",
                            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredDiseases.length,
                          itemBuilder: (context, index) {
                            final disease = _filteredDiseases[index];
                            final bool isSelected = _riwayatList.contains(disease.name);
                              return ListTile(
                              dense: true,
                              title: Text(disease.name),
                              trailing: isSelected 
                                ? const Icon(Icons.check_circle, color: Color(0xFF83AEB1)) 
                                : const Icon(Icons.add_circle_outline),
                              onTap: () async {
                                if (isSelected) {
                                  // Hapus dari database dan UI
                                  await _removeDiseaseFromHistory(disease.name);
                                  
                                  setModalState(() {
                                    setState(() {
                                      _riwayatList.remove(disease.name);
                                    });
                                  });
                                } else {
                                  // Tambahkan ke database dan UI
                                  await _addDiseaseToHistory(disease);
                                  
                                  setModalState(() {
                                    setState(() {
                                      if (!_riwayatList.contains(disease.name)) {
                                        _riwayatList.add(disease.name);
                                      }
                                    });
                                  });
                                }
                              },
                            );
                          },
                        ),
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 8),
                
                // Selected diseases section
                const Text(
                  "Penyakit yang Anda pilih:",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _riwayatList.isEmpty
                    ? [
                        Text(
                          "Belum ada penyakit yang dipilih",
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                        )
                      ]
                    : _riwayatList
                        .map((item) => RawChip(
                              label: Text(
                                item,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: const Color(0xFF83AEB1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              deleteIcon: const Icon(Icons.close, color: Colors.white, size: 18),                                onDeleted: () async {
                                  // Hapus dari database dan UI
                                  await _removeDiseaseFromHistory(item);
                                  
                                  setModalState(() {
                                    setState(() {
                                      _riwayatList.remove(item);
                                    });
                                  });
                                },
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              side: BorderSide.none,
                            ))
                        .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Button(
                    content: "Selesai",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.grey),
  );  @override
  void initState() {
    super.initState();
    
    // Load all diseases when initializing
    _loadAllDiseases();
    
    // Load user's disease history
    _loadDiseaseHistory();
    
    // Set up listener for search filtering
    _searchController.addListener(() {
      _filterDiseases(_searchController.text);
    });
  }
  
  // Load user's disease history
  Future<void> _loadDiseaseHistory() async {
    try {
      final diseases = await getDiseaseHistory(_userId);
      
      if (mounted) {
        setState(() {
          _riwayatList.clear();
          for (final disease in diseases) {
            _riwayatList.add(disease.name);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat riwayat penyakit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Load all diseases from API
  void _loadAllDiseases() async {
    setState(() {
      _isLoadingDiseases = true;
    });
    
    try {
      final diseases = await fetchDiseases();
      
      if (mounted) {
        setState(() {
          _allDiseases = diseases;
          _filteredDiseases = diseases;
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
            content: Text('Gagal memuat daftar penyakit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Filter diseases based on search query
  void _filterDiseases(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDiseases = _allDiseases;
      } else {
        _filteredDiseases = _allDiseases
          .where((disease) => disease.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      }
    });
  }

  // Fungsi untuk menambah penyakit ke database
  Future<void> _addDiseaseToHistory(Disease disease) async {
    try {
      final success = await addDiseaseToHistory(_userId, disease.name);
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan penyakit ke riwayat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Fungsi untuk menghapus penyakit dari database
  Future<void> _removeDiseaseFromHistory(String diseaseName) async {
    try {
      final success = await removeDiseaseFromHistoryByName(_userId, diseaseName);
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus penyakit dari riwayat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const UserAvatar(
                      imageUrl: 'assets/images/profile.jpg',
                      size: 120,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFB6D9D0),
                        child: IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.white, size: 18),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kucing Sedih',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),

                _buildLabel("Nama"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    hintText: "Masukkan nama lengkap",
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                const SizedBox(height: 18),

                _buildLabel("Email"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Masukkan email",
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Email tidak boleh kosong" : null,
                ),
                const SizedBox(height: 18),

                _buildLabel("Kata Sandi"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "********",
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) => value!.length < 6
                      ? "Minimal 6 karakter"
                      : null,
                ),
                const SizedBox(height: 18),

                _buildLabel("Tanggal Lahir"),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _tanggalLahirController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    hintText: 'dd/MM/yyyy',
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 18),

                _buildLabel("Riwayat Penyakit"),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _riwayatList
                          .map((e) => RawChip(
                                label: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF83AEB1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                deleteIcon: const Icon(Icons.close,
                                    color: Colors.white),                                onDeleted: () async {
                                  // Hapus dari database dan UI
                                  await _removeDiseaseFromHistory(e);
                                  
                                  setState(() {
                                    _riwayatList.remove(e);
                                  });
                                },
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: _showAddRiwayatModal,
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Riwayat"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Button(
            content: 'Simpan Perubahan',
            onPressed: _submitForm,
          ),
        ),
      ),
    );
  }
}
