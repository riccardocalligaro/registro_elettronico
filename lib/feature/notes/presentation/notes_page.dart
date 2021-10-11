import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/core/presentation/widgets/custom_refresher.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

import 'bloc/attachments/note_attachments_bloc.dart';
import 'bloc/notes_bloc.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final ExpandableController expandableController = ExpandableController();
  @override
  void initState() {
    BlocProvider.of<NotesBloc>(context).add(GetNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('notes')!),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              if (state is NotesLoadErrorNotConnected) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    AppNavigator.instance!.getNetworkErrorSnackBar(context),
                  );
              }
            },
          ),
          BlocListener<NoteAttachmentsBloc, NoteAttachmentsState>(
            listener: (context, state) {
              if (state is NoteAttachmentsLoadNotConnected) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    AppNavigator.instance!.getNetworkErrorSnackBar(context),
                  );
              }
            },
          ),
        ],
        child: _buildNotes(context),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NotesLoaded) {
          return _buildNotesList(state.notes, context);
        }

        if (state is NotesError || state is NotesUpdateError) {
          return CustomPlaceHolder(
            icon: Icons.error,
            text: AppLocalizations.of(context)!
                .translate('unexcepted_error_single'),
            showUpdate: true,
            onTap: () {
              BlocProvider.of<NotesBloc>(context).add(UpdateNotes());
              BlocProvider.of<NotesBloc>(context).add(GetNotes());
            },
          );
        }

        if (state is NotesUpdateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildNotesList(List<Note> notes, BuildContext context) {
    if (notes.isNotEmpty) {
      return CustomRefresher(
        onRefresh: () {
          BlocProvider.of<NotesBloc>(context).add(UpdateNotes());
          BlocProvider.of<NotesBloc>(context).add(GetNotes());
        },
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text('${note.author}'),
              subtitle: Text(
                  '${AppLocalizations.of(context)!.translate(note.type!.toLowerCase()) ?? ""} - ${SRDateUtils.convertDateLocale(note.date, AppLocalizations.of(context)!.locale.toString())}'),
              onTap: () {
                BlocProvider.of<NoteAttachmentsBloc>(context)
                    .add(ReadNote(eventId: note.id, type: note.type));

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: NoteDialog(),
                    );
                  },
                );
              },
            );
          },
        ),
      );
    } else {
      return CustomPlaceHolder(
        icon: Icons.info,
        text: AppLocalizations.of(context)!.translate('no_notes'),
        showUpdate: true,
        onTap: () {
          BlocProvider.of<NotesBloc>(context).add(UpdateNotes());
          BlocProvider.of<NotesBloc>(context).add(GetNotes());
        },
      );
    }
  }

  // Future<void> _refreshNotes() async {
  //   BlocProvider.of<NotesBloc>(context).add(UpdateNotes());
  //   BlocProvider.of<NotesBloc>(context).add(GetNotes());
  // }
}

class NoteDialog extends StatelessWidget {
  const NoteDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteAttachmentsBloc, NoteAttachmentsState>(
      builder: (context, state) {
        if (state is NoteAttachmentsLoadInProgress) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ],
          );
        } else if (state is NoteAttachmentsLoadSuccess) {
          final attachment = state.attachment;
          return ListTile(
            title: Text(
              "${AppLocalizations.of(context)!.translate('description')}: ${attachment.description}",
            ),
          );
        } else if (state is NoteAttachmentsLoadError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Icon(Icons.error),
          );
        }
        return Container();
      },
    );
  }
}
