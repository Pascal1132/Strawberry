import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/core/models/WSMessage.dart';
import 'package:strawberry/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:eventify/eventify.dart';

class WSManager extends EventEmitter {
  static const url = 'ws://localhost:8080';
  open() {
    final channel = WebSocketChannel.connect(
      Uri.parse(url),
    );

    /// Listen for all incoming data
    channel.stream.listen((data) {
      WSMessage message = WSMessage.fromJson(data);
      messageHandler(message);
      //print(message.data);
    }, onError: (error) {
      print('error: $error');
    }, onDone: () {
      // Set timer to retry in 5s
      print('Server closed connection retrying in 5s');
      eventBus
          .fire(WebSocketConnectionEvent('Unable to connect to server', false));
      Future.delayed(const Duration(seconds: 5), () {
        open();
      });
    });
  }

  messageHandler(WSMessage message) {
    switch (message.tag) {
      case 'cpuInfos':
        eventBus.fire(UpdatedCpuInfosEvent(message.data));
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
