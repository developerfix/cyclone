import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  const DateSeparator(
      {@required this.currentMessage, @required this.nextMessage});

  final Message currentMessage;
  final Message nextMessage;

  @override
  Widget build(BuildContext context) {
    if (nextMessage == null ||
        !isSameDate(currentMessage.dateTime, nextMessage.dateTime)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            fullDate(context, date: currentMessage.dateTime),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Container();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
