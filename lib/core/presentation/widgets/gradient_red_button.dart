import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/color_utils.dart';

class GradientRedButton extends StatefulWidget {
  final Widget center;
  final double height;
  final double width;
  final GestureTapCallback onTap;

  GradientRedButton({
    Key key,
    this.center,
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  _GradientRedButtonState createState() => _GradientRedButtonState();
}

class _GradientRedButtonState extends State<GradientRedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        padding: const EdgeInsets.all(0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      ),
      child: Container(
        width: widget.width ?? 220,
        height: widget.height ?? 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.6, 1],
            colors: ColorUtils.getGradientForColor(
                Theme.of(context).accentColor,
                button: true),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: widget.center ?? Container(),
      ),
    );
  }
}
