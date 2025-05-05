import 'package:flutter/material.dart';
import 'package:masakio/.components/resep_grid.dart';
import 'package:masakio/data/dummy_resep.dart';

class ResepSayaPage extends StatefulWidget {
  const ResepSayaPage({super.key});

  @override
  State<ResepSayaPage> createState() => _ResepSayaPageState();
}

class _ResepSayaPageState extends State<ResepSayaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: ResepGrid(
            reseps: dummyResepListOwned,
          ),
        ),
      ),
    );
  }
}