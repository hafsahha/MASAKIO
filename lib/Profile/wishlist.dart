import 'package:flutter/material.dart';
import 'package:masakio/data/func_wishlist.dart';
import 'package:masakio/.components/future_resep_grid.dart';
import 'package:masakio/data/func_profile.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Future<List>? _wishlistFuture;
  User? user;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = AuthService.getCurrentUser().then((u) {
      user = u;
      return fetchWishlist(user!.id);
    });
  }

  void _refreshWishlist() => setState(() => _wishlistFuture = fetchWishlist(user!.id));

  @override
  Widget build(BuildContext context) {
    if (_wishlistFuture == null) return Scaffold(body: const Center(child: CircularProgressIndicator()));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: ResepGridF(
          recipes: _wishlistFuture!,
          onRefresh: _refreshWishlist,
        ),
      ),
    );
  }
}