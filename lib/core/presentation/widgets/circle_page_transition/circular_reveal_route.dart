import 'package:flutter/material.dart';

/// Since the clipper is not exported from circular_reveal_animation package
/// You will need to get that separately.
import 'circular_reveal_clipper.dart';

class CircularRevealRoute extends PageRouteBuilder {
  final Widget page;
  final AlignmentGeometry centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;

  /// Reveals the next item pushed to the navigation using circle shape.
  ///
  /// You can provide [centerAlignment] for the reveal center or if you want a
  /// more precise use only [centerOffset] and leave other blank.
  ///
  /// The transition doesn't affect the entry screen so we will only touch
  /// the target screen.
  CircularRevealRoute({
    @required this.page,
    this.minRadius = 0,
    @required this.maxRadius,
    this.centerAlignment,
    this.centerOffset,
  })  : assert(centerOffset != null || centerAlignment != null),
        super(
          /// We could override pageBuilder but it's a required parameter of
          /// [PageRouteBuilder] and it won't build unless it's provided.
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return page;
          },
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: animation.value,
        centerAlignment: centerAlignment,
        centerOffset: centerOffset,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
      child: child,
    );
  }
}
