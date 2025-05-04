import 'package:flutter/material.dart';
import 'package:masakio/.components/navbar.dart';
import 'package:masakio/.components/bottom_popup.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/Tambah Resep/tambah_resep1.dart';
import 'package:masakio/Tips Trik/tambah_tips.dart';
import 'package:masakio/main_page.dart';

class TipsAndTrikPage extends StatefulWidget {
  const TipsAndTrikPage({super.key});

  @override
  State<TipsAndTrikPage> createState() => _TipsAndTrikPageState();
}

class _TipsAndTrikPageState extends State<TipsAndTrikPage> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _onNavbarItemSelected(int index) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahResep1Page(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Button(
              content: 'Tulis Tips & Trik',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahTipsPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 60,
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/kentang.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF83AEB1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Text(
                      'Sayuran',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Simpan Kentang dengan Cara Ini Agar Tidak Cepat Busuk',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kentang adalah salah satu bahan makanan yang populer di banyak dapur. Namun, sering kali kalian mengalami masalah dengan kentang yang cepat busuk atau berubah berwarna hitam. Untuk mencegah hal tersebut, penting untuk mengetahui cara menyimpan kentang dengan benar. Nah, berikut tips untuk menjaga kentang tetap awet dan segar.\n\nHindari Menyimpan di Bawah Sinar Matahari',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        if (_isExpanded) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Kentang sebaiknya disimpan di tempat yang tidak terlalu dingin dengan suhu sejuk, tetapi kering. Tujuannya adalah untuk menjaga rasa alami kentang agar tidak berubah dengan mudah, serta menunda pembentukan kecambah pada kulit kentang yang menandakan awal pembusukan. \n\nPenting untuk menjaga kentang agar tidak terpapar sinar matahari langsung. Sebuah penelitian yang diterbitkan dalam Critical Reviews in Food Science and Nutrition menunjukkan bahwa paparan sinar matahari dapat menghasilkan senyawa beracun bernama solanine. Selain dapat menyebabkan rasa pahit saat dimakan, solanine juga tergolong beracun jika dikonsumsi dalam jumlah besar.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Jangan Simpan di Tempat yang Tertutup Rapat',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Sirkulasi udara adalah kunci untuk menjaga kentang tetap segar. Sebaiknya, simpan kentang dalam wadah terbuka, seperti keranjang atau kantong berjaring agar udara bisa masuk dan keluar dengan bebas.\n\nHindari menyimpan kentang dalam kantong plastik karena ini dapat memicu kelembapan yang mempercepat kerusakan.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Jangan Simpan di Kulkas',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Kentang akan lebih mudah rusak jika disimpan di lemari es. Suhu dingin bisa mengubah kandungan pati menjadi gula, mengubah rasa dan tekstur kentang.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Cara Menyimpan Kentang yang Sudah Dikupas',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Simpan dalam air agar tidak menghitam. Jangan dicuci terlalu awal saat belum ingin digunakan untuk menghindari kelembapan berlebih.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: _toggleExpansion,
                        child: Text(
                          _isExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Selengkapnya',
                          style: const TextStyle(
                            color: Color(0xFF82AEB1),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
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
                  onPressed: () {},
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
