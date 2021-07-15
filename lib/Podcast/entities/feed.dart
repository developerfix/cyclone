import 'package:cyclone/Podcast/entities/podcast.dart';
import 'package:flutter/foundation.dart';

/// This class is used when loading a [Podcast] feed. The key information
/// is contained within the [Podcast] instance, but as the iTunes API also
/// returns large and thumbnail artwork within its search results this class
/// also contains properties to represent those.
class Feed {
  /// The podcast to load
  final Podcast podcast;

  /// The full-size artwork for the podcast.
  String imageUrl;

  /// The thumbnail artwork for the podcast,
  String thumbImageUrl;

  /// If true the podcast is loaded regardless of if it's currently cached.
  bool refresh;

  Feed({
    @required this.podcast,
    this.imageUrl,
    this.thumbImageUrl,
    this.refresh = false,
  });
}
