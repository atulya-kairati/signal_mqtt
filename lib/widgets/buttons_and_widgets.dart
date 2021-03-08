import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:signal_final/models/contants_and_utils.dart';

import 'charts/guage_chart.dart';
import 'charts/line_chart.dart';
import 'charts/bar_chart.dart';

class MyGuage extends StatefulWidget {
  final Function onInitCallBack;
  final Map<String, String> data;
  final Map adr;

  MyGuage(
      {@required this.data, @required this.onInitCallBack, @required this.adr});

  @override
  _MyGuageState createState() => _MyGuageState();
}

class _MyGuageState extends State<MyGuage> {
  Map<String, String> data;
  double min;
  double max;

  @override
  void initState() {
    data = widget.data;
    max = double.parse(data['max']);
    min = double.parse(data['min']);
    super.initState();
    widget.onInitCallBack();
  }

  @override
  Widget build(BuildContext context) {
    data = widget.data;
    max = double.parse(data['max']);
    min = double.parse(data['min']);
    return GestureDetector(
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
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height / 2,
          child: GaugeChart(
            title: data['name'],
            color: Color.fromARGB(
              255,
              int.parse(data['color'].split(',')[0]),
              int.parse(data['color'].split(',')[1]),
              int.parse(data['color'].split(',')[2]),
            ),
            guageWidth: 16,
            animate: false,
            max: double.parse(data["max"]),
            min: double.parse(data["min"]),
            indexTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(
                255,
                int.parse(data['color'].split(',')[0]),
                int.parse(data['color'].split(',')[1]),
                int.parse(data['color'].split(',')[2]),
              ),
            ),
            index: double.tryParse(Provider.of<AppState>(context)
                        .topicData[data['topic']]
                        ?.last
                        ?.message ??
                    min.toString()) ??
                min,
          ),
        ),
      ),
    );
  }
}

class MyGraph extends StatefulWidget {
  final Function onInitCallBack;
  final Map<String, String> data;
  final Map adr;

  MyGraph(
      {@required this.data, @required this.onInitCallBack, @required this.adr});

  @override
  MyGraphState createState() => MyGraphState();
}

class MyGraphState extends State<MyGraph> {
  List<String> labelX = [];
  List<String> labelY = [];
  List<double> datapoints;
  int noOfDatapoints = 6;
  double min;
  double max;
  String topic;

  @override
  void initState() {
    super.initState();
    widget.onInitCallBack();
    //////////-----------
    topic = widget.data['topic'];
    // prepLableY();
    // labelX = ['00:00', '00:00', '00:32', '11:43', '11:55', '12:00'];
  }

  // void prepLableY() {
  //   min = double.parse(widget.data['min']);
  //   max = double.parse(widget.data['max']);
  //   double diff = ((max - min) ~/ (5 - 1)).toDouble();

  //   labelY = [
  //     // length
  //     // min.toStringAsFixed(0),
  //     (min + diff).toStringAsFixed(0),
  //     (min + 2 * diff).toStringAsFixed(0),
  //     (min + 3 * diff).toStringAsFixed(0),
  //     max.toStringAsFixed(0),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
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
              // child: Wrap(
              //   children: [
              //     Stack(
              //       children: [
              //         widget,
              //         Expanded(
              //           child: Container(
              //             color: Colors.transparent,
              //             width: double.infinity,
              //             height: MediaQuery.of(context).size.width * 0.55,
              //           ),
              //         ),
              //       ],
              //     )
              // ],
              // ),
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
          child: PointsLineChart(
            animate: false,
            data: Provider.of<AppState>(context).topicData[topic],
            color: Color.fromARGB(
              255,
              int.parse(widget.data['color'].split(',')[0]),
              int.parse(widget.data['color'].split(',')[1]),
              int.parse(widget.data['color'].split(',')[2]),
            ),
            title: widget.data['name'],
          ),
        ),
        // child: LineGraph(
        //   features: [
        //     Feature(
        //       title: "${widget.data['name']} (topic: $topic)",
        //       color: Colors.blue,
        //       data: getDatapoints(
        //         data: Provider.of<AppState>(context).topicData[topic],
        //       ),
        //     ),
        //   ],
        //   // size: Size(400, 400),
        //   labelX: labelX,
        //   labelY: labelY,
        //   showDescription: true,
        //   size: Size(MediaQuery.of(context).size.width * 0.8,
        //       MediaQuery.of(context).size.width * 0.5),
        // ),
      ),
    );
  }

  // List<double> getDatapoints({List<Payload> data}) {
  //   print(data);
  //   if (data == null || data.isEmpty) return [0, 0, 0, 0, 0, 0];

  //   data = data
  //       .where((payload) => double.tryParse(payload.message) != null)
  //       .toList();
  //   if (data.length > noOfDatapoints)
  //     data = data.sublist(data.length - noOfDatapoints);

  //   labelX = [];
  //   data.forEach((payload) {
  //     labelX.add(payload.timestamp);
  //   });

  //   return data.map((payload) {
  //     double temp = double.parse(payload.message);
  //     double point = (temp - min) / (max - min);
  //     return point;
  //   }).toList();
  // }
}

class MyBarGraph extends StatefulWidget {
  final Function onInitCallBack;
  final Map<String, String> data;
  final Map adr;

  MyBarGraph(
      {@required this.data, @required this.onInitCallBack, @required this.adr});

  @override
  MyBarGraphState createState() => MyBarGraphState();
}

class MyBarGraphState extends State<MyBarGraph> {
  int noOfDatapoints = 6;
  String topic;

  @override
  void initState() {
    super.initState();
    widget.onInitCallBack();
    //////////-----------
    topic = widget.data['topic'];
  }

  @override
  Widget build(BuildContext context) {
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
          child: SimpleBarChart(
            animate: false,
            data: Provider.of<AppState>(context).topicData[topic],
            color: Color.fromARGB(
              255,
              int.parse(widget.data['color'].split(',')[0]),
              int.parse(widget.data['color'].split(',')[1]),
              int.parse(widget.data['color'].split(',')[2]),
            ),
            title: widget.data['name'],
          ),
        ),
      ),
    );
  }
}

// (Provider.of<AppState>(context).topicData[topic] == null) ? [] : getDatapoints(),
