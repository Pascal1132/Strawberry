import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/main.dart';
import 'package:strawberry/ui/components/card.dart';
import 'package:strawberry/ui/components/graph.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/tools/dimensions.dart';
import 'package:fl_chart/fl_chart.dart';

// To a stateful widget
class CPUCard extends StatefulWidget {
  const CPUCard({super.key});

  @override
  State<CPUCard> createState() => _CPUCardState();
}

class _CPUCardState extends State<CPUCard> {
  List<dynamic> _cpuUsage = [0];
  List<dynamic> _cpuTemp = [0];
  List<FlSpot> _cpuUsageSpots = [];
  int _processes = 0;
  late StreamSubscription _cpuUsageSubscription;
  late Dimensions dimensions;
  // On init
  @override
  void initState() {
    _cpuUsageSpots = List.generate(30, (index) => FlSpot(index.toDouble(), 0));
    StreamSubscription sub =
        eventBus.on<UpdatedCpuInfosEvent>().listen((event) {
      if (!mounted) {
        deactivate();
        return;
      }
      setState(() {
        _cpuUsage = event.data['cpuUsage'];
        _cpuTemp = event.data['cpuTemp'];
        _processes = event.data['processes'];

        _cpuUsageSpots.add(FlSpot(
            _cpuUsageSpots.length.toDouble(), _cpuUsage.last.toDouble() * 100));
      });
    });
    setState(() {
      _cpuUsageSubscription = sub;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    return StCard(
        title: 'CPU',
        dimensions: dimensions,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: dimensions.getVW(20, 70, 150),
                  height: dimensions.getVW(20, 70, 150),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: StrawTheme.c5),
                  child: _graph(_cpuUsageSpots, dimensions),
                ),
                SizedBox(width: dimensions.getVW(05, 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Processes : $_processes',
                        style: StrawTheme.h4(context)),
                    Text(
                        'Temperature : ${_cpuTemp[_cpuTemp.length - 1] ?? 0}⁰C',
                        style: StrawTheme.h4(context)),
                    Text(
                        'Usage : ${((_cpuUsage[_cpuUsage.length - 1] ?? 0) * 100).round()}%',
                        style: StrawTheme.h4(context)),
                  ],
                )
              ],
            )));

    // On dispose, remove the listener from the event bus
    // ignore: dead_code
    @override
    void deactivate() {
      super.deactivate();
      setState(() {
        _cpuUsageSubscription.cancel();
      });
    }
  }

  Widget _graph(List<FlSpot> data, Dimensions dimensions) {
    return Graph(data: data, dimensions: dimensions);
  }
}
