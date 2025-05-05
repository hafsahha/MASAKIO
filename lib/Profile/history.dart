import 'package:flutter/material.dart';
import 'package:masakio/.components/resep_grid.dart';
import 'package:masakio/data/dummy_resep.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: ResepGrid(
            reseps: dummyResepList,
          ),
        ),
      ),
    );
  }
}