import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/repositories/models/discovery_models.dart';
import '../../core/repositories/models/pagination_models.dart';

class ToursQuery {
  final String category;
  final int page;
  final int pageSize;

  const ToursQuery({
    this.category = 'All',
    this.page = 1,
    this.pageSize = 20,
  });
}

final toursQueryProvider = StateProvider<ToursQuery>((ref) => const ToursQuery());

final toursProvider = FutureProvider<PaginatedResult<TourListing>>((ref) async {
  final repository = ref.read(discoveryRepositoryProvider);
  final query = ref.watch(toursQueryProvider);

  return repository.getTours(
    userId: 'demo-user',
    query: PaginationQuery(
      page: query.page,
      pageSize: query.pageSize,
      filters: {'category': query.category},
    ),
  );
});
