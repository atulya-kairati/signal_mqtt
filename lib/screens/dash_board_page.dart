import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:signal_final/models/contants_and_utils.dart';
import 'package:provider/provider.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:signal_final/mqtt/MQTTmanager.dart';
import 'package:signal_final/widgets/buttons_and_widgets.dart';
import 'package:signal_final/widgets/custom_listTile.dart';
import 'package:signal_final/widgets/custom_textfield.dart';
import 'package:signal_final/widgets/my_icon_picker.dart';
import 'package:signal_final/widgets/picture_frame.dart';

class MQTTpage extends StatefulWidget {
  const MQTTpage({Key key}) : super(key: key);

  @override
  _MQTTpageState createState() => _MQTTpageState();
}

class _MQTTpageState extends State<MQTTpage> {
  MQTTManager manager;
  int bindex;
  List<String> topics;

  @override
  void initState() {
    super.initState();

    // manager = MQTTManager(host: null, topic: null, identifier: null);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bindex = ModalRoute.of(context).settings.arguments;
      _configureAndConnect();
    });
  }

  @override
  Widget build(BuildContext context) {
    bindex = ModalRoute.of(context).settings.arguments;
    // print(Colors.white);s
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    manager?.disconnectionNotifyFlag =
        true; // for situation where page gets replaced and not disposed

    print(ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${Provider.of<AppState>(context).brokerData[bindex]['name'].toUpperCase()} Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              manager.disconnectionNotifyFlag = true;
              manager.disconnect();
              _configureAndConnect();
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton:
          (keyboardIsOpen) ? null : myFloatingActionButton(context),
      body: (Provider.of<AppState>(context).mqttConnectionState !=
              MqttConnectionState.connected)
          ? Text(Provider.of<AppState>(context).mqttConnectionState.toString())
          : Consumer(
              // Provider.of<ListData>(context, listen: false) --> brokerData
              builder: (context, AppState appState, child) {
                return GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    print('>> $index');

                    return getWidget(
                      appState: appState,
                      index: index,
                    );
                  },
                  itemCount: appState.getWidgetData(bindex).length,
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    manager.disconnectionNotifyFlag = false;
    manager.disconnect();
  }

  Widget getWidget({int index, AppState appState}) {
    switch (appState.getWidgetData(bindex)[index]['id']) {
      case kSingleValueButtonId:
        return SinglevalueButton(
          data: appState.getWidgetData(bindex)[index],
          pubFunc: manager.publish,
          adr: {'bindex': bindex, 'windex': index, 'id': kSingleValueButtonId},
        );
      case kDoubleValueButtonId:
        // return Text('shoot');
        return DoubleValueButton(
          data: appState.getWidgetData(bindex)[index],
          onInitCallBack: () {
            manager.subscribe(appState.getWidgetData(bindex)[index]['topic']);
          },
          pubFunc: manager.publish,
          adr: {'bindex': bindex, 'windex': index, 'id': kDoubleValueButtonId},
        );
      case kIconButtonId:
        return CustomIconButton(
          pubFunc: manager.publish,
          data: appState.getWidgetData(bindex)[index],
          adr: {'bindex': bindex, 'windex': index, 'id': kIconButtonId},
        );
      case kTextTerminalId:
        return TextTerminal(
          pubFunc: manager.publish,
          data: appState.getWidgetData(bindex)[index],
          onInitCallBack: () {
            manager.subscribe(appState.getWidgetData(bindex)[index]['topic']);
          },
          adr: {'bindex': bindex, 'windex': index, 'id': kTextTerminalId},
        );
      case kGuageId:
        return MyGuage(
          data: appState.getWidgetData(bindex)[index],
          adr: {'bindex': bindex, 'windex': index, 'id': kGuageId},
          onInitCallBack: () {
            manager.subscribe(appState.getWidgetData(bindex)[index]['topic']);
          },
        ); //Text(appState.getWidgetData(bindex)[index].toString());
      case kGraphId:
        return MyGraph(
          data: appState.getWidgetData(bindex)[index],
          adr: {'bindex': bindex, 'windex': index, 'id': kGraphId},
          onInitCallBack: () {
            manager.subscribe(appState.getWidgetData(bindex)[index]['topic']);
          },
        ); //Text(appState.getWidgetData(bindex)[index].toString());

      case kBarGraphId:
        return MyBarGraph(
          data: appState.getWidgetData(bindex)[index],
          adr: {'bindex': bindex, 'windex': index, 'id': kBarGraphId},
          onInitCallBack: () {
            manager.subscribe(appState.getWidgetData(bindex)[index]['topic']);
          },
        );

      case kPictureFrame:
        return PictureFrame(
          data: appState.getWidgetData(bindex)[index],
          adr: {'bindex': bindex, 'windex': index, 'id': kPictureFrame},
          onInitCallBack: () {
            manager.subscribe(appState.getWidgetData(bindex)[index]['topic']);
          },
        );
    }
    return Text('Dummy');
  }

  FloatingActionButton myFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        openDialog(
          title: 'Choose Widget',
          context: context,
          content: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {
                          'id': kSingleValueButtonId,
                          'bindex': bindex
                        });
                  },
                  title: Text('Single value Button'),
                ),
                ListTile(
                  // padding: EdgeInsets.symmetric(vertical: 24),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {
                          'id': kDoubleValueButtonId,
                          'bindex': bindex
                        });
                  },
                  title: Text('Double value Button'),
                ),
                ListTile(
                  // padding: EdgeInsets.symmetric(vertical: 24),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {'id': kIconButtonId, 'bindex': bindex});
                  },
                  title: Text('Icon Button'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {'id': kTextTerminalId, 'bindex': bindex});
                  },
                  title: Text('Text Terminal'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {'id': kGuageId, 'bindex': bindex});
                  },
                  title: Text('Guage'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {'id': kGraphId, 'bindex': bindex});
                  },
                  title: Text('Graph'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {'id': kBarGraphId, 'bindex': bindex});
                  },
                  title: Text('Bar Graph'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: {'id': kPictureFrame, 'bindex': bindex});
                  },
                  title: Text('Picture Frame'),
                ),
              ],
            ),
          ),
          actionWidgetList: [
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _configureAndConnect() {
    manager = MQTTManager(
      appState: Provider.of<AppState>(context, listen: false),
      host: Provider.of<AppState>(context, listen: false).brokerData[bindex]
          ['host'],
      identifier: Provider.of<AppState>(context, listen: false)
          .brokerData[bindex]['uID'],
    );

    manager.initializeMQTTClient();
    manager.connect();

    print(
        '______------------------------------------------------------------------------------');
    print(manager.connectionStat);
  }
}

