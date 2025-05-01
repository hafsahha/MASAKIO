import 'package:flutter/material.dart';
import 'package:masakio/components/bottom_popup.dart';
import 'package:masakio/components/button.dart';
import 'package:masakio/components/navbar.dart';
import 'package:masakio/tambah-resep/tambah-resep-1.dart';

import 'package:masakio/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = [
    const Center(child: Text('Home Page')),     // HomePage(),
    const Center(child: Text('Explore Page')),  // ExplorePage(),
    const Center(child: Text('Forum Page')),    // ForumPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF83AEB1),
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return BottomPopup(
                children: [
                  Text('Mau buat apa hari ini?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Button(dest: TambahResep1Page(), content: 'Buat Resep Baru'),
                  const SizedBox(height: 10),
                  Button(dest: null, content: 'Tulis Tips & Trik'),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(
        idx: _index,
        onItemSelected: (index) => setState(() => _index = index),
      ),
    );
  }
}