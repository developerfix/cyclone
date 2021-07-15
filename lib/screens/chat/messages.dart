import 'package:cyclone/utils/res.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 110,
          decoration: BoxDecoration(gradient: linearGradient),
          child: Column(
            children: [
              Container(
                height: 50,
                // color: Colors.red,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 44.00,
                      width: 296.00,
                      decoration: BoxDecoration(
                        color: Color(0xfffff5eb),
                        borderRadius: BorderRadius.circular(30.00),
                      ),
                      child: TextFormField(
                        cursorColor: Color(twine),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xffb7b7b7),
                          ),
                          hintText: "Search…",
                          hintStyle: TextStyle(
                            fontFamily: "Monteserrat",
                            fontSize: 15,
                            color: Color(0xffb7b7b7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(110),
      ),
      body: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  buildText(
                      text: 'Messages',
                      color: Color(0xff000000),
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                  buildText(
                      text: 'You have 2 new messages',
                      color: Color(0xff000000).withOpacity(0.30),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  buildListTile(
                      leadingImagePath: "assets/images/Image.png",
                      subtitle: 'Hi Julian! See you after work?',
                      title: 'Julian Dasilva',
                      trailing: 'Now'),
                  buildListTile(
                      leadingImagePath: "assets/images/mike.png",
                      subtitle: 'I must tell you my interview this...',
                      title: 'Mike Lyne',
                      trailing: '3 min ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/claire.png",
                      subtitle: 'Yes I can do this to you in the week...',
                      title: 'Claire Kumas',
                      trailing: '1 hour ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/blair.png",
                      subtitle: 'By the way, did not you see my dog...',
                      title: 'Blair Dota',
                      trailing: '1 day ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/Image.png",
                      subtitle: 'Hi Julian! See you after work?',
                      title: 'Julian Dasilva',
                      trailing: 'Now'),
                  buildListTile(
                      leadingImagePath: "assets/images/mike.png",
                      subtitle: 'I must tell you my interview this...',
                      title: 'Mike Lyne',
                      trailing: '3 min ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/claire.png",
                      subtitle: 'Yes I can do this to you in the week...',
                      title: 'Claire Kumas',
                      trailing: '1 hour ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/blair.png",
                      subtitle: 'By the way, did not you see my dog...',
                      title: 'Blair Dota',
                      trailing: '1 day ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/Image.png",
                      subtitle: 'Hi Julian! See you after work?',
                      title: 'Julian Dasilva',
                      trailing: 'Now'),
                  buildListTile(
                      leadingImagePath: "assets/images/mike.png",
                      subtitle: 'I must tell you my interview this...',
                      title: 'Mike Lyne',
                      trailing: '3 min ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/claire.png",
                      subtitle: 'Yes I can do this to you in the week...',
                      title: 'Claire Kumas',
                      trailing: '1 hour ago'),
                  buildListTile(
                      leadingImagePath: "assets/images/blair.png",
                      subtitle: 'By the way, did not you see my dog...',
                      title: 'Blair Dota',
                      trailing: '1 day ago'),
                ],
              ),
            ),
          )),
    );
  }

  InkWell buildListTile(
      {String leadingImagePath,
      String title,
      String subtitle,
      String trailing}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/chat');
      },
      child: ListTile(
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(
                text: trailing,
                color: Color(0xff000000).withOpacity(0.30),
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ],
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(leadingImagePath),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                maxRadius: 5,
                backgroundColor: Color(greenish),
              ),
            ),
          ],
        ),
        title: buildText(
            text: title,
            color: Color(0xff000000),
            fontSize: 15,
            fontWeight: FontWeight.w700),
        subtitle: buildText(
            text: subtitle,
            color: Color(0xff000000).withOpacity(0.40),
            fontSize: 15,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Text buildText(
      {String text, double fontSize, FontWeight fontWeight, Color color}) {
    return new Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
