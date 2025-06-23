import 'package:flutter/material.dart';
import 'package:masakio/data/func_recipe.dart';
import 'package:masakio/.components/future_resep_grid.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Map<String, dynamic>>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    // TODO: Implement actual history tracking
    // For now, showing all recipes as placeholder
    setState(() {
      _historyFuture = fetchAllRecipes();
    });
  }

  void _refreshHistory() {
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
              // TODO: Implement clear history
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Riwayat'),
                  content: const Text('Apakah Anda yakin ingin menghapus semua riwayat?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Clear history implementation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur hapus riwayat akan segera tersedia'),
                          ),
                        );
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Info section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Riwayat resep yang Anda lihat akan muncul di sini',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // History grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: _historyFuture != null
                  ? ResepGridF(
                      recipes: _historyFuture!,
                      onRefresh: _refreshHistory,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}