import 'package:flutter/material.dart';
import 'package:strawberry/ui/straw_theme.dart';

class DefaultLayout extends StatelessWidget {
  const DefaultLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: StrawTheme.c5,
        body: Column(
          children: [generateTopBar(context), child],
        ));
  }

  generateTopBar(BuildContext ctx) {
    return const Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: StrawTheme.c4,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'STRAWBERRY',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: StrawTheme.cText1),
              ),
            ),
          ),
        ));
  }
}
