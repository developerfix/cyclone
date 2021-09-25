import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Siuu/models/user_model.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;

ChatUser currentUser;

//firestore
String get isMutedField => 'is_muted';

String get newMessagesNumField => 'new_messages_num';

String get newMessageTimestampField => 'timestamp';

String get nameCaseSearchField => 'name_case_search';

String get latestMessageField => 'latest_message';

String get latestMessageReadedField => 'latest_message_readed';

String get isWritingField => 'is_writing';

//firebase storage
String get audiosDirectory => 'audios';

String get imagesDirectory => 'images';
