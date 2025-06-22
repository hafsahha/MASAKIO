// func_detail_resep.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dummy_resep.dart'; // Pastikan path sesuai

Future<Resep> fetchDetailResepById(int id) async {
  final response = await http.get(
    Uri.parse('https://masakio.up.railway.app/recipe/$id'),
  );  if (response.statusCode != 200) {
    throw Exception('Failed to load recipe detail');
  }
  final data = json.decode(response.body);

  // Mapping field sesuai dengan struktur data dari backend/database kamu
  return Resep(
    id: data['info']['id_resep'].toString(),
    title: data['info']['nama_resep'] ?? '',
    description: data['info']['deskripsi'] ?? '',
    ingredients:
        (data['bahan'] as List<dynamic>?)
            ?.map((b) => b['nama_bahan'] ?? '')
            .toList()
            .cast<String>() ??
        [],
    ingredientNames:
        (data['bahan'] as List<dynamic>?)
            ?.map((b) => b['nama_bahan'] ?? '')
            .toList()
            .cast<String>() ??
        [],
    tools:
        (data['alat'] as List<dynamic>?)
            ?.map((a) => a['nama_alat'] ?? '')
            .toList()
            .cast<String>() ??
        [],
    steps:
        (data['prosedur'] as List<dynamic>?)
            ?.map(
              (p) => {
                'title': p['nama_prosedur'] ?? '',
                'duration': (p['durasi'] ?? '').toString(),
                'steps':
                    (p['langkah'] as List<dynamic>?)
                        ?.map((l) => l['nama_langkah'] ?? '')
                        .toList()
                        .cast<String>() ??
                    [],
              },
            )
            .toList() ??
        [],
    categories: [],
    tags: [],
    imageAsset: '',
    author: data['info']['nama_penulis'] ?? '',
    authorFollowers: '', // Isi jika ada
    rating: double.tryParse(data['info']['rating'].toString()) ?? 0,
    reviewCount: data['info']['jumlah_review'] ?? 0,
    viewsCount: data['info']['jumlah_view'] ?? 0,
    servings: data['info']['porsi'] ?? 1,    duration: const Duration(minutes: 0), // Isi jika ada
    price: 0, // Isi jika ada
    nutrition: {
      'Karbohidrat': data['info']['karbohidrat'] != null ? '${data['info']['karbohidrat']} gr' : '0 gr',
      'Protein': data['info']['protein'] != null ? '${data['info']['protein']} gr' : '0 gr', 
      'Lemak': data['info']['lemak'] != null ? '${data['info']['lemak']} gr' : '0 gr',
      'Serat': data['info']['serat'] != null ? '${data['info']['serat']} gr' : '0 gr',
    },
    uploadDate: DateTime.now(),
    isOwned: false,
    isBookmarked: false,
  );
}
