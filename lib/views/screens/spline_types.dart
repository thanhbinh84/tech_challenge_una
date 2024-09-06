import 'package:flutter/material.dart';
import 'package:tech_challenge/data/models/chart_data.dart';
import 'package:tech_challenge/data/models/period.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SplineTypes extends StatefulWidget {
  final List<ChartData> chartData;
  final Period period;

  const SplineTypes(this.chartData, this.period, {super.key});

  @override
  _SplineTypesState createState() => _SplineTypesState();
}

class _SplineTypesState extends State<SplineTypes> {
  _SplineTypesState();

  late SplineType _spline;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _spline = SplineType.natural;
    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTypesSplineChart();
  }

  /// Returns the spline types chart.
  SfCartesianChart _buildTypesSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat('d MMM'),
        intervalType: DateTimeIntervalType.days,
      ),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getSplineTypesSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<ChartData, DateTime>> _getSplineTypesSeries() {
    return <SplineSeries<ChartData, DateTime>>[
      SplineSeries<ChartData, DateTime>(
          splineType: _spline,
          dataSource: widget.chartData,
          xValueMapper: (ChartData sales, _) => sales.timestamp,
          yValueMapper: (ChartData sales, _) => sales.value,
          width: 2)
    ];
  }
}
