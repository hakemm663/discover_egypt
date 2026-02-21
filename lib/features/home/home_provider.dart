import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/repositories/discovery_repositories.dart';

final homeDataProvider = FutureProvider<HomeFeed>((ref) async {
  final repository = ref.read(discoveryRepositoryProvider);
  return repository.getHomeFeed(userId: 'demo-user');
});
