import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:masakio/data/func_profile.dart';

const String baseUrl = 'https://masakio.up.railway.app/tips';

/// Ambil semua tips (ringkasan, tanpa hashtag)
Future<List<Map<String, dynamic>>> fetchAllTips() async {
  try {
    print('[fetchAllTips] Memulai request ke $baseUrl/all');
    final response = await http.get(Uri.parse('$baseUrl/all')).timeout(const Duration(seconds: 10));

    print('[fetchAllTips] Status Code: ${response.statusCode}');
    print('[fetchAllTips] Body: ${response.body}');

    if (response.statusCode != 200) throw Exception('Gagal memuat tips');

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => {
      'id': item['id_tips'],
      'uploader': item['nama_uploader'],
      'title': item['judul'],
      'imageUrl': item['foto'],
    }).toList();
  } catch (e) {
    print('[fetchAllTips] ERROR: $e');
    rethrow;
  }
}


/// Ambil detail tips berdasarkan ID (termasuk hashtag)
Future<Map<String, dynamic>> fetchTipsDetail(int idTips) async {
  final url = Uri.parse('https://masakio.up.railway.app/tips/$idTips');

  try {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail tips');
    }

    final data = jsonDecode(response.body);
    return {
      'id': data['id_tips'],
      'title': data['judul'],
      'description': data['deskripsi'],
      'imageUrl': data['foto'],
      'timestamp': data['timestamp'],
      'uploader': data['nama_user'],
      'hashtags': data['hashtags'] != null
          ? (data['hashtags'] as String)
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList()
          : [],
    };
  } catch (e) {
    print('[fetchTipsDetail] Error: $e');
    rethrow;
  }
}


/// Tambah tips baru
Future<Map<String, dynamic>?> addTips({
  required String title,
  required String description,
  required List<String> hashtags,
  required String imageUrl,
  required int userId,
}) async {
  final url = Uri.parse('https://masakio.up.railway.app/tips/add');

  final Map<String, dynamic> requestData = {
    'id_user': userId,
    'judul': title,
    'deskripsi': description,
    'foto': imageUrl,
    'hashtags': hashtags,
  };

  print('[addTips] Data yang dikirim: ${jsonEncode(requestData)}');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    print('[addTips] Status Code: ${response.statusCode}');
    print('[addTips] Response: ${response.body}');

    if (response.statusCode != 201) {
      print('[addTips] Gagal menyimpan tips, status: ${response.statusCode}');
      return null;
    }

    // Decode response
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return {
      'id_tips': responseData['id_tips'],
      'judul': title,
      'deskripsi': description,
      'foto': imageUrl,
      'hashtags': hashtags,
      'id_user': userId,
    };
  } catch (e) {
    print('[addTips] ERROR: $e');
    return null;
  }
}



/// Mengupload gambar ke Cloudinary dan mengembalikan URL-nya.
Future<String> uploadImageToCloudinary(Uint8List imageBytes) async {
  const cloudName = 'dve4fhdob';
  const uploadPreset = 'gambar';

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  print('[uploadImageToCloudinary] Upload dimulai');

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'tips_image.jpg',
      ),
    );

  try {
    final response = await request.send();

    print('[uploadImageToCloudinary] Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final resJson = jsonDecode(resStr);
      print('[uploadImageToCloudinary] Response: $resJson');
      return resJson['secure_url'];
    } else {
      throw Exception('Upload gagal (status: ${response.statusCode})');
    }
  } catch (e) {
    print('[uploadImageToCloudinary] ERROR: $e');
    rethrow;
  }
}


/// Hapus tips berdasarkan ID
Future<bool> deleteTips(int tipsId) async {
  final url = '$baseUrl/$tipsId/delete';
  print('[deleteTips] Menghapus tips dengan ID: $tipsId');

  try {
    final response = await http.delete(Uri.parse(url)).timeout(const Duration(seconds: 10));

    print('[deleteTips] Status Code: ${response.statusCode}');
    print('[deleteTips] Response: ${response.body}');

    return response.statusCode == 200;
  } catch (e) {
    print('[deleteTips] ERROR: $e');
    return false;
  }
}

