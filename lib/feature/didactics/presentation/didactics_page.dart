import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_search_empty_view.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/teacher_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/presentation/teacher_card.dart';
import 'package:registro_elettronico/feature/didactics/presentation/watcher/didactics_watcher_bloc.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

final GlobalKey<ScaffoldState> didacticsScaffold = GlobalKey();

class DidacticsPage extends StatefulWidget {
  DidacticsPage({Key key}) : super(key: key);

  @override
  _DidacticsPageState createState() => _DidacticsPageState();
}

class _DidacticsPageState extends State<DidacticsPage> {
  SearchBar _searchBar;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
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
    BlocProvider.of<DidacticsWatcherBloc>(context)
        .add(DidacticsWatchAllStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: didacticsScaffold,
      appBar: _searchBar.build(context),
      body: BlocBuilder<DidacticsWatcherBloc, DidacticsWatcherState>(
        builder: (context, state) {
          if (state is DidacticsWatcherLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () {
                SRUpdateManager srUpdateManager = sl();
                return srUpdateManager.updateDidacticsData(context);
              },
              child: _DidacticsLoaded(
                teachers: state.teachers,
                query: _searchQuery,
              ),
            );
          } else if (state is DidacticsWatcherFailure) {
            return SRFailureView(failure: state.failure);
          }

          return SRLoadingView();
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).translate('school_material'),
      ),
      actions: [
        _searchBar.getSearchAction(context),
      ],
    );
  }
}

class _DidacticsLoaded extends StatelessWidget {
  final List<DidacticsTeacherDomainModel> teachers;
  final String query;

  const _DidacticsLoaded({
    Key key,
    @required this.teachers,
    @required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DidacticsTeacherDomainModel> teachersToShow;

    if (teachers.isEmpty) {
      return CustomPlaceHolder(
        text: AppLocalizations.of(context).translate('no_materials'),
        icon: Icons.folder,
        showUpdate: true,
        onTap: () {
          SRUpdateManager srUpdateManager = sl();
          return srUpdateManager.updateDidacticsData(context);
        },
      );
    }

    if (query.isNotEmpty && query.length >= 2) {
      teachersToShow = teachers.where((l) => _showResult(query, l)).toList();
    } else {
      teachersToShow = teachers;
    }

    if (teachersToShow.isEmpty) {
      return SrSearchEmptyView();
    }

    return ListView.builder(
      itemCount: teachersToShow.length,
      itemBuilder: (context, index) {
        final teacher = teachersToShow[index];

        if (teacher.folders.isEmpty) {
          return Container();
        }

        return TeacherCard(teacher: teacher);
      },
    );
  }

  bool _showResult(String query, DidacticsTeacherDomainModel teacher) {
    final lQuery = query.toLowerCase().replaceAll(' ', '');

    return teacher.name.toLowerCase().replaceAll(' ', '').contains(lQuery) ||
        teacher.firstName.toLowerCase().replaceAll(' ', '').contains(lQuery) ||
        teacher.lastName.toLowerCase().replaceAll(' ', '').contains(lQuery) ||
        teacher.folders
            .toString()
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(lQuery);
  }
}
