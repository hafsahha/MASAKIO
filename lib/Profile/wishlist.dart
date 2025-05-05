import 'package:flutter/material.dart';
import 'package:masakio/.components/resep_grid.dart';
import 'package:masakio/data/dummy_resep.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: ResepGrid(
            reseps: dummyResepListBookmarked,
          ),
        ),
      ),
    );
  }
}