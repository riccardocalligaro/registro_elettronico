import 'package:flutter/material.dart';

class GradesLoading extends StatelessWidget {
  const GradesLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: List.generate(
        4,
        (index) => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
