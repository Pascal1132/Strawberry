import 'package:flutter/material.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/tools/dimensions.dart';

class StCard extends StatelessWidget {
  final Widget child;
  final String title;
  final Dimensions dimensions;

  const StCard(
      {Key? key,
      required this.child,
      required this.title,
      required this.dimensions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Card(
          color: StrawTheme.c4,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
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
}
