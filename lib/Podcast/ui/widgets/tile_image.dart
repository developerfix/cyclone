import 'package:cyclone/Podcast/ui/widgets/placeholder_builder.dart';
import 'package:cyclone/Podcast/ui/widgets/podcast_image.dart';
import 'package:flutter/material.dart';

class TileImage extends StatelessWidget {
  const TileImage({
    Key key,
    @required this.url,
    @required this.size,
  }) : super(key: key);

  /// The URL of the image to display.
  final String url;

  /// The size of the image container; both height and width.
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholderBuilder = PlaceholderBuilder.of(context);

    return PodcastImage(
      key: Key('tile$url'),
      url: url,
      height: size,
      width: size,
      placeholder: placeholderBuilder != null
          ? placeholderBuilder?.builder()(context)
          : Image(
              image: AssetImage('assets/images/anytime-placeholder-logo.png')),
      errorPlaceholder: placeholderBuilder != null
          ? placeholderBuilder?.errorBuilder()(context)
          : Image(
              image: AssetImage('assets/images/anytime-placeholder-logo.png')),
    );
  }
}
