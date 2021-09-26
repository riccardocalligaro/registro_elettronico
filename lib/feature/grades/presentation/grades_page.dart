import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_failure.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loading.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/grades_tab.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/tabs/period_tab.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

final GlobalKey<RefreshIndicatorState> gradesRefresherKey = GlobalKey();

class GradesPage extends StatefulWidget {
  GradesPage({Key? key}) : super(key: key);

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
          AppLocalizations.of(context)!.translate('grades')!,
        ),
        brightness: Theme.of(context).brightness,
      ),
      body: BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
        builder: (context, state) {
          if (state is GradesWatcherLoadSuccess) {
            late List<StatelessWidget> widgets;

            if (state.gradesSections != null) {
              widgets = [
                GradesTab(
                  grades: state.gradesSections!.grades,
                ),
                ...List.generate(
                  state.gradesSections!.periods,
                  (index) {
                    return PeriodTab(
                      periodWithGradesDomainModel:
                          state.gradesSections!.periodsWithGrades[index],
                    );
                  },
                ),
              ];
            }

            return RefreshIndicator(
              key: gradesRefresherKey,
              onRefresh: () {
                return _refreshData(state.gradesSections);
              },
              child: state.gradesSections == null
                  ? _EmptyGrades(
                      onTap: () {
                        gradesRefresherKey.currentState!.show();
                      },
                    )
                  : ListView(
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
                                    label: Text(AppLocalizations.of(context)!
                                        .translate('last_grades')!),
                                    onPressed: () {
                                      setState(() {
                                        _currentPage = 0;
                                      });
                                    },
                                    backgroundColor: _chipBackgroundColor(0),
                                  ),
                                ),
                                ...List.generate(state.gradesSections!.periods,
                                    (index) {
                                  final position = index + 1;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ActionChip(
                                      label: Text(position ==
                                              state.gradesSections!.periods
                                          ? AppLocalizations.of(context)!
                                              .translate('general')!
                                          : AppLocalizations.of(context)!
                                              .translate('term_chip')!
                                              .replaceAll('{number}',
                                                  position.toString())),
                                      onPressed: () {
                                        setState(() {
                                          _currentPage = position;
                                        });
                                      },
                                      backgroundColor:
                                          _chipBackgroundColor(position),
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

  Future<void> _refreshData(GradesPagesDomainModel? gradesSections) {
    final SRUpdateManager srUpdateManager = sl();
    return srUpdateManager.updateGradesData(
      gradesSections: gradesSections,
      context: context,
    );
  }

  Color? _chipBackgroundColor(int index) {
    if (index == _currentPage) {
      return Theme.of(context).accentColor;
    }
    return null;
  }
}

class _EmptyGrades extends StatelessWidget {
  final Function() onTap;

  const _EmptyGrades({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPlaceHolder(
        icon: Icons.timeline,
        showUpdate: true,
        onTap: onTap,
        text: AppLocalizations.of(context)!.translate('no_grades'),
      ),
    );
  }
}
