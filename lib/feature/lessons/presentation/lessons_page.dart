import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_search_empty_view.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/presentation/watcher/lessons_watcher_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class LessonsPage extends StatefulWidget {
  final int? subjectId;
  final String? subjectName;

  LessonsPage({
    Key? key,
    required this.subjectId,
    required this.subjectName,
  }) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  late SearchBar _searchBar;
  String _searchQuery = '';

  @override
  void initState() {
    BlocProvider.of<LessonsWatcherBloc>(context)
        .add(LessonsWatchAllStarted(subjectId: widget.subjectId));

    _searchBar = SearchBar(
      setState: setState,
      onChanged: (query) {
        if (query.isNotEmpty) {
          setState(() => _searchQuery = query);
        }
      },
      onClosed: () {
        setState(() => _searchQuery = '');
      },
      onCleared: () {
        setState(() => _searchQuery = '');
      },
      buildDefaultAppBar: buildAppBar,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      body: BlocBuilder<LessonsWatcherBloc, LessonsWatcherState>(
        builder: (context, state) {
          if (state is LessonsWatcherLoadSuccess) {
            if (state.lessons!.isEmpty) {
              return CustomPlaceHolder(
                text: AppLocalizations.of(context)!.translate('no_lessons'),
                icon: Icons.subject,
                showUpdate: true,
              );
            }
            return _LessonsLoaded(
              lessons: state.lessons,
              query: _searchQuery,
            );
          } else if (state is LessonsWatcherFailure) {
            return SRFailureView(failure: state.failure);
          }

          return SRLoadingView();
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.subjectName!),
      actions: [
        _searchBar.getSearchAction(context),
      ],
    );
  }
}

class _LessonsLoaded extends StatelessWidget {
  final List<LessonDomainModel>? lessons;
  final String query;

  const _LessonsLoaded({
    Key? key,
    required this.lessons,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentMonth = -1;
    bool showMonth;

    List<LessonDomainModel>? lessonsToShow;

    if (query.isNotEmpty) {
      lessonsToShow = lessons!.where((l) => _showResult(query, l)).toList();
    } else {
      lessonsToShow = lessons;
    }

    if (lessonsToShow!.isEmpty) {
      return SrSearchEmptyView();
    }

    return ListView.builder(
      itemCount: lessonsToShow.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final lesson = lessons![index];

        if (lesson.date!.month != currentMonth) {
          showMonth = true;
        } else {
          showMonth = false;
        }

        currentMonth = lesson.date!.month;

        if (showMonth) {
          var convertMonthLocale = SRDateUtils.convertMonthLocale(
              lesson.date, AppLocalizations.of(context)!.locale.toString());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                child: Text(
                  convertMonthLocale,
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              _buildLessonCard(lesson)
            ],
          );
        } else {
          return _buildLessonCard(lesson);
        }
      },
    );
  }

  Widget _buildLessonCard(LessonDomainModel lesson) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.lessonArgoment!,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${StringUtils.titleCase(lesson.author!)} - ${lesson.lessonType} - ${lesson.duration} H',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _showResult(String query, LessonDomainModel lesson) {
    final lQuery = query.toLowerCase().replaceAll(' ', '');
    return lesson.author!.toLowerCase().replaceAll(' ', '').contains(lQuery) ||
        lesson.lessonArgoment!
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(lQuery);
  }
}
