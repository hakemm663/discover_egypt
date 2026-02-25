import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/repositories/models/discovery_models.dart';
import '../../core/repositories/models/pagination_models.dart';

class CarsQuery {
  final String type;
  final bool withDriverOnly;
  final int page;
  final int pageSize;

  const CarsQuery({
    this.type = 'All',
    this.withDriverOnly = false,
    this.page = 1,
    this.pageSize = 20,
  });
}

final carsQueryProvider = StateProvider<CarsQuery>((ref) => const CarsQuery());

final carsProvider = FutureProvider<PaginatedResult<CarListing>>((ref) async {
  final repository = ref.read(discoveryRepositoryProvider);
  final query = ref.watch(carsQueryProvider);
  final profileUserId = ref.watch(currentUserProvider).valueOrNull?.id;
  final authUserId = ref.read(authServiceProvider).currentUser?.uid;
  final userId = profileUserId ?? authUserId ?? 'guest-user';

  try {
    return await repository.getCars(
      userId: userId,
      query: PaginationQuery(
        page: query.page,
        pageSize: query.pageSize,
        filters: {
          'type': query.type,
          'withDriverOnly': query.withDriverOnly.toString(),
        },
      ),
    );
  } catch (error) {
    throw Exception('Unable to load cars: $error');
  }
});
