import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL untuk backend API resep
const url = 'https://masakio.up.railway.app/recipe'; // URL utama API resep
const url2 ='https://masakio.up.railway.app/card_recipe'; // URL alternatif API resep
const urlFilter = 'https://masakio.up.railway.app/card_recipe/filter'; // URL untuk filter resep

// Print URL untuk debugging
final bool _debugPrintUrls = true; // set ke false di production

// Fungsi helper untuk print URL saat debug
void _printDebugUrl(String url) {
  if (_debugPrintUrls) {
    print("[DEBUG URL] Mengakses: $url");
  }
}

// Model utama untuk resep
// Digunakan untuk menyimpan detail lengkap sebuah resep
// Terdiri dari info dasar, alat, bahan, prosedur memasak, dan tag
class Recipe {
  final RecipeInfo info; // Informasi dasar resep (nama, deskripsi, dll)
  final List<Equipment> alat; // Daftar peralatan yang dibutuhkan
  final List<Ingredient> bahan; // Daftar bahan-bahan resep
  final List<Procedure> prosedur; // Langkah-langkah memasak
  final List<Tag> tag; // Tag/kategori tambahan

  Recipe({
    required this.info,
    required this.alat,
    required this.bahan,
    required this.prosedur,
    required this.tag,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      info: RecipeInfo.fromJson(json['info']),
      alat:
          List<Equipment>.from(json['alat'].map((x) => Equipment.fromJson(x))),
      bahan: List<Ingredient>.from(
          json['bahan'].map((x) => Ingredient.fromJson(x))),
      prosedur: List<Procedure>.from(
          json['prosedur'].map((x) => Procedure.fromJson(x))),
      tag: List<Tag>.from(json['tag'].map((x) => Tag.fromJson(x))),
    );
  }

  // Convert to UI display format for card view
  Map<String, dynamic> toUIFormat() {
    return {
      'id': info.id.toString(),
      'title': info.name,
      'reviewCount': info.jumlahView,
      'imageAsset': 'assets/images/${info.thumbnail}',
      'isBookmarked': false,
    };
  }
}

// Model untuk menyimpan informasi dasar resep
// Berisi semua data utama tentang resep (tanpa bahan, alat, dan langkah pembuatan)
class RecipeInfo {
  final int id; // ID resep
  final String name; // Nama resep
  final String description; // Deskripsi resep
  final String? video; // URL video tutorial (opsional)
  final int servings; // Jumlah porsi
  final int jumlahLike; // Jumlah like/suka
  final int jumlahView; // Jumlah penayangan/view
  final String thumbnail; // Nama file gambar thumbnail
  final int userId; // ID pembuat resep
  final String pembuat; // Nama pembuat resep
  final String emailPembuat; // Email pembuat resep
  final String tanggalLahir; // Tanggal lahir pembuat
  final String tanggalDaftarPembuat; // Tanggal pembuat mendaftar
  final int categoryId; // ID kategori resep
  final String namaKategori; // Nama kategori resep
  final int nutrisiId; // ID info nutrisi
  final String karbohidrat; // Nilai karbohidrat (gr)
  final String protein; // Nilai protein (gr)
  final String lemak; // Nilai lemak (gr)
  final String serat; // Nilai serat (gr)

  RecipeInfo({
    required this.id,
    required this.name,
    required this.description,
    this.video,
    required this.servings,
    required this.jumlahLike,
    required this.jumlahView,
    required this.thumbnail,
    required this.userId,
    required this.pembuat,
    required this.emailPembuat,
    required this.tanggalLahir,
    required this.tanggalDaftarPembuat,
    required this.categoryId,
    required this.namaKategori,
    required this.nutrisiId,
    required this.karbohidrat,
    required this.protein,
    required this.lemak,
    required this.serat,
  });

