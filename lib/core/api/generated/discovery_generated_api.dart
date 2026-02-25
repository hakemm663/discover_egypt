// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: docs/openapi/discovery_api.openapi.json

class DiscoveryGeneratedApi {
          final String baseUrl;

          const DiscoveryGeneratedApi({this.baseUrl = 'https://api.discoveregypt.com/v1'});

        Uri listHotelsUri(String? city, String? sortBy) {
                final queryParams = <String, String>{};
if (city != null) queryParams['city'] = city.toString();
if (sortBy != null) queryParams['sortBy'] = sortBy.toString();
              final base = Uri.parse(baseUrl);
              final normalizedPath = ('${base.path.endsWith('/') ? base.path.substring(0, base.path.length - 1) : base.path}/hotels').replaceAll('//', '/');
              return base.replace(path: normalizedPath, queryParameters: queryParams.isEmpty ? null : queryParams);
            }
Uri listToursUri(String? category) {
                final queryParams = <String, String>{};
if (category != null) queryParams['category'] = category.toString();
              final base = Uri.parse(baseUrl);
              final normalizedPath = ('${base.path.endsWith('/') ? base.path.substring(0, base.path.length - 1) : base.path}/tours').replaceAll('//', '/');
              return base.replace(path: normalizedPath, queryParameters: queryParams.isEmpty ? null : queryParams);
            }
Uri listCarsUri(String? type, bool? withDriverOnly) {
                final queryParams = <String, String>{};
if (type != null) queryParams['type'] = type.toString();
if (withDriverOnly != null) queryParams['withDriverOnly'] = withDriverOnly.toString();
              final base = Uri.parse(baseUrl);
              final normalizedPath = ('${base.path.endsWith('/') ? base.path.substring(0, base.path.length - 1) : base.path}/cars').replaceAll('//', '/');
              return base.replace(path: normalizedPath, queryParameters: queryParams.isEmpty ? null : queryParams);
            }
Uri listRestaurantsUri(String? cuisine) {
                final queryParams = <String, String>{};
if (cuisine != null) queryParams['cuisine'] = cuisine.toString();
              final base = Uri.parse(baseUrl);
              final normalizedPath = ('${base.path.endsWith('/') ? base.path.substring(0, base.path.length - 1) : base.path}/restaurants').replaceAll('//', '/');
              return base.replace(path: normalizedPath, queryParameters: queryParams.isEmpty ? null : queryParams);
            }
        }
