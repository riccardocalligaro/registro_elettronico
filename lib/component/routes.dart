import 'package:registro_elettronico/ui/feature/home/home_page.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splash_screen.dart';

class Routes {
  static const MAIN = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';

  static var routes = {
    MAIN: (ctx) => SplashScreen(),
    LOGIN: (ctx) => LoginPage(),
    HOME: (ctx) => HomePage()
  };
}
