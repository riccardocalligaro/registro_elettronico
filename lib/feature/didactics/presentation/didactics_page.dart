import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DidacticsWatcherBloc>(context)
        .add(DidacticsWatchAllStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: didacticsScaffold,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('school_material'),
        ),
      ),
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
}

class _DidacticsLoaded extends StatelessWidget {
  final List<DidacticsTeacherDomainModel> teachers;

  const _DidacticsLoaded({
    Key key,
    @required this.teachers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];

        if (teacher.folders.isEmpty) {
          return Container();
        }

        return TeacherCard(teacher: teacher);
      },
    );
  }
}
