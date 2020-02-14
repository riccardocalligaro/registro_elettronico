import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachment_download/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachments/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeboardPage extends StatefulWidget {
  NoticeboardPage({Key key}) : super(key: key);

  @override
  _NoticeboardPageState createState() => _NoticeboardPageState();
}

class _NoticeboardPageState extends State<NoticeboardPage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";

  List<Lesson> lessons = List();
  List<Lesson> filteredLessons = List();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('Comunicazioni');
  int _noticeboardLastUpdate;
  bool _showOutdatedNotices = false;

  _NoticeboardPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredLessons = lessons;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<NoticesBloc>(context).add(GetNoticeboard());

    restore();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appBarTitle = Text(
      AppLocalizations.of(context).translate('notice_board'),
    );
    super.didChangeDependencies();
  }

  void restore() async {
    SharedPreferences sharedPreferences = Injector.appInstance.getDependency();

    setState(() {
      _noticeboardLastUpdate =
          sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_NOTICEBOARD);

      _showOutdatedNotices =
          sharedPreferences.getBool(PrefsConstants.SHOW_OUTDATED_NOTICES) ??
              false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              _searchPressed(context);
            },
          ),
          PopupMenuButton(
            onSelected: (bool result) async {
              setState(() {
                _showOutdatedNotices = result;
              });
              SharedPreferences sharedPreferences =
                  Injector.appInstance.getDependency();
              sharedPreferences.setBool(
                PrefsConstants.SHOW_OUTDATED_NOTICES,
                result,
              );
            },
            itemBuilder: (BuildContext context) => [
              CheckedPopupMenuItem(
                value: !_showOutdatedNotices,
                child: Text(
                    AppLocalizations.of(context).translate('outdated_notices')),
                checked: _showOutdatedNotices,
              ),
            ],
          ),
        ],
      ),
      bottomSheet: LastUpdateBottomSheet(
        millisecondsSinceEpoch: _noticeboardLastUpdate,
      ),
      // drawer: AppDrawer(
      //   position: DrawerConstants.NOTICE_BOARD,
      // ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NoticesBloc, NoticesState>(
            listener: (context, state) {
              if (state is NoticesAttachmentsLoadNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context));
              }

              if (state is NoticesUpdateLoaded) {
                setState(() {
                  _noticeboardLastUpdate = DateTime.now().millisecondsSinceEpoch;
                });
              }
            },
          ),
          BlocListener<AttachmentDownloadBloc, AttachmentDownloadState>(
            listener: (context, state) {
              if (state is AttachmentDownloadLoadNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context));
              }
            },
          ),
          BlocListener<AttachmentsBloc, AttachmentsState>(
            listener: (context, state) {
              if (state is NoticesAttachmentsLoadNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context));
              }
            },
          ),
        ],
        child: Container(
          child: _buildNoticeBoard(),
        ),
      ),
    );
  }

  Widget _buildNoticeBoard() {
    return BlocBuilder<NoticesBloc, NoticesState>(
      builder: (context, state) {
        if (state is NoticesError) {
          return CustomPlaceHolder(
            icon: Icons.error,
            text: AppLocalizations.of(context)
                .translate('unexcepted_error_single'),
            showUpdate: true,
            onTap: _refreshNoticeBoard,
          );
        }
        if (state is NoticesLoaded) {
          if (_showOutdatedNotices) {
            return _buildNoticeBoardList(state.notices);
          } else {
            return _buildNoticeBoardList(state.notices
                .where(
                    (notice) => notice.contentValidTo.isAfter(DateTime.now()))
                .toList());
          }
        }

        if (state is NoticesLoading || state is NoticesUpdateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildNoticeBoardList(List<Notice> notices) {
    /// Search functionality
    if (_searchText.isNotEmpty) {
      notices = notices
          .where((notice) => notice.contentTitle
              .toLowerCase()
              .contains(_searchText.toLowerCase()))
          .toList()
            ..sort(
              (b, a) => a.pubDate.compareTo(b.pubDate),
            );
    }

    if (notices.length > 0) {
      return BlocListener<AttachmentDownloadBloc, AttachmentDownloadState>(
        listener: (context, state) {
          if (state is AttachmentDownloadLoading) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)
                          .translate('downloading')),
                      Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      )
                    ],
                  ),
                  duration: Duration(days: 1),
                ),
              );
          }

          if (state is AttachmentDownloadLoaded) {
            FLog.info(text: 'Path ${state.path}');
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    AppLocalizations.of(context)
                        .translate('download_of_file_completed')
                        .replaceAll('{fileName}', state.path),
                  ),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context)
                        .translate('open')
                        .toUpperCase(),
                    onPressed: () async {
                      await OpenFile.open(state.path);
                      BlocProvider.of<NoticesBloc>(context)
                          .add(GetNoticeboard());
                    },
                  ),
                ),
              );
          }

          if (state is AttachmentDownloadError) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                      AppLocalizations.of(context).translate('error_download')),
                ),
              );
          }
        },
        child: CustomRefresher(
          onRefresh: _refreshNoticeBoard,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];
              return _buildNoticeCard(notice, context);
            },
          ),
        ),
      );
    } else if (_searchText.isNotEmpty) {
      return CustomPlaceHolder(
        text: AppLocalizations.of(context).translate('no_documents'),
        icon: Icons.assignment,
        showUpdate: false,
      );
    }

    return CustomPlaceHolder(
      text: AppLocalizations.of(context).translate('no_documents'),
      icon: Icons.assignment,
      onTap: () async {
        BlocProvider.of<NoticesBloc>(context).add(FetchNoticeboard());
        BlocProvider.of<NoticesBloc>(context).add(GetNoticeboard());
      },
      showUpdate: true,
    );
  }

  Widget _buildNoticeCard(Notice notice, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Text(notice.contentTitle),
          subtitle: Text(
            DateUtils.convertDateLocale(
                notice.pubDate, AppLocalizations.of(context).locale.toString()),
          ),
          trailing: notice.readStatus
              ? Icon(
                  Icons.mail,
                  color: Colors.green,
                )
              : Icon(
                  Icons.mail,
                  color: Colors.red,
                ),
          onTap: () async {
            _downloadAttachments(context, notice);
          },
          onLongPress: () {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(AppLocalizations.of(context)
                    .translate('delete_notice_snackbar_info')),
              ));
          },
        ),
      ),
    );
  }

  void _downloadAttachments(BuildContext context, Notice notice) {
    BlocProvider.of<AttachmentsBloc>(context)
        .add(GetAttachments(notice: notice));
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          AppLocalizations.of(context).translate('select_attachment'),
        ),
        children: <Widget>[
          BlocBuilder<AttachmentsBloc, AttachmentsState>(
            builder: (context, state) {
              if (state is NoticesAttachmentsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is NoticesAttachmentsLoaded) {
                return Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.attachments.length,
                    itemBuilder: (ctx, index) {
                      if (state.attachments.length > 0) {
                        final attachment = state.attachments[index];
                        return ListTile(
                          title: Text(attachment.fileName),
                          onLongPress: () async {
                            final file = await _localFile(notice, attachment);
                            if (file.existsSync()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(AppLocalizations.of(context)
                                      .translate('delete_notice_alert_title')),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(AppLocalizations.of(context)
                                          .translate('no')
                                          .toUpperCase()),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(AppLocalizations.of(context)
                                          .translate('yes')
                                          .toUpperCase()),
                                      onPressed: () async {
                                        file.deleteSync();
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          onTap: () async {
                            final file = await _localFile(notice, attachment);
                            if (file.existsSync()) {
                              await OpenFile.open(file.path);
                              BlocProvider.of<NoticesBloc>(context)
                                  .add(GetNoticeboard());
                            } else {
                              await BlocProvider.of<AttachmentDownloadBloc>(
                                      context)
                                  .add(DownloadAttachment(
                                      notice: notice, attachment: attachment));

                              await Navigator.pop(context);
                              // BlocProvider.of<NoticesBloc>(context)
                              //     .add(GetNoticeboard());
                            }
                          },
                        );
                      }
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('no_attachments'),
                        ),
                      );
                    },
                  ),
                );
              }

              if (state is NoticesAttachmentsError) {
                return Center(
                  child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      BlocProvider.of<AttachmentsBloc>(context)
                          .add(GetAttachments(notice: notice));
                    },
                  ),
                );
              }
              return Text(state.toString());
            },
          )
        ],
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(Notice notice, Attachment attachment) async {
    final path = await _localPath;
    final ext = attachment.fileName.split('.').last;

    return File(
        '$path/${notice.contentTitle.replaceAll('/', '').replaceAll(' ', '_')}.$ext');
  }

  Future<void> _refreshNoticeBoard() async {
    BlocProvider.of<NoticesBloc>(context).add(FetchNoticeboard());
    BlocProvider.of<NoticesBloc>(context).add(GetNoticeboard());
  }

  void _searchPressed(BuildContext context) {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);

        this._appBarTitle = TextField(
          autofocus: true,
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "${AppLocalizations.of(context).translate('search')}...",
            border: InputBorder.none,
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text(
          AppLocalizations.of(context).translate('notice_board'),
        );
        //filteredNames = names;
        _filter.clear();
      }
    });
  }
}
