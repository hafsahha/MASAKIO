import 'package:flutter/material.dart';
import 'package:masakio/data/functions.dart';
import 'package:masakio/.components/future_resep_grid.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = fetchWishlist();
  }

  void _refreshWishlist() {
    setState(() {
      _wishlistFuture = fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: ResepGridF(
          recipes: _wishlistFuture,
          onRefresh: _refreshWishlist, // If your grid supports a callback
        ),
      ),
    );
  }
}