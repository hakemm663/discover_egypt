import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/repositories/models/discovery_models.dart';
import '../../core/repositories/models/pagination_models.dart';

class HotelsQuery {
  final String city;
  final String sortBy;
  final int page;
  final int pageSize;

  const HotelsQuery({
    this.city = 'All',
    this.sortBy = 'Popular',
    this.page = 1,
    this.pageSize = 20,
  });
}

final hotelsQueryProvider = StateProvider<HotelsQuery>((ref) => const HotelsQuery());

final hotelsProvider = FutureProvider<PaginatedResult<HotelListing>>((ref) async {
  final repository = ref.read(discoveryRepositoryProvider);
  final query = ref.watch(hotelsQueryProvider);
  final profileUserId = ref.watch(currentUserProvider).valueOrNull?.id;
  final authUserId = ref.read(authServiceProvider).currentUser?.uid;
  final userId = profileUserId ?? authUserId ?? 'guest-user';

  try {
    return await repository.getHotels(
      userId: userId,
      query: PaginationQuery(
        page: query.page,
        pageSize: query.pageSize,
        filters: {
          'city': query.city,
          'sortBy': query.sortBy,
        },
      ),
    );
  } catch (error) {
    throw Exception('Unable to load hotels: $error');
  }
});
