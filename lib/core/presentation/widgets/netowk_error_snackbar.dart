import 'package:flutter/material.dart';

class NetworkErrorSnackbar extends StatelessWidget {
  const NetworkErrorSnackbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Not connected'),
    );
  }
}
