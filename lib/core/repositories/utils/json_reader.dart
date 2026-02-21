class JsonSchemaException implements Exception {
  final String message;

  const JsonSchemaException(this.message);

  @override
  String toString() => 'JsonSchemaException: $message';
}

class JsonReader {
  final Map<String, dynamic> _json;

  const JsonReader(this._json);

  String requiredString(String key) {
    final value = _json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    throw JsonSchemaException('Missing or invalid string for key "$key".');
  }

  String stringOr(String key, String fallback) {
    final value = _json[key];
    return value is String && value.trim().isNotEmpty ? value : fallback;
  }

  int requiredInt(String key) {
    final value = _json[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    throw JsonSchemaException('Missing or invalid int for key "$key".');
  }

  int intOr(String key, int fallback) {
    final value = _json[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return fallback;
  }

  double requiredDouble(String key) {
    final value = _json[key];
    if (value is num) {
      return value.toDouble();
    }
    throw JsonSchemaException('Missing or invalid double for key "$key".');
  }

  double doubleOr(String key, double fallback) {
    final value = _json[key];
    if (value is num) {
      return value.toDouble();
    }
    return fallback;
  }

  bool boolOr(String key, bool fallback) {
    final value = _json[key];
    return value is bool ? value : fallback;
  }

  List<String> stringListOrEmpty(String key) {
    final value = _json[key];
    if (value is List) {
      return value.whereType<String>().toList(growable: false);
    }
    return const [];
  }
}