  factory RecipeInfo.fromJson(Map<String, dynamic> json) {
    return RecipeInfo(
      id: json['id_resep'],
      name: json['nama_resep'],
      description: json['deskripsi'],
      video: json['video'],
      servings: json['porsi'],
      jumlahLike: json['jumlah_like'],
      jumlahView: json['jumlah_view'],
      thumbnail: json['thumbnail'],
      userId: json['id_user'],
      pembuat: json['pembuat'],
      emailPembuat: json['email_pembuat'],
      tanggalLahir: json['tanggal_lahir'],
      tanggalDaftarPembuat: json['tanggal_daftar_pembuat'],
      categoryId: json['id_kategori'],
      namaKategori: json['nama_kategori'],
      nutrisiId: json['id_nutrisi'],
      karbohidrat: json['karbohidrat'],
      protein: json['protein'],
      lemak: json['lemak'],
      serat: json['serat'],
    );
  }
}

// Model untuk menyimpan data peralatan yang dibutuhkan dalam resep
class Equipment {
  final int id; // ID alat
  final String name; // Nama alat (misal: Panci, Wajan)
  final int jumlah; // Jumlah yang dibutuhkan

  Equipment({
    required this.id,
    required this.name,
    required this.jumlah,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id_alat'],
      name: json['nama_alat'],
      jumlah: json['jumlah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alat': id,
      'nama_alat': name,
      'jumlah': jumlah,
    };
  }
}

// Model untuk menyimpan data bahan-bahan dalam resep
class Ingredient {
  final int id; // ID bahan
  final String name; // Nama bahan (misal: Bawang, Garam)
  final int jumlah; // Jumlah yang dibutuhkan
  final int satuanId; // ID satuan ukuran (misal: 1 untuk gram)
  final String namaSatuan; // Nama satuan (misal: Gram, Sendok)

  Ingredient({
    required this.id,
    required this.name,
    required this.jumlah,
    required this.satuanId,
    required this.namaSatuan,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id_bahan'],
      name: json['nama_bahan'],
      jumlah: json['jumlah'],
      satuanId: json['id_satuan'],
      namaSatuan: json['nama_satuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_bahan': id,
      'nama_bahan': name,
      'jumlah': jumlah,
      'id_satuan': satuanId,
      'nama_satuan': namaSatuan,
    };
  }
}

// Model untuk menyimpan data prosedur/cara membuat dalam resep
// Setiap prosedur memiliki beberapa langkah (steps)
class Procedure {
  final int id; // ID prosedur
  final String name; // Nama prosedur (misal: "Membuat kuah")
  final int urutan; // Urutan prosedur dalam resep
  final int durasiMenit; // Durasi dalam menit
  final List<Step> langkah; // Daftar langkah-langkah dalam prosedur

