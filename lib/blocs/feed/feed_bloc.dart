import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/feed_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository;
  int _currentPage = 1;
  bool _isLoading = false;

  FeedBloc({required FeedRepository feedRepository})
      : _feedRepository = feedRepository,
        super(const FeedInitial()) {
    on<FeedFetched>(_onFeedFetched);
    on<FeedRefreshed>(_onFeedRefreshed);
    on<ApproachingListEnd>(_onApproachingListEnd);
    on<SearchBarVisibilityChanged>(_onSearchBarVisibilityChanged);
  }

  // Setting the state while items are being fetched from the UNSPLASH API
  Future<void> _onFeedFetched(
    FeedFetched event,
    Emitter<FeedState> emit,
  ) async {
    if (state is FeedLoaded && (state as FeedLoaded).hasReachedMax) {
      return;
    }

    try {
      if (state is FeedInitial) {
        emit(const FeedLoading());
        final items = await _feedRepository.getFeedItems(_currentPage);
        emit(FeedLoaded(items: items));
      } else if (state is FeedLoaded) {
        final currentState = state as FeedLoaded;
        final items = await _feedRepository.getFeedItems(_currentPage + 1);

        if (items.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          _currentPage += 1;
          emit(currentState.copyWith(
            items: List.of(currentState.items)..addAll(items),
          ));
        }
      }
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  // Feed refresh handler
  Future<void> _onFeedRefreshed(
    FeedRefreshed event,
    Emitter<FeedState> emit,
  ) async {
    _currentPage = 1;
    try {
      emit(const FeedLoading());
      final items = await _feedRepository.getFeedItems(_currentPage);
      emit(FeedLoaded(items: items));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  // Fetching more items when the user is about to reach the end of the list.
  // Item are loaded in advance to give a seamless user experience.
  Future<void> _onApproachingListEnd(
    ApproachingListEnd event,
    Emitter<FeedState> emit,
  ) async {
    if (_isLoading ||
        state is! FeedLoaded ||
        (state as FeedLoaded).hasReachedMax) {
      return;
    }

    try {
      _isLoading = true;
      final currentState = state as FeedLoaded;
      final items = await _feedRepository.getFeedItems(_currentPage + 1);

      if (items.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        _currentPage += 1;
        emit(currentState.copyWith(
          items: List.of(currentState.items)..addAll(items),
        ));
      }
    } catch (e) {
      emit(FeedError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  // Search bar visibility handler
  void _onSearchBarVisibilityChanged(
    SearchBarVisibilityChanged event,
    Emitter<FeedState> emit,
  ) {
    if (state is FeedLoaded) {
      final currentState = state as FeedLoaded;
      emit(currentState.copyWith(isSearchBarVisible: event.isVisible));
    }
  }
}
