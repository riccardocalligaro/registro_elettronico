import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_bloc.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_event.dart';
import 'package:registro_elettronico/ui/bloc/notes/notes_state.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
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
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text('Notes'),
      ),
      drawer: AppDrawer(
        position: DrawerConstants.NOTES,
      ),
      body: _buildNotes(context),
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
            text: 'Unexcepted error',
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
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.description),
            subtitle: Text(
                "${note.author} - ${DateUtils.convertDateLocale(note.date, AppLocalizations.of(context).locale.toString())}"),
          );
        },
      );
    } else {
      return CustomPlaceHolder(
        icon: Icons.info,
        text: 'No notes',
        showUpdate: true,
        onTap: () {
          BlocProvider.of<NotesBloc>(context).add(UpdateNotes());
          BlocProvider.of<NotesBloc>(context).add(GetNotes());
        },
      );
    }
  }
}
