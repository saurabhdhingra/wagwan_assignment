import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed_item.dart';

class FeedRepository {
  static const String _baseUrl = 'https://api.unsplash.com/photos';
  static const String _accessKey =
      'FWoPkevw7YlmPICYaWPyUzmJGdWT44Ui1x-njqR3paI'; // Replace with your Unsplash API key
  static const int _pageSize = 100;

  Future<List<FeedItem>> getFeedItems(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?page=$page&per_page=$_pageSize&client_id=$_accessKey'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => FeedItem.fromJson({
                  'id': json['id'],
                  'imageUrl': json['urls']['regular'],
                  'title': json['alt_description'] ?? 'Untitled',
                  'description': json['user']['name'],
                }))
            .toList();
      } else {
        throw Exception('Failed to load feed items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching feed items: $e');
    }
  }
}
