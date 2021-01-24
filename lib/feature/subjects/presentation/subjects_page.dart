import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/feature/lessons/presentation/lessons_page.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/feature/subjects/presentation/watcher/subjects_watcher_bloc.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key key}) : super(key: key);

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  void initState() {
    BlocProvider.of<SubjectsWatcherBloc>(context)
        .add(SubjectsStartWatcherIfNeeded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('lessons'),
        ),
      ),
      body: BlocBuilder<SubjectsWatcherBloc, SubjectsWatcherState>(
        builder: (context, state) {
          if (state is SubjectsWatcherLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () {
                return _refreshPage();
              },
              child: _SubjectsLoaded(
                subjects: state.subjects,
              ),
            );
          } else if (state is SubjectsWatcherFailure) {
            return SRFailureView(
              failure: state.failure,
              refresh: _refreshPage,
            );
          }

          return SRLoadingView();
        },
      ),
    );
  }

  Future<void> _refreshPage() {
    final SubjectsRepository subjectsRepository = sl();
    final LessonsRepository lessonsRepository = sl();

    return Future.wait([
      subjectsRepository.updateSubjects(ifNeeded: false),
      lessonsRepository.updateAllLessons(ifNeeded: false),
    ]);
  }
}

class _SubjectsLoaded extends StatelessWidget {
  final List<SubjectDomainModel> subjects;

  const _SubjectsLoaded({
    Key key,
    @required this.subjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return ListTile(
          title: Text(subject.name),
          subtitle: Text(subject.professorsText),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return LessonsPage(
                  subjectId: subject.id,
                  subjectName: subject.name,
                );
              }),
            );
          },
        );
      },
    );
  }
}