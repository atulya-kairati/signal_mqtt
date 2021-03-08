import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:signal_final/models/contants_and_utils.dart';

class PointsLineChart extends StatelessWidget {
  final bool animate;
  final noOfDataPoints = 6;
  final List<Payload> data;
  final Color color;
  final List<String> xLabels = [];
  final String xLableName, title;

  PointsLineChart({
    this.animate,
    this.data,
    this.color,
    this.xLableName = 'X-lable',
    this.title = 'Name',
  });

  @override
  Widget build(BuildContext context) {
    var customTickFormatter = charts.BasicNumericTickFormatterSpec((num value) {
      try {
        return xLabels[value.toInt()];
      } catch (e) {
        return '00';
      }
    });

    return charts.LineChart(
      _createSampleData(
        data: data,
      ),
      animate: false,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      domainAxis: charts.NumericAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelRotation: 30,
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
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: noOfDataPoints,
        ),
        tickFormatterSpec: customTickFormatter,
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
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Point, int>> _createSampleData({List<Payload> data}) {
    // data = null;
    List<Point> points = [];
    if (data != null) {
      data = data
          ?.where((payload) => double.tryParse(payload.message) != null)
          ?.toList();

      if (data.length > noOfDataPoints)
        data = data.sublist(data.length - noOfDataPoints);

      print(data);

      xLabels?.clear();

      for (var i = 0; i < data.length; i++) {
        points.add(Point(i, double.parse(data[i].message)));
        xLabels.add(data[i].timestamp);
      }
      print(xLabels);
    } else {
      points = [
        Point(0, 0),
        Point(0, 0),
        Point(0, 0),
        Point(0, 0),
        Point(0, 0),
      ];
    }

    return [
      charts.Series<Point, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        domainFn: (payload, _) => payload.index,
        measureFn: (payload, _) => (payload.message),
        data: points,
      )
    ];
  }
}

/// Sample linear data type.
class Point {
  final int index;
  final double message;

  Point(this.index, this.message);

  @override
  @override
  String toString() {
    return '($index, $message)';
  }
}

// class Payload {
//   final String timestamp;
//   final String message;

//   Payload(this.timestamp, this.message);
// }
