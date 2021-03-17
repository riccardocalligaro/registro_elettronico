import 'dart:io';

import 'package:dartz/dartz.dart' hide OpenFile;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/attachment_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/attachment/attachment_download_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class NoticeCard extends StatelessWidget {
  final NoticeDomainModel notice;
  final Function showDownloadSnackbar;

  const NoticeCard({
    Key key,
    @required this.notice,
    @required this.showDownloadSnackbar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Text(notice.contentTitle),
          subtitle: Text(
            SRDateUtils.convertDateLocale(
              notice.date,
              AppLocalizations.of(context).locale.toString(),
            ),
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
          onTap: () {
            if (notice.attachments != null) {
              _showDownloadDialog(context);
            }
          },
          onLongPress: () {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  AppLocalizations.of(context)
                      .translate('delete_notice_snackbar_info'),
                ),
              ));
          },
        ),
      ),
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          AppLocalizations.of(context).translate('select_attachment'),
        ),
        children: <Widget>[
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notice.attachments.length,
              itemBuilder: (ctx, index) {
                if (notice.attachments.isNotEmpty) {
                  final attachment = notice.attachments[index];
                  return ListTile(
                    title: Text(attachment.fileName),
                    onLongPress: () async {
                      final fileExists = await _checkIfFileExists(
                        notice: notice,
                        attachment: attachment,
                      );

                      await fileExists.fold(
                        (l) => null,
                        (r) async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)
                                  .translate('delete_notice_alert_title')),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(AppLocalizations.of(context)
                                      .translate('no')
                                      .toUpperCase()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('yes')
                                        .toUpperCase(),
                                  ),
                                  onPressed: () async {
                                    await r.delete();
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    onTap: () async {
                      // controlliamo che il file non sia già stato scaricato
                      final fileExists = await _checkIfFileExists(
                        notice: notice,
                        attachment: attachment,
                      );

                      await fileExists.fold(
                        (fileDoesentExist) async {
                          // è necessario scaricarlo

                          BlocProvider.of<AttachmentDownloadBloc>(context).add(
                            DownloadAttachment(
                              attachment: attachment,
                              notice: notice,
                            ),
                          );

                          showDownloadSnackbar();

                          Navigator.pop(context);
                        },
                        (file) async {
                          await OpenFile.open(file.path);
                        },
                      );
                    },
                  );
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context).translate('no_attachments'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Either<FileNotExists, File>> _checkIfFileExists({
    @required NoticeDomainModel notice,
    @required AttachmentDomainModel attachment,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    final ext = attachment.fileName.split('.').last;

    final file = File(
      '$path/${notice.contentTitle.replaceAll('/', '').replaceAll(' ', '_')}-${attachment.pubId}${attachment.attachNumber}.$ext',
    );

    if (await file.exists()) {
      return Right(file);
    } else {
      return Left(FileNotExists());
    }
  }
}

class FileNotExists {}
