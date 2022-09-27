import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/core/managers/WSManager.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/views/home_page.dart';
import 'package:strawberry/ui/views/settings_page.dart';

import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

void main() {
  runApp(const Strawberry());
}

class Strawberry extends StatefulWidget {
  const Strawberry({super.key});

  @override
  State<Strawberry> createState() => _StrawberryState();
}

class _StrawberryState extends State<Strawberry> {
  late WSManager wsManager;

  @override
  void initState() {
    wsManager = WSManager();
    wsManager.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry',
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: generateRoutes(),
    );
  }
}

generateRoutes() {
  return {
    '/': (context) => const HomePage(),
    '/settings': (context) => const SettingsPage(),
  };
}
