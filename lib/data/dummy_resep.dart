class Resep {
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> ingredientNames;
  final List<String> tools;
  final List<Map<String, dynamic>> steps;
  final List<String> categories;
  final List<String> tags;
  final String imageAsset;
  final String author;
  final String authorFollowers;
  final double rating;
  final int reviewCount;
  final int servings;
  final Duration duration;
  final int price;
  final Map<String, String> nutrition;
  final DateTime uploadDate;

  Resep({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.ingredientNames,
    required this.tools,
    required this.steps,
    required this.categories,
    required this.tags,
    required this.imageAsset,
    required this.author,
    required this.authorFollowers,
    required this.rating,
    required this.reviewCount,
    required this.servings,
    required this.duration,
    required this.price,
    required this.nutrition,
    required this.uploadDate,
  });
}

final List<Resep> dummyResepList = [
  Resep(
    title: "Sausage Nasi Goreng",
    description: "Nasi goreng dengan sosis dan bumbu sederhana, cocok untuk menu sarapan cepat dan bergizi.",
    ingredients: [
      "2 mangkok nasi", "2 buah sosis, potong", "2 siung bawang putih, iris",
      "1 siung bawang merah, iris", "1 buah cabe merah, iris"
    ],
    ingredientNames: ["nasi", "sosis", "bawang putih", "bawang merah", "cabe merah"],
    tools: ["Wajan", "Spatula", "Piring saji", "Pisau", "Talenan"],
    steps: [
      {
        'title': 'Persiapan',
        'duration': '5 menit',
        'steps': [
          'Masak nasi jika tidak menggunakan sisa nasi.',
          'Iris sosis, cincang bawang putih, potong bawang bombay, iris cabai, dan potong dadu wortel.',
        ]
      },
      {
        'title': 'Masak sosis',
        'duration': '5 menit',
        'steps': ['Panaskan minyak, tumis bawang hingga harum.', 'Masukkan sosis, aduk hingga matang.']
      },
      {
        'title': 'Masak nasi',
        'duration': '10 menit',
        'steps': ['Masukkan nasi, tambahkan bumbu, aduk hingga merata.'],
      },
    ],
    categories: ["Makanan"],
    tags: ["Asian", "Viral"],
    imageAsset: "assets/images/nasi_goreng.jpeg",
    author: "Alicia Ramsey",
    authorFollowers: "10.9k Followers",
    rating: 4.9,
    reviewCount: 3500,
    servings: 1,
    duration: Duration(minutes: 50),
    price: 30000,
    nutrition: {
      "Karbohidrat": "65 gr",
      "Protein": "27 gr",
      "Kalori": "120 Kkal",
      "Lemak": "9 gr",
    },
    uploadDate: DateTime(2025, 5, 1),
  ),
  Resep(
    title: "Es Kopi Susu Gula Aren",
    description: "Minuman kopi kekinian dengan campuran kopi, susu, dan gula aren yang nikmat.",
    ingredients: [
      "50 ml espresso", "150 ml susu cair", "2 sdm gula aren cair", "Es batu secukupnya"
    ],
    ingredientNames: ["espresso", "susu cair", "gula aren", "es batu"],
    tools: ["Gelas", "Sendok", "Mesin kopi"],
    steps: [
      {
        'title': 'Siapkan bahan',
        'duration': '3 menit',
        'steps': ["Tuang gula aren ke gelas, tambahkan es batu."]
      },
      {
        'title': 'Campurkan',
        'duration': '2 menit',
        'steps': ["Tuang espresso lalu susu, aduk perlahan."]
      },
    ],
    categories: ["Minuman"],
    tags: ["Viral", "Kopi", "Kekinian"],
    imageAsset: "assets/images/es_kopi.jpg",
    author: "Bagus Santosa",
    authorFollowers: "3.4k Followers",
    rating: 4.7,
    reviewCount: 2800,
    servings: 1,
    duration: Duration(minutes: 5),
    price: 18000,
    nutrition: {
      "Karbohidrat": "20 gr",
      "Protein": "4 gr",
      "Kalori": "160 Kkal",
      "Lemak": "6 gr",
    },
    uploadDate: DateTime(2025, 5, 4),
  ),
  Resep(
    title: "Cokelat Lava Cake",
    description: "Dessert favorit dengan cokelat leleh di dalamnya. Cocok untuk hidangan penutup yang mewah namun mudah.",
    ingredients: [
      "100 gr dark chocolate", "50 gr mentega", "2 butir telur", "30 gr gula pasir", "30 gr tepung terigu"
    ],
    ingredientNames: ["cokelat", "mentega", "telur", "gula", "tepung"],
    tools: ["Oven", "Whisk", "Cetakan muffin"],
    steps: [
      {
        'title': 'Lelehkan cokelat',
        'duration': '5 menit',
        'steps': ["Lelehkan cokelat dan mentega di atas panci berisi air panas."]
      },
      {
        'title': 'Campur bahan',
        'duration': '7 menit',
        'steps': ["Kocok telur dan gula, masukkan tepung, lalu campurkan cokelat leleh."]
      },
      {
        'title': 'Panggang',
        'duration': '10 menit',
        'steps': ["Panggang 200°C selama 10 menit, sajikan hangat."]
      },
    ],
    categories: ["Cemilan"],
    tags: ["Dessert", "Western"],
    imageAsset: "assets/images/lava_cake.jpg",
    author: "Cynthia Lestari",
    authorFollowers: "5.2k Followers",
    rating: 4.8,
    reviewCount: 2400,
    servings: 2,
    duration: Duration(minutes: 30),
    price: 25000,
    nutrition: {
      "Karbohidrat": "40 gr",
      "Protein": "5 gr",
      "Kalori": "230 Kkal",
      "Lemak": "15 gr",
    },
    uploadDate: DateTime(2025, 5, 3),
  ),
  // === Sup Jagung Telur ===
  Resep(
    title: "Sup Jagung Telur",
    description: "Sup ringan dan sehat dengan rasa manis dari jagung dan tekstur lembut telur.",
    ingredients: [
      "2 jagung manis",
      "1 butir telur",
      "500 ml air",
      "1 sdm maizena",
      "Garam dan merica",
    ],
    ingredientNames: ["jagung", "telur", "air", "maizena", "garam", "merica"],
    tools: ["Panci", "Whisk", "Sendok"],
    steps: [
      {
        "title": "Rebus jagung",
        "duration": "10 menit",
        "steps": ["Masukkan jagung ke dalam air mendidih."]
      },
      {
        "title": "Tambahkan bahan lain",
        "duration": "5 menit",
        "steps": ["Masukkan telur yang sudah dikocok perlahan sambil diaduk.", "Tambahkan larutan maizena, bumbui."]
      },
    ],
    categories: ["Sup"],
    tags: ["Chinese Food", "Sehat"],
    imageAsset: "assets/images/sup_jagung.jpeg",
    author: "Michelle Kurnia",
    authorFollowers: "8.6k Followers",
    rating: 4.6,
    reviewCount: 1950,
    servings: 3,
    duration: Duration(minutes: 20),
    price: 20000,
    nutrition: {
      "Karbohidrat": "35 gr",
      "Protein": "6 gr",
      "Kalori": "110 Kkal",
      "Lemak": "3 gr",
    },
    uploadDate: DateTime(2025, 5, 5),
  ),

  // === Simple Scrambled Egg ===
  Resep(
    title: "Simple Scrambled Egg",
    description: "Telur orak-arik lembut dengan sedikit mentega, cocok untuk sarapan cepat dan bergizi.",
    ingredients: [
      "2 butir telur",
      "1 sdm mentega",
      "Garam secukupnya",
      "Merica secukupnya",
    ],
    ingredientNames: ["telur", "mentega", "garam", "merica"],
    tools: ["Wajan", "Spatula", "Mangkuk"],
    steps: [
      {
        'title': 'Kocok telur',
        'duration': '2 menit',
        'steps': ["Kocok telur dalam mangkuk hingga tercampur rata."]
      },
      {
        'title': 'Masak telur',
        'duration': '5 menit',
        'steps': [
          "Panaskan wajan dengan mentega.",
          "Tuang telur dan aduk perlahan dengan api kecil hingga matang lembut."
        ]
      },
    ],
    categories: ["Makanan"],
    tags: ["BasicSkill", "Sarapan", "Western"],
    imageAsset: "assets/images/scrambled_egg.jpg",
    author: "Anna Belle",
    authorFollowers: "4.2k Followers",
    rating: 4.5,
    reviewCount: 5000,
    servings: 1,
    duration: Duration(minutes: 10),
    price: 8000,
    nutrition: {
      "Karbohidrat": "2 gr",
      "Protein": "12 gr",
      "Kalori": "150 Kkal",
      "Lemak": "10 gr",
    },
    uploadDate: DateTime(2025, 5, 4),
  ),

  // === Grilled Cheese Sandwich ===
  Resep(
    title: "Grilled Cheese Sandwich",
    description: "Roti lapis isi keju leleh, dipanggang renyah di luar, lembut dan gurih di dalam.",
    ingredients: [
      "2 lembar roti tawar",
      "2 lembar keju cheddar",
      "1 sdm mentega",
    ],
    ingredientNames: ["roti", "keju", "mentega"],
    tools: ["Teflon", "Spatula", "Pisau"],
    steps: [
      {
        'title': 'Siapkan roti',
        'duration': '2 menit',
        'steps': ["Olesi satu sisi roti dengan mentega."]
      },
      {
        'title': 'Panggang sandwich',
        'duration': '5 menit',
        'steps': [
          "Letakkan keju di antara roti, panggang sisi luar hingga kecokelatan dan keju meleleh."
        ]
      },
    ],
    categories: ["Cemilan"],
    tags: ["Western", "Keju", "Snack"],
    imageAsset: "assets/images/grilled_cheese.jpg",
    author: "Michael T.",
    authorFollowers: "7.5k Followers",
    rating: 4.6,
    reviewCount: 4000,
    servings: 1,
    duration: Duration(minutes: 8),
    price: 12000,
    nutrition: {
      "Karbohidrat": "25 gr",
      "Protein": "9 gr",
      "Kalori": "250 Kkal",
      "Lemak": "15 gr",
    },
    uploadDate: DateTime(2025, 5, 5),
  ),
];