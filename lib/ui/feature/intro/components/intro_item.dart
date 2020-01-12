import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';

class IntroItem extends StatelessWidget {
  final String title;
  final Widget centerWidget;
  final String description;
  final double dy;
  final List<Widget> additionalWidgets;

  const IntroItem(
      {Key key,
      @required this.title,
      @required this.centerWidget,
      @required this.description,
      this.dy,
      this.additionalWidgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          AlignPositioned(
            dy: 100,
            alignment: Alignment.topCenter,
            child: Text(
              title ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
          AlignPositioned(
            child: centerWidget,
          ),
          AlignPositioned(
            alignment: Alignment.bottomCenter,
            dy: dy ?? -70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]..addAll(additionalWidgets ?? [])
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: <Widget>[
      //     Text(
      //       title ?? '',
      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      //     ),
      //     SizedBox(
      //       height: 150,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //       child: Text(
      //         description,
      //         style: TextStyle(fontSize: 18),
      //         textAlign: TextAlign.center,
      //       ),
      //     ),
      //     SizedBox(
      //       height: 50,
      //     ),
      //   ]..addAll(additionalWidgets ?? []),
      // ),
      // child: Container(
      //   padding: EdgeInsets.all(16.0),
      //   child: Stack(
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.only(top: 100),
      //         child: Align(
      //           alignment: Alignment.topCenter,
      //           child: Text(
      //             title ?? '',
      //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      //           ),
      //         ),
      //       ),
      //       Align(
      //         alignment: Alignment.center,
      //         child: centerWidget,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
      //         child: Align(
      //           alignment: Alignment.bottomCenter,
      //           child: Text(
      //             description,
      //             style: TextStyle(fontSize: 18),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //       ),
      //     ]..addAll(additionalWidgets ?? []),
      //   ),
      // ),
    );
  }
}
