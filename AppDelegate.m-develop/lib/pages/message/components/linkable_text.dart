import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/models/url_data_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkable/constants.dart';
import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkableText extends StatefulWidget {
  final Message message;

  LinkableText({
    @required this.message,
  });

  @override
  _LinkableTextState createState() => _LinkableTextState();
}

class _LinkableTextState extends State<LinkableText>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Linkable(
          text: widget.message.text,
          textColor: Colors.blueGrey,
          linkColor: Colors.blueGrey[700],
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        UrlsPreview(message: widget.message),
      ],
    );
  }
}

class UrlsPreview extends StatelessWidget {
  final Message message;

  const UrlsPreview({@required this.message});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<UrlData>>(
      valueListenable: message.urlsDataNotifier,
      builder: (_, List<UrlData> value, __) {
        if (message.urlsData != null) return getPreview(message.urlsData);
        return (value == null || value.isEmpty)
            ? Container(width: 0)
            : getPreview(value);
      },
    );
  }

  Column getPreview(List<UrlData> data) {
    return Column(
      children: data
          .map(
            (e) => CachedNetworkImage(
              imageUrl: e.image ?? '',
              errorWidget: (_, __, ___) => Container(width: 0),
              imageBuilder: (_, image) {
                return GestureDetector(
                  onTap: () {
                    try {
                      _launch(_getUrl(e.url ?? '', http));
                    } catch (e) {}
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 160,
                              minHeight: 0,
                              minWidth: double.infinity),
                          child: image == null
                              ? Container()
                              : Image(
                                  image: image,
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                      if (e.name.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            e.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (e.description != null &&
                          e.description.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            e.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getUrl(String text, String type) {
    switch (type) {
      case http:
        return text.substring(0, 4) == 'http' ? text : 'http://$text';
      case email:
        return text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text';
      case tel:
        return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      default:
        return text;
    }
  }
}
