import 'package:flutter/material.dart';
import 'package:masakio/.components/future_resep_grid.dart';
import 'package:masakio/data/func_profile.dart';
import 'package:masakio/data/func_recipe.dart';

class ResepSayaPage extends StatefulWidget {
  const ResepSayaPage({super.key});

  @override
  State<ResepSayaPage> createState() => _ResepSayaPageState();
}

class _ResepSayaPageState extends State<ResepSayaPage> {
  Future<List>? _myRecipesFuture;
  User? user;

  @override
  void initState() {
    super.initState();
    _myRecipesFuture = AuthService.getCurrentUser().then((u) {
      user = u;
      return fetchAllUserRecipes(user!.id);
    });
  }

  void _refreshMyRecipes() => setState(() => _myRecipesFuture = fetchAllUserRecipes(user!.id));

  @override
  Widget build(BuildContext context) {
    if (_myRecipesFuture == null) return Scaffold(body: const Center(child: CircularProgressIndicator()));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: ResepGridF(
          recipes: _myRecipesFuture!,
          onRefresh: _refreshMyRecipes,
        ),
      ),
    );
  }
}
