import 'package:flutter/material.dart';
import 'package:masakio/.components/bottom_popup.dart';
import 'package:masakio/.components/button.dart';
import 'package:masakio/.components/navbar.dart';

import 'package:masakio/Tambah Resep/tambah-resep-1.dart';
import 'package:masakio/Tips Trik/tambah_tips.dart';

import 'package:masakio/home.dart';
import 'package:masakio/Forum/forum_page.dart';
import 'package:masakio/Profile/profile.dart';
import 'package:masakio/Auth/auth_gate.dart'; // Import AuthGate

import 'package:masakio/discovery.dart';

class MainPage extends StatefulWidget {
  final int pageIndex;
  const MainPage({super.key, required this.pageIndex});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _index;

  // Wrap the ProfilePage with AuthGate
  final _pages = [
    const HomePage(),
    const DiscoveryResep(),
    const ForumPage(),
    const AuthGate(
      childPage: ProfilePage(pageIndex: 0),
      pageName: "Profil",
      icon: Icons.person
    )
  ];
  
  @override
  void initState() {
    super.initState();
    _index = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                  Button(
                    content: 'Buat Resep Baru',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TambahResep1Page()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Button(
                    content: 'Tulis Tips & Trik',
                    onPressed: () {
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