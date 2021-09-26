import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/presentation/watcher/subjects_watcher_bloc.dart';

class SelectSubjectDialog extends StatefulWidget {
  final SubjectDomainModel? selectedSubject;

  SelectSubjectDialog({Key? key, this.selectedSubject}) : super(key: key);

  @override
  _SelectSubjectDialogState createState() => _SelectSubjectDialogState();
}

class _SelectSubjectDialogState extends State<SelectSubjectDialog> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SubjectsWatcherBloc>(context)
        .add(SubjectsStartWatcherIfNeeded());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.translate('select_subject')!),
      content: BlocBuilder<SubjectsWatcherBloc, SubjectsWatcherState>(
        builder: (context, state) {
          if (state is SubjectsWatcherLoadSuccess) {
            return Container(
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(
                    state.subjects!.length,
                    (int index) {
                      return RadioListTile<SubjectDomainModel>(
                        title: Text(
                          state.subjects![index].name!,
                          style: TextStyle(fontSize: 13),
                        ),
                        value: state.subjects![index],
                        groupValue: widget.selectedSubject,
                        onChanged: (SubjectDomainModel? subj) {
                          Navigator.pop(context, subj);
                        },
                        //groupValue: 312,
                      );
                    },
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
