import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/core/managers/WSManager.dart';
import 'package:strawberry/core/repositories/UserApiRepository.dart';
import 'package:strawberry/main.dart';
import 'package:strawberry/ui/components/graph.dart';
import 'package:strawberry/ui/layouts/default.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/tools/dimensions.dart';
import 'package:fl_chart/fl_chart.dart';

// To a stateful widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _cpuUsage = [0];
  List<dynamic> _cpuTemp = [0];
  List<FlSpot> _cpuUsageSpots = [];
  int _processes = 0;
  List<dynamic> _services = [];
  late Dimensions dimensions;
  // On init
  @override
  void initState() {
    _cpuUsageSpots = List.generate(30, (index) => FlSpot(index.toDouble(), 0));
    eventBus.on<UpdatedCpuInfosEvent>().listen((event) {
      setState(() {
        _cpuUsage = event.data['cpuUsage'];
        _cpuTemp = event.data['cpuTemp'];
        _processes = event.data['processes'];
        // Add the latest cpu usage to the list
        _cpuUsageSpots.add(FlSpot(
            _cpuUsageSpots.length.toDouble(), _cpuUsage.last.toDouble() * 100));
      });
    });
    eventBus.on<UpdatedServicesEvent>().listen((event) {
      setState(() {
        //_services = event.data;
        // before remove .service from the service name
        _services = event.data.map((e) {
          return {...e, 'name': e['name'].replaceAll('.service', '')};
        }).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    return DefaultLayout(
        child: Column(
      children: [
        createCard(
            'CPU',
            SingleChildScrollView(
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
                ))),
        createCard(
          'Services',
          Column(
            children: [
              for (var service in _services)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(service['name'],
                          overflow: TextOverflow.ellipsis,
                          style: StrawTheme.h4(context)),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        service['active'],
                        style: StrawTheme.h4(context).copyWith(
                            color: service['active'] == 'active'
                                ? StrawTheme.cSuccess
                                : StrawTheme.cError),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ],
    ));
  }

  createCard(title, child) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Card(
          color: StrawTheme.c4,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: dimensions.getVW(100, null, 600),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: StrawTheme.cText1, fontSize: 25)),
                    const SizedBox(height: 20),
                    child
                  ]),
            ),
          ),
        ));
  }

  Widget _graph(List<FlSpot> data, Dimensions dimensions) {
    return HomePageGraph(data: data, dimensions: dimensions);
  }
}
