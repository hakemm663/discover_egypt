class PaginationQuery {
  final int page;
  final int pageSize;
  final Map<String, String> filters;

  const PaginationQuery({
    this.page = 1,
    this.pageSize = 20,
    this.filters = const {},
  });

  int get offset => (page - 1) * pageSize;
}

class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  bool get hasNextPage => page * pageSize < totalCount;
}
