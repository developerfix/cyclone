import 'dart:developer';

import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/consts/massage_consts.dart';
import 'package:Siuu/models/url_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:linkable/emailParser.dart';
import 'package:linkable/httpParser.dart';
import 'package:linkable/link.dart';
import 'package:linkable/parser.dart';
import 'package:linkable/telParser.dart';
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' as parser show parse;

class Message {
  final String id;
  final int type;
  final String text;
  final String senderId;
  final Timestamp timestamp;
  final Message quotedMessage;
  final String reaction;
  final String audioUrl;
  final int audioDuration;
  final String imageUrl;
  final String lottiePath;
  final String temporaryAudioPath;
  final String temporaryImagePath;
  final bool loadUrls;
  List<UrlData> urlsData;
  ValueNotifier<List<UrlData>> urlsDataNotifier =
      ValueNotifier<List<UrlData>>([]);

  Message({
    @required this.type,
    @required this.text,
    this.id,
    this.senderId,
    this.timestamp,
    this.audioUrl,
    this.imageUrl,
    this.lottiePath,
    this.quotedMessage,
    this.reaction,
    this.audioDuration,
    this.temporaryImagePath,
    this.temporaryAudioPath,
    this.urlsData,
    this.loadUrls = false,
  }) {
    if (urlsData == null) {
      if (loadUrls) {
        if (isText) {
          init();
        }
      }
    }
  }

  init() async {
    List<UrlData> urls = await getUrlsData(text);
    if (urls.isNotEmpty) {
      urlsData = urls;
    }
    urlsDataNotifier.value = urls;
  }

  List<Parser> _parsers = <Parser>[];
  List<Link> _links = <Link>[];

  Future<List<UrlData>> getUrlsData(String text) async {
    _addParsers(text);
    _parseLinks();
    _filterLinks();
    return await _fetchData(text);
  }

  _addParsers(String text) {
    _parsers.add(EmailParser(text));
    _parsers.add(HttpParser(text));
    _parsers.add(TelParser(text));
  }

  _parseLinks() {
    for (Parser parser in _parsers) {
      _links.addAll(parser.parse().toList());
    }
  }

  _filterLinks() {
    _links.sort(
        (Link a, Link b) => a.regExpMatch.start.compareTo(b.regExpMatch.start));

    List<Link> _filteredLinks = <Link>[];
    if (_links.length > 0) {
      _filteredLinks.add(_links[0]);
    }

    for (int i = 0; i < _links.length - 1; i++) {
      if (_links[i + 1].regExpMatch.start > _links[i].regExpMatch.end) {
        _filteredLinks.add(_links[i + 1]);
      }
    }
    _links = _filteredLinks;
  }

  Future<List<UrlData>> _fetchData(String text) async {
    // log('_fetchData : ${_links.length}');
    if (_links.isEmpty) return null;
    int i = 0;
    int pos = 0;
    List<String> urls = [];
    List<UrlData> res = [];
    while (i < text.length) {
      if (pos < _links.length && i <= _links[pos].regExpMatch.start) {
        if (_links[pos].type == 'http') {
          urls.add(
            text.substring(
                _links[pos].regExpMatch.start, _links[pos].regExpMatch.end),
          );
        }
        i = _links[pos].regExpMatch.end;
        pos++;
      } else {
        i = text.length;
      }
    }
    for (var i = 0; i < urls.length; i++) {
      log('urls  for :  ${urls[i]}');
      UrlData data = await _addUrlData(urls[i]);
      if (data != null) res.add(data);
    }
    return res;
  }

  Future<UrlData> _addUrlData(String url) async {
    var response = await get(
        Uri.parse(url.substring(0, 4) == 'http' ? url : 'http://$url'));
    if (response.statusCode != 200) {
      return null;
    }

    var document = parser.parse(response.body);
    Map<String, dynamic> data = {};
    _extractOGData(document, data, 'og:title');
    _extractOGData(document, data, 'og:description');
    _extractOGData(document, data, 'og:site_name');
    _extractOGData(document, data, 'og:image');
    data['url'] = url;

    if (data.isNotEmpty) {
      return UrlData.fromMap(data);
    }
    return null;
  }

  void _extractOGData(Document document, Map data, String parameter) {
    var titleMetaTag = document.getElementsByTagName("meta").firstWhere(
          (meta) => meta.attributes['property'] == parameter,
          orElse: () => null,
        );
    if (titleMetaTag != null) {
      data[parameter] = titleMetaTag.attributes['content'];
    }
  }

  DateTime get dateTime => timestamp.toDate();

  bool get isMe => senderId == currentUser.id;
  bool get isAudio => type == Message_Audio_Type;
  bool get isImage => type == Message_Image_Type;
  bool get isLottie => type == Message_Lottie_Type;
  bool get isText => type == Message_Text_Type;
  bool get hasReaction => reaction != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'reaction': reaction,
      'timestamp': FieldValue.serverTimestamp(),
      'text': text,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'lottiePath': lottiePath,
      'type': type,
      'audioDuration': audioDuration,
      'q_message': quotedMessage == null ? null : quotedMessage.quotedToMap(),
    };
  }

  Map<String, dynamic> quotedToMap() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'type': type,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'lottiePath': lottiePath,
      'audioDuration': audioDuration,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      timestamp: map['timestamp'],
      reaction: map['reaction'],
      text: map['text'],
      type: map['type'],
      audioUrl: map['audioUrl'],
      imageUrl: map['imageUrl'],
      lottiePath: map['lottiePath'],
      audioDuration: map['audioDuration'],
      quotedMessage:
          map['q_message'] == null ? null : Message.fromMap(map['q_message']),
    );
  }

  Message copyWith({
    String id,
    String senderId,
    Timestamp timestamp,
    String text,
    String audioUrl,
    String imageUrl,
    String lottiePath,
    String temporaryAudioPath,
    String temporaryImagePath,
    String reaction,
    List<UrlData> urlsData,
    int type,
    Message quotedMessage,
    Key key,
    bool loadUrls,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      text: text ?? this.text,
      type: type ?? this.type,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      lottiePath: lottiePath ?? this.lottiePath,
      temporaryAudioPath: temporaryAudioPath ?? this.temporaryAudioPath,
      temporaryImagePath: temporaryImagePath ?? this.temporaryImagePath,
      audioDuration: audioDuration ?? this.audioDuration,
      loadUrls: loadUrls ?? this.loadUrls,
      urlsData: urlsData ?? this.urlsData,
      reaction: reaction ?? this.reaction,
      quotedMessage: quotedMessage ?? this.quotedMessage,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, type: $type, text: $text, senderId: $senderId, timestamp: $timestamp, quotedMessage: $quotedMessage, reaction: $reaction, audioUrl: $audioUrl, imageUrl: $imageUrl, lottiePath: $lottiePath, temporaryAudioPath: $temporaryAudioPath, temporaryImagePath: $temporaryImagePath, audioDuration: $audioDuration)';
  }
}
