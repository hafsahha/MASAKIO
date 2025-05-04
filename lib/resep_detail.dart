import 'package:flutter/material.dart';

class ResepDetailPage extends StatefulWidget {
  const ResepDetailPage({super.key});

  @override
  State<ResepDetailPage> createState() => _ResepDetailPageState();
}

class _ResepDetailPageState extends State<ResepDetailPage> {
  bool showAllIngredients = false;
  bool showAllTools = false;
  bool showAllSteps = false;

  final List<Map<String, String>> ingredients = [
    {'name': 'Nasi (sesuaikan saja)', 'amount': '2 mangkok'},
    {'name': 'Sosis, potong', 'amount': '2 buah'},
    {'name': 'Bawang putih, iris', 'amount': '2 siung'},
    {'name': 'Bawang merah, iris', 'amount': '1 siung'},
    {'name': 'Cabe merah, iris', 'amount': '1 buah'},
  ];

  final List<Map<String, String>> tools = [
    {'name': 'Wajan', 'description': '1 buah ukuran sedang'},
    {'name': 'Spatula', 'description': '1 buah'},
    {'name': 'Piring saji', 'description': '1 buah'},
    {'name': 'Pisau', 'description': '1 buah'},
    {'name': 'Talenan', 'description': '1 buah'},
  ];

  final List<Map<String, dynamic>> cookingSteps = [
    {
      'title': 'Persiapan',
      'duration': '5 menit',
      'steps': [
        'Masak nasi jika tidak menggunakan sisa nasi.',
        'Iris sosis, cincang bawang putih, potong bawang bombay, iris cabai, dan potong dadu wortel.'
      ]
    },
    {
      'title': 'Masak sosis',
      'duration': '5 menit',
      'steps': [
        'Panaskan 1 sendok makan minyak sayur dalam wajan atau wajan besar dengan api sedang besar.',
        'Tumis bawang putih dan bawang merah hingga harum.',
        'Masukkan sosis, aduk hingga sosis matang.'
      ]
    },
    {
      'title': 'Masak nasi',
      'duration': '10 menit',
      'steps': [
        'Masukkan nasi ke dalam wajan, aduk rata dengan bumbu dan sosis.',
        'Tambahkan kecap manis, garam, dan merica secukupnya.',
        'Aduk terus hingga nasi matang merata dan bumbu meresap.'
      ]
    },
  ];

