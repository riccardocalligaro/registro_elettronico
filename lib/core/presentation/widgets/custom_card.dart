import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final GestureTapCallback onTap;
  final Color color;

  const CustomCard({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 15.0),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
