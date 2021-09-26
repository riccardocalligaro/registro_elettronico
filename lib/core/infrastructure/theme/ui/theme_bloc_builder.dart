import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class ThemeBlocBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ThemeData themeData,
      CupertinoThemeData? cupertinoThemeData) builder;

  ThemeBlocBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (BuildContext context) => ThemeBloc.instance!,
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: (ctx, themeState) {
        return builder(
          context,
          themeState.materialThemeData,
          null,
        );
      }),
    );
  }
}
