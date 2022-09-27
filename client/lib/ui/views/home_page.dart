import 'package:flutter/material.dart';
import 'package:strawberry/core/managers/PersistentStorageManager.dart';
import 'package:strawberry/ui/components/button.dart';
import 'package:strawberry/ui/components/cards/cpu.dart';
import 'package:strawberry/ui/components/cards/pm2.dart';
import 'package:strawberry/ui/layouts/default.dart';
import 'package:strawberry/ui/tools/dimensions.dart';

// To a stateful widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const Map<String, dynamic> cards = {
    'CPU': CPUCard(key: Key('CPU')),
    'PM2': PM2Card(key: Key('PM2')),
  };

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Dimensions dimensions;
  List<dynamic> cardPicked = [];
  // On init
  @override
  void initState() {
    PersistentStorageManager.get('cardPicked').then((value) {
      if (value != null) {
        // Value is a string and we need to convert it to a list
        List<dynamic> val = value.split(',');
        // Foreach val get the card with the key
        for (var element in val) {
          if (HomePage.cards.containsKey(element)) {
            cardPicked.add(HomePage.cards[element]);
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    return DefaultLayout(
        rightWidget: Button(
          text: null,
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
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
        child: Column(
          children: [
            ...cardPicked,
            Button(
                text: 'Add a card ',
                icon: const Icon(Icons.library_add_rounded),
                onPressed: () {
                  // Alert dialog
                  createPopupAddCard();
                }),
          ],
        ));
  }

  createPopupAddCard() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a card'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose a card to add'),
                const SizedBox(height: 10),
                // List of cards
                for (var card in HomePage.cards.entries)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Button(
                        text: card.key,
                        onPressed: () => onAddCardBtnPressed(card)),
                  ),
              ],
            ),
          );
        });
  }

  // Add a card
  onAddCardBtnPressed(dynamic card) {
    setState(() {
      // if card already in cardPicked
      if (cardPicked.any((element) => element.key.value == card.key)) {
        // remove it
        cardPicked.removeWhere((element) => element.key.value == card.key);
      } else {
        cardPicked.add(card.value);
      }
      List list = cardPicked.map((e) => e.key.value).toList();
      if (list.length > 0) {
        PersistentStorageManager.set('cardPicked', list.join(','));
      } else {
        PersistentStorageManager.set('cardPicked', '');
      }
      //PersistentStorageManager.set('cardPicked', list.join(','));
    });
  }
}
