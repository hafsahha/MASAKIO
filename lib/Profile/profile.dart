import 'package:flutter/material.dart';
import 'package:masakio/.components/user_avatar.dart';
import 'package:masakio/Profile/edit_profile.dart';
import 'package:masakio/Profile/history.dart';
import 'package:masakio/Profile/resep_saya.dart';
import 'package:masakio/Profile/wishlist.dart';
import 'package:masakio/data/func_profile.dart';

class ProfilePage extends StatefulWidget {
  final int pageIndex;
  const ProfilePage({super.key, required this.pageIndex});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int _index;
  User ? user;
  bool isLoggedIn = false;

  final List<Map<String, dynamic>> _pages = [
    { 'dest': const ResepSayaPage(), 'text': 'Resep Saya' },
    { 'dest': const HistoryPage(), 'text': 'History' },
    { 'dest': const WishlistPage(), 'text': 'Wishlist' },
  ];

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _index = widget.pageIndex;
  }

  Future<void> _checkAuth() async {
    isLoggedIn = await AuthService.isLoggedIn();
    user = isLoggedIn ? await AuthService.getCurrentUser() : null;
    if (mounted) setState(() => isLoggedIn = isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index]['dest'],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(260.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UserAvatar(
                    imageUrl: isLoggedIn ? 'assets/images/${user!.photo}' : '',
                    size: 120,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFB6D9D0),
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                        color: Colors.white, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfile(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                user != null ? user!.name : 'Guest User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_pages.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                      _index = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _index == index ? Color(0xFF83AEB1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _pages[index]['text'],
                          style: TextStyle(
                          color: _index == index ? Colors.white : Color(0xFF83AEB1),
                          fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),          
        ),
      ),
    );
  }
}