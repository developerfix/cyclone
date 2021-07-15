import 'package:cyclone/screens/Podcast_UI/gridtile.dart';
import 'package:flutter/material.dart';

class Listings extends StatefulWidget {
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // SizedBox(height: 10.0),
          SizedBox(
            height: 150.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                gridTile(
                  image: 'assets/images/podcast_imags/mesutcevik.jpg',
                  title: "Mesut Çevik ile Podcast",
                  subtitle: "Mesut Çevik",
                ),
                gridTile(
                    image:
                        'assets/images/podcast_imags/teknolojivebilimnotlari.jpg',
                    title: "Teknoloji ve Bilim Notları",
                    subtitle: "Teknoseyir"),
                gridTile(
                  image: 'assets/images/podcast_imags/studio71.jpg',
                  title: "Waveform: The MKBHD Podcast",
                  subtitle: "Studio71",
                ),
                gridTile(
                    image: 'assets/images/podcast_imags/teknoseyir.jpg',
                    title: "Haftalık Gündem Değerlendirmesi",
                    subtitle: "Teknoseyir"),
                gridTile(
                  image: 'assets/images/podcast_imags/mesutcevik.jpg',
                  title: "Mesut Çevik ile Podcast",
                  subtitle: "Mesut Çevik",
                ),
                gridTile(
                    image:
                        'assets/images/podcast_imags/teknolojivebilimnotlari.jpg',
                    title: "Teknoloji ve Bilim Notları",
                    subtitle: "Teknoseyir"),
                gridTile(
                  image: 'assets/images/podcast_imags/studio71.jpg',
                  title: "Waveform: The MKBHD Podcast",
                  subtitle: "Studio71",
                ),
                gridTile(
                    image: 'assets/images/podcast_imags/teknoseyir.jpg',
                    title: "Haftalık Gündem Değerlendirmesi",
                    subtitle: "Teknoseyir"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
