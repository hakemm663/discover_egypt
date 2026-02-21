import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum NetworkImageFallbackType { tour, hotel, car, profile, generic }

class NetworkImageFallback extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final NetworkImageFallbackType type;

  const NetworkImageFallback({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.type = NetworkImageFallbackType.generic,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) => _NetworkImageStateView(type: type),
      errorWidget: (context, url, error) => _NetworkImageStateView(type: type),
    );
  }
}

class _NetworkImageStateView extends StatelessWidget {
  final NetworkImageFallbackType type;

  const _NetworkImageStateView({required this.type});

  @override
  Widget build(BuildContext context) {
    final config = _configFor(type);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.baseColor.withValues(alpha: 0.9),
            config.baseColor.withValues(alpha: 0.65),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          config.icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  _FallbackConfig _configFor(NetworkImageFallbackType type) {
    switch (type) {
      case NetworkImageFallbackType.tour:
        return const _FallbackConfig(Icons.map_outlined, Color(0xFFC89B3C));
      case NetworkImageFallbackType.hotel:
        return const _FallbackConfig(Icons.hotel_outlined, Color(0xFF3C7EC8));
      case NetworkImageFallbackType.car:
        return const _FallbackConfig(Icons.directions_car_outlined, Color(0xFF616161));
      case NetworkImageFallbackType.profile:
        return const _FallbackConfig(Icons.person_outline, Color(0xFF8E24AA));
      case NetworkImageFallbackType.generic:
        return const _FallbackConfig(Icons.image_outlined, Color(0xFF90A4AE));
    }
  }
}

class _FallbackConfig {
  final IconData icon;
  final Color baseColor;

  const _FallbackConfig(this.icon, this.baseColor);
}
