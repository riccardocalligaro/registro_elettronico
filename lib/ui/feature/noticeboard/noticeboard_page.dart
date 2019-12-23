import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
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
      body: Container(
        child: _buildNoticeBoard(),
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
      return ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          return Card(
            child: ListTile(
              title: Text(notice.contentTitle),
              subtitle: Text(DateUtils.convertDateLocale(notice.pubDate,
                  AppLocalizations.of(context).locale.toString())),
            ),
          );
        },
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
}
