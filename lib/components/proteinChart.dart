/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ProteinChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesProtein, DateTime>> seriesList;
  final bool animate;

  ProteinChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory ProteinChart.withSampleData() {
    return new ProteinChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesProtein, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesProtein(new DateTime(2017, 9, 5), 75),
      new TimeSeriesProtein(new DateTime(2017, 9, 6), 88),
      new TimeSeriesProtein(new DateTime(2017, 9, 7), 65),
      new TimeSeriesProtein(new DateTime(2017, 9, 8), 91),
      new TimeSeriesProtein(new DateTime(2017, 9, 9), 100),
      new TimeSeriesProtein(new DateTime(2017, 9, 10), 111),
      new TimeSeriesProtein(new DateTime(2017, 9, 11), 90),
      new TimeSeriesProtein(new DateTime(2017, 9, 12), 50),
      new TimeSeriesProtein(new DateTime(2017, 9, 13), 40),
      new TimeSeriesProtein(new DateTime(2017, 9, 14), 30),
      new TimeSeriesProtein(new DateTime(2017, 9, 15), 40),
      new TimeSeriesProtein(new DateTime(2017, 9, 16), 50),
      new TimeSeriesProtein(new DateTime(2017, 9, 17), 30),
      new TimeSeriesProtein(new DateTime(2017, 9, 18), 35),
      new TimeSeriesProtein(new DateTime(2017, 9, 19), 40),
      new TimeSeriesProtein(new DateTime(2017, 9, 20), 32),
      new TimeSeriesProtein(new DateTime(2017, 9, 21), 31),
      new TimeSeriesProtein(new DateTime(2017, 10, 1), 5),
      new TimeSeriesProtein(new DateTime(2017, 10, 2), 5),
      new TimeSeriesProtein(new DateTime(2017, 10, 3), 25),
      new TimeSeriesProtein(new DateTime(2017, 10, 4), 100),
    ];

    return [
      new charts.Series<TimeSeriesProtein, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (TimeSeriesProtein sales, _) => sales.time,
        measureFn: (TimeSeriesProtein sales, _) => sales.proteinAmount,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesProtein {
  final DateTime time;
  final int proteinAmount;

  TimeSeriesProtein(this.time, this.proteinAmount);
}
