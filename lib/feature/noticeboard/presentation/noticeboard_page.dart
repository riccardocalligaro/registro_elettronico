import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/watcher/noticeboard_watcher_bloc.dart';

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

    if (query.isNotEmpty) {
      noticesToShow = notices.where((l) => _showResult(query, l)).toList();
    } else {
      noticesToShow = notices;
    }

    return ListView.builder(
      itemCount: noticesToShow.length,
      padding: const EdgeInsets.all(12.0),
      itemBuilder: (context, index) {
        return NoticeCard(
          notice: noticesToShow[index],
        );
      },
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
