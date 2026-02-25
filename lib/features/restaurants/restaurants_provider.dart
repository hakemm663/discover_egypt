import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/repositories/models/discovery_models.dart';
import '../../core/repositories/models/pagination_models.dart';

class RestaurantsQuery {
  final String cuisine;
  final int page;
  final int pageSize;

  const RestaurantsQuery({
    this.cuisine = 'All',
    this.page = 1,
    this.pageSize = 20,
  });
}

final restaurantsQueryProvider = StateProvider<RestaurantsQuery>((ref) => const RestaurantsQuery());

final restaurantsProvider = FutureProvider<PaginatedResult<RestaurantListing>>((ref) async {
  final repository = ref.read(discoveryRepositoryProvider);
  final query = ref.watch(restaurantsQueryProvider);
  final profileUserId = ref.watch(currentUserProvider).valueOrNull?.id;
  final authUserId = ref.read(authServiceProvider).currentUser?.uid;
  final userId = profileUserId ?? authUserId ?? 'guest-user';

  try {
    return await repository.getRestaurants(
      userId: userId,
      query: PaginationQuery(
        page: query.page,
        pageSize: query.pageSize,
        filters: {'cuisine': query.cuisine},
      ),
    );
  } catch (error) {
    throw Exception('Unable to load restaurants: $error');
  }
});
