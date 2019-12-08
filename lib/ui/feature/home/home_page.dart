import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/lessons_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/feature/login/login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Lesson Card
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 0.0, 0.0),
        child: Container(
          width: 275.0,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.red,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 275,
                child: Row(
                  //TODO: Pills
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 0, 0),
                      child: Container(
                        //TODO: Subject Related Icon
                        child: Icon(Icons.format_list_bulleted),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Container(
                        color: Colors.red,
                        child: Text("Math",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('make request'),
                    onPressed: () async {
                      // S6102171X
                      final dio = Dio();

                      dio.options.headers["Content-Type"] = "application/json";
                      dio.options.headers["Content-Type"] =
                          Headers.jsonContentType;
                      dio.options.headers["User-Agent"] = "zorro/1.0";
                      dio.options.headers["Z-Dev-Apikey"] = "+zorro+";
                      dio.options.headers["Z-Auth-Token"] =
                          "QbtwzyMJirahT3XQPvKoZBM94suiadiF4i3tMcrkt2A9of4J9SI5NbaWmEOPf3MU60awefncdAREaolb+uQkTaLe3HsAUP9b0QbXMyZkpGazfIwwSYnV5valz8E9ldzzW1uQrTSapGvYtiUYSxt8OYJthP1ttaXtar2FW/r9FQb+PKQbcB89JtuLIp8ijaasLYm0oXb3LE9S+mrvf4WyUS7USZ0bFBBU+PFGnIO+Jth/nJH6kQqxa5KZDvbHUVTf";
                      final lessons =
                          await SpaggiariClient(dio).getTodayLessons("6102171");

                      print(lessons[0].classDesc);
                    },
                  ),
                  RaisedButton(
                    child: Text('Logout'),
                    onPressed: () async {
                      BlocProvider.of<AuthBloc>(context).add(SignOut());
                      // print(await ProfileDao(Injector.appInstance.getDependency()).getAllProfiles());
                    },
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is SignOutSuccess) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                      child: Container(
                        color: Colors.red,
                        child: Text(
                            "Lorem  ipsum dolor sit a met txt only a test.",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
