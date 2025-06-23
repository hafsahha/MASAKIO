import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // ← Tambahkan ini
import 'package:masakio/data/func_tips.dart';
import 'package:masakio/.components/navbar.dart';
import 'package:masakio/.components/bottom_popup.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/Tambah Resep/tambah-resep-1.dart';
import 'package:masakio/Tips Trik/tambah_tips.dart';
import 'package:masakio/main_page.dart';

class TipsAndTrikPage extends StatefulWidget {
  final int idTips;

  const TipsAndTrikPage({super.key, required this.idTips});

  @override
  State<TipsAndTrikPage> createState() => _TipsAndTrikPageState();
}

class _TipsAndTrikPageState extends State<TipsAndTrikPage> {
  bool _isExpanded = false;
  bool _isLoading = true;
  Map<String, dynamic>? _tip;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      print('[TipsAndTrikPage] _isExpanded toggled to: $_isExpanded'); // Debug log
    });
  }

  void _onNavbarItemSelected(int index) {
    print('[TipsAndTrikPage] Navbar item selected: $index'); // Debug log
    if (index != 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(pageIndex: index),
        ),
      );
    }
  }

  void _showBottomPopup() {
    print('[TipsAndTrikPage] Showing bottom popup'); // Debug log
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomPopup(
          children: [
            const Text(
              'Mau buat apa hari ini?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Button(
              content: 'Buat Resep Baru',
              onPressed: () {
                print('[TipsAndTrikPage] "Buat Resep Baru" button pressed'); // Debug log
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahResep1Page()),
                );
              },
            ),
            const SizedBox(height: 10),
            Button(
              content: 'Tulis Tips & Trik',
              onPressed: () {
                print('[TipsAndTrikPage] "Tulis Tips & Trik" button pressed'); // Debug log
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahTipsPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('[TipsAndTrikPage] initState called for idTips: ${widget.idTips}'); // Debug log
    initializeDateFormatting('id_ID', null); // Inisialisasi untuk format tanggal lokal
    _loadTipDetail();
  }

  Future<void> _loadTipDetail() async {
    print('[TipsAndTrikPage] _loadTipDetail() called for idTips: ${widget.idTips}'); // Debug log
    try {
      final data = await fetchTipsDetail(widget.idTips);
      print('[TipsAndTrikPage] Data received from fetchTipsDetail: $data'); // Debug log: Full data received
      setState(() {
        _tip = data;
        _isLoading = false;
        print('[TipsAndTrikPage] State updated: _isLoading=$_isLoading, _tip loaded'); // Debug log
      });
    } catch (e) {
      print('[TipsAndTrikPage] Error loading tip detail: $e'); // Debug log: Error message
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat detail tips.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[TipsAndTrikPage] Building widget. _isLoading: $_isLoading, _tip is null: ${_tip == null}'); // Debug log

    if (_isLoading) {
      print('[TipsAndTrikPage] Displaying loading indicator.'); // Debug log
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_tip == null) {
      print('[TipsAndTrikPage] Tip data is null, displaying error message.'); // Debug log
      return const Scaffold(
        body: Center(child: Text('Gagal memuat data tips.')),
      );
    }

    final tip = _tip!;
    print('[TipsAndTrikPage] Tip data available: ${tip['title']}'); // Debug log: confirm data available

    // Formatting date
    String formattedDate;
    try {
      formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(tip['timestamp'])); // 'yyyy' untuk menampilkan tahun
      print('[TipsAndTrikPage] Formatted Date: $formattedDate (Original timestamp: ${tip['timestamp']})'); // Debug log
    } catch (e) {
      formattedDate = 'Tanggal tidak valid';
      print('[TipsAndTrikPage] Error formatting date: $e'); // Debug log
    }

    final content = tip['description'] ?? '';
    print('[TipsAndTrikPage] Description content length: ${content.length}'); // Debug log

    // --- Debugging Hashtags ---
    List<String> hashtags;
    if (tip['hashtags'] != null && tip['hashtags'] is List) {
      // Jika backend sudah mengirim sebagai List (misal, jika ada pre-processing di server)
      hashtags = List<String>.from(tip['hashtags']);
      print('[TipsAndTrikPage] Hashtags received as List: $hashtags'); // Debug log
    } else if (tip['hashtags'] != null && tip['hashtags'] is String) {
      // Ini adalah kasus yang kita harapkan dari backend Node.js Anda
      hashtags = (tip['hashtags'] as String).split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
      print('[TipsAndTrikPage] Hashtags received as String, parsed to List: $hashtags'); // Debug log
    } else {
      hashtags = [];
      print('[TipsAndTrikPage] Hashtags are null or not a valid type. Defaulting to empty list.'); // Debug log
    }
    // --- End Debugging Hashtags ---

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () {
                print('[TipsAndTrikPage] Back button pressed'); // Debug log
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hashtags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: hashtags.map((tag) {
                    print('[TipsAndTrikPage] Displaying hashtag: $tag'); // Debug log
                    return Chip(
                      label: Text(tag),
                      backgroundColor: const Color(0xFF83AEB1),
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'Tidak ada hashtag untuk tips ini.', // Debug message if no hashtags
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tip['title'] ?? '-',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
              child: Text(
                'Oleh ${tip['uploader']} • Diunggah: $formattedDate',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  tip['imageUrl'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('[TipsAndTrikPage] Image loading error for URL: ${tip['imageUrl']} - Error: $error'); // Debug log
                    return const SizedBox(height: 200, child: Center(child: Text('Gagal memuat gambar')));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
                    ),
                    child: Text(
                      _isExpanded
                          ? content
                          : content.split('. ').take(3).join('. ') + (content.split('. ').length > 3 ? '...' : ''),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  if (content.split('. ').length > 3)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _toggleExpansion,
                        child: Text(
                          _isExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Selengkapnya',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF83AEB1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    print('[TipsAndTrikPage] Share button pressed'); // Debug log
                    // TODO: share logic
                  },
                  icon: const Icon(Icons.share, color: Colors.grey),
                  label: const Text(
                    'Bagikan Tips & Trik',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF83AEB1),
        shape: const CircleBorder(),
        onPressed: _showBottomPopup,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(
        idx: 1,
        onItemSelected: _onNavbarItemSelected,
      ),
    );
  }
}