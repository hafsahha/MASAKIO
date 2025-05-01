import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int idx;
  final Function(int) onItemSelected;

  const Navbar({super.key, required this.idx, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      { 'icon': Icons.home,    'label': 'Home'    },
      { 'icon': Icons.explore, 'label': 'Explore' },
      { 'icon': Icons.forum,   'label': 'Forum'   },
      { 'icon': Icons.person,  'label': 'Profile' },
    ];
    
    return BottomAppBar (
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      elevation: 10.0,
      color: Colors.white,
      height: 80.0,
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, items[0], 0),
            _navItem(context, items[1], 1),
            const SizedBox(width: 60),
            _navItem(context, items[2], 2),
            _navItem(context, items[3], 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, Map<String, dynamic> item, int index) {
    final isSelected = idx == index;
    return IconButton(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item['icon'],
            color: isSelected ? const Color(0xFF83AEB1) : Colors.grey,
          ),
          Text(
            item['label'],
            style: TextStyle(
              color: isSelected ? const Color(0xFF83AEB1) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onPressed: () => onItemSelected(index),
    );
  }
}