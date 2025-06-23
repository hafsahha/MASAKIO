import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masakio/data/func_profile.dart';

const url = 'https://masakio.up.railway.app/forum';

// Forum model
class Forum {
  final int id;
  final String author;
  final String? authorPhoto;
  final String? image;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final int? threadId;

  Forum({
    required this.id,
    required this.author,
    this.authorPhoto,
    this.image,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
    this.threadId
  });

  static List<Forum> fromJsonList(Map<String, dynamic> forums) {
    return (forums['data'] as List).map((item) => Forum.fromJson(item)).toList();
  }

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id_discuss'],
      author: json['nama_user'],
      authorPhoto: json['foto'],
      image: json['gambar'],
      content: json['caption'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['jumlah_like'],
      comments: json['jumlah_reply'],
      threadId: json['reply_to']
    );
  }
}

class ForumDetail {
  final int id;
  final String author;
  final String? authorPhoto;
  final String? image;
  final String content;
  final DateTime timestamp;
  int likes;
  final int comments;
  final List<ForumReply>? replies;

  ForumDetail({
    required this.id,
    required this.author,
    this.authorPhoto,
    this.image,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
    this.replies,
  });

  factory ForumDetail.fromJson(Map<String, dynamic> json) {
    List<ForumReply>? replies;
    if (json['replies'] != null) {
      replies = List<ForumReply>.from(
        json['replies'].map((x) => ForumReply.fromJson(x))
      ).toList();
    }
    return ForumDetail(
      id: json['id_discuss'],
      author: json['nama_user'],
      authorPhoto: json['foto'],
      image: json['gambar'],
      content: json['caption'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['jumlah_like'],
      comments: replies?.length ?? 0,
      replies: replies,
    );
  }
}

class ForumReply {
  final int id;
  final String author;
  final String? authorPhoto;
  final String? image;
  final String caption;
  final DateTime timestamp;
  final int likes;
  final int comments;

  ForumReply({
    required this.id,
    required this.author,
    this.authorPhoto,
    this.image,
    required this.caption,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
      id: json['id_discuss'],
      author: json['nama_user'],
      authorPhoto: json['foto'],
      image: json['gambar'],
      caption: json['caption'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['jumlah_like'],
      comments: json['jumlah_reply'],
    );
  }
}

// Fetch all forum posts
Future<List<Forum>> fetchForums() async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Failed to load forums');

    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Forum.fromJson(item)).toList();
  } catch (e) { rethrow; }
}

// Fetch a specific forum post by ID
Future<ForumDetail> fetchForumById(int id) async {
  try {
    final response = await http.get(Uri.parse('$url/$id')).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Failed to load forum post');

    final data = json.decode(response.body);
    return ForumDetail.fromJson(data);
  } catch (e) { rethrow; }
}

// Create a new forum post
Future<bool> addForumPost(String content, File? image) async {
  final user = await AuthService.getCurrentUser();
  final userId = user!.id;

  try {
    final response = await http.post(Uri.parse('$url/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_user': userId,
        'gambar': image,
        'caption': content,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 201) throw Exception('Failed to create forum post');
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) { rethrow; }
}

// Reply to a forum post
Future<bool> addForumReply(int postId, String content, File? image) async {
  final user = await AuthService.getCurrentUser();
  final userId = user!.id;

  try {
    final response = await http.post(Uri.parse('$url/reply'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_user': userId,
        'gambar': image,
        'caption': content,
        'reply_to': postId,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 201) throw Exception('Failed to reply to forum post');
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) { rethrow; }
}

Future<bool> isLikedForumPost(int postId) async {
  final user = await AuthService.getCurrentUser();
  final userId = user!.id;

  try {
    final response = await http.get(Uri.parse('$url/like?user_id=$userId&post_id=$postId'))
      .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) throw Exception('Failed to check like status');
    return json.decode(response.body)['liked'] as bool;
  } catch (e) { rethrow; }
}

Future<bool> likeForumPost(int postId) async {
  final user = await AuthService.getCurrentUser();
  final userId = user!.id;

  try {
    final response = await http.post(Uri.parse('$url/like'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_user': userId,
        'id_discuss': postId,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) throw Exception('Failed to like forum post');
    return response.statusCode == 200;
  } catch (e) { rethrow; }
}