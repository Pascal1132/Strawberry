import 'package:flutter/material.dart';

class StCard {
  static createFromChild() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.album, size: 45),
            title: Text('Sonu Nigam'),
            subtitle: Text('Best of Sonu Nigam Song'),
          ),
        ],
      ),
    );
  }
}
