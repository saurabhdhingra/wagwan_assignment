import 'package:equatable/equatable.dart';
import '../../models/feed_item.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<FeedItem> items;
  final bool hasReachedMax;

  const FeedLoaded({
    required this.items,
    this.hasReachedMax = false,
  });

  FeedLoaded copyWith({
    List<FeedItem>? items,
    bool? hasReachedMax,
  }) {
    return FeedLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}
