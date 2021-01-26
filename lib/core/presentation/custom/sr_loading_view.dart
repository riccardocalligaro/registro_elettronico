import 'package:flutter/material.dart';

class SRLoadingView extends StatelessWidget {
  const SRLoadingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
