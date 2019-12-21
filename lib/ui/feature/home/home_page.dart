import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/section_header.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

import 'components/event_card.dart';
import 'components/lesson_card.dart';
import 'components/subjects_grid.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppLocalizations trans = AppLocalizations.of(context);

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        title: 'Home page',
        scaffoldKey: _drawerKey,
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.HOME,
      ),
      body: BlocListener<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state is LessonsLoading) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(trans.translate('loading_new_data')),
              duration: Duration(seconds: 3),
            ));
          }

          if (state is LessonsError) {
            if (state.error.response.statusCode == 422) {
              final exception =
                  ServerException.fromJson(state.error.response.data);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(exception.message),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: trans.translate('log_out'),
                  onPressed: () {
                    AppNavigator.instance.navToLogin(context);
                    BlocProvider.of<AuthBloc>(context).add(SignOut());
                  },
                ),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.error.error.toString()),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).translate('log_out'),
                  onPressed: () {
                    AppNavigator.instance.navToLogin(context);
                    BlocProvider.of<AuthBloc>(context).add(SignOut());
                  },
                ),
              ));
            }
          }
        },
        child: RefreshIndicator(
          onRefresh: _test,
          child: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                child: RefreshIndicator(
                  onRefresh: _test,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SectionHeader(
                        headingText: trans.translate('last_lessons'),
                        onTap: () {
                          AppNavigator.instance.navToLessons(context);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                        child: Container(
                          height: 140,
                          child: _buildLessonsCards(context),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('notice_board'),
                                  style: Theme.of(context).textTheme.headline,
                                ),
                                Text(
                                  trans.translate("discover_all_notice"),
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 14),
                                )
                              ],
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                trans.translate("view"),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[300]),
                      SectionHeader(
                        headingText: AppLocalizations.of(context)
                            .translate('next_events'),
                        onTap: () {
                          AppNavigator.instance.navToAgenda(context);
                        },
                      ),
                      _buildAgenda(context),
                      Divider(color: Colors.grey[300]),
                      SectionHeader(
                        headingText: AppLocalizations.of(context)
                            .translate('my_subjects'),
                        onTap: () {},
                      ),
                      _buildSubjectsGrid(context),
                      Divider(color: Colors.grey[300]),
                      SectionHeader(
                        headingText: AppLocalizations.of(context)
                            .translate('last_grades'),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildLastGrades(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _test() async {
    await Future.delayed(Duration(seconds: 1));
  }

  StreamBuilder<List<Grade>> _buildLastGrades(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<GradesBloc>(context).watchNumberOfGradesByDate(),
      initialData: List<Grade>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Grade> grades =
            snapshot.data.toSet().toList() ?? List<Grade>();

        if (grades.length > 0) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: grades.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GradeCard(
                  grade: grades[index],
                ),
              );
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Icon(
                Icons.timeline,
                size: 80,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  StreamBuilder<List<db.AgendaEvent>> _buildAgenda(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<AgendaBloc>(context).watchAllEvents(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<db.AgendaEvent> events =
            snapshot.data.toSet().toList() ?? List();
        if (events.length == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(AppLocalizations.of(context).translate('free_to_go')),
            ),
          );
        } else {
          return Container(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                //final db.AgendaEvent event = events[index];

                return AgendaCardEvent(
                  agendaEvent: events[index],
                );
              },
            ),
          );
        }
      },
    );
  }

  StreamBuilder<List<Subject>> _buildSubjectsGrid(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<SubjectsBloc>(context).subjects,
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Subject> subjects = snapshot.data ?? List();
        return StreamBuilder(
          stream: BlocProvider.of<GradesBloc>(context).watchAllGrades(),
          initialData: List<Grade>(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final List<Grade> grades = snapshot.data ?? List<Grade>();
            if (subjects.length == 0) {
              return Center(
                  child: Icon(
                Icons.assessment,
                size: 80,
                color: Colors.grey,
              ));
            }
            return SubjectsGrid(
              subjects: GlobalUtils.removeUnwantedSubject(subjects),
              grades: grades,
            );
          },
        );
      },
    );
  }

  StreamBuilder<List<Lesson>> _buildLessonsCards(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<LessonsBloc>(context).relevandLessonsOfToday(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Lesson> lessons = snapshot.data ?? List();
        if (lessons.length == 0) {
          // todo: maybe a better placeholder?
          return Center(
            child: Text(
                '${AppLocalizations.of(context).translate('nothing_here')}'),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessons.length,
            itemBuilder: (_, index) {
              final lesson = lessons[index];
              return LessonCard(
                position: index,
                lesson: lesson,
              );
            },
          );
        }
      },
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
