import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:registro_elettronico/core/infrastructure/theme/bloc/bloc.dart';

class ColorSettingsDialog extends StatelessWidget {
  const ColorSettingsDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> _colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlockPicker(
        pickerColor: Theme.of(context).accentColor,
        availableColors: _colors,
        onColorChanged: (color) {
          Navigator.of(context).pop();
          BlocProvider.of<ThemeBloc>(context)
              .add(ThemeChanged(theme: null, color: color));
        },
        itemBuilder: (color, isCurrentColor, changeColor) {
          return Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: color,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: changeColor,
                borderRadius: BorderRadius.circular(50.0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 210),
                  opacity: isCurrentColor ? 1.0 : 0.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
