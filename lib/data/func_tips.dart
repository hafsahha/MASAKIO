import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:masakio/data/func_profile.dart';

const String baseUrl = 'https://masakio.up.railway.app/tips';

/// Ambil semua tips (ringkasan, tanpa hashtag)
Future<List<Map<String, dynamic>>> fetchAllTips() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/all')).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) throw Exception('Gagal memuat tips');

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'id': item['id_tips'],
      'uploader': item['nama_uploader'],
      'title': item['judul'],
      'imageUrl': item['foto'],
    }).toList();
  } catch (e) {
    rethrow;
  }
}

/// Ambil detail tips berdasarkan ID (termasuk hashtag)
Future<Map<String, dynamic>> fetchTipsDetail(int id) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/$id')).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) throw Exception('Tips tidak ditemukan');

    final data = json.decode(response.body);
    return {
      'id': data['id_tips'],
      'uploader': data['nama_user'],
      'title': data['judul'],
      'description': data['deskripsi'],
      'imageUrl': data['foto'],
      'timestamp': data['timestamp'],
      'hashtags': (data['hashtags'] as String?)?.split(',') ?? [],
    };
  } catch (e) {
    rethrow;
  }
}

/// Tambah tips baru
Future<bool> addTips({
  required String title,
  required String description,
  required List<String> hashtags,
  required String imageUrl,
  required int userId,
}) async {
  final url = Uri.parse('https://masakio.up.railway.app/tips/add');

  final Map<String, dynamic> requestData = {
    'id_user': userId, // ✅ harus id_user
    'judul': title,
    'deskripsi': description,
    'foto': imageUrl,
    'hashtags': hashtags,
  };

  print("Mengirim data: ${jsonEncode(requestData)}"); // 🔍 debug

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    print("Status: ${response.statusCode}");
    print("Response: ${response.body}");

    return response.statusCode == 201;
  } catch (e) {
    print("Gagal mengirim tips: $e");
    return false;
  }
}


/// Mengupload gambar ke Cloudinary dan mengembalikan URL-nya.
Future<String> uploadImageToCloudinary(Uint8List imageBytes) async {
  const cloudName = 'dve4fhdob';
  const uploadPreset = 'gambar';

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'tips_image.jpg',
      ),
    );

  final response = await request.send();

  if (response.statusCode == 200) {
    final resStr = await response.stream.bytesToString();
    final resJson = jsonDecode(resStr);
    return resJson['secure_url']; // URL gambar dari Cloudinary
  } else {
    throw Exception('Gagal mengupload gambar ke Cloudinary (status: ${response.statusCode})');
  }
}

/// Hapus tips berdasarkan ID
Future<bool> deleteTips(int tipsId) async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/$tipsId/delete'))
      .timeout(const Duration(seconds: 10));

    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
