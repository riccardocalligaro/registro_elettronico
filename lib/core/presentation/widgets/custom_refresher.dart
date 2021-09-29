import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/utils/color_utils.dart';

class CustomRefresher extends StatelessWidget {
  final Widget? child;

  final VoidCallback? onRefresh;

  final RefreshController? controller;

  const CustomRefresher({
    Key? key,
    this.child,
    this.onRefresh,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller ?? RefreshController(),
      header: WaterDropMaterialHeader(
        backgroundColor: ColorUtils.getDropHeaderColor(context),
        color: Theme.of(context).colorScheme.secondary,
      ),
      onRefresh: onRefresh,
      child: child,
    );
  }
}
