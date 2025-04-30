import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tips & Trik',
      home: TipsAndTrikPage(),
    );
  }
}

class TipsAndTrikPage extends StatefulWidget {
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
        title: Text('Tips & Trik'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar dengan padding kiri-kanan
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16), // Padding kiri-kanan
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/kentang.png'), // Ganti dengan path gambar Anda
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Kategori 'Sayuran' setelah gambar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF83AEB1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      'Sayuran',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            // Judul Artikel
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Simpan Kentang dengan Cara Ini Agar Tidak Cepat Busuk',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            // Isi Konten (dengan toggle untuk expand)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFD8D8D8), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview Konten
                    Text(
                      'Kentang adalah salah satu bahan makanan yang populer di banyak dapur. Namun, sering kali kalian mengalami masalah dengan kentang yang cepat busuk atau berubah berwarna hitam. Untuk mencegah hal tersebut, penting untuk mengetahui cara menyimpan kentang dengan benar. Nah, berikut tips untuk menjaga kentang tetap awet dan segar.\n\nHindari Menyimpan di Bawah Sinar Matahari',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    if (_isExpanded) ...[
                      SizedBox(height: 12),
                      Text(
                        'Kentang sebaiknya disimpan di tempat yang tidak terlalu dingin dengan suhu sejuk, tetapi kering. Tujuannya adalah untuk menjaga rasa alami kentang agar tidak berubah dengan mudah, serta menunda pembentukan kecambah pada kulit kentang yang menandakan awal pembusukan. \n\nPenting untuk menjaga kentang agar tidak terpapar sinar matahari langsung. Sebuah penelitian yang diterbitkan dalam Critical Reviews in Food Science and Nutrition menunjukkan bahwa paparan sinar matahari dapat menghasilkan senyawa beracun bernama solanine. Selain dapat menyebabkan rasa pahit saat dimakan, solanine juga tergolong beracun jika dikonsumsi dalam jumlah besar.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Jangan Simpan di Tempat yang Tertutup Rapat',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sirkulasi udara adalah kunci untuk menjaga kentang tetap segar. Sebaiknya, simpan kentang dalam wadah terbuka, seperti keranjang atau kantong berjaring agar udara bisa masuk dan keluar dengan bebas.\n\nHindari menyimpan kentang dalam kantong plastik karena ini dapat memicu kelembapan yang mempercepat kerusakan. Jika kamu menggunakan kantong plastik saat berbelanja, pastikan untuk segera mengeluarkan kentang agar dapat disimpan lebih lama.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Jangan Simpan di Kulkas',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tidak semua bahan makanan dapat bertahan lama saat disimpan di dalam kulkas. Kentang adalah salah satu bahan yang justru akan kurang baik jika disimpan dan diletakkan di lemari es. Cara menyimpan kentang di kulkas ini kurang baik untuk ketahanan dari kentang.\n\nSelain memengaruhi ketahanan, suhu dingin dapat mengubah kandungan pati pada kentang menjadi gula yang akan berdampak pada rasa saat dikonsumsi. Di samping itu, tekstur kentang juga akan menjadi lebih lembek.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Cara Menyimpan Kentang yang Sudah Dikupas',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Cara menyimpan kentang yang sudah dikupas berbeda dengan cara menyimpan sebelum dikupas. Kentang segar yang masih berkulit sebaiknya tidak langsung dicuci. Mencuci kentang dengan kulitnya justru dapat menciptakan kondisi lembap yang mendorong pertumbuhan jamur dan bakteri.\n\nMeskipun tampak kotor dan penuh tanah, biarkan kentang dalam kondisi tersebut sampai siap untuk diolah. Saat sudah dikupas, kentang cenderung lebih mudah menghitam ketika terpapar udara. Hal ini disebabkan oleh kandungan polifenol oksidase dalam kentang yang bereaksi dengan oksigen, mengubah daging kentang menjadi berwarna kecokelatan atau keabu-abuan. Untuk mencegah warna menghitam pada kentang yang sudah dikupas, kalian bisa merendam kentang dalam baskom berisi air.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: _toggleExpansion,
                      child: Text(
                        _isExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Selengkapnya',
                        style: TextStyle(
                          color: Color(0xFF82AEB1),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bagikan Button Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Action untuk Bagikan
                },
                icon: Icon(Icons.share),
                label: Text(
                  'Bagikan Tips & Trik',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Background color
                  onPrimary: Colors.grey, // Text color
                  side: BorderSide(color: Colors.grey), // Border color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Gradient Fade Effect for the "See More" Button
            Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
