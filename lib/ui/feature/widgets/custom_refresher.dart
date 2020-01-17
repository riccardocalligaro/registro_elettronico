import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefresher extends StatelessWidget {
  final Widget child;

  final VoidCallback onRefresh;

  const CustomRefresher({
    Key key,
    this.child,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: RefreshController(),
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        color: Colors.red,
      ),
      onRefresh: onRefresh,
      child: child,
    );
  }
}
