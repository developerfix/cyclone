import 'package:cyclone/widgets/CustomPostContainer.dart';
import 'package:cyclone/widgets/customAppbar.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: CustomAppBar(),
      body: SizedBox(
        height: height,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.purple,
              expandedHeight: height * 0.102,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.orange,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: height * 0.021,
                            ),
                            Center(
                              child: new Text(
                                "Energy Building, Sec 16A, Noida",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Color(0xff777777),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.007,
                            ),
                            new Text(
                              "10:00 AM - 12:00 PM",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
