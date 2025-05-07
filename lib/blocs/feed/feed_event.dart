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
