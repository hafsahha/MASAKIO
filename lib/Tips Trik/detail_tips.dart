import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tips & Trik',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TipsAndTrikPage(),
    );
  }
}

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
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Jangan Simpan di Tempat yang Tertutup Rapat',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Sirkulasi udara adalah kunci untuk menjaga kentang tetap segar. Sebaiknya, simpan kentang dalam wadah terbuka, seperti keranjang atau kantong berjaring agar udara bisa masuk dan keluar dengan bebas.\n\nHindari menyimpan kentang dalam kantong plastik karena ini dapat memicu kelembapan yang mempercepat kerusakan. Jika kamu menggunakan kantong plastik saat berbelanja, pastikan untuk segera mengeluarkan kentang agar dapat disimpan lebih lama.',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Jangan Simpan di Kulkas',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tidak semua bahan makanan dapat bertahan lama saat disimpan di dalam kulkas. Kentang adalah salah satu bahan yang justru akan kurang baik jika disimpan dan diletakkan di lemari es. Cara menyimpan kentang di kulkas ini kurang baik untuk ketahanan dari kentang.\n\nSelain memengaruhi ketahanan, suhu dingin dapat mengubah kandungan pati pada kentang menjadi gula yang akan berdampak pada rasa saat dikonsumsi. Di samping itu, tekstur kentang juga akan menjadi lebih lembek.',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Cara Menyimpan Kentang yang Sudah Dikupas',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Cara menyimpan kentang yang sudah dikupas berbeda dengan cara menyimpan sebelum dikupas. Kentang segar yang masih berkulit sebaiknya tidak langsung dicuci. Mencuci kentang dengan kulitnya justru dapat menciptakan kondisi lembap yang mendorong pertumbuhan jamur dan bakteri.\n\nMeskipun tampak kotor dan penuh tanah, biarkan kentang dalam kondisi tersebut sampai siap untuk diolah. Saat sudah dikupas, kentang cenderung lebih mudah menghitam ketika terpapar udara. Hal ini disebabkan oleh kandungan polifenol oksidase dalam kentang yang bereaksi dengan oksigen, mengubah daging kentang menjadi berwarna kecokelatan atau keabu-abuan. Untuk mencegah warna menghitam pada kentang yang sudah dikupas, kalian bisa merendam kentang dalam baskom berisi air.',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!_isExpanded)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _toggleExpansion,
                          child: const Text(
                            'Lihat Selengkapnya',
                            style: TextStyle(
                              color: Color(0xFF82AEB1),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_isExpanded)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 0, bottom: 16),
                        child: GestureDetector(
                          onTap: _toggleExpansion,
                          child: const Text(
                            'Lihat Lebih Sedikit',
                            style: TextStyle(
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
    );
  }
}
