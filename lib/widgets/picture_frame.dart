import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:signal_final/models/contants_and_utils.dart';
import 'dart:convert';

class PictureFrame extends StatefulWidget {
  final Function onInitCallBack;
  final Map<String, String> data;
  final Map adr;

  PictureFrame(
      {@required this.data, @required this.onInitCallBack, @required this.adr});

  @override
  PictureFrameState createState() => PictureFrameState();
}

class PictureFrameState extends State<PictureFrame> {
  String topic;
  final defaultImage =
      'https://hips.hearstapps.com/digitalspyuk.cdnds.net/16/51/1482318327-blackadder-1.jpg?crop=0.563xw:1.00xh;0.106xw,0&resize=480:*';

  @override
  void initState() {
    super.initState();
    widget.onInitCallBack();
    //////////-----------
    topic = widget.data['topic'];
  }

  @override
  Widget build(BuildContext context) {
    print('>>  >>>${widget.adr}');
    // prepLableY();
    return GestureDetector(
      onDoubleTap: () {
        print(context);
        openDialog(
            title: widget.data['name'],
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: widget,
            ),
            actionWidgetList: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
            context: context);
      },
      onLongPress: () {
        print(widget.adr);
        openDialog(
          title: widget.data['name'],
          content: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 6,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: widget.adr);
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text('Delete'),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false)
                        .deleteWidgetData(
                      bindex: widget.adr['bindex'],
                      windex: widget.adr['windex'],
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actionWidgetList: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          context: context,
        );
      },
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark.withOpacity(0.4),
              offset: Offset(0, 4), //(x,y)
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Expanded(
                  flex: 15,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                          '${widget.data["name"]} (topic: ${widget.data["topic"]})',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(0.6),
                            fontSize: 16,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 80,
                  child: Center(
                    child: _pictureFormater(
                      data: Provider.of<AppState>(context)
                          .topicData[widget.data['topic']]
                          ?.last
                          ?.message,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                          'Recieved at: ${Provider.of<AppState>(context).topicData[widget.data["topic"]]?.last?.timestamp ?? "--:--"}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(0.6),
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _pictureFormater({String data}) {
    if (data == null) {
      return Text('No Image Found');
    }

    try {
      var decodedImage = base64Decode(data);
      return Image.memory(decodedImage);
    } on FormatException {
      return Text('Unformatable Data');
    }
  }
}
