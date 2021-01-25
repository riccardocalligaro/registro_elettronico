import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/noticeboard_repository.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/watcher/noticeboard_watcher_bloc.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

import 'notice_card.dart';

final GlobalKey<ScaffoldState> noticeboardScaffold = GlobalKey();

class NoticeboardPage extends StatefulWidget {
  const NoticeboardPage({Key key}) : super(key: key);

  @override
  _NoticeboardPageState createState() => _NoticeboardPageState();
}

class _NoticeboardPageState extends State<NoticeboardPage> {
  SearchBar _searchBar;
  String _searchQuery = '';

  @override
  void initState() {
    _searchBar = SearchBar(
      setState: setState,
      onChanged: (query) {
        if (query.isNotEmpty) {
          setState(() => _searchQuery = query);
        }
      },
      buildDefaultAppBar: buildAppBar,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      key: noticeboardScaffold,
      body: BlocBuilder<NoticeboardWatcherBloc, NoticeboardWatcherState>(
        builder: (context, state) {
          if (state is NoticeboardWatcherLoadSuccess) {
            if (state.notices.isEmpty) {
              return _NoticesEmpty();
            }

            return _NoticesLoaded(
              notices: state.notices,
              query: _searchQuery,
            );
          } else if (state is NoticeboardWatcherFailure) {
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
        AppLocalizations.of(context).translate('notice_board'),
      ),
      actions: [
        _searchBar.getSearchAction(context),
      ],
    );
  }
}

class _NoticesEmpty extends StatelessWidget {
  const _NoticesEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPlaceHolder(
      icon: Icons.email,
      showUpdate: true,
      onTap: () {
        final NoticeboardRepository noticeboardRepository = sl();
        return noticeboardRepository.updateNotices(ifNeeded: false);
      },
      text: AppLocalizations.of(context).translate('no_notices'),
    );
  }
}

class _NoticesLoaded extends StatelessWidget {
  final List<NoticeDomainModel> notices;
  final String query;

  const _NoticesLoaded({
    Key key,
    @required this.notices,
    @required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<NoticeDomainModel> noticesToShow;

    if (query.isNotEmpty && query.length >= 2) {
      noticesToShow = notices.where((l) => _showResult(query, l)).toList();
    } else {
      noticesToShow = notices;
    }

    return RefreshIndicator(
      onRefresh: () {
        final SRUpdateManager srUpdateManager = sl();
        return srUpdateManager.updateNoticeboardData(context);
      },
      child: ListView.builder(
        itemCount: noticesToShow.length,
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          return NoticeCard(
            notice: noticesToShow[index],
          );
        },
      ),
    );
  }

  bool _showResult(String query, NoticeDomainModel notice) {
    final lQuery = query.toLowerCase().replaceAll(' ', '');
    return notice.contentTitle
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(lQuery) ||
        notice.attachments
            .toString()
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(lQuery);
  }
}
