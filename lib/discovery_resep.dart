import 'package:flutter/material.dart';
import '.components/resep_grid.dart';
import '.components/search_bar.dart';
import 'data/dummy_resep.dart';

class DiscoveryResep extends StatefulWidget {
  const DiscoveryResep({super.key});

  @override
  _DiscoveryResepState createState() => _DiscoveryResepState();
}

class _DiscoveryResepState extends State<DiscoveryResep> {
  // Menyimpan kategori yang dipilih (default: "Semua")
  String selectedCategory = "Semua";

  // Menyimpan query pencarian
  String searchQuery = '';

  // Tab yang aktif (0 = Resep Makanan, 1 = Tips & Trik)
  int activeTab = 0;

  // Daftar kategori
  final List<String> categories = ["Semua", "Makanan", "Cemilan", "Minuman", "Sup"];

  @override
  void initState() {
    super.initState();
    // Inisialisasi kategori default saat pertama kali halaman dibuka
    selectedCategory = "Semua";
  }

  // Filter resep berdasarkan kategori yang dipilih dan query pencarian
  List getFilteredReseps() {
    List filteredList = selectedCategory == "Semua"
        ? dummyResepList
        : dummyResepList.where((resep) =>
        resep.categories.contains(selectedCategory)).toList();

    if (searchQuery.isNotEmpty) {
      return filteredList.where((resep) =>
          resep.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return filteredList;
  }

  // Fungsi untuk mengganti tab
  void changeTab(int tabIndex) {
    setState(() {
      // Jika pindah dari tab resep ke tab tips & trik
      if (activeTab == 0 && tabIndex == 1) {
        // Reset query pencarian
        searchQuery = '';
      }

      activeTab = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Bagian search bar menggunakan CustomSearchBar
            CustomSearchBar(
              hintText: activeTab == 0 ? "Cari resep" : "Cari tips & trik",
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),

            // Tab navigasi
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  // Tab Resep Makanan
                  Expanded(
                    child: GestureDetector(
                      onTap: () => changeTab(0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: activeTab == 0 ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Resep Makanan",
                            style: TextStyle(
                              fontWeight: activeTab == 0 ? FontWeight.bold : FontWeight.normal,
                              color: activeTab == 0 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tab Tips & Trik
                  Expanded(
                    child: GestureDetector(
                      onTap: () => changeTab(1),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: activeTab == 1 ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Tips & Trik",
                            style: TextStyle(
                              fontWeight: activeTab == 1 ? FontWeight.bold : FontWeight.normal,
                              color: activeTab == 1 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten berdasarkan tab yang aktif
            if (activeTab == 0) ...[
              // Tombol kategori untuk tab Resep
              Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  children: categories.map((category) {
                    bool isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.teal.shade200
                              : Colors.grey.shade200,
                          foregroundColor: isSelected
                              ? Colors.black
                              : Colors.black54,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(category),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Grid resep
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ResepGrid(
                    reseps: getFilteredReseps(),
                  ),
                ),
              ),
            ] else ...[
              // Konten untuk tab Tips & Trik
              Expanded(
                child: Center(
                  child: Text(
                    "Grid Tip dan Trik",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
