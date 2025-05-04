class Tips {
  final String title;
  final String content;
  final List<String> hashtags;
  final String imageAsset;
  final String author;
  final DateTime uploadDate;

  Tips({
    required this.title,
    required this.content,
    required this.hashtags,
    required this.imageAsset,
    required this.author,
    required this.uploadDate,
  });
}

final List<Tips> dummyTipsList = [
  Tips(
    title: "Simpan Kentang dengan Cara Ini Agar Tidak Cepat Busuk",
    content:
        "Kentang adalah bahan makanan yang serbaguna, tapi cepat busuk jika disimpan sembarangan. Salah satu kesalahan umum adalah menyimpan kentang di dalam kulkas. Suhu dingin justru mengubah pati menjadi gula, membuat rasa dan teksturnya berubah. Simpan kentang di tempat sejuk dan kering, seperti keranjang terbuka yang tidak terkena sinar matahari langsung. Jangan mencucinya sebelum disimpan karena kelembapan memicu pertumbuhan jamur. Jika sudah dikupas, rendam dalam air agar tidak menghitam. Hindari kantong plastik tertutup dan pilih kantong jaring agar sirkulasi udara terjaga.",
    hashtags: ["Sayuran", "Penyimpanan", "TipsDapur"],
    imageAsset: "assets/images/kentang.png",
    author: "Nina Wulandari",
    uploadDate: DateTime(2025, 5, 1),
  ),
  Tips(
    title: "Cara Merebus Telur yang Sempurna Setiap Waktu",
    content:
        "Telur rebus mungkin terlihat sederhana, tapi tekniknya menentukan hasil. Untuk telur setengah matang, rebus selama 6–7 menit setelah air mendidih. Telur matang sempurna butuh 9–10 menit. Mulailah dari air dingin agar cangkangnya tidak retak, lalu gunakan api sedang. Setelah matang, langsung rendam dalam air es agar mudah dikupas dan mencegah kelanjutan proses masak. Jika ingin telur dengan kuning sedikit lembut tapi putih padat, coba teknik 8 menit tanpa tutup. Jangan lupa beri sedikit garam di air rebusan untuk mencegah pecah.",
    hashtags: ["BasicSkill", "Telur", "MasakMudah"],
    imageAsset: "assets/images/telur.jpg",
    author: "Bayu Setiawan",
    uploadDate: DateTime(2025, 4, 29),
  ),
  Tips(
    title: "Rahasia Tumisan Sayur Tetap Hijau dan Renyah",
    content:
        "Pernah merasa sayur tumisanmu jadi lembek dan kusam? Gunakan api besar dan waktu masak yang singkat! Sayur seperti buncis, brokoli, atau kangkung sebaiknya ditumis tak lebih dari 3–4 menit. Gunakan sedikit minyak dan masukkan bumbu di awal. Jangan lupa garam baru di akhir agar sayur tidak layu duluan. Trik lain: rendam sayur di air es sebelum ditumis agar warnanya tetap cerah. Dan jangan terlalu sering diaduk, biarkan panas menyentuh semua sisi secara merata.",
    hashtags: ["TeknikMasak", "Sayuran", "Sehat"],
    imageAsset: "assets/images/sayur.jpeg",
    author: "Farah Nuraini",
    uploadDate: DateTime(2025, 4, 25),
  ),
];
