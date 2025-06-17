import 'dart:convert';
import 'package:http/http.dart' as http;

const url = 'https://masakio.up.railway.app/';

Future<List> fetchWishlist() async {
  final response = await http.get(Uri.parse('${url}wishlist'));
  if (response.statusCode != 200) throw Exception('Failed to load wishlist');
  final List data = (json.decode(response.body) as List)
    .map((item) => {
      'id': item['id_resep'].toString(),
      'title': item['nama_resep'],
      'rating': item['rating'] ?? 0.0,
      'reviewCount': item['review_count'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isBookmarked': true,
    }).toList();
  return data;
}

Future<List> fetchAllRecipes() async {
  final response = await http.get(Uri.parse('${url}recipes'));
  if (response.statusCode != 200) throw Exception('Failed to load recipes');
  final List data = (json.decode(response.body) as List)
    .map((item) => {
      'id': item['id_resep'].toString(),
      'title': item['nama_resep'],
      'rating': item['rating'] ?? 0.0,
      'reviewCount': item['review_count'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isOwned': false,
      'isBookmarked': false,
    }).toList();
  return data;
}

void wish(String id) async {
  final response = await http.post(Uri.parse('${url}wish/$id'));
  if (response.statusCode == 200) {
    print('Berhasil menambahkan ke wishlist');
  } else {
    print('Gagal menambahkan ke wishlist: ${response.reasonPhrase}');
  }
}

void unWish (String id) async { await http.post(Uri.parse('${url}unwish/$id')); }