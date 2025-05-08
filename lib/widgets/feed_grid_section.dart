import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/feed_item.dart';

class FeedGridSection extends StatelessWidget {
  final List<FeedItem> items;
  final int sectionIndex;

  const FeedGridSection({
    super.key,
    required this.items,
    required this.sectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    var side = (MediaQuery.sizeOf(context).width - 2) / 3;

    if (items.length != 5) {
      return const SizedBox.shrink();
    }

    final isEvenSection = sectionIndex % 2 == 0;
    final matrixItems = items.sublist(0, 4);
    final longItem = items[4];

    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isEvenSection) ...[
            SizedBox(
              width: side,
              height: 2 * side,
              child: _buildLongItem(longItem),
            ),
            const SizedBox(width: 1),
          ],
          SizedBox(
            width: 2 * side,
            height: 2 * side,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildGridItem(matrixItems[0])),
                    const SizedBox(width: 1),
                    Expanded(child: _buildGridItem(matrixItems[1])),
                  ],
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Expanded(child: _buildGridItem(matrixItems[2])),
                    const SizedBox(width: 1),
                    Expanded(child: _buildGridItem(matrixItems[3])),
                  ],
                ),
              ],
            ),
          ),
          if (isEvenSection) ...[
            const SizedBox(width: 1),
            SizedBox(
              width: side,
              height: 2 * side,
              child: _buildLongItem(longItem),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridItem(FeedItem item) {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        key: ValueKey('grid_item_${item.id}'),
        imageUrl: item.imageUrl,
        fit: BoxFit.cover,
        memCacheWidth: 300,
        memCacheHeight: 300,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildLongItem(FeedItem item) {
    return AspectRatio(
      aspectRatio: 1 / 2,
      child: CachedNetworkImage(
        key: ValueKey('long_item_${item.id}'),
        imageUrl: item.imageUrl,
        fit: BoxFit.cover,
        memCacheWidth: 300,
        memCacheHeight: 600,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.error),
        ),
      ),
    );
  }
}
