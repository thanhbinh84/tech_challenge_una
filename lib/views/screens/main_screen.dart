import 'package:tech_challenge/blocs/chart/chart_cubit.dart';
import 'package:tech_challenge/blocs/chart/chart_states.dart';
import 'package:tech_challenge/views/screens/spline_types.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tech_challenge/common/utils.dart';
import 'package:tech_challenge/data/models/period.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ChartCubit _chartCubit;

  @override
  void initState() {
    _chartCubit = BlocProvider.of<ChartCubit>(context);
    _getChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartCubit, ChartState>(
        listener: (context, state) {
          if (state is ChartFailure) Utils.errorToast(state.error);
        },
        child: Scaffold(
          body: _mainView(),
        ));
  }

  _mainView() =>
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_filterView(), const Divider(), Expanded(child: _chartView())]),
        ),
      );

  _filterView() {
    return BlocBuilder<ChartCubit, ChartState>(
        buildWhen: (previous, current) {
          return current is ChartLoadSuccess;
        },
        builder: (context, state) =>
        state is ChartLoadSuccess
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _startButton(state),
          _endButton(state),
        ],)
            : Container())
    ;
  }

  _chartView() {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return state is ChartLoadInProgress
            ? SpinKitWave(color: Theme
            .of(context)
            .primaryColor, size: 25.0)
            : state is ChartLoadSuccess
            ? SplineTypes(state.chartData, state.period)
            : Container();
      },
    );
  }

  _getChart({Period? period}) {
    _chartCubit.getChartData(period: period);
  }

  _startButton(ChartLoadSuccess state) {
    return ElevatedButton(
      onPressed: () => _selectStartDate(state.period),
      child: const Text('Start'),
    );
  }

  Future<void> _selectStartDate(Period period) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: period.start,
        lastDate: period.end, firstDate: Period.minDate);
    if (picked != null && picked != period.start) {
      period.start = picked;
      _getChart(period: period);
    }
  }

  _endButton(ChartLoadSuccess state) {
    return ElevatedButton(
      onPressed: () => _selectEndDate(state.period),
      child: const Text('End'),
    );
  }

  Future<void> _selectEndDate(Period period) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: period.end,
        lastDate: Period.maxDate, firstDate: period.start);
    if (picked != null && picked != period.end) {
      period.end = picked;
      _getChart(period: period);
    }
  }
}
