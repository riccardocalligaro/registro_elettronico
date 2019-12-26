import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/didactics/bloc.dart';
import 'package:registro_elettronico/ui/bloc/didactics/didactics_attachments/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class SchoolMaterialPage extends StatefulWidget {
  const SchoolMaterialPage({Key key}) : super(key: key);

  @override
  _SchoolMaterialPageState createState() => _SchoolMaterialPageState();
}

class _SchoolMaterialPageState extends State<SchoolMaterialPage> {
  @override
  void initState() {
    BlocProvider.of<DidacticsBloc>(context).add(GetDidactics());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        title: Text(AppLocalizations.of(context).translate('school_material')),
        scaffoldKey: _drawerKey,
      ),
      drawer: AppDrawer(
        position: DrawerConstants.SCHOOL_MATERIAL,
      ),
      body: BlocListener<DidacticsAttachmentsBloc, DidacticsAttachmentsState>(
        listener: (context, state) {
          if (state is DidacticsAttachmentsLoading) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context).translate('downloading')),
                duration: Duration(minutes: 10),
              ),
            );
          }

          if (state is DidacticsAttachmentsFileLoaded) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate('download_of_file_completed')),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context).translate('open'),
                    onPressed: () {
                      OpenFile.open(state.path);
                    },
                  ),
                ),
              );
          }
          //if(state is DidacticsAttachments)
        },
        child: _buildBlocBuilder(),
      ),
    );
  }

  Widget _buildBlocBuilder() {
    return BlocBuilder<DidacticsBloc, DidacticsState>(
      builder: (context, state) {
        if (state is DidacticsLoading || state is DidacticsUpdateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DidacticsLoaded) {
          return RefreshIndicator(
            onRefresh: _refreshDidactics,
            child: _buildList(
              teachers: state.teachers,
              folders: state.folders,
              contents: state.contents,
            ),
          );
        }

        if (state is DidacticsError || state is DidacticsUpdateError) {
          return CustomPlaceHolder(
            text: AppLocalizations.of(context)
                .translate('unexcepted_error_single'),
            icon: Icons.error,
            showUpdate: true,
            onTap: () {
              BlocProvider.of<DidacticsBloc>(context).add(UpdateDidactics());
              BlocProvider.of<DidacticsBloc>(context).add(GetDidactics());
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildList({
    List<DidacticsTeacher> teachers,
    List<DidacticsFolder> folders,
    List<DidacticsContent> contents,
  }) {
    if (teachers.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: teachers.length,
        itemBuilder: (ctx, index) {
          final teacher = teachers[index];
          final List<DidacticsFolder> foldersList = folders
              .where((folder) => folder.teacherId == teacher.id)
              .toList();

          return Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  teacher.name,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _buildFolderList(foldersList, contents)
            ],
          );
        },
      );
    }

    return CustomPlaceHolder(
      text: AppLocalizations.of(context).translate('no_school_material'),
      icon: Icons.folder,
      showUpdate: true,
      onTap: () {
        BlocProvider.of<DidacticsBloc>(context).add(UpdateDidactics());
        BlocProvider.of<DidacticsBloc>(context).add(GetDidactics());
      },
    );
  }

  Widget _buildFolderList(
      List<DidacticsFolder> folders, List<DidacticsContent> contents) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        final contentsList = contents
            .where((content) => content.folderId == folders[index].id)
            .toList();
        return ExpandableTheme(
          data:
              ExpandableThemeData(iconColor: Theme.of(context).iconTheme.color),
          child: ExpandablePanel(
            header: ListTile(
              leading: Icon(Icons.folder),
              title: Text(_getContentText(folders[index].name)),
              subtitle: Text(
                DateUtils.convertDateLocale(
                  folders[index].lastShare,
                  AppLocalizations.of(context).locale.toString(),
                ),
              ),
            ),
            expanded: _buildContentsList(contentsList),
            tapHeaderToExpand: true,
            hasIcon: true,
          ),
        );
      },
    );
  }

  String _getContentText(String text) {
    if (text.length > 0)
      return text;
    else
      return "No description";
  }

  Widget _buildContentsList(List<DidacticsContent> contents) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: contents.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        final content = contents[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
          leading: _getIconFromFileType(content.type),
          title: Text(_getContentText(content.name)),
          subtitle: Text(content.objectId.toString()),
          onTap: () async {
            Logger log = Logger();
            if (content.type == 'file') {
              final file = await _localFile(content);
              log.i("$file is a file");
              if (file.existsSync()) {
                log.i("$file exists");
                OpenFile.open(file.path);
                return;
              } else {
                log.i("$file does not exist");
              }
            }
            BlocProvider.of<DidacticsAttachmentsBloc>(context).add(
              GetAttachment(content: content),
            );
          },
        );
      },
    );
  }

  // _launchUrl(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(DidacticsContent content) async {
    final path = await _localPath;
    if (content.name.length > 0) {
      return File('$path/${content.name.replaceAll(' ', '_')}');
    } else {
      final name = content.date.millisecondsSinceEpoch.toString() +
          content.folderId.toString();
      return File('$path/${name.replaceAll(' ', '_')}');
    }
    //// final ext = attachment.fileName.split('.').last;
  }

  Future _refreshDidactics() {
    BlocProvider.of<DidacticsBloc>(context).add(UpdateDidactics());
    BlocProvider.of<DidacticsBloc>(context).add(GetDidactics());
  }

  Icon _getIconFromFileType(String fileType) {
    if (fileType == 'link') return Icon(Icons.link);
    if (fileType == 'text')
      return Icon(Icons.text_fields);
    else
      return Icon(Icons.cloud_download);
  }
}