// Widgets move them to seperate file

class CustomIconButton extends StatelessWidget {
  final Map<String, String> data;
  final Function({String message, String topic}) pubFunc;
  final Map adr;

  const CustomIconButton({Key key, this.data, this.pubFunc, @required this.adr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonContainer(
      title: data['name'],
      subtitle: "Publish  ${data['value']} in  ${data['topic']}",
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 6,
        child: Container(
          height: double.infinity,
          child: Material(
            color: Theme.of(context).cardColor,
            child: InkWell(
              customBorder: new CircleBorder(),
              onTap: () {
                pubFunc(
                  topic: data['topic'],
                  message: data['value'],
                );
              },
              // splashColor: Colors.red,
              child: FittedBox(
                child: Icon(
                  mIcons[data['icon']],
                  size: 32,
                  color: Color.fromARGB(
                    255,
                    int.parse(data['color'].split(',')[0]),
                    int.parse(data['color'].split(',')[1]),
                    int.parse(data['color'].split(',')[2]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onLongPress: () {
        print(adr);
        openDialog(
          title: data['name'],
          content: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 6,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: adr);
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text('Delete'),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false)
                        .deleteWidgetData(
                      bindex: adr['bindex'],
                      windex: adr['windex'],
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
    );
  }
}

class TextTerminal extends StatefulWidget {
  // passing function with named arguement
  final Function({String message, String topic}) pubFunc;
  final Function onInitCallBack;
  final Map<String, String> data;
  final Map adr;

  TextTerminal(
      {@required this.pubFunc,
      @required this.data,
      @required this.onInitCallBack,
      @required this.adr});

  @override
  _TextTerminalState createState() => _TextTerminalState();
}

class _TextTerminalState extends State<TextTerminal> {
  TextEditingController msgTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.onInitCallBack();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print(widget.adr);
        openDialog(
          title: widget.data['name'],
          content: Container(
            width: MediaQuery.of(context).size.width,
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
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(height: 6),
            Expanded(
              flex: 2,
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
              flex: 5,
              child: Card(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  // height: MediaQuery.of(context).size.width / 4.5,
                  child: Consumer(
                    builder: (context, AppState appState, child) {
                      int listLen =
                          appState.topicData[widget.data['topic']]?.length ?? 0;
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: listLen,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // (listLen - 1 - index ) is to reverse list
                              Text(
                                "${appState.topicData[widget.data['topic']]?.elementAt(listLen - 1 - index)?.timestamp ?? ''} >>>  ",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                    255,
                                    int.parse(
                                        widget.data['color'].split(',')[0]),
                                    int.parse(
                                        widget.data['color'].split(',')[1]),
                                    int.parse(
                                        widget.data['color'].split(',')[2]),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(appState
                                        .topicData[widget.data['topic']]
                                        ?.elementAt(listLen - 1 - index)
                                        ?.message ??
                                    ''), // reverse the list
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  print(value);
                  if (msgTextEditingController.text.isEmpty) return;
                  widget.pubFunc(
                    topic: widget.data['topic'],
                    message: msgTextEditingController.text,
                  );
                  msgTextEditingController.clear();
                },
                // onChanged: (val) {},
                controller: msgTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Payload',
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            // SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class DoubleValueButton extends StatefulWidget {
  // passing function with named arguement
  final Function({String message, String topic}) pubFunc;
  final Function onInitCallBack;
  final Map<String, String> data;
  final adr;

  DoubleValueButton(
      {@required this.pubFunc,
      @required this.data,
      @required this.onInitCallBack,
      @required this.adr});

  @override
  _DoubleValueButtonState createState() => _DoubleValueButtonState();
}

class _DoubleValueButtonState extends State<DoubleValueButton> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    widget.onInitCallBack();
  }

  @override
  Widget build(BuildContext context) {
    ///// this logic is part 1 to handle if values other than
    /// on or off vlaues are encountered
    if (Provider.of<AppState>(context, listen: false)
            .topicData[widget.data['topic']]
            ?.last
            ?.message ==
        widget.data['onValue'])
      isSwitched = true;
    else if (Provider.of<AppState>(context, listen: false)
            .topicData[widget.data['topic']]
            ?.last
            ?.message ==
        widget.data['offValue']) isSwitched = false;

    return ButtonContainer(
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
      title: widget.data['name'],
      subtitle:
          'Publish ${widget.data['offValue']}(off) or ${widget.data['onValue']}(on) in ${widget.data['topic']}',
      child: FittedBox(
        child: Transform.scale(
          scale: 1.6,
          child: Switch(
            ///// this logic is part 1 to handle if values other than
            /// on or off vlaues are encountered
            value: (Provider.of<AppState>(context)
                        .topicData[widget.data['topic']]
                        ?.last
                        ?.message ==
                    widget.data['onValue'])
                ? true
                : ((Provider.of<AppState>(context)
                            .topicData[widget.data['topic']]
                            ?.last
                            ?.message ==
                        widget.data['offValue'])
                    ? false
                    : isSwitched),
            activeColor: Color.fromARGB(
              255,
              int.parse(widget.data['color'].split(',')[0]),
              int.parse(widget.data['color'].split(',')[1]),
              int.parse(widget.data['color'].split(',')[2]),
            ),

            onChanged: (value) {
              // setState(() {

              //   print(isSwitched);
              // });
              isSwitched = value;
              if (value)
                widget.pubFunc(
                    message: widget.data['onValue'],
                    topic: widget.data['topic']);
              else
                widget.pubFunc(
                    message: widget.data['offValue'],
                    topic: widget.data['topic']);
            },
          ),
        ),
      ),
    );
  }
}

// Provider.of<AppState>(context).getWidgetData(bindex).toString(),

class SinglevalueButton extends StatelessWidget {
  final Map<String, String> data;
  final Map adr;
  final Function({String message, String topic}) pubFunc;

  const SinglevalueButton({
    Key key,
    @required this.data,
    @required this.pubFunc,
    @required this.adr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonContainer(
      onLongPress: () {
        print(adr);
        openDialog(
          title: data['name'],
          content: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 6,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, rWidgetInfoForm,
                        arguments: adr);
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text('Delete'),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false)
                        .deleteWidgetData(
                      bindex: adr['bindex'],
                      windex: adr['windex'],
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
      title: data['name'],
      subtitle: " Publish " + data['value'] + " in " + data['topic'],
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 6,
        child: Container(
          height: double.infinity,
          child: RaisedButton(
            color: Color.fromARGB(
              255,
              int.parse(data['color'].split(',')[0]),
              int.parse(data['color'].split(',')[1]),
              int.parse(data['color'].split(',')[2]),
            ),
            child: FittedBox(
              child: Text('PUBLISH'),
            ),
            onPressed: () {
              pubFunc(message: data['value'], topic: data['topic']);
            },
          ),
        ),
      ),
    );
  }
}
