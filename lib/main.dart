import 'package:flutter/material.dart';
import 'tambah-resep/tambah-resep-1.dart';
import 'detail_tips.dart';
import 'forumPage/forum_page.dart';
import 'tambah_tips.dart';
import 'main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MASAKIO | KELOMPOK 20',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF83AEB1),
          primary: const Color(0xFF83AEB1),
        ),
        useMaterial3: true,
      ),
      home: const RecipeMenuPage(),
    );
  }
}

class RecipeMenuPage extends StatelessWidget {
  const RecipeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data anggota kelompok
    final List<Map<String, String>> teamMembers = [
      {'nim': '2304137', 'name': 'Muhammad Bintang Eighista Dwiputra'},
      {'nim': '2308224', 'name': 'Datuk Daneswara Raditya Samsura'},
      {'nim': '2308744', 'name': 'Shizuka Maulia Putri'},
      {'nim': '2309209', 'name': 'Safira Aliyah Azmi'},
      {'nim': '2311474', 'name': 'Hafsah Hamidah'},
      {'nim': '2312091', 'name': 'Nina Wulandari'},
    ];

    // List menu resep
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Register',
        'dest': null,
        'icon': Icons.app_registration,
        'gradient': [const Color(0xFF83AEB1), const Color(0xFF6A9598)]
      },
      {
        'title': 'Login',
        'dest': null,
        'icon': Icons.login,
        'gradient': [const Color(0xFF8EBDC0), const Color(0xFF75A3A6)]
      },
      {
        'title': 'Homepage',
        'dest': const MainPage(pageIndex: 0),
        'icon': Icons.home,
        'gradient': [const Color(0xFF98C7CA), const Color(0xFF7FABB0)]
      },
      {
        'title' : 'Discover - Resep',
        'dest': const MainPage(pageIndex: 1),
        'icon': Icons.search,
        'gradient': [const Color(0xFFA3D0D3), const Color(0xFF8AB5B8)]
      },
      {
        'title': 'Discover - Tips & Trik',
        'dest': null,
        'icon': Icons.search,
        'gradient': [const Color(0xFF83AEB1), const Color(0xFF6A9598)]
      },
      {
        'title': 'Detail Resep',
        'dest': null,
        'icon': Icons.receipt_long,
        'gradient': [const Color(0xFF8EBDC0), const Color(0xFF75A3A6)]
      },
      {
        'title': 'Tambah Resep Baru',
        'dest' : const TambahResep1Page(),
        'icon': Icons.restaurant_menu,
        'gradient': [const Color(0xFF83AEB1), const Color(0xFF6A9598)]
      },
      {
        'title': 'Detail Tips & Trik',
        'dest' : const TipsAndTrikPage(),
        'icon': Icons.info_outline,
        'gradient': [const Color(0xFF8EBDC0), const Color(0xFF75A3A6)]
      },
      {
        'title': 'Tambah Tips & Trik',
        'dest': const TambahTipsPage(),
        'icon': Icons.add_circle_outline,
        'gradient': [const Color(0xFF98C7CA), const Color(0xFF7FABB0)]
      },
      {
        'title': 'Forum Diskusi',
        'dest': const MainPage(pageIndex: 2)
        'icon': Icons.forum,
        'gradient': [const Color(0xFFA3D0D3), const Color(0xFF8AB5B8)]
      },
      {
        'title' : 'Detail Forum Diskusi',
        'dest': null,
        'icon': Icons.forum_outlined,
        'gradient': [const Color(0xFF83AEB1), const Color(0xFF6A9598)]
      },
      {
        'title' : 'Profile',
        'dest': const MainPage(pageIndex: 3),
        'icon': Icons.person,
        'gradient': [const Color(0xFF8EBDC0), const Color(0xFF75A3A6)]
      },
      {
        'title' : 'Edit Profile',
        'dest': null,
        'icon': Icons.edit,
        'gradient': [const Color(0xFF83AEB1), const Color(0xFF6A9598)]
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF83AEB1),
        title: const Text(
          'MASAKIO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF566E70),
                ),
              ),
              const Text(
                'Pilih menu untuk menambahkan resep baru',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF83AEB1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              
              // Card untuk informasi kelompok
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF83AEB1), Color(0xFF6A9598)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF83AEB1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.groups,
                              size: 24,
                              color: Color(0xFF566E70),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'KELOMPOK 20',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white30,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: teamMembers.map((member) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  member['nim']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    member['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return _buildMenuCard(
                      context,
                      menuItems[index]['title'],
                      menuItems[index]['dest'],
                      menuItems[index]['icon'],
                      menuItems[index]['gradient'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Metode untuk membuat item bottom nav bar
  Widget _buildNavBarItem({required IconData icon, required int index, required bool isSelected}) {
    return Container(
      width: 60,
      height: 60,
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFF83AEB1) : Colors.grey[400],
        size: 24,
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, String title, dynamic dest, IconData icon, List<Color> gradient) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => dest)
        );
        // if (title == 'Tambah Resep Baru') {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const TambahResep1Page()),
        //   );
        // } else if (title == 'Detail Tips & Trik') {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const TipsAndTrikPage()),
        //   );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('$title dipilih'),
        //       backgroundColor: const Color(0xFF83AEB1),
        //       duration: const Duration(seconds: 1),
        //     ),
        //   );
        // }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF83AEB1).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: const Color(0xFF83AEB1),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}