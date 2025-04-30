import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;

  const Navbar({super.key, this.initialIndex = 0});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int idx;

  @override
  void initState() {
    super.initState();
    idx = widget.initialIndex; // Set the initial index from the parameter
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.add, size: 0), label: ''), // Placeholder for the center button
            BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: idx,
          selectedItemColor: Color(0xFF83AEB1),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              idx = index;
            });
          },
        ),
        Positioned(
          bottom: 10, // Adjust as needed
          left: MediaQuery.of(context).size.width / 2 - 28, // Center the button
          child: FloatingActionButton(
            onPressed: () {
              // Add your action here
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}