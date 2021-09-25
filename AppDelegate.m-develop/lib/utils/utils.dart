import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/cubit/audioplayer_cubit.dart';
import 'package:Siuu/cubit/recordaudio_cubit.dart';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/cubit/typing_cubit.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/home/home.dart';
import 'package:Siuu/pages/message/screens/conversation/conversation_page.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String dateToTime(BuildContext context, {@required DateTime date}) =>
    TimeOfDay.fromDateTime(date).format(context);

String fullDate(BuildContext context,
    {@required DateTime date, bool withTime = false}) {
  DateTime today = DateTime.now();
  DateTime yesterday = today.subtract(Duration(days: 1));
  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    if (withTime) return dateToTime(context, date: date);
    return 'Today';
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Yesterday';
  } else {
    return DateFormat('MMM dd,yyyy').format(date);
  }
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours == 0) return "$twoDigitMinutes:$twoDigitSeconds";
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

void goToConverstation(BuildContext context, ChatUser _user) {
  if (_user == null) {
    Fluttertoast.showToast(
        msg: "User not loaded...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0);
    return;
  }

  storeUser(_user);
  Navigator.push(
    context ?? OBHomePage.generalContext,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TypingCubit(_user.id)),
          BlocProvider(create: (context) => ReplyCubit()),
          BlocProvider(create: (context) => AudioPlayerCubit()),
          BlocProvider(create: (context) => RecordAudioCubit()),
          BlocProvider(create: (context) => ConversationBloc(reciever: _user)),
        ],
        child: Conversation(),
      ),
    ),
  );
}
