import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strawberry/ui/straw_theme.dart';

class Button extends StatefulWidget {
  final String? text;
  final Function() onPressed;
  final bool disabled;
  final bool secondary;
  final Icon? icon;
  final bool iconLeft;
  final ButtonStyle? style;

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.secondary = false,
    this.iconLeft = false,
    this.style,
    this.icon,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.disabled ? null : widget.onPressed,
      style: widget.style ??
          ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                widget.secondary ? StrawTheme.bgBtnC2 : StrawTheme.bgBtnC1),
            foregroundColor: MaterialStateProperty.all(
                widget.secondary ? StrawTheme.fgBtnC2 : StrawTheme.fgBtnC1),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: (widget.text == null
            ? (widget.icon ?? Container())
            : Row(mainAxisSize: MainAxisSize.min, children: [
                widget.iconLeft ? (widget.icon ?? Container()) : Container(),
                const SizedBox(width: 5),
                Text(widget.text ?? ''),
                const SizedBox(width: 5),
                widget.iconLeft ? Container() : (widget.icon ?? Container())
              ])),
      ),
    );
  }
}
