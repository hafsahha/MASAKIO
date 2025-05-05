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
  Tips(
    title: "Trik Mengupas Bawang Tanpa Menangis",
    content:
        "Mengupas bawang sering kali membuat mata perih dan berair. Untuk menghindari hal ini, dinginkan bawang di dalam kulkas selama 30 menit sebelum dipotong. Gunakan pisau tajam agar irisan lebih halus dan tidak menghancurkan sel-sel bawang secara berlebihan. Kamu juga bisa mengupas bawang di dekat aliran air mengalir atau di bawah ventilasi dapur untuk mengurangi paparan gas. Hindari meniup bawang karena justru mempercepat gas mengenai mata.",
    hashtags: ["BasicSkill", "Dapur", "TipsCepat"],
    imageAsset: "assets/images/bawang.jpg",
    author: "Rina Maharani",
    uploadDate: DateTime(2025, 5, 2),
  ),
  Tips(
    title: "Cara Menyimpan Daun Bawang agar Tahan Lama",
    content:
        "Daun bawang sering layu dan berlendir jika tidak disimpan dengan tepat. Untuk menjaga kesegarannya, bungkus daun bawang dengan tisu dapur kering lalu masukkan ke dalam plastik ziplock sebelum diletakkan di kulkas. Kamu juga bisa menyimpannya dalam gelas berisi sedikit air dan menutup bagian atasnya dengan plastik longgar. Jangan langsung mencuci daun bawang sebelum disimpan, karena air justru mempercepat pembusukan.",
    hashtags: ["Sayuran", "Penyimpanan", "TipsDapur"],
    imageAsset: "assets/images/daun_bawang.jpeg",
    author: "Ahmad Rizki",
    uploadDate: DateTime(2025, 5, 3),
  ),

  // New 5 tips added below
  Tips(
    title: "Cara Membuat Roti Panggang yang Sempurna",
    content:
        "Untuk membuat roti panggang yang sempurna, pastikan wajan atau panggangan sudah cukup panas sebelum roti dimasukkan. Oleskan mentega tipis pada kedua sisi roti untuk hasil yang lebih garing. Panggang selama 2-3 menit di setiap sisi dengan api sedang. Jika ingin roti lebih crispy, kamu bisa menambahkan sedikit minyak zaitun ke mentega.",
    hashtags: ["Sarapan", "Roti", "MasakMudah"],
    imageAsset: "assets/images/roti_panggang.jpeg",
    author: "Tara Pratama",
    uploadDate: DateTime(2025, 5, 6),
  ),
  Tips(
    title: "Rahasia Menyimpan Ikan agar Tetap Segar",
    content:
        "Ikan segar bisa cepat rusak jika tidak disimpan dengan benar. Untuk menjaga kesegarannya, bungkus ikan dalam plastik wrap dan masukkan ke dalam wadah kedap udara, lalu simpan di bagian paling dingin kulkas. Jika tidak langsung dimasak, simpan ikan dalam es batu yang digulung dengan kain lap, ini akan menjaga ikan tetap segar hingga 24 jam.",
    hashtags: ["Ikan", "Penyimpanan", "TipsDapur"],
    imageAsset: "assets/images/ikan.jpg",
    author: "Budi Santoso",
    uploadDate: DateTime(2025, 5, 7),
  ),
  Tips(
    title: "Menyimpan Sayur Agar Tetap Segar Lebih Lama",
    content:
        "Sayuran seperti selada dan bayam cenderung cepat layu. Untuk menjaga kesegarannya lebih lama, cuci sayur terlebih dahulu, tiriskan, lalu bungkus dengan handuk kering dan simpan dalam kantong plastik terbuka di kulkas. Jangan biarkan sayuran terpapar udara langsung karena hal ini mempercepat pembusukan.",
    hashtags: ["Sayuran", "Penyimpanan", "Sehat"],
    imageAsset: "assets/images/sayur_tahan_lama.jpg",
    author: "Dwi Lestari",
    uploadDate: DateTime(2025, 5, 8),
  ),
  Tips(
    title: "Menghilangkan Bau Tak Sedap pada Kulkas",
    content:
        "Untuk menghilangkan bau tak sedap di dalam kulkas, letakkan sepotong arang aktif atau baking soda di bagian belakang kulkas. Ini akan menyerap bau tak diinginkan dan menjaga kulkas tetap segar. Kamu juga bisa menempatkan beberapa irisan lemon atau daun mint untuk memberikan aroma yang lebih segar pada kulkas.",
    hashtags: ["Dapur", "Higienis", "TipsCepat"],
    imageAsset: "assets/images/bau_kulkas.jpeg",
    author: "Toni Pratama",
    uploadDate: DateTime(2025, 5, 9),
  ),
  Tips(
    title: "Trik Memasak Nasi yang Tidak Mudah Gosong",
    content:
        "Untuk memasak nasi yang tidak mudah gosong, gunakan api kecil setelah air mendidih. Pastikan juga penutup rice cooker rapat agar uap tidak keluar. Setelah nasi matang, diamkan selama 10 menit di dalam rice cooker sebelum disajikan, agar nasi lebih pulen.",
    hashtags: ["Nasi", "MasakMudah", "TipsDapur"],
    imageAsset: "assets/images/nasi_pulen.jpeg",
    author: "Rina Wulandari",
    uploadDate: DateTime(2025, 5, 10),
  ),
];
