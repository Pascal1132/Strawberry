import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/main.dart';
import 'package:strawberry/ui/straw_theme.dart';

// Transform to Stateful Widget
class DefaultLayout extends StatefulWidget {
  final Widget rightWidget;
  final Widget? leftWidget;
  final String title;

  const DefaultLayout(
      {super.key,
      required this.child,
      this.rightWidget = const SizedBox(),
      this.leftWidget,
      this.title = 'Strawberry'});

  final Widget child;

  @override
  _DefaultLayoutState createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  bool _connected = false;
  late StreamSubscription _connectionSubscription;
  @override
  void initState() {
    _connectionSubscription =
        eventBus.on<WebSocketConnectionEvent>().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        // if the state changes, display a toast
        if (event.success != _connected) {
          _connected = event.success;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StrawTheme.c5,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [generateTopBar(context), widget.child],
          ),
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          height: 50,
          color: StrawTheme.c5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Strawberry',
                style: TextStyle(color: StrawTheme.c0),
              ),
              Text(
                ' - v0.1.0',
                style: TextStyle(color: StrawTheme.c0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  generateTopBar(BuildContext ctx) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: const BoxDecoration(
                color: StrawTheme.c4,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    widget.leftWidget ??
                        Icon(
                          (_connected
                              ? Icons.signal_cellular_alt
                              : Icons
                                  .signal_cellular_connected_no_internet_4_bar),
                          color: (_connected ? Colors.green : Colors.red),
                          size: 30.0,
                        ),
                    const SizedBox(width: 5),
                    Text(
                      widget.title,
                      style:
                          const TextStyle(color: StrawTheme.c0, fontSize: 25),
                    ),
                  ]),
                  widget.rightWidget
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
