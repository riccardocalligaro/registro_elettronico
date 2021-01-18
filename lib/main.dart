import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/application.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/feature/agenda/presentation/agenda_page.dart';
import 'package:registro_elettronico/feature/grades/presentation/grades_page.dart';
import 'package:registro_elettronico/feature/home/presentation/home_page.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/noticeboard_page.dart';
import 'package:registro_elettronico/feature/splash/presentation/splash_screen.dart';

import 'core/data/remote/api/dio_client.dart';
import 'core/infrastructure/log/logger.dart';
import 'core/infrastructure/log/logger_bloc.dart';
import 'core/infrastructure/notification/fcm_service.dart';
import 'core/infrastructure/routes.dart';

FlutterLocalNotificationsPlugin globalLocalNotifications;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  AppInjector.init();

  Bloc.observer = LoggerBlocDelegate();

  initApp();

  runZonedGuarded(() {
    runApp(SrApp());
  }, (e, s) {
    Logger.e(
      exception: Exception(e.toString()),
      stacktrace: s,
    );
    FirebaseCrashlytics.instance.recordError(e, s);
  });
}

void initApp() async {
  PushNotificationService pushNotificationService = sl();
  await pushNotificationService.initialise();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

class SrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      builder: (bCtx, initData) {
        return MaterialApp(
          navigatorKey: navigator,
          title: 'Registro elettronico',
          locale: initData.locale,
          theme: initData.materialThemeData,
          supportedLocales: initData.supportedLocales,
          localizationsDelegates: initData.localizationsDelegates,
          localeResolutionCallback: initData.localeResolutionCallback,
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          routes: Routes.routes,
          // home: NavigatorPage(),
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => SplashScreen());
          },
        );
      },
    );
  }
}

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  List<Widget> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      GradesPage(),
      AgendaPage(),
      NoticeboardPage(),
      Scaffold()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) {
        // Calls the api if needed
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          // title: Container(),
          label: '',

          icon: Icon(Icons.timeline),
        ),
        BottomNavigationBarItem(
          // title: Container(),
          label: '',
          icon: Icon(
            Icons.event,
            size: 26,
          ),
        ),
        BottomNavigationBarItem(
          // title: Container(),
          label: '',
          icon: Icon(
            Icons.assignment,
            size: 26,
          ),
        ),
        BottomNavigationBarItem(
          // title: Container(),
          label: '',
          icon: Icon(
            Icons.more_horiz,
            size: 26,
          ),
        ),
      ],
    );
  }
}
