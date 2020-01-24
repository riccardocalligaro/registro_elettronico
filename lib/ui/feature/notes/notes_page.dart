import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/notes/note_attachments/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_bloc.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_event.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_state.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    BlocProvider.of<NotesBloc>(context).add(GetNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    return Scaffold(
      //key: _drawerKey,
      appBar: AppBar(
        //scaffoldKey: _drawerKey,
        title: Text(AppLocalizations.of(context).translate('notes')),
      ),
      // drawer: AppDrawer(
      //   position: DrawerConstants.NOTES,
      // ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              if (state is NotesLoadErrorNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    AppNavigator.instance.getNetworkErrorSnackBar(context),
                  );
              }
            },
          ),
          BlocListener<NoteAttachmentsBloc, NoteAttachmentsState>(
            listener: (context, state) {
              // TODO: implement listener
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
            text: AppLocalizations.of(context)
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
    if (notes.length > 0) {
      return CustomRefresher(
        onRefresh: () {
          BlocProvider.of<NotesBloc>(context).add(UpdateNotes());
          BlocProvider.of<NotesBloc>(context).add(GetNotes());
        },
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            print(note.toString());
            return ExpandableTheme(
              data: ExpandableThemeData(
                iconColor: Theme.of(context).iconTheme.color,
              ),
              child: ExpandablePanel(
                header: ListTile(
                  // onLongPress: () {
                  //   final AppDatabase appDatabase = AppDatabase();
                  //   final NoteDao noteDao = NoteDao(appDatabase);

                  //   noteDao.deleteAllNotes();
                  // },
                  title: Text("${note.author}"),
                  subtitle: Text(
                      "${AppLocalizations.of(context).translate(note.type.toLowerCase()) ?? ""} - ${DateUtils.convertDateLocale(note.date, AppLocalizations.of(context).locale.toString())}"),
                ),
                expanded: ExpandedNote(
                  note: note,
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
            );
          },
        ),
      );
    } else {
      return CustomPlaceHolder(
        icon: Icons.info,
        text: AppLocalizations.of(context).translate('no_notes'),
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

class ExpandedNote extends StatelessWidget {
  final Note note;
  const ExpandedNote({
    Key key,
    @required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NoteAttachmentsBloc>(context)
        .add(ReadNote(eventId: note.id, type: note.type));
    return BlocBuilder<NoteAttachmentsBloc, NoteAttachmentsState>(
      builder: (context, state) {
        if (state is NoteAttachmentsLoadInProgress) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          );
        } else if (state is NoteAttachmentsLoadSuccess) {
          final attachment = state.attachment;
          return ListTile(
            title: Text(
                "${AppLocalizations.of(context).translate('description')}: ${attachment.description}"),
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
