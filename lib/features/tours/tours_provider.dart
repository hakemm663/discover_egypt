import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../shared/models/catalog_models.dart';
import '../shared/models/paginated_list_state.dart';

const _pageSize = 2;
const List<TourListItem> _allTours = <TourListItem>[
  TourListItem(
    id: '1',
    name: 'Pyramids & Sphinx Day Tour',
    category: 'Historical',
    duration: 'Full Day • 8 hours',
    image: Img.pyramidsMain,
    rating: 4.9,
    reviewCount: 1250,
    price: 65.0,
    pickupIncluded: true,
  ),
  TourListItem(
    id: '2',
    name: 'Nile River Cruise',
    category: 'Cruise',
    duration: '3 Days • Luxor to Aswan',
    image: Img.nileCruise,
    rating: 4.8,
    reviewCount: 890,
    price: 320.0,
    pickupIncluded: true,
  ),
  TourListItem(
    id: '3',
    name: 'Luxor Temple & Valley of Kings',
    category: 'Historical',
    duration: 'Full Day • 10 hours',
    image: Img.luxorTemple,
    rating: 4.7,
    reviewCount: 720,
    price: 85.0,
    pickupIncluded: true,
  ),
  TourListItem(
    id: '4',
    name: 'Red Sea Diving Adventure',
    category: 'Adventure',
    duration: 'Half Day • 4 hours',
    image: Img.coralReef,
    rating: 4.9,
    reviewCount: 540,
    price: 95.0,
    pickupIncluded: false,
  ),
  TourListItem(
    id: '5',
    name: 'Desert Safari & BBQ',
    category: 'Adventure',
    duration: 'Evening • 5 hours',
    image: Img.pyramidsCamels,
    rating: 4.6,
    reviewCount: 380,
    price: 75.0,
    pickupIncluded: true,
  ),
];

final toursProvider =
    AsyncNotifierProvider<ToursNotifier, PaginatedListState<TourListItem>>(
  ToursNotifier.new,
);

class ToursNotifier extends AsyncNotifier<PaginatedListState<TourListItem>> {
  int _offset = 0;

  @override
  Future<PaginatedListState<TourListItem>> build() async {
    _offset = 0;
    return _fetchPage(reset: true);
  }

  Future<void> fetchNextPage() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));
    final next = await _fetchPage();
    state = AsyncData(next);
  }

  Future<PaginatedListState<TourListItem>> _fetchPage({bool reset = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final start = reset ? 0 : _offset;
    final end = (start + _pageSize).clamp(0, _allTours.length);
    final fetched = _allTours.sublist(start, end);
    final previousItems = reset ? const <TourListItem>[] : (state.valueOrNull?.items ?? const <TourListItem>[]);
    final mergedItems = <TourListItem>[...previousItems, ...fetched];

    _offset = mergedItems.length;
    return PaginatedListState<TourListItem>(
      items: mergedItems,
      hasMore: _offset < _allTours.length,
    );
  }
}
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
