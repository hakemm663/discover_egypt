import 'package:flutter/foundation.dart';

@immutable
class PaginatedListState<T> {
  final List<T> items;
  final bool hasMore;
  final bool isLoadingMore;

  const PaginatedListState({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  PaginatedListState<T> copyWith({
    List<T>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaginatedListState<T>(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
