import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:signal_final/models/contants_and_utils.dart';

class SimpleBarChart extends StatelessWidget {
  final List<Payload> data;
  final Color color;
  final bool animate;
  final noOfDatapoints = 5;
  final String xLableName, title;

  SimpleBarChart({
    this.animate,
    @required this.data,
    this.color = Colors.blueAccent,
    this.xLableName = 'X-lable',
    this.title = 'Name',
  });

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createData(data: data),
      animate: false,
      domainAxis: charts.AxisSpec<String>(
        renderSpec: new charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelRotation: 20,
          labelStyle: new charts.TextStyleSpec(
            fontSize: 10, // size in Pts.
            color: charts.ColorUtil.fromDartColor(
              Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
            ),
          ),

          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(
              Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
            ),
          ),
        ),
        // tickProviderSpec: charts.BasicNumericTickProviderSpec(
        //   desiredTickCount: noOfDatapoints,
        // ),
        // tickFormatterSpec: customTickFormatter,
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
            fontSize: 12, // size in Pts.
            color: charts.ColorUtil.fromDartColor(
              Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
            ),
          ),

          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(
              Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
            ),
          ),
        ),
      ),
      behaviors: [
        charts.ChartTitle(
          title,
          titleStyleSpec: charts.TextStyleSpec(
            fontSize: Theme.of(context).textTheme.headline6.fontSize.toInt(),
            color: charts.ColorUtil.fromDartColor(
              Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
            ),
          ),
          behaviorPosition: charts.BehaviorPosition.top,
          titleOutsideJustification: charts.OutsideJustification.middle,
          innerPadding: 8,
        ),
        charts.ChartTitle(
          'Time',
          titleStyleSpec: charts.TextStyleSpec(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize.toInt(),
            color: charts.ColorUtil.fromDartColor(
              Theme.of(context).textTheme.subtitle2.color.withOpacity(0.6),
            ),
          ),
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        // charts.ChartTitle(
        //   xLableName,
        //   titleStyleSpec: charts.TextStyleSpec(
        //     fontSize: Theme.of(context).textTheme.bodyText1.fontSize.toInt(),
        //     color: charts.ColorUtil.fromDartColor(
        //       Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
        //     ),
        //   ),
        //   behaviorPosition: charts.BehaviorPosition.start,
        //   titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        // ),
      ],
      defaultRenderer: new charts.BarRendererConfig(
        // By default, bar renderer will draw rounded bars with a constant
        // radius of 100.
        // To not have any rounded corners, use [NoCornerStrategy]
        // To change the radius of the bars, use [ConstCornerStrategy]
        cornerStrategy: const charts.ConstCornerStrategy(30),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Point, String>> _createData({List<Payload> data}) {
    if (data == null) return [];

    data = data
        ?.where((payload) => double.tryParse(payload.message) != null)
        ?.toList();

    if (data.length > noOfDatapoints)
      data = data.sublist(data.length - noOfDatapoints);

    List<Point> xLabels = [];

    for (var i = 1; i <= data.length; i++) {
      xLabels.add(
        Point(
          message: data[i - 1].message,
          timestamp: '$i\n' + data[i - 1].timestamp,
        ),
      );
    }

    // xLabels;timesatmp: '$i\n' + data[i - 1].timestamp, data[i - 1].message

    return [
      charts.Series<Point, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        domainFn: (payload, _) => payload.timestamp,
        measureFn: (payload, _) => double.parse(payload.message),
        data: xLabels,
      )
    ];
  }
}

class Point {
  final String message, timestamp;
  Point({this.message, this.timestamp});
}
