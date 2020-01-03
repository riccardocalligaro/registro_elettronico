import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/bloc_delegate.dart';

import 'global/localizations/ui/locale_bloc_builder.dart';
import 'global/theme/ui/theme_bloc_builder.dart';

//This widget contains  init data, theme and locale manager and provides that data to child widget
class Application extends StatelessWidget {
  final Widget Function(BuildContext context, InitData initData) builder;

  Application({@required this.builder});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocDelegate.instance(context).blocProviders,
      child: LocaleBlocBuilder(
        builder: (lBBContext, locale, supportedLocales,
            localizationsDelegates, localeResolutionCallback) {
          return ThemeBlocBuilder(
            builder: (tBBContext, materialThemeData, cupertinoThemeData) {
              InitData initData = InitData(
                  materialThemeData,
                  cupertinoThemeData,
                  locale,
                  supportedLocales,
                  localizationsDelegates,
                  localeResolutionCallback);
              return builder(tBBContext, initData);
            },
          );
        },
      ),
    );
  }
}

class InitData {
  ThemeData materialThemeData;
  CupertinoThemeData cupertinoThemeData;
  Locale locale;
  List<Locale> supportedLocales;
  List<LocalizationsDelegate> localizationsDelegates;
  Function localeResolutionCallback;

  InitData(
      this.materialThemeData,
      this.cupertinoThemeData,
      this.locale,
      this.supportedLocales,
      this.localizationsDelegates,
      this.localeResolutionCallback);
}
