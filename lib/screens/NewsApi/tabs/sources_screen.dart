import 'package:cyclone/bloc/get_sources_bloc.dart';
import 'package:cyclone/book_view_models/app_provider.dart';
import 'package:cyclone/elements/loader.dart';
import 'package:cyclone/models/newsApi/source.dart';
import 'package:cyclone/models/newsApi/source_response.dart';
import 'package:cyclone/screens/NewsApi/screens/source_detail.dart';
import 'package:cyclone/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SourceScreen extends StatefulWidget {
  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc..getSources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Top channels",
          style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.0),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<SourceResponse>(
        stream: getSourcesBloc.subject.stream,
        builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return Container();
            }
            return _buildSourcesWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return buildLoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildSourcesWidget(SourceResponse data) {
    List<SourceModel> sources = data.sources;
    if (sources.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Sources",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return GridView.builder(
        itemCount: sources.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.86),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SourceDetail(
                              source: sources[index],
                            )));
              },
              child: Container(
                width: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[100],
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: sources[index].id,
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/logos/${sources[index].id}.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                      child: Text(
                        sources[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: Provider.of<AppProvider>(context).theme ==
                                    ThemeConfig.lightTheme
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
