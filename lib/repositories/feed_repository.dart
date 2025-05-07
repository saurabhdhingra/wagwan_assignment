import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed_item.dart';

class FeedRepository {
  static const String _baseUrl = 'https://picsum.photos/v2/list';
  static const int _pageSize = 10;

  Future<List<FeedItem>> getFeedItems(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?page=$page&limit=$_pageSize'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => FeedItem.fromJson({
                  'id': json['id'],
                  'imageUrl': json['download_url'],
                  'title': 'Image ${json['id']}',
                  'description': json['author'],
                }))
            .toList();
      } else {
        throw Exception('Failed to load feed items');
      }
    } catch (e) {
      throw Exception('Error fetching feed items: $e');
    }
  }
}
