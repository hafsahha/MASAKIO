import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend
const url = 'https://masakio.up.railway.app/';
const diseasesEndpoint = '${url}diseases/'; // Endpoint untuk penyakit

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

// Get user disease history
Future<List<Disease>> getDiseaseHistory(int userId) async {
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse('${diseasesEndpoint}user/${userId}'))
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

// Fetch all diseases
Future<List<Disease>> fetchAllDiseases() async {
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse('${url}diseases'))
      .timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) throw Exception('Failed to load diseases');
    
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Disease.fromJson(item)).toList();
  } catch (e) {
    print('Error fetching diseases: $e');
    rethrow;
  } finally {
    client.close();
  }
}

// Fetch all diseases with optional filtering
Future<List<Disease>> fetchDiseases({String? query}) async {
  final client = http.Client();
  try {
    // Get all diseases from the endpoint
    final response = await client.get(Uri.parse(diseasesEndpoint))
      .timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200) throw Exception('Failed to load diseases');
    
    final List<dynamic> data = json.decode(response.body);
    List<Disease> diseases = data.map((item) => Disease.fromJson(item)).toList();
    
    // Filter locally if query is provided
    if (query != null && query.isNotEmpty) {
      diseases = diseases.where(
        (disease) => disease.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    
    return diseases;
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
      Uri.parse('${diseasesEndpoint}user/add-by-name'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'diseaseName': diseaseName,
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

// Remove disease from user history by disease name
Future<bool> removeDiseaseFromHistoryByName(int userId, String diseaseName) async {
  final client = http.Client();
  try {
    final response = await client.delete(
      Uri.parse('${diseasesEndpoint}user/remove-by-name'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'diseaseName': diseaseName,
      }),
    ).timeout(const Duration(seconds: 10));
    
    return response.statusCode == 200;
  } catch (e) {
    print('Error removing disease from history: $e');
    return false;
  } finally {
    client.close();
  }
}
