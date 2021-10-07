import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetable/timetable.dart';

import '../bloc/bloc.dart';
import '../localizations_delegates.dart';

class LocaleBlocBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    Locale locale,
    List<Locale>? supportedLocales,
    List<LocalizationsDelegate>? localizationsDelegates,
    Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback,
  ) builder;

  LocaleBlocBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocalizationsBloc>(
      create: (BuildContext context) => LocalizationsBloc.instance!,
      child: BlocBuilder<LocalizationsBloc, LocalizationsState>(
        builder: (bCtx, localeState) {
          return builder(
            bCtx,
            localeState.locale,
            LocalizationsDelegates.instance!.supportedLocales,
            LocalizationsDelegates.instance!.localizationsDelegates,
            LocalizationsDelegates.instance!.localeResolutionCallback,
          );
        },
      ),
    );
  }
}
