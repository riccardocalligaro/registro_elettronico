import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/agenda_loaded.dart';
import 'package:registro_elettronico/feature/agenda/presentation/watcher/agenda_watcher_bloc.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaWatcherBloc, AgendaWatcherState>(
      builder: (context, state) {
        if (state is AgendaWatcherLoadSuccess) {
          if (state.agendaDataDomainModel == null ||
              state.agendaDataDomainModel!.allEvents.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.translate('agenda')!),
                brightness: Theme.of(context).brightness,
              ),
              body: CustomPlaceHolder(
                text: AppLocalizations.of(context)!.translate('no_events'),
                icon: Icons.event,
                showUpdate: true,
                onTap: () async {
                  final SRUpdateManager srUpdateManager = sl();
                  return srUpdateManager.updateAgendaData(context);
                },
              ),
            );
          }
          return AgendaLoaded(
            data: state.agendaDataDomainModel,
          );
        } else if (state is AgendaWatcherFailure) {
          return _AgendaFailure(failure: state.failure);
        }

        return _AgendaLoading();
      },
    );
  }
}

class _AgendaLoading extends StatelessWidget {
  const _AgendaLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('agenda')!),
        brightness: Theme.of(context).brightness,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _AgendaFailure extends StatelessWidget {
  final Failure? failure;

  const _AgendaFailure({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('agenda')!),
        brightness: Theme.of(context).brightness,
      ),
      body: CustomPlaceHolder(
        text: failure!.localizedDescription(context),
        icon: Icons.error,
        showUpdate: true,
        onTap: () async {
          final SRUpdateManager srUpdateManager = sl();
          return srUpdateManager.updateAgendaData(context);
        },
      ),
    );
  }
}
