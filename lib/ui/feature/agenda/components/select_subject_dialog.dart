import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';

class SelectSubjectDialog extends StatefulWidget {
  final Subject selectedSubject;
  SelectSubjectDialog({Key key, this.selectedSubject}) : super(key: key);

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
            return Container(
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(
                    state.subjects.length,
                    (int index) {
                      return RadioListTile(
                        title: Text(
                          state.subjects[index].name,
                          style: TextStyle(fontSize: 13),
                        ),
                        value: state.subjects[index],
                        groupValue: widget.selectedSubject,
                        onChanged: (Subject subj) {
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
          return Container();
        },
      ),
    );
  }
}
