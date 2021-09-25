import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/repository/conversation_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

uploadFile({
  @required String filePath,
  @required String fileName,
  @required String cloudDir,
  @required Message msg,
  @required String recieverId,
}) async {
  File file = File(filePath);
  String randomNum = Random().nextInt(64).toString();
  d.log(
      '$cloudDir/$fileName | $randomNum | ${file.path.split('/').last.split('.').first}');
  UploadTask uploadTask = storage
      .ref()
      .child(
          '$cloudDir/$fileName | $randomNum | ${file.path.split('/').last.split('.').first}')
      .putFile(file);

  TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

  snapshot.ref.getDownloadURL().then((url) async {
    d.log(url);
    if (url != null) {
      ConversationRepository.updateUrl(
          msg: msg, url: url, recieverId: recieverId);
    }
  });
}
