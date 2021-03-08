import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GaugeChart extends StatelessWidget {
  // final List<charts.Series> seriesList;
  final bool animate;
  final String title;
  final double max, min, index;
  final Color color;
  final int guageWidth;
  final TextStyle indexTextStyle;

  GaugeChart({
    this.animate,
    this.max,
    this.min,
    this.index,
    this.color = Colors.blue,
    this.guageWidth = 10,
    this.indexTextStyle,
    this.title = 'Guage',
  });

  // /// Creates a [PieChart] with sample data and no transition.
  // factory GaugeChart.withSampleData() {
  //   return new GaugeChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        charts.PieChart(
          _createData(
            max: max,
            min: min,
            index: index,
          ),
          animate: animate,
          behaviors: [
            // charts.DatumLegend(),
            charts.ChartTitle(
              title,
              // subTitle: 'Subtitle',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification: charts.OutsideJustification.middle,
              titlePadding: 8,
              titleStyleSpec: charts.TextStyleSpec(
                fontSize:
                    Theme.of(context).textTheme.headline6.fontSize.toInt(),
                color: charts.ColorUtil.fromDartColor(
                  Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
                ),
              ),
            ),
          ],
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: guageWidth,
            startAngle: 4 / 5 * pi,
            arcLength: 7 / 5 * pi,
          ),
        ),
        Center(
          child: FittedBox(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                index.toStringAsFixed(0),
                style: indexTextStyle,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<charts.Series<GaugeSegment, String>> _createData(
      {double max, double min, double index}) {
    final data = [
      new GaugeSegment(
          'Low', index - min, charts.ColorUtil.fromDartColor(color)),
      new GaugeSegment('Acceptable', max - index,
          charts.ColorUtil.fromDartColor(color.withOpacity(0.3))),
      // new GaugeSegment('High', 50),
      // // new GaugeSegment('Highly Unusual', 5),
      // GaugeSegment('Highly Unusual', 50),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        // seriesColor: charts.ColorUtil.fromDartColor(Colors.black),
        colorFn: (GaugeSegment segment, _) => segment.color,
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Low', 100, charts.ColorUtil.fromDartColor(Colors.red)),
      new GaugeSegment('Acceptable', 100,
          charts.ColorUtil.fromDartColor(Colors.red.withOpacity(0.3))),
      // new GaugeSegment('High', 50),
      // // new GaugeSegment('Highly Unusual', 5),
      // GaugeSegment('Highly Unusual', 50),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        seriesColor: charts.ColorUtil.fromDartColor(Colors.black),
        colorFn: (GaugeSegment segment, _) => segment.color,
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final double size;
  final charts.Color color;

  GaugeSegment(this.segment, this.size, this.color);
}
