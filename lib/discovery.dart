import 'package:flutter/material.dart';
import '.components/resep_grid.dart';
import '.components/search_bar.dart';
import '.components/bottom_popup.dart';
import 'data/dummy_resep.dart';
import '.components/TipsDanTrikCardV2.dart';

class DiscoveryResep extends StatefulWidget {
  const DiscoveryResep({super.key});

  @override
  _DiscoveryResepState createState() => _DiscoveryResepState();
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

  List<Resep> getFilteredReseps() {
    // 1. Filter kategori
    List<Resep> filtered =
        selectedCategory == "Semua"
            ? dummyResepList
            : dummyResepList
                .where((r) => r.categories.contains(selectedCategory))
                .toList();

    // 2. Filter search query
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (r) =>
                    r.title.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
    }

    // 3. Filter bahan yang diinginkan
    if (bahanDiinginkan.isNotEmpty) {
      filtered =
          filtered.where((r) {
            return bahanDiinginkan.every((b) {
              final bl = b.toLowerCase();
              return r.ingredientNames.any(
                (ing) => ing.toLowerCase().contains(bl),
              );
            });
          }).toList();
    }

    // 4. Filter bahan yang tidak diinginkan
    if (bahanTidakDiinginkan.isNotEmpty) {
      filtered =
          filtered.where((r) {
            return !bahanTidakDiinginkan.any((b) {
              final bl = b.toLowerCase();
              return r.ingredientNames.any(
                (ing) => ing.toLowerCase().contains(bl),
              );
            });
          }).toList();
    }

    return filtered;
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
        return StatefulBuilder(
          builder: (ctx, setModalState) {
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
                      items:
                          categories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
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
                    Text(
                      'Bahan yang diinginkan',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
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
                  children:
                      tempWanted
                          .map(
                            (b) => Chip(
                              backgroundColor: Colors.teal.shade200,
                              label: Text(b),
                              onDeleted:
                                  () =>
                                      setModalState(() => tempWanted.remove(b)),
                            ),
                          )
                          .toList(),
                ),

                const SizedBox(height: 20),

                // Bahan yang Tidak Diinginkan (staging)
                Row(
                  children: const [
                    Icon(Icons.list, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Bahan yang tidak diinginkan',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
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
                          final txt =
                              _bahanTidakDiinginkanController.text.trim();
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
                  children:
                      tempUnwanted
                          .map(
                            (b) => Chip(
                              backgroundColor: Colors.red.shade100,
                              label: Text(b),
                              onDeleted:
                                  () => setModalState(
                                    () => tempUnwanted.remove(b),
                                  ),
                            ),
                          )
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
                            borderRadius: BorderRadius.circular(30),
                          ),
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
                          foregroundColor:
                              Colors
                                  .white, // Mengatur warna text secara eksplisit
                          elevation:
                              2, // Menambahkan sedikit elevasi untuk efek visual
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Pasang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16, // Ukuran font yang sedikit lebih besar
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
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
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
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
                              color:
                                  activeTab == 0
                                      ? Colors.black
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Resep Makanan",
                            style: TextStyle(
                              fontWeight:
                                  activeTab == 0
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
                              color:
                                  activeTab == 1
                                      ? Colors.black
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Tips & Trik",
                            style: TextStyle(
                              fontWeight:
                                  activeTab == 1
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
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final c = categories[index];
                          final sel = selectedCategory == c;
                          return ElevatedButton(
                            onPressed:
                                () => setState(() => selectedCategory = c),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  sel
                                      ? Colors.teal.shade200
                                      : Colors.grey.shade200,
                              foregroundColor:
                                  sel ? Colors.black : Colors.black54,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(80, 36),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: Text(c),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ElevatedButton.icon(
                        onPressed: _showFilterBottomSheet,
                        icon: const Icon(
                          Icons.filter_list,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF83AEB1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(80, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Grid Resep
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ResepGrid(
                    reseps:
                        getFilteredReseps(), // This should now be passing List<Resep>
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
