import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedFetched extends FeedEvent {
  const FeedFetched();
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}

class ApproachingListEnd extends FeedEvent {
  const ApproachingListEnd();
}

class SearchBarVisibilityChanged extends FeedEvent {
  final bool isVisible;

  const SearchBarVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}
