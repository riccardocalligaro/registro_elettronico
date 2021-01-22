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
      child: BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
        builder: (context, state) {
          if (state is GradesWatcherLoadSuccess) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context).translate('grades'),
                ),
              ),
              // bottomNavigationBar: _buildBottomNavigationBar(
              //   periods: state.gradesSections.periods,
              // ),
              body: Column(
                children: [
                  ActionChip(
                    label: Text('Ultimi voti'),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: GradesLoaded(
                      gradesPagesDomainModel: state.gradesSections,
                      index: _currentPage,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is GradesWatcherFailure) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context).translate('grades'),
                ),
              ),
              body: GradesFailure(failure: state.failure),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).translate('grades'),
              ),
            ),
            body: GradesLoading(),
          );
        },
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar({
    @required int periods,
  }) {
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
          icon: Icon(Icons.format_list_numbered),
        ),
        ...List.generate(periods - 1, (index) => _navBarItem(index)),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.timeline),
        ),
      ],
    );
  }

  BottomNavigationBarItem _navBarItem(int period) {
    return BottomNavigationBarItem(
      label: '',
      icon: Icon(_iconFromNumber(period)),
    );
  }

  IconData _iconFromNumber(int number) {
    switch (number) {
      case 0:
        return Icons.looks_one;
        break;
      case 1:
        return Icons.looks_two;
        break;
      case 3:
        return Icons.looks_3;
        break;
      case 4:
        return Icons.looks_4;
        break;
      default:
        return Icons.looks_6;
    }
  }
}
