import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_failure.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loading.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/grades_tab.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/period_tab.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/widget/empty_grades.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> with TickerProviderStateMixin {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('grades'),
        ),
      ),
      body: BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
        builder: (context, state) {
          if (state is GradesWatcherLoadSuccess) {
            if (state.gradesSections == null) {
              return _EmptyGrades();
            }
            final widgets = [
              GradesTab(
                grades: state.gradesSections.grades,
              ),
              ...List.generate(
                state.gradesSections.periods,
                (index) {
                  return PeriodTab(
                    periodWithGradesDomainModel:
                        state.gradesSections.periodsWithGrades[index],
                  );
                },
              ),
            ];

            return RefreshIndicator(
              onRefresh: () {
                final GradesRepository gradesRepository = sl();
                return gradesRepository.updateGrades(ifNeeded: false);
              },
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0.0, 0),
                    child: Container(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              label: Text(AppLocalizations.of(context)
                                  .translate('last_grades')),
                              onPressed: () {
                                setState(() {
                                  _currentPage = 0;
                                });
                              },
                              backgroundColor: _chipBackgroundColor(0),
                            ),
                          ),
                          ...List.generate(state.gradesSections.periods,
                              (index) {
                            final position = index + 1;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ActionChip(
                                label: Text(position ==
                                        state.gradesSections.periods
                                    ? AppLocalizations.of(context)
                                        .translate('general')
                                    : AppLocalizations.of(context)
                                        .translate('term_chip')
                                        .replaceAll(
                                            '{number}', position.toString())),
                                onPressed: () {
                                  setState(() {
                                    _currentPage = position;
                                  });
                                },
                                backgroundColor: _chipBackgroundColor(position),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  widgets.elementAt(_currentPage),
                ],
              ),
            );
          } else if (state is GradesWatcherFailure) {
            return GradesFailure(failure: state.failure);
          }

          return GradesLoading();
        },
      ),
    );
  }

  Color _chipBackgroundColor(int index) {
    if (index == _currentPage) {
      return Theme.of(context).accentColor;
    }
    return null;
  }
}

class _EmptyGrades extends StatelessWidget {
  const _EmptyGrades({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPlaceHolder(
        icon: Icons.timeline,
        showUpdate: true,
        onTap: () {
          final GradesRepository gradesRepository = sl();
          return gradesRepository.updateGrades(ifNeeded: false);
        },
        text: AppLocalizations.of(context).translate('no_grades'),
      ),
    );
  }
}
