import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:open_file/open_file.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_failure_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_loading_view.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_search_empty_view.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/watcher/noticeboard_watcher_bloc.dart';
import 'package:registro_elettronico/utils/update_manager.dart';

import 'attachment/attachment_download_bloc.dart';
import 'notice_card.dart';

final GlobalKey<RefreshIndicatorState> noticeboardRefresherKey = GlobalKey();

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
      onClosed: () {
        setState(() => _searchQuery = '');
      },
      onCleared: () {
        setState(() => _searchQuery = '');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      // key: noticeboardScaffold,
      body: RefreshIndicator(
        key: noticeboardRefresherKey,
        onRefresh: () {
          final SRUpdateManager srUpdateManager = sl();
          return srUpdateManager.updateNoticeboardData(context);
        },
        child: BlocBuilder<NoticeboardWatcherBloc, NoticeboardWatcherState>(
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
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context).brightness,
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
        noticeboardRefresherKey.currentState.show();
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

    if (noticesToShow.isEmpty) {
      return SrSearchEmptyView();
    }

    return ListView.builder(
      itemCount: noticesToShow.length,
      padding: const EdgeInsets.all(12.0),
      itemBuilder: (context, index) {
        return NoticeCard(
          notice: noticesToShow[index],
          showDownloadSnackbar: () {
            final snackBar = SnackBar(
              content: _DownloadAttachmentSnackbar(),
              duration: Duration(minutes: 1),
              behavior: SnackBarBehavior.floating,
            );

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
          },
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

class _DownloadAttachmentSnackbar extends StatelessWidget {
  const _DownloadAttachmentSnackbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttachmentDownloadBloc, AttachmentDownloadState>(
      listener: (context, state) {
        if (state is AttachmentDownloadSuccess ||
            state is AttachmentDownloadFailure) {
          Future.delayed(Duration(seconds: 3)).then((value) =>
              ScaffoldMessenger.of(context)..removeCurrentSnackBar());
        }
        if (state is AttachmentDownloadSuccess) {
          OpenFile.open(state.downloadedAttachment.file.path);
        }
      },
      builder: (context, state) {
        if (state is AttachmentDownloadSuccess) {
          return Text(AppLocalizations.of(context)
              .translate('file_downloaded_success'));
        } else if (state is AttachmentDownloadFailure) {
          return Text(AppLocalizations.of(context).translate('error_download'));
        } else if (state is AttachmentDownloadInProgress) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate('downloading'),
              ),
              Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  value: state.percentage,
                ),
              )
            ],
          );
        }

        return Text('');
      },
    );
  }
}
