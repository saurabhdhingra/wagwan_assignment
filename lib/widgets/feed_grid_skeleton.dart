import 'package:flutter/material.dart';

class FeedGridSkeleton extends StatelessWidget {
  final int sectionIndex;

  const FeedGridSkeleton({
    super.key,
    required this.sectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isEvenSection = sectionIndex % 2 == 0;

    return Container(
      color: Colors.white,
      child: Row(
        children: [
          if (!isEvenSection) ...[
            Expanded(
              child: _buildLongSkeleton(),
            ),
            const SizedBox(width: 1),
          ],
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildGridSkeleton()),
                    const SizedBox(width: 1),
                    Expanded(child: _buildGridSkeleton()),
                  ],
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Expanded(child: _buildGridSkeleton()),
                    const SizedBox(width: 1),
                    Expanded(child: _buildGridSkeleton()),
                  ],
                ),
              ],
            ),
          ),
          if (isEvenSection) ...[
            const SizedBox(width: 1),
            Expanded(
              child: _buildLongSkeleton(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridSkeleton() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLongSkeleton() {
    return AspectRatio(
      aspectRatio: 1 / 2,
      child: Container(
        color: Colors.grey[200],
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }
}
