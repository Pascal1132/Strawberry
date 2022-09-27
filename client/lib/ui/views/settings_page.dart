import 'package:flutter/material.dart';
import 'package:strawberry/core/events/WebSocketEvents.dart';
import 'package:strawberry/core/managers/PersistentStorageManager.dart';
import 'package:strawberry/main.dart';
import 'package:strawberry/ui/components/button.dart';
import 'package:strawberry/ui/layouts/default.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/tools/dimensions.dart';

// To a stateful widget
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Dimensions dimensions;
  TextEditingController serverIp = TextEditingController();
  // On init
  @override
  void initState() {
    PersistentStorageManager.get('serverIp').then((value) {
      setState(() {
        serverIp.text = value ?? 'localhost:8080';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    return DefaultLayout(
      title: 'Settings',
      leftWidget: Button(
        text: null,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Input text field for the server address
            DecoratedBox(
              decoration: const BoxDecoration(
                color: StrawTheme.c4,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: TextField(
                controller: serverIp,
                style: const TextStyle(
                    color: StrawTheme.cText1, fontSize: 20, height: 1.5),
                decoration: const InputDecoration(
                    fillColor: StrawTheme.c0,
                    labelText: 'Server address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    // font size of 15 and color of c0 for the value of the text field
                    labelStyle: TextStyle(color: StrawTheme.c0)),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Button(
                text: 'Save',
                icon: const Icon(
                  Icons.save,
                  color: StrawTheme.c2,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(StrawTheme.c4),
                  foregroundColor: MaterialStateProperty.all(StrawTheme.c2),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                ),
                onPressed: () async {
                  PersistentStorageManager.set('serverIp', serverIp.text);
                  eventBus.fire(ServerAddressIpUpdatedEvent(serverIp.text));
                })
          ],
        ),
      ),
    );
  }
}
