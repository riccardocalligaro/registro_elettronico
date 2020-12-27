import 'package:registro_elettronico/feature/absences/presentation/absences_page.dart';
import 'package:registro_elettronico/ui/feature/agenda/agenda_page.dart';
import 'package:registro_elettronico/feature/grades/presentation/grades_page.dart';
import 'package:registro_elettronico/ui/feature/home/home_page.dart';
import 'package:registro_elettronico/ui/feature/intro/intro_slideshow_page.dart';
import 'package:registro_elettronico/ui/feature/lessons/lessons_page.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';
import 'package:registro_elettronico/ui/feature/notes/notes_page.dart';
import 'package:registro_elettronico/ui/feature/noticeboard/noticeboard_page.dart';
import 'package:registro_elettronico/ui/feature/school_material/school_material_page.dart';
import 'package:registro_elettronico/ui/feature/scrutini/scrutini_page.dart';
import 'package:registro_elettronico/ui/feature/settings/settings_page.dart';
import 'package:registro_elettronico/ui/feature/splash_screen/splash_screen.dart';
import 'package:registro_elettronico/ui/feature/stats/stats_page.dart';
import 'package:registro_elettronico/ui/feature/timetable/timetable_page.dart';

class Routes {
  static const MAIN = '/';
  static const INTRO = '/intro';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const LESSONS = '/lessons';
  static const GRADES = '/grades';
  static const AGENDA = '/agenda';
  static const ABSENCES = '/absences';
  static const SCHOOL_MATERIAL = '/school-material';
  static const NOTES = '/notes';
  static const NOTICEBOARD = '/noticeboard';
  static const TIMETABLE = '/timetable';
  static const SCRUTINI = '/scrutini';
  static const STATS = '/stats';
  static const WEB_VIEW = '/web-view';
  static const SETTINGS = '/settings';

  static var routes = {
    MAIN: (ctx) => SplashScreen(),
    INTRO: (ctx) => IntroSlideshowPage(),
    LOGIN: (ctx) => LoginPage(),
    HOME: (ctx) => HomePage(),
    LESSONS: (ctx) => LessonsPage(),
    GRADES: (ctx) => GradesPage(),
    AGENDA: (ctx) => AgendaPage(),
    //NEXT_TESTS: (ctx) => NextTestsPage(),
    ABSENCES: (ctx) => AbsencesPage(),
    NOTES: (ctx) => NotesPage(),
    SCHOOL_MATERIAL: (ctx) => SchoolMaterialPage(),
    NOTICEBOARD: (ctx) => NoticeboardPage(),
    TIMETABLE: (ctx) => TimetablePage(),
    SCRUTINI: (ctx) => ScrutiniPage(),
    STATS: (ctx) => StatsPage(),
    SETTINGS: (ctx) => SettingsPage()
  };
}
