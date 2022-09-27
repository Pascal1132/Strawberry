import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/main.dart';
import 'package:strawberry/ui/components/button.dart';
import 'package:strawberry/ui/components/card.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/tools/dimensions.dart';

// To a stateful widget
class PM2Card extends StatefulWidget {
  const PM2Card({super.key});

  @override
  State<PM2Card> createState() => _PM2CardState();
}

class _PM2CardState extends State<PM2Card> {
  late Dimensions dimensions;
  late StreamSubscription _pm2InfosSubscription;
  List<dynamic> _pm2Infos = [];
  int currentProcessToShow = -1;
  // On init
  @override
  void initState() {
    StreamSubscription sub =
        eventBus.on<UpdatedPm2InfosEvent>().listen((event) {
      if (!mounted) {
        deactivate();
        return;
      }
      setState(() {
        _pm2Infos = event.data;
      });
    });
    setState(() {
      _pm2InfosSubscription = sub;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    return StCard(
      title: 'PM2',
      dimensions: dimensions,
      child: SizedBox(
        width: dimensions.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (currentProcessToShow == -1
              ? [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button(
                          text: 'Save',
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(StrawTheme.c0),
                            foregroundColor:
                                MaterialStateProperty.all(StrawTheme.c5),
                          ),
                          icon: const Icon(Icons.save),
                          onPressed: () {
                            showAreYouSureDialog(
                              context,
                              'Are you sure you want to save the current state?',
                              () {
                                eventBus.fire(SavePm2Event());
                              },
                            );
                          },
                        ),
                        Button(
                          text: 'Resurrect',
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(StrawTheme.c0),
                            foregroundColor:
                                MaterialStateProperty.all(StrawTheme.c5),
                          ),
                          icon: const Icon(Icons.restore),
                          onPressed: () {
                            // Are you sure you want to restore to the last saved state?
                            showAreYouSureDialog(
                              context,
                              'Are you sure you want to restore to the last saved state?',
                              () {
                                eventBus.fire(ResurrectPm2Event());
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Name (ID)',
                          style:
                              TextStyle(fontSize: 15, color: StrawTheme.cText1),
                        ),
                        Text(
                          'Status',
                          style:
                              TextStyle(fontSize: 15, color: StrawTheme.cText1),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    padding: const EdgeInsets.all(5),
                    shrinkWrap: true,
                    itemCount: _pm2Infos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () => {onProcessPressed(index)},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(StrawTheme.c5),
                          elevation: MaterialStateProperty.all(2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: const StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 15, color: StrawTheme.c0),
                                      text:
                                          '${_pm2Infos[index]['name']} (${_pm2Infos[index]['pid']})'),
                                ),
                              ),
                              Text(
                                '${_pm2Infos[index]['status']}',
                                style: const TextStyle(
                                    fontSize: 15, color: StrawTheme.c0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  )
                ]
              : [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(StrawTheme.c0),
                          foregroundColor:
                              MaterialStateProperty.all(StrawTheme.c5),
                        ),
                        text: null,
                        iconLeft: true,
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => {onBackToListPressed()},
                      ),
                      Row(children: [
                        Button(
                          secondary: true,
                          text: null,
                          iconLeft: false,
                          icon: const Icon(Icons.restart_alt,
                              color: StrawTheme.cSuccess),
                          onPressed: () => {onRestartPressed()},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(StrawTheme.c5),
                            elevation: MaterialStateProperty.all(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Button(
                          secondary: true,
                          text: null,
                          iconLeft: false,
                          icon: const Icon(Icons.delete,
                              color: StrawTheme.cError),
                          onPressed: () => {onDeletePressed()},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(StrawTheme.c5),
                            elevation: MaterialStateProperty.all(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Stop / Start button
                        Button(
                          secondary: true,
                          text: null,
                          iconLeft: false,
                          icon: Icon(
                            _pm2Infos[currentProcessToShow]['status'] ==
                                    'online'
                                ? Icons.stop
                                : Icons.play_arrow,
                            color: _pm2Infos[currentProcessToShow]['status'] ==
                                    'online'
                                ? StrawTheme.cError
                                : StrawTheme.cSuccess,
                          ),
                          onPressed: () => {
                            _pm2Infos[currentProcessToShow]['status'] ==
                                    'online'
                                ? onStopPressed()
                                : onStartPressed()
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(StrawTheme.c5),
                            elevation: MaterialStateProperty.all(2),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Name: ${_pm2Infos[currentProcessToShow]['name']}',
                      style: StrawTheme.t1),
                  const SizedBox(height: 5),
                  Text('Status: ${_pm2Infos[currentProcessToShow]['status']}',
                      style: StrawTheme.t1),
                  const SizedBox(height: 5),
                  Text(
                      'Instances: ${_pm2Infos[currentProcessToShow]['instances']}',
                      style: StrawTheme.t1),
                  const SizedBox(height: 5),
                  Text(
                      'CPU: ${_pm2Infos[currentProcessToShow]['monit']['cpu']} %',
                      style: StrawTheme.t1),
                  const SizedBox(height: 5),
                  Text(
                      'Memory: ${_pm2Infos[currentProcessToShow]['monit']['memory']} MB',
                      style: StrawTheme.t1),
                ]),
        ),
      ),
    );
  }

  onProcessPressed(int index) {
    setState(() {
      currentProcessToShow = index;
    });
  }

  onBackToListPressed() {
    setState(() {
      currentProcessToShow = -1;
    });
  }

  showAreYouSureDialog(
      BuildContext context, String text, Function onYesPressed) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: Text(text),
            actions: [
              Button(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Cancel',
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(StrawTheme.c5),
                  foregroundColor:
                      MaterialStateProperty.all(StrawTheme.cSuccess),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Button(
                onPressed: () {
                  Navigator.of(context).pop();
                  onYesPressed();
                },
                text: 'Yes',
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(StrawTheme.c0),
                  foregroundColor: MaterialStateProperty.all(StrawTheme.c5),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  onRestartPressed() {
    eventBus.fire(RestartPm2ProcessEvent(
        _pm2Infos[currentProcessToShow]['name'].toString()));
  }

  onDeletePressed() {
    showAreYouSureDialog(context,
        'Are you sure you want to delete ${_pm2Infos[currentProcessToShow]['name']}?',
        () {
      eventBus.fire(DeletePm2ProcessEvent(
          _pm2Infos[currentProcessToShow]['name'].toString()));
      setState(() {
        currentProcessToShow = -1;
      });
    });
  }

  onStopPressed() {
    showAreYouSureDialog(context,
        'Are you sure you want to stop ${_pm2Infos[currentProcessToShow]['name']}?',
        () {
      eventBus.fire(StopPm2ProcessEvent(
          _pm2Infos[currentProcessToShow]['name'].toString()));
    });
  }

  onStartPressed() {
    eventBus.fire(StartPm2ProcessEvent(
        _pm2Infos[currentProcessToShow]['name'].toString()));
  }

  @override
  void deactivate() {
    _pm2InfosSubscription.cancel();
    super.deactivate();
  }
}
