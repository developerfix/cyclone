import 'package:flutter/foundation.dart';

/// Anytime can support multiple search providers. This class represents a
/// provider.
class SearchProvider {
  final String key;
  final String name;

  SearchProvider({
    @required this.key,
    @required this.name,
  });
}
