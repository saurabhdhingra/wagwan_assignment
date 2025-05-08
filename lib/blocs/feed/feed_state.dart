import 'package:equatable/equatable.dart';
import '../../models/feed_item.dart';

abstract class FeedState extends Equatable {
  final bool isSearchBarVisible;

  const FeedState({
    this.isSearchBarVisible = true,
  });

  @override
  List<Object?> get props => [isSearchBarVisible];
}

class FeedInitial extends FeedState {
  const FeedInitial() : super();
}

class FeedLoading extends FeedState {
  const FeedLoading() : super();
}

class FeedLoaded extends FeedState {
  final List<FeedItem> items;
  final bool hasReachedMax;

  const FeedLoaded({
    required this.items,
    this.hasReachedMax = false,
    bool isSearchBarVisible = true,
  }) : super(isSearchBarVisible: isSearchBarVisible);

  FeedLoaded copyWith({
    List<FeedItem>? items,
    bool? hasReachedMax,
    bool? isSearchBarVisible,
  }) {
    return FeedLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isSearchBarVisible: isSearchBarVisible ?? this.isSearchBarVisible,
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax, isSearchBarVisible];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message) : super();

  @override
  List<Object?> get props => [message];
}
