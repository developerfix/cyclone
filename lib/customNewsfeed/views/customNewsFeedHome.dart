import 'dart:async';

import 'package:cyclone/customNewsfeed/views/categorie_news.dart';
import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget child;

String chosenValue;

class CustomNewsFeedHome extends StatefulWidget {
  @override
  _CustomNewsFeedHomeState createState() => _CustomNewsFeedHomeState();
}

class _CustomNewsFeedHomeState extends State<CustomNewsFeedHome> {
  int timerValue = 0;
// ignore: must_call_super
  void initState() {
    print(chosenValue);
    setState(() {
      if (child == null) {
        child = Center(
          child: new Text(
            "Add topics\nto customize your\nnewsfeed by clicking on\nthe plus icon",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.grey[800],
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        );
      }
    });
    _timer();
  }

  _timer() {
    if (chosenValue == '1 day') {
      timerValue = 1;
    } else if (chosenValue == '3 days') {
      timerValue = 3;
    } else if (chosenValue == '7 days') {
      timerValue = 7;
    } else {
      timerValue = 100;
    }
    Timer(Duration(days: timerValue), () {
      setState(() {
        child = null;
      });
    });
  }

  void _timerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Timer for the Category"),
          content: Container(
            height: 100,
            width: 200,
            child: Column(
              children: <Widget>[
                new Text(
                    "Please choose the time period for the selected topic"),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState) {
                  return DropdownButton<String>(
                    hint: new Text(
                      "Select",
                      style: TextStyle(
                          fontFamily: "Montserrat", color: Colors.black),
                    ),
                    value: chosenValue,
                    underline: Container(),
                    items: <String>[
                      '1 Day',
                      '3 Days',
                      '7 Days',
                      'Until Changed'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      dropDownState(() {
                        chosenValue = value;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _selectCategory(String choice) {
    switch (choice) {
      case '':
        child = Center(
          child: new Text(
            "Add topics\nto customize your\nnewsfeed by clicking on\nthe plus icon",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.grey[800],
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        );
        break;
      case 'Business':
        setState(() {
          child = CategoryNews(
            newsCategory: 'Business',
          );
        });

        break;
      case 'Entertainment':
        child = CategoryNews(
          newsCategory: 'Entertainment',
        );
        break;
      case 'Health':
        child = CategoryNews(
          newsCategory: 'Health',
        );
        break;
      case 'Science':
        child = CategoryNews(
          newsCategory: 'Science',
        );
        break;
      case 'Sports':
        child = CategoryNews(
          newsCategory: 'Sports',
        );
        break;
      case 'Technology':
        child = CategoryNews(
          newsCategory: 'Technology',
        );
        break;
      case 'General':
        child = CategoryNews(
          newsCategory: 'Generat',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          decoration: BoxDecoration(gradient: linearGradient),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                height: 60,
                child: Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg/logo.svg'),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Custom Newsfeed",
                          style: TextStyle(
                              fontFamily: "Billabong",
                              fontWeight: FontWeight.w600,
                              // fontStyle: FontStyle.italic,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      color: Theme.of(context).dialogBackgroundColor,
                      onSelected: (value) {
                        setState(() {
                          _selectCategory(value);
                          _timerDialog();
                        });
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              textStyle: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              value: 'Business',
                              child: Text('Business')),
                          PopupMenuItem<String>(
                              textStyle: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              value: 'Entertainment',
                              child: Text('Entertainment')),
                          PopupMenuItem<String>(
                              textStyle: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              value: 'Health',
                              child: Text('Health')),
                          PopupMenuItem<String>(
                              textStyle: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              value: 'Science',
                              child: Text('Science')),
                          PopupMenuItem<String>(
                              textStyle: TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              value: 'Sports',
                              child: Text('Sports')),
                          PopupMenuItem<String>(
                            textStyle: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            value: 'Technology',
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Text('Technology');
                              },
                            ),
                          ),
                          PopupMenuItem<String>(
                            textStyle: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            value: 'General',
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    child = CategoryNews(
                                      newsCategory: 'General',
                                    );
                                  });
                                },
                                child: Text('General')),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(60),
      ),
      body: SizedBox.expand(child: child),
    );
  }
}
