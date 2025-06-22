import 'package:flutter/material.dart';
import './.components/resep_grid.dart';
import './.components/search_bar.dart';
import './.components/bottom_popup.dart';
import './.components/TipsDanTrikCardV2.dart';

// import function recipe
import './data/func_recipe.dart' as recipe_api;
import './utils/api_debug_helper.dart';

class DiscoveryResep extends StatefulWidget {
  const DiscoveryResep({super.key});

  @override
  State<DiscoveryResep> createState() => _DiscoveryResepState();
}

class _DiscoveryResepState extends State<DiscoveryResep> {
  // STATE UTAMA
  int activeTab = 0; // 0 = Resep Makanan, 1 = Tips & Trik
  String searchQuery = '';
  String selectedCategory = "Semua";

  final List<String> categories = [
    "Semua",
    "Makanan",
    "Cemilan",
    "Minuman",
    "Sup",
  ];

  List<String> bahanDiinginkan = [];
  List<String> bahanTidakDiinginkan = [];

  final TextEditingController _bahanDiinginkanController =
      TextEditingController();
  final TextEditingController _bahanTidakDiinginkanController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedCategory = "Semua";

    // Test API connection saat aplikasi dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      APIDebugHelper.testAPIConnection();
    });
  }

  @override
  void dispose() {
    _bahanDiinginkanController.dispose();
    _bahanTidakDiinginkanController.dispose();
    super.dispose();
  }

  void changeTab(int tabIndex) {
    setState(() {
      // Jika pindah ke Tips & Trik, reset searchQuery
      if (activeTab != tabIndex) searchQuery = '';
      activeTab = tabIndex;
    });
  }

  // Fungsi ini akan digunakan untuk filter data dummy (jika diperlukan)
  // Tidak diperlukan lagi untuk grid resep karena menggunakan data dari API
  List<Map<String, dynamic>> getFilteredReseps() {
    // Return list kosong - tidak digunakan untuk grid resep
    return [];
  }

  void _showFilterBottomSheet() {
    // staging variables
    String tempCategory = selectedCategory;
    List<String> tempWanted = List.from(bahanDiinginkan);
    List<String> tempUnwanted = List.from(bahanTidakDiinginkan);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return BottomPopup(
            children: [
              const Text(
                'Filter Pencarian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Dropdown kategori (staging)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: tempCategory,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categories
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setModalState(() => tempCategory = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bahan yang Diinginkan (staging)
              Row(
                children: const [
                  Icon(Icons.list, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Text('Bahan yang diinginkan',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bahanDiinginkanController,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Telur',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        final txt = _bahanDiinginkanController.text.trim();
                        if (txt.isNotEmpty) {
                          setModalState(() => tempWanted.add(txt));
                          _bahanDiinginkanController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: tempWanted
                    .map((b) => Chip(
                          backgroundColor: Colors.teal.shade200,
                          label: Text(b),
                          onDeleted: () =>
                              setModalState(() => tempWanted.remove(b)),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // Bahan yang Tidak Diinginkan (staging)
              Row(
                children: const [
                  Icon(Icons.list, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Text('Bahan yang tidak diinginkan',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bahanTidakDiinginkanController,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Jahe',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        final txt = _bahanTidakDiinginkanController.text.trim();
                        if (txt.isNotEmpty) {
                          setModalState(() => tempUnwanted.add(txt));
                          _bahanTidakDiinginkanController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: tempUnwanted
                    .map((b) => Chip(
                          backgroundColor: Colors.red.shade100,
                          label: Text(b),
                          onDeleted: () =>
                              setModalState(() => tempUnwanted.remove(b)),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 30),

              // Tombol Aksi
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = 'Semua';
                          bahanDiinginkan.clear();
                          bahanTidakDiinginkan.clear();
                        });
                        Navigator.pop(ctx);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Hapus filter'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = tempCategory;
                          bahanDiinginkan = List.from(tempWanted);
                          bahanTidakDiinginkan = List.from(tempUnwanted);
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade300,
                        foregroundColor: Colors
                            .white, // Mengatur warna text secara eksplisit
                        elevation:
                            2, // Menambahkan sedikit elevasi untuk efek visual
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Pasang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Ukuran font yang sedikit lebih besar
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            CustomSearchBar(
              hintText: activeTab == 0 ? "Cari resep" : "Cari tips & trik",
              onSearch: (q) => setState(() => searchQuery = q),
            ),

            // Tab Navigasi
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => changeTab(0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: activeTab == 0
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Resep Makanan",
                            style: TextStyle(
                              fontWeight: activeTab == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  activeTab == 0 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => changeTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: activeTab == 1
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Tips & Trik",
                            style: TextStyle(
                              fontWeight: activeTab == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  activeTab == 1 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten Berdasarkan Tab
            if (activeTab == 0) ...[
              // Kategori + Tombol Filter
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: categories.map((c) {
                          final sel = selectedCategory == c;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () =>
                                  setState(() => selectedCategory = c),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: sel
                                    ? Colors.teal.shade200
                                    : Colors.grey.shade200,
                                foregroundColor:
                                    sel ? Colors.black : Colors.black54,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(c),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ElevatedButton.icon(
                          onPressed: _showFilterBottomSheet,
                          icon: const Icon(Icons.filter_list,
                              size: 18, color: Colors.white),
                          label: const Text(
                            "Filter",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF83AEB1),
                            foregroundColor: Colors
                                .white, // Mengatur warna text secara eksplisit
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )),
                  ],
                ),
              ),
              // Grid Resep dengan data dari API
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    // Menggunakan fungsi dengan fallback ke dummy data jika API gagal
                    future: recipe_api.fetchAllRecipesWithFallback(),
                    builder: (context, snapshot) {
                      print(
                          "[DEBUG] Discovery FutureBuilder: ConnectionState: ${snapshot.connectionState}");

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print(
                            "[DEBUG] Discovery FutureBuilder: Masih loading...");
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF83AEB1),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(
                            "[ERROR] Discovery FutureBuilder: Error: ${snapshot.error}");
                        // Tampilkan error dengan detail lebih jelas untuk debugging
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Error: ${snapshot.error}"),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {}); // Reload untuk mencoba lagi
                                },
                                child: const Text("Coba Lagi"),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        print(
                            "[WARN] Discovery FutureBuilder: Data kosong: ${snapshot.data}");
                        return const Center(
                          child: Text("Tidak ada resep yang tersedia"),
                        );
                      } else {
                        // Data berhasil didapat, tampilkan dengan ResepGrid
                        print(
                            "[DEBUG] Discovery FutureBuilder: Data berhasil didapat: ${snapshot.data!.length} item");
                        print(
                            "[DEBUG] Discovery FutureBuilder: Contoh data pertama: ${snapshot.data!.isNotEmpty ? snapshot.data![0] : 'Tidak ada data'}");

                        return ResepGrid(
                          reseps: snapshot.data!,
                        );
                      }
                    },
                  ),
                ),
              ),
            ] else ...[
              // Tips & Trik Section
              const TipsDanTrikSectionV2(),
            ],
          ],
        ),
      ),
    );
  }
}
