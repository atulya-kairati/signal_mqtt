import 'package:flutter/material.dart';
//_________________Constants___________________//

const rHome = 'home';
const rInfoPage = 'info';
const rMqttPage = 'mqtt';
const rWidgetInfoForm = 'wForms';

//_______________Widget ids_______________//
const kSingleValueButtonId = '0';
const kDoubleValueButtonId = '1';
const kIconButtonId = '2';
const kGuageId = '3';
const kTextTerminalId = '4';
const kGraphId = '5';
const kBarGraphId = '6';
const kPictureFrame = '7';

//_________________utils_____________________//
void openDialog({
  @required String title,
  @required Widget content,
  @required List<Widget> actionWidgetList,
  @required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.all(6.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
            Divider(),
          ],
        ),
        titleTextStyle: Theme.of(context).textTheme.headline3,
        content: content,
        actions: actionWidgetList,
      );
    },
  );
}

String getColorRGB(Color color) {
  int r = color.red;
  int g = color.green;
  int b = color.blue;
  String hexColor = '$r,$g,$b';
  return hexColor;
}

////////////////////////////////////////////

class Payload {
  String _message;

  String _timestamp;

  Payload({
    @required String message,
  }) : _message = message {
    _timestamp =
        '${DateTime.now().hour}:${(DateTime.now().minute < 10) ? "0" + DateTime.now().minute.toString() : DateTime.now().minute}';
  }

  // set setTimestamp(String val) {
  //   _timestamp = val;
  // }

  // set setMessage(String val) {
  //   _message = val;
  // }

  String get timestamp => _timestamp;

  String get message => _message;

  @override
  String toString() {
    // return super.toString();
    return "Payload(timestamp: $timestamp, message: $message)";
  }
}
