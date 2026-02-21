import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../shared/models/catalog_models.dart';
import '../shared/models/paginated_list_state.dart';

const _pageSize = 2;
const List<CarListItem> _allCars = <CarListItem>[
  CarListItem(
    id: '1',
    name: 'Toyota Camry 2023',
    type: 'Sedan',
    image: Img.carSedan,
    seats: 5,
    transmission: 'Automatic',
    rating: 4.8,
    reviewCount: 245,
    price: 45.0,
    withDriver: true,
    driverPrice: 25,
  ),
  CarListItem(
    id: '2',
    name: 'BMW X5',
    type: 'SUV',
    image: Img.carSuv,
    seats: 7,
    transmission: 'Automatic',
    rating: 4.9,
    reviewCount: 189,
    price: 85.0,
    withDriver: true,
    driverPrice: 35,
  ),
  CarListItem(
    id: '3',
    name: 'Mercedes C-Class',
    type: 'Luxury',
    image: Img.carLuxury,
    seats: 5,
    transmission: 'Automatic',
    rating: 4.9,
    reviewCount: 156,
    price: 120.0,
    withDriver: true,
    driverPrice: 45,
  ),
  CarListItem(
    id: '4',
    name: 'Hyundai Staria',
    type: 'Van',
    image: Img.carVan,
    seats: 8,
    transmission: 'Automatic',
    rating: 4.7,
    reviewCount: 320,
    price: 70.0,
    withDriver: false,
    driverPrice: 0,
  ),
];

final carsProvider =
    AsyncNotifierProvider<CarsNotifier, PaginatedListState<CarListItem>>(
  CarsNotifier.new,
);

class CarsNotifier extends AsyncNotifier<PaginatedListState<CarListItem>> {
  int _offset = 0;

  @override
  Future<PaginatedListState<CarListItem>> build() async {
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

  Future<PaginatedListState<CarListItem>> _fetchPage({bool reset = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final start = reset ? 0 : _offset;
    final end = (start + _pageSize).clamp(0, _allCars.length);
    final fetched = _allCars.sublist(start, end);
    final previousItems = reset ? const <CarListItem>[] : (state.valueOrNull?.items ?? const <CarListItem>[]);
    final mergedItems = <CarListItem>[...previousItems, ...fetched];

    _offset = mergedItems.length;
    return PaginatedListState<CarListItem>(
      items: mergedItems,
      hasMore: _offset < _allCars.length,
    );
  }
}