  Procedure({
    required this.id,
    required this.name,
    required this.urutan,
    required this.durasiMenit,
    required this.langkah,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id_prosedur'],
      name: json['nama_prosedur'],
      urutan: json['urutan_prosedur'],
      durasiMenit: json['durasi_menit'],
      langkah: List<Step>.from(json['langkah'].map((x) => Step.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_prosedur': id,
      'nama_prosedur': name,
      'urutan_prosedur': urutan,
      'durasi_menit': durasiMenit,
      'langkah': langkah.map((x) => x.toJson()).toList(),
    };
  }
}

// Model untuk menyimpan data langkah-langkah dalam setiap prosedur
class Step {
  final int id; // ID langkah
  final String name; // Deskripsi langkah (misal: "Rebus air hingga mendidih")
  final int urutan; // Urutan langkah dalam prosedur

  Step({
    required this.id,
    required this.name,
    required this.urutan,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      id: json['id_langkah'],
      name: json['nama_langkah'],
      urutan: json['urutan_langkah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_langkah': id,
      'nama_langkah': name,
      'urutan_langkah': urutan,
    };
  }
}

// Model untuk menyimpan data tag/label tambahan untuk resep
class Tag {
  final int id; // ID tag
  final String name; // Nama tag (misal: "Sehat", "Cepat", "Vegetarian")

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id_tag'],
      name: json['nama_tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tag': id,
      'nama_tag': name,
    };
  }
}

// Fungsi untuk mengambil semua resep dari API
// Digunakan untuk: Halaman utama, daftar resep populer
// Return: List resep dalam format sederhana untuk tampilan card/list
Future<List<Map<String, dynamic>>> fetchAllRecipes() async {
  // card recipe
  try {
    final String apiUrl = '$url2/all';
    print("[DEBUG] fetchAllRecipes: Memulai request API ke $apiUrl");
    _printDebugUrl(apiUrl);

    final response =
        await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

    print("[DEBUG] fetchAllRecipes: Status response: ${response.statusCode}");

    if (response.statusCode != 200) {
      print(
          "[ERROR] fetchAllRecipes: Response error dengan kode ${response.statusCode}");
      print("[ERROR] fetchAllRecipes: Body: ${response.body}");
      throw Exception(
          'Failed to load recipes with status code: ${response.statusCode}');
    }

    print("[DEBUG] fetchAllRecipes: Response berhasil");

    final List<dynamic> data = json.decode(response.body);
    print("[DEBUG] fetchAllRecipes: Jumlah data resep: ${data.length}");

    if (data.isEmpty) {
      print("[WARN] fetchAllRecipes: Data resep kosong");
      return [];
    }

    print(
        "[DEBUG] fetchAllRecipes: Contoh data pertama: ${data.isNotEmpty ? data[0] : 'Tidak ada data'}");
    final result = data
        .map((item) => {
              // Convert id_resep to integer
              'id': item['id_resep'] is int
                  ? item['id_resep']
                  : int.tryParse(item['id_resep'].toString()) ?? 0,
              'title': item['nama_resep'],
              'reviewCount': item['jumlah_view'] ?? 0,
              'imageAsset': 'assets/images/${item['thumbnail']}',
              'isBookmarked': false,
            })
        .toList();

    print(
        "[DEBUG] fetchAllRecipes: Hasil transformasi data: ${result.length} item");
    if (result.isNotEmpty) {
      print(
          "[DEBUG] fetchAllRecipes: Contoh hasil transformasi pertama: ${result[0]}");
    }

    return result;
  } catch (e) {
    print("[ERROR] fetchAllRecipes: Exception: $e");
    throw Exception('Failed to load recipes: $e');
  }
}

// Fungsi untuk mengambil detail lengkap satu resep berdasarkan ID
// Digunakan untuk: Halaman detail resep (saat user membuka satu resep tertentu)
// Return: Objek Recipe lengkap dengan semua detail (info, bahan, alat, prosedur, dll)
Future<Recipe> fetchRecipeById(int id) async {
  try {
    final response = await http
        .get(Uri.parse('$url/$id'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200)
      throw Exception('Failed to load recipe details');

    final data = json.decode(response.body);
    return Recipe.fromJson(data);
  } catch (e) {
    rethrow;
  }
}

// Fungsi untuk menambahkan resep baru ke database
// Digunakan untuk: Halaman penambahan/pembuatan resep baru (ValidasiResepPage)
// Return: ID resep baru yang berhasil ditambahkan
// Parameter:
// - nama: Judul resep
// - deskripsi: Deskripsi/penjelasan resep
// - porsi: Jumlah porsi yang dapat disajikan
// - idUser: ID pengguna yang menambahkan resep
// - idKategori: ID kategori resep (makanan berat, minuman, dll)
// - alat: Daftar peralatan yang dibutuhkan
// - bahan: Daftar bahan-bahan yang dibutuhkan
// - prosedur: Langkah-langkah memasak
// - tag: Tanda/label tambahan untuk resep
// - videoPath: Path file video tutorial (opsional)
Future<int> addRecipe({  required String nama,
  required String deskripsi,
  required int porsi,
  required int idUser,
  required int idKategori,
  required List<Map<String, dynamic>> alat,
  required List<Map<String, dynamic>> bahan,
  required List<Map<String, dynamic>> prosedur,
  required List<String> tag,
  String? videoPath,
  String? thumbnailPath,
  String defaultThumbnail = 'nasi_goreng.jpeg', // Default thumbnail if none provided
}) async {
  try {
    // Create the recipe data
    final recipeData = {
      'nama': nama,
      'deskripsi': deskripsi,
      'porsi': porsi,
      'id_user': idUser,
      'id_kategori': idKategori,
      'alat': alat,
      'bahan': bahan,
      'prosedur': prosedur,
      'tag': tag,
      'thumbnail': defaultThumbnail, // Always include a default thumbnail
    };

    // If video or thumbnail is included, handle as multipart request
    if (videoPath != null || thumbnailPath != null) {
      print("[DEBUG] Creating multipart request for recipe with files");
      var request = http.MultipartRequest('POST', Uri.parse('$url/create'));

      // Add files if available
      if (videoPath != null) {
        print("[DEBUG] Adding video file: $videoPath");
        var videoFile = await http.MultipartFile.fromPath('video', videoPath);
        request.files.add(videoFile);
      }

      if (thumbnailPath != null) {
        print("[DEBUG] Adding thumbnail file: $thumbnailPath");
        var thumbnailFile = await http.MultipartFile.fromPath('thumbnail', thumbnailPath);
        request.files.add(thumbnailFile);
      }

      // Add recipe data as JSON field
      request.fields['recipe'] = jsonEncode(recipeData);
      print("[DEBUG] Recipe data in multipart request: ${jsonEncode(recipeData)}");

      // Send the request
      print("[DEBUG] Sending multipart request...");
      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      print("[DEBUG] Response status: ${response.statusCode}");
      print("[DEBUG] Response body: ${response.body}");

      if (response.statusCode != 201)
        throw Exception('Failed to add recipe: ${response.body}');

      final data = json.decode(response.body);
      return data['id_resep'] ?? 0;
    } else {
      // No files, just send JSON
      print("[DEBUG] Creating JSON request for recipe without files");
      print("[DEBUG] Recipe data in JSON request: ${jsonEncode(recipeData)}");
      
      final response = await http
          .post(
            Uri.parse('$url/create'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(recipeData),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 201)
        throw Exception('Failed to add recipe: ${response.body}');

      final data = json.decode(response.body);
      return data['id_resep'] ?? 0;
    }
  } catch (e) {
    print('Error adding recipe: $e');
    rethrow;
  }
}

// Fungsi untuk mengambil semua resep milik satu pengguna
// Digunakan untuk: Halaman profil user, daftar "Resep Saya"
// Return: List resep milik user dalam format sederhana untuk tampilan card/list
Future<List<Map<String, dynamic>>> fetchUserRecipes(int userId) async {
  try {
    print('[DEBUG] Fetching recipes for user ID: $userId');
    
    // Try both endpoints (old url and new url2)
    final String apiUrl1 = 'https://masakio.up.railway.app/recipe/user/$userId';
    final String apiUrl2 = 'https://masakio.up.railway.app/card_recipe/user/$userId';
    
    print('[DEBUG] Trying API URL 1: $apiUrl1');
    
    // Try first endpoint
    http.Response response;
    try {
      response = await http
          .get(Uri.parse(apiUrl1))
          .timeout(const Duration(seconds: 5));
      
      print('[DEBUG] Response 1 status code: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        // If failed, try second endpoint
        print('[DEBUG] First endpoint failed, trying API URL 2: $apiUrl2');
        response = await http
            .get(Uri.parse(apiUrl2))
            .timeout(const Duration(seconds: 5));
        
        print('[DEBUG] Response 2 status code: ${response.statusCode}');
        
        if (response.statusCode != 200)
          throw Exception('Failed to load user recipes from both endpoints');
      }
    } catch (e) {
      // If first endpoint throws, try second endpoint
      print('[DEBUG] Error with first endpoint: $e');
      print('[DEBUG] Trying API URL 2: $apiUrl2');
      response = await http
          .get(Uri.parse(apiUrl2))
          .timeout(const Duration(seconds: 5));
      
      print('[DEBUG] Response 2 status code: ${response.statusCode}');
      
      if (response.statusCode != 200)
        throw Exception('Failed to load user recipes from both endpoints');
    }

    final List<dynamic> data = json.decode(response.body);
    print('[DEBUG] Received ${data.length} recipes');
    if (data.isNotEmpty) {
      print('[DEBUG] Sample first recipe: ${data[0]}');
    } else {
      print('[DEBUG] No recipes found for user $userId');
    }
    
    return data
        .map((item) => {
              'id': item['id_resep'].toString(), // Convert to string
              'title': item['nama_resep'] ?? 'Untitled',
              'reviewCount': item['jumlah_view'] ?? 0,
              'rating': '5.0', // Add default rating
              'imageAsset': item['thumbnail'] != null && item['thumbnail'].toString().isNotEmpty
                  ? 'assets/images/${item['thumbnail']}' 
                  : 'assets/images/nasi_goreng.jpeg', // Default if thumbnail is null
              'isOwned': true,
              'isBookmarked': false,
            })
        .toList();
  } catch (e) {
    print('Error fetching user recipes: $e');
    return [];
  }
}

// Fungsi untuk mengambil resep berdasarkan filter (kategori, bahan yang diinginkan, bahan yang dihindari)
// Digunakan untuk: Halaman pencarian/filter resep, membantu user menemukan resep sesuai preferensi
// Return: List resep yang sesuai dengan filter dalam format untuk tampilan card/list
// Parameter:
// - categoryId: ID kategori resep (opsional)
// - includeIngredients: List bahan yang harus ada dalam resep (opsional)
// - excludeIngredients: List bahan yang tidak boleh ada dalam resep (opsional)
Future<List<Map<String, dynamic>>> fetchRecipesByFilter({
  int? categoryId,
  List<String>? includeIngredients,
  List<String>? excludeIngredients,
}) async {
  try {
    // Validasi parameter - minimal satu parameter harus ada
    if (categoryId == null && 
        (includeIngredients == null || includeIngredients.isEmpty) && 
        (excludeIngredients == null || excludeIngredients.isEmpty)) {
      throw Exception('At least one filter parameter must be provided');
    }

    // Membangun query parameters
    final queryParams = <String, String>{};
    
    // Tambahkan category_id jika ada
    if (categoryId != null) {
      queryParams['category_id'] = categoryId.toString();
    }
    
    // Tambahkan include ingredients jika ada (gabungkan dengan koma)
    if (includeIngredients != null && includeIngredients.isNotEmpty) {
      queryParams['include'] = includeIngredients.join(',');
    }
    
    // Tambahkan exclude ingredients jika ada (gabungkan dengan koma)
    if (excludeIngredients != null && excludeIngredients.isNotEmpty) {
      queryParams['exclude'] = excludeIngredients.join(',');
    }
    
    // Bangun URL dengan parameter
    final uri = Uri.parse(urlFilter).replace(queryParameters: queryParams);
    
    _printDebugUrl(uri.toString());
    print("[DEBUG] fetchRecipesByFilter: Memulai request API ke $uri");
    
    // Lakukan request
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    
    print("[DEBUG] fetchRecipesByFilter: Status response: ${response.statusCode}");
    
    if (response.statusCode != 200) {
      print("[ERROR] fetchRecipesByFilter: Response error dengan kode ${response.statusCode}");
      print("[ERROR] fetchRecipesByFilter: Body: ${response.body}");
      throw Exception('Failed to filter recipes with status code: ${response.statusCode}');
    }
    
    print("[DEBUG] fetchRecipesByFilter: Response berhasil");
    
    final List<dynamic> data = json.decode(response.body);
    print("[DEBUG] fetchRecipesByFilter: Jumlah data resep: ${data.length}");
    
    if (data.isEmpty) {
      print("[WARN] fetchRecipesByFilter: Data resep kosong");
      return [];
    }
    
    // Transform data ke format UI yang konsisten dengan fungsi-fungsi lain
    final result = data.map((item) => {
      'id': item['id_resep'] is int
          ? item['id_resep']
          : int.tryParse(item['id_resep'].toString()) ?? 0,
      'title': item['nama_resep'],
      'reviewCount': item['jumlah_view'] ?? 0,
      'imageAsset': 'assets/images/${item['thumbnail']}',
      'isBookmarked': false,
    }).toList();
    
    print("[DEBUG] fetchRecipesByFilter: Hasil transformasi data: ${result.length} item");
    
    return result;
  } catch (e) {
    print("[ERROR] fetchRecipesByFilter: Exception: $e");
    throw Exception('Failed to filter recipes: $e');
  }
}

// // Fungsi untuk mencari resep berdasarkan kata kunci
// // Digunakan untuk: Halaman pencarian, saat user mengetik di kotak pencarian
// // Return: List resep yang sesuai dengan pencarian dalam format untuk tampilan card/list
// Future<List<Map<String, dynamic>>> searchRecipes(String query) async {
//   try {
//     final response = await http
//         .get(Uri.parse('$url/search?q=$query'))
//         .timeout(const Duration(seconds: 10));

//     if (response.statusCode != 200) throw Exception('Failed to search recipes');

//     final List<dynamic> data = json.decode(response.body);
//     return data
//         .map((item) => {
//               'id': item['id_resep'],
//               'title': item['nama_resep'],
//               'reviewCount': item['jumlah_view'] ?? 0,
//               'imageAsset': 'assets/images/${item['thumbnail']}',
//               'isBookmarked': false,
//             })
//         .toList();
//   } catch (e) {
//     throw Exception('Failed to search recipes: $e');
//   }
// }

// Fungsi alternatif untuk menghasilkan data dummy jika API gagal
List<Map<String, dynamic>> _generateDummyRecipes() {
  print("[DEBUG] Menggunakan data dummy karena API gagal");

  return [
    {
      'id': 1, // Using integer instead of string
      'title': "Nasi Goreng Special",
      'reviewCount': 120,
      'imageAsset': 'assets/images/nasi_goreng.jpeg',
      'isBookmarked': false,
    },
    {
      'id': 2, // Using integer instead of string
      'title': "Ayam Bakar Taliwang",
      'reviewCount': 85,
      'imageAsset': 'assets/images/ayam_bakar_taliwang.jpg',
      'isBookmarked': false,
    },
    {
      'id': 3, // Using integer instead of string
      'title': "Sup Buntut Sapi",
      'reviewCount': 65,
      'imageAsset': 'assets/images/sup_buntut_sapi.jpeg',
      'isBookmarked': false,
    },
    {
      'id': 4, // Using integer instead of string
      'title': "Es Kelapa Muda",
      'reviewCount': 45,
      'imageAsset': 'assets/images/es_kelapa_muda.jpeg',
      'isBookmarked': false,
    },
  ];
}

// Fungsi wrapper untuk fetchAllRecipes yang menangani fallback ke data dummy
Future<List<Map<String, dynamic>>> fetchAllRecipesWithFallback() async {
  try {
    print("[DEBUG] Mencoba mengambil data dari API...");
    final recipes = await fetchAllRecipes();
    return recipes;
  } catch (e) {
    print("[ERROR] API gagal: $e");
    print("[DEBUG] Menggunakan data fallback...");
    return _generateDummyRecipes();
  }
}

// Function to fetch recipe by ID with fallback to dummy data
Future<Map<String, dynamic>> fetchRecipeByIdWithFallback(int id) async {
  try {
    print("[DEBUG] Mencoba mengambil resep dengan ID $id dari API...");
    _printDebugUrl('$url/$id');

    final response = await http
        .get(Uri.parse('$url/$id'))
        .timeout(const Duration(seconds: 10));

    print("[DEBUG] fetchRecipeById: Status response: ${response.statusCode}");

    if (response.statusCode != 200) {
      print(
          "[ERROR] fetchRecipeById: Response error dengan kode ${response.statusCode}");
      throw Exception('Failed to load recipe details');
    }

    print("[DEBUG] fetchRecipeById: Response berhasil");
    final data = json.decode(response.body);

    // Transform API data to UI format
    final Recipe recipe = Recipe.fromJson(data);
    print("[DEBUG] fetchRecipeById: Berhasil membuat objek Recipe");

    // Convert recipe to UI display format
    return _convertRecipeToUiFormat(recipe);
  } catch (e) {
    print("[ERROR] fetchRecipeById: Exception: $e");
    print("[DEBUG] Menggunakan data dummy karena API gagal");

    // Return dummy recipe that matches the requested ID if available
    final dummyData = _generateDummyRecipes();
    final matchingRecipe = dummyData.firstWhere(
      (recipe) => recipe['id'] == id,
      orElse: () => dummyData.first,
    );

    print(
        "[DEBUG] fetchRecipeById: Menggunakan data dummy: ${matchingRecipe['title']}");
    return matchingRecipe;
  }
}

// Helper method to convert Recipe object to UI format
// Returns a cleaned Map that can be safely used in the UI
Map<String, dynamic> _convertRecipeToUiFormat(Recipe recipe) {
  // Extract ingredients with amounts - ensure we have a List<String>
  final List<String> ingredients = recipe.bahan.map((bahan) {
    return "${bahan.name}, ${bahan.jumlah} ${bahan.namaSatuan}";
  }).toList();

  // Extract tools - ensure we have a List<String>
  final List<String> tools = recipe.alat.map((alat) => alat.name).toList();
  // Extract steps
  final steps = recipe.prosedur.map((prosedur) {
    // Explicitly create a Map<String, dynamic>
    Map<String, dynamic> step = {};
    step['title'] = prosedur.name;
    step['duration'] = '${prosedur.durasiMenit} menit';

    // Explicitly convert to List<String>
    List<String> langkahList =
        prosedur.langkah.map((langkah) => langkah.name).toList();
    step['steps'] = langkahList;

    return step;
  }).toList(); // Calculate average cooking time
  final totalMinutes =
      recipe.prosedur.fold<int>(0, (sum, proc) => sum + proc.durasiMenit);
  final Duration duration = Duration(minutes: totalMinutes);
  // Extract tags - ensure we have a List<String>
  final List<String> tags = recipe.tag.map((tag) => tag.name).toList();
  // Extract nutrition - explicitly cast to Map<String, String>
  final Map<String, String> nutrition = {
    'Karbohidrat': '${recipe.info.karbohidrat} gr',
    'Protein': '${recipe.info.protein} gr',
    'Lemak': '${recipe.info.lemak} gr',
    'Kalori':
        '${recipe.info.serat} gr', // Note: using serat for now as calorie data isn't available
  };

  // Convert to UI format
  return {
    'id': recipe.info.id,
    'title': recipe.info.name,
    'imageAsset': 'assets/images/${recipe.info.thumbnail}',
    'author': recipe.info.pembuat,
    'authorFollowers': 'Premium Member',
    'rating': 4.7, // Placeholder as rating is not in the API
    'reviewCount': recipe.info.jumlahView,
    'servings': recipe.info.servings,
    'duration': duration,
    'price': 25000, // Placeholder as price is not in the API
    'categories': <String>[recipe.info.namaKategori],
    'tags': tags,
    'description': recipe.info.description,
    'ingredients': ingredients,
    'tools': tools,
    'steps': steps,
    'nutrition': nutrition,
  };
}
