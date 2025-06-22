import 'package:flutter/material.dart';
import 'package:masakio/data/func_recipe.dart';
import 'package:masakio/.components/future_resep_grid.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: ResepGridF(
          recipes: Future.value(fetchAllRecipes())
        ),
      ),
    );
  }
}