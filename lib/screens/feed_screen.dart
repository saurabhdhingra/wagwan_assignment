import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/feed/feed_bloc.dart';
import '../blocs/feed/feed_event.dart';
import '../blocs/feed/feed_state.dart';
import '../widgets/feed_item_widget.dart';
import '../widgets/search_bar_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _showSearchBar = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.pixels;
      if (position > _lastScrollPosition && _showSearchBar) {
        setState(() => _showSearchBar = false);
      } else if (position < _lastScrollPosition && !_showSearchBar) {
        setState(() => _showSearchBar = true);
      }
      _lastScrollPosition = position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Feed'),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _showSearchBar ? 72 : 0,
            child: _showSearchBar
                ? SearchBarWidget(
                    controller: _searchController,
                    onChanged: (value) {
                      // Implement search functionality here
                    },
                  )
                : null,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<FeedBloc>().add(const FeedRefreshed());
              },
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state is FeedInitial) {
                    context.read<FeedBloc>().add(const FeedFetched());
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FeedLoading && state is! FeedLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FeedError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<FeedBloc>()
                                  .add(const FeedRefreshed());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FeedLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(
                        child: Text('No items found'),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.items.length
                          : state.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return FeedItemWidget(item: state.items[index]);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
