import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/lessons_repository_impl.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_event.dart';
import 'package:registro_elettronico/ui/feature/home/components/lesson_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

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
      drawer: AppDrawer(),
      body: BlocListener<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state is LessonsLoading) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Loading new data...'),
              duration: Duration(seconds: 3),
            ));
          }
        },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        trans.translate('last_lessons'),
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 16.0),
                child: Container(
                  height: 140,
                  child: _buildLessonsCards(context),
                ),
              ),
              Divider(
                color: Colors.grey[400],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 14),
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
                      onPressed: () async {
                        final client = SpaggiariClient(
                            Injector.appInstance.getDependency());
                        final res = await client.getTodayLessons("6102171");
                        print(res.lessons[0].authorName);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[400],
              ),
              RaisedButton(
                child: Text('Request lessons'),
                onPressed: () async {
                  final repo = LessonsRepositoryImpl(
                      Injector.appInstance.getDependency(),
                      Injector.appInstance.getDependency(),
                      Injector.appInstance.getDependency());

                  try {
                    BlocProvider.of<LessonsBloc>(context).add(FetchLessons());
                    //final res = await repo.upadateLessons("6102171");
                  } catch (e) {
                    print("Already inserted!");
                  }
                },
              ),
              BlocBuilder<LessonsBloc, LessonsState>(
                builder: (context, state) {
                  if (state is LessonsLoading) {
                    return CircularProgressIndicator();
                  }
                  if (state is LessonsNotLoaded) {
                    return Text('Not loaded');
                  }
                  if (state is LessonsError) {
                    return Text(state.error);
                  }
                  if (state is LessonsLoaded) {
                    return Text('Lessons loaded');
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
                child: Text('Store password'),
                onPressed: () async {
                  final storage = new FlutterSecureStorage();
                  await storage.write(
                      key: "ciao123", value: "passwordsupersegreta");
                },
              ),
              RaisedButton(
                child: Text('retrieve password'),
                onPressed: () async {
                  final storage = new FlutterSecureStorage();

                  String value = await storage.read(key: "ciao123");
                  print(value);
                },
              ),
              // Expanded(child: _buildTaskList(context))
            ],
          ),
        ),
      ),
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