  final List<Map<String, dynamic>> nutrition = [
    {'name': 'Karbohidrat', 'value': '65 gr', 'icon': Icons.grass_outlined},
    {'name': 'Protein', 'value': '27 gr protein', 'icon': Icons.egg_outlined},
    {'name': 'Lemak', 'value': '15 gr', 'icon': Icons.fastfood_outlined},
    {'name': 'Serat', 'value': '3 gr', 'icon': Icons.local_florist_outlined},
    
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> visibleIngredients =
        showAllIngredients ? ingredients : ingredients.take(3).toList();

    List<Map<String, String>> visibleTools =
        showAllTools ? tools : tools.take(3).toList();

    List<Map<String, dynamic>> visibleSteps =
        showAllSteps ? cookingSteps : cookingSteps.take(2).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/pizza.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Chip(
                    label: Text('12:08'),
                    backgroundColor: Colors.white70,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Sausage Nasi Goreng',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('4.9'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                      SizedBox(width: 8),
                      Text('Alicia Ramsey · 10.9k Followers'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.person_outline),
                      SizedBox(width: 4),
                      Text('Porsi 1 Orang'),
                      SizedBox(width: 16),
                      Icon(Icons.access_time),
                      SizedBox(width: 4),
                      Text('50 Minutes'),
                      SizedBox(width: 16),
                      Icon(Icons.monetization_on_outlined),
                      SizedBox(width: 4),
                      Text('Rp. 30.000'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Chip(
                        label: Text('Makanan Berat'),
                        backgroundColor: Color(0xFF83AEB1),
                        labelStyle: TextStyle(color: Colors.white),
                        shape: StadiumBorder(
                          side: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      SizedBox(width: 8),
                      Chip(
                        label: Text('Asian'),
                        backgroundColor: Color(0xFF83AEB1),
                        labelStyle: TextStyle(color: Colors.white),
                        shape: StadiumBorder(
                          side: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ini adalah resep kebanggan keluarga. Nasi goreng dengan sosis, telur, dan bumbu yang meresap sempurna. Cocok untuk makan siang keluarga.',
                  ),
                  const SizedBox(height: 16),
                  Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Supaya rata kiri
  children: [
    const Text(
      'Bahan',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ini penting agar isi juga rata kiri
          children: [
            for (int i = 0; i < visibleIngredients.length; i++) ...[
              IngredientRow(
                name: visibleIngredients[i]['name']!,
                amount: visibleIngredients[i]['amount']!,
              ),
              if (i < visibleIngredients.length - 1) const Divider(),
            ],
            TextButton(
              onPressed: () {
                setState(() {
                  showAllIngredients = !showAllIngredients;
                });
              },
              child: Text(
                showAllIngredients ? 'Sembunyikan' : 'Lihat Lainnya',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
                  const SizedBox(height: 16),
                  const Text(
                    'Alat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                  color: Colors.white, // Warna latar putih
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300), // Border abu-abu
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          for (int i = 0; i < visibleTools.length; i++) ...[
                            ToolRow(
                              name: visibleTools[i]['name']!,
                              description: visibleTools[i]['description']!,
                            ),
                            if (i < visibleTools.length - 1)
                              const Divider(), // Garis pemisah antar alat
                          ],
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAllTools = !showAllTools;
                              });
                            },
                            child: Text(
                              showAllTools ? 'Sembunyikan' : 'Lihat Lainnya',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cara Memasak',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                  color: Colors.white, // Warna latar putih
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300), // Border abu-abu
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          for (int i = 0; i < visibleSteps.length; i++) ...[
                            CookingStepItem(
                              stepNumber: i + 1,
                              title: visibleSteps[i]['title'],
                              duration: visibleSteps[i]['duration'],
                              steps:
                                  List<String>.from(visibleSteps[i]['steps']),
                            ),
                            if (i < visibleSteps.length - 1)
                              const SizedBox(height: 16), // Spasi antar langkah
                          ],
                          if (cookingSteps.length > 2)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showAllSteps = !showAllSteps;
                                });
                              },
                              child: Text(
                                showAllSteps ? 'Sembunyikan' : 'Lihat Lainnya',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                                    const Text(
                    'Nutrisi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true, // penting agar tinggi menyesuaikan isi
                    physics: const NeverScrollableScrollPhysics(), // biar gak bisa di-scroll sendiri
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: nutrition.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  nutrition[index]['icon'],
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      nutrition[index]['value'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      nutrition[index]['name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // batasnya disini
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // aksi simpan resep
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                        ),
                        icon: const Icon(Icons.bookmark_border, color: Colors.grey),
                        label: const Text(
                          'Simpan Resep',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          // aksi bagikan resep
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                        ),
                        icon: const Icon(Icons.share, color: Colors.grey),
                        label: const Text(
                          'Bagikan Resep',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  // lanjut disini yang beri ulasan
                  const SizedBox(height: 24),
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Menurutmu bagaimana resep ini?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (index) => IconButton(
            icon: Icon(
              Icons.star_border,
              color: Colors.grey.shade400,
              size: 32,
            ),
            onPressed: () {
              // Implementasi logika penilaian
            },
          ),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        decoration: InputDecoration(
          hintText: 'Tulis ulasan...',
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          prefixIcon: Icon(Icons.edit, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        maxLines: 3,
        minLines: 1,
      ),
    ],
  ),
),
//sampai sini
// mulai lagi
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Ulasan (1.234)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Lihat semua',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    // Card Review
    Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama + rating
                Row(
                  children: [
                    const Text(
                      'Ayu R.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        ...List.generate(4, (index) => Icon(Icons.star, color: Colors.amber, size: 16)),
                        Icon(Icons.star_half, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text('4.7', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const Text(
                  'Bergabung sejak Maret 2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Resepnya enak dan mudah diikuti. Terima kasih!',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
)


// sampe  disini
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientRow extends StatelessWidget {
  final String name;
  final String amount;

  const IngredientRow({Key? key, required this.name, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ToolRow extends StatelessWidget {
  final String name;
  final String description;

  const ToolRow({Key? key, required this.name, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(
            description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CookingStepItem extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String duration;
  final List<String> steps;

  const CookingStepItem({
    Key? key,
    required this.stepNumber,
    required this.title,
    required this.duration,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$stepNumber. $title',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($duration)',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: steps
              .map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(step)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
