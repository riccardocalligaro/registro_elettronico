import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_failure.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loaded.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loading.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> with TickerProviderStateMixin {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('grades'),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
          builder: (context, state) {
            if (state is GradesWatcherLoadSuccess) {
              return GradesLoaded(
                gradesPagesDomainModel: state.gradesSections,
                index: _currentPage,
              );
            } else if (state is GradesWatcherFailure) {
              return GradesFailure(failure: state.failure);
            }

            return GradesLoading();
          },
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      // selectedItemColor: CYColors.lightOrange,
      // unselectedItemColor: CYColors.lightText,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPage,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) {
        // Calls the api if needed
        setState(() {
          _currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: 'Tutti i voti',
          icon: Icon(Icons.all_inbox),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.looks_one),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.looks),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.poll),
        ),
      ],
    );
  }
}
