import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:pedantic/pedantic.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/didactics/data/datasource/didactics_local_datasource.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/content_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/folder_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/teacher_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/presentation/attachment/didactics_attachment_bloc.dart';
import 'package:registro_elettronico/feature/didactics/presentation/didactics_page.dart';
import 'package:registro_elettronico/feature/didactics/presentation/text_view_page.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherCard extends StatelessWidget {
  final DidacticsTeacherDomainModel teacher;

  const TeacherCard({
    Key key,
    @required this.teacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            teacher.name,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          // onTap: () {
          //   final DidacticsLocalDatasource didacticsLocalDatasource = sl();
          //   didacticsLocalDatasource.deleteTeacherWith(teacher.id);
          // },
        ),
        _buildFolderList(
          folders: teacher.folders,
          context: context,
        ),
      ],
    );
  }

  Widget _buildFolderList({
    @required List<FolderDomainModel> folders,
    @required BuildContext context,
  }) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        final folderContents = folders[index].contents;

        return ExpandableTheme(
          data:
              ExpandableThemeData(iconColor: Theme.of(context).iconTheme.color),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
            header: ListTile(
              leading: Icon(Icons.folder),
              title: Text(
                _getFolderText(folders[index].name, context),
              ),
              subtitle: Text(
                DateUtils.convertDateLocale(
                  folders[index].lastShareDate,
                  AppLocalizations.of(context).locale.toString(),
                ),
              ),
            ),
            expanded: _buildContentsList(
              contents: folderContents,
              context: context,
            ),
          ),
        );
      },
    );
  }

  String _getFolderText(String text, BuildContext context) {
    if (text.isNotEmpty) {
      return text;
    } else {
      return AppLocalizations.of(context).translate('no_name');
    }
  }

  Widget _buildContentsList({
    @required List<ContentDomainModel> contents,
    @required BuildContext context,
  }) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: contents.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, index) {
        final content = contents[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 32.0),
          leading: _getIconFromFileType(content.type),
          title: Text(
            content.name.isEmpty
                ? AppLocalizations.of(context).translate('no_name')
                : content.name,
          ),
          onTap: () async {
            if (content.files != null &&
                content.files.first.file != null &&
                content.files.first.file.existsSync()) {
              unawaited(OpenFile.open(content.files.first.file.path));
            } else {
              BlocProvider.of<DidacticsAttachmentBloc>(context).add(
                DownloadContentAttachment(contentDomainModel: content),
              );

              final snackBar = SnackBar(
                content: _DownloadAttachmentSnackbar(),
                duration: Duration(minutes: 1),
                behavior: SnackBarBehavior.floating,
              );

              didacticsScaffold.currentState
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
          onLongPress: () async {
            if (content.files.isNotEmpty) {
              final file = content.files.first;

              if (file.file != null && await file.file.exists()) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)
                          .translate('sure_to_delete_it')),
                      content: Text(AppLocalizations.of(context)
                          .translate('the_file_will_be_deleted')),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('cancel')
                                .toUpperCase(),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('delete')
                                .toUpperCase(),
                          ),
                          onPressed: () async {
                            await file.file.delete();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              }
            }
          },
        );
      },
    );
  }

  Icon _getIconFromFileType(ContentType type) {
    if (type == ContentType.url) {
      return Icon(Icons.link);
    } else if (type == ContentType.text) {
      return Icon(Icons.text_fields);
    } else {
      return Icon(Icons.cloud_download);
    }
  }
}

class _DownloadAttachmentSnackbar extends StatelessWidget {
  const _DownloadAttachmentSnackbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DidacticsAttachmentBloc, DidacticsAttachmentState>(
      listener: (context, state) async {
        if (state is DidacticsAttachmentDownloadFailure ||
            state is DidacticsAttachmentFileDownloadSuccess) {
          await Future.delayed(Duration(seconds: 3)).then((value) =>
              didacticsScaffold.currentState..removeCurrentSnackBar());
        }

        if (state is DidacticsAttachmentFileDownloadSuccess) {
          unawaited(OpenFile.open(state.didacticsFile.file.path));
        } else if (state is DidacticsAttachmentURLDownloadSuccess) {
          final url = state.urlContentRemoteModel.item.link;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        } else if (state is DidacticsAttachmentTextDownloadSuccess) {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TextViewPage(
              text: state.textContentRemoteModel.text,
            ),
          ));
        }
      },
      builder: (context, state) {
        if (state is DidacticsAttachmentFileDownloadSuccess ||
            state is DidacticsAttachmentTextDownloadSuccess ||
            state is DidacticsAttachmentURLDownloadSuccess) {
          return Text(AppLocalizations.of(context)
              .translate('file_downloaded_success'));
        } else if (state is DidacticsAttachmentDownloadFailure) {
          return Text(AppLocalizations.of(context).translate('error_download'));
        } else if (state is DidacticsAttachmentDownloadInProgress) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate('downloading'),
              ),
              if (state.percentage < 0)
                Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    value: state.percentage,
                  ),
                ),
              if (state.percentage >= 0)
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
