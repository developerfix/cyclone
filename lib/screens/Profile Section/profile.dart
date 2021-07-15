import 'dart:io';
import 'dart:math';

import 'package:cyclone/chattt/main.dart';
import 'package:cyclone/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _imgFile;

  final picker = ImagePicker();

  Future uploadImgToFirebase() async {
    try {
      int randomNumber = Random().nextInt(10000);
      String imageLocation = 'images/images$randomNumber.jpg';

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child(imageLocation + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(_imgFile);
      uploadTask.then((res) {
        res.ref.getDownloadURL();
      });
    } catch (e) {
      print(e);
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imgFile = File(pickedFile.path);
    });

    uploadImgToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CycloneUser>(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: width,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(),
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        maxRadius: 50,
                        // borderRadius: BorderRadius.circular(50),
                        child: _imgFile != null
                            ? Image.file(_imgFile)
                            : Image.network(user.photoURL) != null
                                ? Image.network(user.photoURL)
                                : Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                  ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                buildText(
                    color: 0xff000000,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    text: user.name),
                SizedBox(
                  height: 5,
                ),
                buildText(
                    color: 0xff5f5f5f,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    text: "+1 232 234 2342"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg/edit.svg'),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                            onTap: pickImage,
                            child: SvgPicture.asset('assets/svg/upload.svg'))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                buildRow(
                    text1: 'Saved',
                    text2: 'Chats',
                    text3: 'Favs',
                    navigation3: '/favs'),
                SizedBox(
                  height: 20,
                ),
                buildHeadingRow(text: "Personality"),
                SizedBox(
                  height: 20,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 10,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 20,
                ),
                buildHeadingRow(text: "Personality Flaws"),
                SizedBox(
                  height: 20,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 10,
                ),
                buildRow(text1: 'Cards', text2: 'Chats', text3: 'Cards'),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildHeadingRow({String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildText(
            color: 0xff000000,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            text: text),
      ],
    );
  }

  Row buildRow({
    String text1,
    String navigation1,
    // Function navigation2,
    String navigation3,
    String text2,
    String text3,
  }) {
    return Row(
      children: [
        buildContainer(text: text1, navigation: navigation1),
        Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FriendlyChatApp()));

            // Navigator.pushNamed(context, navigation);
          },
          child: new Container(
            height: 43.00,
            width: 95.00,
            decoration: BoxDecoration(
              color: Color(0xfffff5eb),
              borderRadius: BorderRadius.circular(15.00),
            ),
            child: Center(
              child: buildText(
                  color: 0xff000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  text: 'Chats'),
            ),
          ),
        ),
        Spacer(),
        buildContainer(text: text3, navigation: navigation3),
      ],
    );
  }

  InkWell buildContainer({String text, String navigation}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, navigation);
      },
      child: new Container(
        height: 43.00,
        width: 95.00,
        decoration: BoxDecoration(
          color: Color(0xfffff5eb),
          borderRadius: BorderRadius.circular(15.00),
        ),
        child: Center(
          child: buildText(
              color: 0xff000000,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              text: text),
        ),
      ),
    );
  }

  Text buildText(
      {String text, FontWeight fontWeight, double fontSize, int color}) {
    return new Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
