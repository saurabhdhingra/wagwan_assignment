import 'package:equatable/equatable.dart';

class FeedItem extends Equatable {
  final String id;
  final String imageUrl;
  final String title;
  final String description;

  const FeedItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, imageUrl, title, description];

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
