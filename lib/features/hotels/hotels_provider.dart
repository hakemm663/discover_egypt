import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/image_urls.dart';
import '../shared/models/catalog_models.dart';
import '../shared/models/paginated_list_state.dart';

const _pageSize = 2;
const List<HotelListItem> _allHotels = <HotelListItem>[
  HotelListItem(
    id: '1',
    name: 'Pyramids View Hotel',
    city: 'Cairo',
    location: 'Giza, Cairo',
    image: Img.hotelLuxury,
    rating: 4.8,
    reviewCount: 520,
    price: 120.0,
    amenities: <String>['WiFi', 'Pool', 'Restaurant', 'Spa'],
    stars: 5,
  ),
  HotelListItem(
    id: '2',
    name: 'Nile Ritz Carlton',
    city: 'Cairo',
    location: 'Downtown Cairo',
    image: Img.hotelPool,
    rating: 4.9,
    reviewCount: 890,
    price: 250.0,
    amenities: <String>['WiFi', 'Pool', 'Gym', 'Restaurant'],
    stars: 5,
  ),
  HotelListItem(
    id: '3',
    name: 'Steigenberger Resort',
    city: 'Hurghada',
    location: 'Hurghada',
    image: Img.hotelResort,
    rating: 4.7,
    reviewCount: 430,
    price: 180.0,
    amenities: <String>['WiFi', 'Beach', 'Pool', 'Spa'],
    stars: 5,
  ),
  HotelListItem(
    id: '4',
    name: 'Hilton Luxor Resort',
    city: 'Luxor',
    location: 'Luxor City',
    image: Img.hotelRoom,
    rating: 4.6,
    reviewCount: 350,
    price: 140.0,
    amenities: <String>['WiFi', 'Pool', 'Restaurant'],
    stars: 4,
  ),
  HotelListItem(
    id: '5',
    name: 'Four Seasons Alexandria',
    city: 'Alexandria',
    location: 'Alexandria Corniche',
    image: Img.hotelLobby,
    rating: 4.9,
    reviewCount: 670,
    price: 300.0,
    amenities: <String>['WiFi', 'Beach', 'Spa', 'Pool'],
    stars: 5,
  ),
];

final hotelsProvider =
    AsyncNotifierProvider<HotelsNotifier, PaginatedListState<HotelListItem>>(
  HotelsNotifier.new,
);

class HotelsNotifier extends AsyncNotifier<PaginatedListState<HotelListItem>> {
  int _offset = 0;

  @override
  Future<PaginatedListState<HotelListItem>> build() async {
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

  Future<PaginatedListState<HotelListItem>> _fetchPage({bool reset = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final start = reset ? 0 : _offset;
    final end = (start + _pageSize).clamp(0, _allHotels.length);
    final fetched = _allHotels.sublist(start, end);
    final previousItems = reset ? const <HotelListItem>[] : (state.valueOrNull?.items ?? const <HotelListItem>[]);
    final mergedItems = <HotelListItem>[...previousItems, ...fetched];

    _offset = mergedItems.length;
    return PaginatedListState<HotelListItem>(
      items: mergedItems,
      hasMore: _offset < _allHotels.length,
    );
  }
}
