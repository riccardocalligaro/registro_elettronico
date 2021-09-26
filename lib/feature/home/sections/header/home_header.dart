import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/agenda/presentation/watcher/agenda_watcher_bloc.dart';
import 'package:registro_elettronico/feature/authentication/data/datasource/profiles_shared_datasource.dart';
import 'package:registro_elettronico/feature/home/sections/header/week_summary_chart.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _BackgroundGradient(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top + 24,
              ),
              _buildNameText(context),
              Text(
                SRDateUtils.convertDateLocale(
                  DateTime.now(),
                  AppLocalizations.of(context)!.locale.toString(),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _WeekEventsChart(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNameText(BuildContext context) {
    ProfilesLocalDatasource profilesLocalDatasource = sl();
    final profile = profilesLocalDatasource.getLoggedInUserSync();

    if (profile != null) {
      return Text(
        '${SRDateUtils.localizedTimeMessage(context)}, ${StringUtils.titleCase(profile.firstName ?? '')}.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    return Text(
      '${SRDateUtils.localizedTimeMessage(context)}.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _WeekEventsChart extends StatelessWidget {
  const _WeekEventsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      child: AspectRatio(
        aspectRatio: 3,
        // width: double.infinity,
        child: BlocBuilder<AgendaWatcherBloc, AgendaWatcherState>(
          builder: (context, state) {
            if (state is AgendaWatcherLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(1, 0, 24, 0),
                child: WeekSummaryChart(
                  events: state.agendaDataDomainModel!.eventsSpots,
                ),
              );
            }
            return Text(state.toString());
          },
        ),
      ),
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.4, 1],
          colors: ColorUtils.getGradientForColor(
            Theme.of(context).accentColor,
          ) as List<Color>,
          begin: Alignment(-1.0, -2.0),
          end: Alignment(1.0, 2.0),
        ),
      ),
    );
  }
}
