import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const diseaseHistoryEndpoint = '${url}user/disease-history/'; // Endpoint untuk riwayat penyakit

// Disease model
class Disease {
  final int id;
  final String name;
  
  Disease({
    required this.id,
    required this.name,
  });
  
  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id_penyakit'],
      name: json['nama_penyakit'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_penyakit': id,
      'nama_penyakit': name,
    };
  }
}

// DiseaseSuggestion model untuk autocomplete
class DiseaseSuggestion {
  final int id;
  final String name;
  
  DiseaseSuggestion({
    required this.id,
    required this.name,
  });
  
  factory DiseaseSuggestion.fromJson(Map<String, dynamic> json) {
    return DiseaseSuggestion(
      id: json['id_penyakit'],
      name: json['nama_penyakit'],
    );
  }
}

// Get user disease history
Future<List<Disease>> getDiseaseHistory(int userId) async {
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse('${diseaseHistoryEndpoint}${userId}'))
      .timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) throw Exception('Failed to load disease history');
    
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Disease.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching disease history: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Add disease to history
Future<bool> addDiseaseHistory(int userId, String diseaseName) async {
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse('${url}user/disease-history/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'diseaseName': diseaseName,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print('Error adding disease history: $e');
    return false;
  } finally {
    client.close();
  }
}

// Fetch diseases for autocomplete
Future<List<DiseaseSuggestion>> fetchDiseases({String? query}) async {
  final client = http.Client();
  try {
    // Menyesuaikan endpoint sesuai dengan ada tidaknya query
    final endpoint = query != null && query.isNotEmpty
        ? '${url}diseases/search?q=${Uri.encodeComponent(query)}'
        : '${url}diseases';
        
    final response = await client.get(Uri.parse(endpoint))
      .timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) throw Exception('Failed to load diseases');
    
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => DiseaseSuggestion.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching diseases: $e');
    // Return empty list on error
    return [];
  } finally {
    client.close();
  }
}

// Add disease to user history
Future<bool> addDiseaseToHistory(int userId, String diseaseName) async {
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse('${diseaseHistoryEndpoint}add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_user': userId,
        'nama_penyakit': diseaseName,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print('Error adding disease to history: $e');
    return false;
  } finally {
    client.close();
  }
}
