import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/core/managers/PersistentStorageManager.dart';
import 'package:strawberry/core/models/WSMessage.dart';
import 'package:strawberry/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:eventify/eventify.dart';

class WSManager extends EventEmitter {
  static const throwBackUrl = 'ws://localhost:8080';
  List<StreamSubscription> subscriptions = [];
  String serverIp = throwBackUrl;
  open({fetchServerIp = true}) async {
    if (fetchServerIp) {
      serverIp = await PersistentStorageManager.get('serverIp') ?? throwBackUrl;
    }
    // remove all subscriptions
    for (var element in subscriptions) {
      element.cancel();
    }
    subscriptions = [];
    // if serverIp doesnt start with ws:// or wss:// then add it
    if (!serverIp.startsWith('ws://') && !serverIp.startsWith('wss://')) {
      serverIp = 'ws://$serverIp';
    }
    final channel = WebSocketChannel.connect(
      Uri.parse(serverIp),
    );

    // send dotenv.env['SERVER_RSA_PUB'] to server
    channel.sink.add(dotenv.env['SERVER_RSA_PUB']);

    /// Listen for all incoming data
    channel.stream.listen((data) {
      WSMessage message = WSMessage.fromJson(data);
      messageHandler(message);
      //print(message.data);
    }, onError: (error) {
      print('error: $error');
    }, onDone: () {
      print('Server closed connection retrying in 5s');
      eventBus
          .fire(WebSocketConnectionEvent('Unable to connect to server', false));
      Future.delayed(const Duration(seconds: 5), () {
        open(fetchServerIp: false);
      });
    });

    /// Send data to the server
    subscriptions.add(eventBus.on<WSSendMessage>().listen((event) {
      var data = {
        'tag': event.tag,
        'data': event.data,
      };
      channel.sink.add(jsonEncode(data).toString());
    }));

    subscriptions
        .add(eventBus.on<ServerAddressIpUpdatedEvent>().listen((event) async {
      serverIp = event.ip;
      await channel.sink.close();
    }));
  }

  messageHandler(WSMessage message) {
    switch (message.tag) {
      case 'cpuInfos':
        eventBus.fire(UpdatedCpuInfosEvent(message.data));
        break;
      case 'pm2Infos':
        eventBus.fire(UpdatedPm2InfosEvent(message.data));
        break;
      case 'services':
        eventBus.fire(UpdatedServicesEvent(message.data));
        break;
      case 'welcome':
        eventBus.fire(WebSocketConnectionEvent('Back online', true));
        break;
      default:
        print('Unknown message tag');
    }
  }
}
