import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/feed/feed_bloc.dart';
import '../blocs/feed/feed_event.dart';
import '../blocs/feed/feed_state.dart';
import '../models/feed_item.dart';
import '../widgets/feed_grid_section.dart';
import '../widgets/feed_grid_skeleton.dart';
import '../widgets/search_bar_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  double _lastScrollPosition = 0;
  static const _scrollThreshold = 0.8;

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
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = position / maxScroll;

      // Handle search bar visibility
      final currentState = context.read<FeedBloc>().state;
      if (position > _lastScrollPosition && currentState is FeedLoaded) {
        context.read<FeedBloc>().add(const SearchBarVisibilityChanged(false));
      } else if (position < _lastScrollPosition && currentState is FeedLoaded) {
        context.read<FeedBloc>().add(const SearchBarVisibilityChanged(true));
      }
      _lastScrollPosition = position;

      // Handle approaching end
      if (currentScroll > _scrollThreshold) {
        context.read<FeedBloc>().add(const ApproachingListEnd());
      }
    }
  }

  List<List<FeedItem>> _groupItemsIntoGridSections(List<FeedItem> items) {
    final sections = <List<FeedItem>>[];
    for (var i = 0; i < items.length; i += 5) {
      if (i + 5 <= items.length) {
        sections.add(items.sublist(i, i + 5));
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<FeedBloc, FeedState>(
              buildWhen: (previous, current) =>
                  previous.isSearchBarVisible != current.isSearchBarVisible,
              builder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: state.isSearchBarVisible ? 56 : 0,
                  child: state.isSearchBarVisible
                      ? SearchBarWidget(
                          controller: _searchController,
                          onChanged: (value) {
                            // Implement search functionality here
                          },
                        )
                      : null,
                );
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<FeedBloc>().add(const FeedRefreshed());
                },
                child: BlocBuilder<FeedBloc, FeedState>(
                  buildWhen: (previous, current) {
                    if (previous is FeedLoaded && current is FeedLoaded) {
                      return previous.items.length != current.items.length ||
                          previous.hasReachedMax != current.hasReachedMax;
                    }
                    return true;
                  },
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

                      final sections = _groupItemsIntoGridSections(state.items);

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.hasReachedMax
                            ? sections.length
                            : sections.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= sections.length) {
                            return Column(
                              children: [
                                FeedGridSkeleton(
                                  key: ValueKey('skeleton_$index'),
                                  sectionIndex: index,
                                ),
                                const SizedBox(height: 1),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              FeedGridSection(
                                key: ValueKey('grid_${sections[index][0].id}'),
                                items: sections[index],
                                sectionIndex: index,
                              ),
                              if (index < sections.length - 1)
                                const SizedBox(height: 1),
                            ],
                          );
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
      ),
    );
  }
}
