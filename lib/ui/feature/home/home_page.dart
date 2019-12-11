import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/lessons_repository_impl.dart';
import 'package:registro_elettronico/data/repository/subjects_resposiotry_impl.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_event.dart';
import 'package:registro_elettronico/ui/feature/home/components/lesson_card.dart';
import 'package:registro_elettronico/ui/feature/home/components/subjects_grid.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

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
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
      ),
      body: BlocListener<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state is LessonsLoading) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Loading new data...'),
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
                  label: 'Log out',
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
                  label: 'Log out',
                  onPressed: () {
                    AppNavigator.instance.navToLogin(context);
                    BlocProvider.of<AuthBloc>(context).add(SignOut());
                  },
                ),
              ));
            }
          }
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _drawerKey.currentState.openDrawer();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        trans.translate('last_lessons'),
                        style: Theme.of(context).textTheme.headline,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: Text(
                            "View all",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                  child: Container(
                    height: 140,
                    child: _buildLessonsCards(context),
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
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
                            trans.translate("notice_board"),
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
                        color: Theme.of(context).primaryColor,
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
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                  child: _buildSubjectsGrid(context),
                ),
                RaisedButton(
                  child: Text('Request lessons'),
                  onPressed: () async {
                    try {
                      BlocProvider.of<LessonsBloc>(context).add(FetchLessons());
                    } catch (e) {
                      print("Already inserted!");
                    }
                  },
                ),
                RaisedButton(
                  child: Text("Delete"),
                  onPressed: () {
                    final lessonDao =
                        LessonDao(Injector.appInstance.getDependency());
                    lessonDao.deleteLessons();
                  },
                ),

                RaisedButton(
                  child: Text('Get subjects'),
                  onPressed: () async {
                    final SubjectsRepositoryImpl subjectsRepositoryImpl =
                        SubjectsRepositoryImpl(
                            Injector.appInstance.getDependency(),
                            Injector.appInstance.getDependency(),
                            Injector.appInstance.getDependency(),
                            Injector.appInstance.getDependency());

                    subjectsRepositoryImpl.updateSubjects("6102171");
                  },
                ),

                // Expanded(child: _buildTaskList(context))
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subject>> _buildSubjectsGrid(BuildContext context) {
    return StreamBuilder(
      stream:
          SubjectDao(Injector.appInstance.getDependency()).watchAllSubjects(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Subject> subjects = snapshot.data ?? List();

        return SubjectsGrid(
          subjects: subjects,
        );
      },
    );
  }

  StreamBuilder<List<Lesson>> _buildLessonsCards(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<LessonsBloc>(context).lessons,
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Lesson> lessons = snapshot.data ?? List();
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lessons.length,
          itemBuilder: (_, index) {
            final lesson = lessons[index];
            return LessonCard(
              color: Colors.red,
              lesson: lesson,
            );
          },
        );
      },
    );
  }
}
