import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class SelectSubjectDialog extends StatefulWidget {
  SelectSubjectDialog({Key key}) : super(key: key);

  @override
  _SelectSubjectDialogState createState() => _SelectSubjectDialogState();
}

class _SelectSubjectDialogState extends State<SelectSubjectDialog> {
  @override
  void initState() {
    BlocProvider.of<SubjectsBloc>(context).add(GetSubjectsAndProfessors());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a subject'),
      content: BlocBuilder<SubjectsBloc, SubjectsState>(
        builder: (context, state) {
          if (state is SubjectsAndProfessorsLoadInProgress) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is SubjectsAndProfessorsLoadSuccess) {
            final professors = state.professors;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = state.subjects[index];

                      final professorsForSubject = professors
                          .where((prof) => prof.subjectId == subject.id)
                          .toList();
                      String professorsText = "";
                      professorsForSubject.forEach((prof) {
                        String name = StringUtils.titleCase(prof.name);
                        if (!professorsText.contains(name))
                          professorsText +=
                              "${StringUtils.titleCase(prof.name)}, ";
                      });
                      professorsText =
                          StringUtils.removeLastChar(professorsText);
                      return ListTile(
                        title: Text(subject.name),
                        subtitle: Text(professorsText),
                      );
                    },
                  ),
                )
              ],
            );
            return Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  final subject = state.subjects[index];

                  final professorsForSubject = professors
                      .where((prof) => prof.subjectId == subject.id)
                      .toList();
                  String professorsText = "";
                  professorsForSubject.forEach((prof) {
                    String name = StringUtils.titleCase(prof.name);
                    if (!professorsText.contains(name))
                      professorsText += "${StringUtils.titleCase(prof.name)}, ";
                  });
                  professorsText = StringUtils.removeLastChar(professorsText);
                  return ListTile(
                    title: Text(subject.name),
                    subtitle: Text(professorsText),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
