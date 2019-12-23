import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/notices/attachment_download/bloc.dart';
import 'package:registro_elettronico/ui/bloc/notices/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class NoticeboardPage extends StatefulWidget {
  NoticeboardPage({Key key}) : super(key: key);

  @override
  _NoticeboardPageState createState() => _NoticeboardPageState();
}

class _NoticeboardPageState extends State<NoticeboardPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    BlocProvider.of<NoticesBloc>(context).add(GetNoticeboard());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: AppLocalizations.of(context).translate('notice_board'),
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.NOTICE_BOARD,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
          return Text(state.error);
        }
        if (state is NoticesLoaded) {
          return _buildNoticeBoardList(state.notices);
        }

        if (state is NoticesUpdateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NoticesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Text(state.toString());
      },
    );
  }

  Widget _buildNoticeBoardList(List<Notice> notices) {
    if (notices.length > 0) {
      return BlocListener<AttachmentDownloadBloc, AttachmentDownloadState>(
        listener: (context, state) {
          if (state is AttachmentDownloadLoading) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Loading...'),
              ),
            );
          }

          if (state is AttachmentDownloadLoaded) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Downloaded...'),
              ),
            );
          }
        },
        child: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final notice = notices[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text(notice.contentTitle),
                  subtitle: Text(
                    DateUtils.convertDateLocale(notice.pubDate,
                        AppLocalizations.of(context).locale.toString()),
                  ),
                  trailing: notice.readStatus
                      ? Icon(
                          Icons.mail,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.mail,
                          color: Colors.red,
                        ),
                  onTap: () async {
                    final file = await _localFile;
                    print(file.exists());
                    // BlocProvider.of<AttachmentDownloadBloc>(context).add(
                    //     DownloadAttachment(
                    //         pubId: notice.pubId, attachmentNumber: 1));
                  },
                ),
              ),
            );
          },
        ),
      );
    }

    return CustomPlaceHolder(
      text: 'No documents!',
      icon: Icons.assignment,
      onTap: () async {
        BlocProvider.of<NoticesBloc>(context).add(FetchNoticeboard());
        BlocProvider.of<NoticesBloc>(context).add(GetNoticeboard());
      },
    );
  }

  Future<String> get _localPath async {
    //final directory = await getApplicationDocumentsDirectory();
    //return directory.path;
  }

  Future<File> get _localFile async {
    //final path = await _localPath;
    //return File('$path/counter.txt');
  }
}
