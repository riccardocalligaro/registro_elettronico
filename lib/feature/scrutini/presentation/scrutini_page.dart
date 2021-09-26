import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/core/presentation/widgets/custom_refresher.dart';
import 'package:registro_elettronico/feature/authentication/presentation/token/token_bloc.dart';
import 'package:registro_elettronico/feature/web/presentation/spaggiari_web_view_no_persistency.dart';

import 'bloc/document_attachment/document_attachment_bloc.dart';
import 'bloc/documents_bloc.dart';

class ScrutiniPage extends StatefulWidget {
  const ScrutiniPage({Key? key}) : super(key: key);

  @override
  _ScrutiniPageState createState() => _ScrutiniPageState();
}

class _ScrutiniPageState extends State<ScrutiniPage> {
  @override
  void initState() {
    BlocProvider.of<DocumentsBloc>(context).add(GetDocuments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          title: Text(AppLocalizations.of(context)!.translate('scrutini')!),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TokenBloc, TokenState>(
              listener: (context, state) {
                if (state is TokenLoadInProgress) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!
                              .translate('loading')!),
                          Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.red,
                            ),
                          )
                        ],
                      ),
                      duration: Duration(minutes: 1),
                    ),
                  );
                } else if (state is TokenSchoolReportLoadSuccess) {
                  ScaffoldMessenger.of(context)..removeCurrentSnackBar();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SpaggiariWebViewNoPersistency(
                        phpSessid: state.token,
                        url: state.schoolReport.viewLink,
                        appBarTitle: state.schoolReport.description,
                      ),
                    ),
                  );
                } else if (state is TokenLoadError) {
                  ScaffoldMessenger.of(context)..removeCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        AppLocalizations.of(context)!
                            .translate('unexcepted_error_single')!,
                      ),
                    ),
                  );
                } else if (state is TokenLoadNotConnected) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        AppNavigator.instance!.getNetworkErrorSnackBar(context));
                }
              },
            ),
            BlocListener<DocumentAttachmentBloc, DocumentAttachmentState>(
              listener: (context, state) {
                if (state is DocumentLoadInProgress) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.translate('loading')!,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                            )
                          ],
                        ),
                        duration: Duration(minutes: 1),
                      ),
                    );
                } else if (state is DocumentNotAvailable) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(AppLocalizations.of(context)!
                            .translate('document_not_available')!),
                      ),
                    );
                } else if (state is DocumentLoadSuccess) {
                  Logger.info(state.path);
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          AppLocalizations.of(context)!
                              .translate('download_of_file_completed')!
                              .replaceAll('{fileName}', state.path),
                        ),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context)!
                              .translate('open')!
                              .toUpperCase(),
                          onPressed: () {
                            OpenFile.open(state.path);
                          },
                        ),
                      ),
                    );
                } else if (state is DocumentLoadedLocally) {
                  ScaffoldMessenger.of(context)..removeCurrentSnackBar();
                  OpenFile.open(state.path);
                } else if (state is DocumentAttachmentDeleteSuccess) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(AppLocalizations.of(context)!
                            .translate('deleted_success')!),
                      ),
                    );
                } else if (state is DocumentAttachmentError) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(AppLocalizations.of(context)!
                            .translate('error_emoji')!),
                      ),
                    );
                } else if (state is DocumentLoadNotConnected) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        AppNavigator.instance!.getNetworkErrorSnackBar(context));
                }
              },
              child: Container(),
            ),
            BlocListener<DocumentsBloc, DocumentsState>(
              listener: (context, state) {
                if (state is DocumentsLoadNotConnected) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        AppNavigator.instance!.getNetworkErrorSnackBar(context));
                }
              },
            )
          ],
          child: BlocBuilder<DocumentsBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsLoadSuccess) {
                if (state.documents.isEmpty && state.documents.isEmpty) {
                  return CustomPlaceHolder(
                    icon: Icons.import_contacts,
                    showUpdate: true,
                    text: AppLocalizations.of(context)!
                        .translate('no_final_grades'),
                    onTap: () {
                      BlocProvider.of<DocumentsBloc>(context)
                          .add(UpdateDocuments());
                      BlocProvider.of<DocumentsBloc>(context)
                          .add(GetDocuments());
                    },
                  );
                }
                return CustomRefresher(
                  onRefresh: () {
                    BlocProvider.of<DocumentsBloc>(context)
                        .add(UpdateDocuments());
                    BlocProvider.of<DocumentsBloc>(context).add(GetDocuments());
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: _buildDocumentsList(
                        documents: state.documents,
                        schoolReports: state.schoolReports,
                      ),
                    ),
                  ),
                );
              }

              if (state is DocumentsUpdateLoadError ||
                  state is DocumentsLoadError) {
                return CustomPlaceHolder(
                  icon: Icons.error,
                  text: AppLocalizations.of(context)!
                      .translate('unexcepted_error'),
                  showUpdate: true,
                  onTap: () {
                    BlocProvider.of<DocumentsBloc>(context)
                        .add(UpdateDocuments());
                  },
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }

  Widget _buildDocumentsList({
    required List<SchoolReport> schoolReports,
    required List<Document> documents,
  }) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.translate('scrutini_documents')!,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: schoolReports.length,
          itemBuilder: (context, index) {
            final report = schoolReports[index];
            return ListTile(
              title: Text(report.description!),
              onTap: () {
                BlocProvider.of<TokenBloc>(context)
                    .add(GetLoginTokenForSchoolReport(
                  schoolReport: report,
                ));
              },
            );
          },
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.translate('scrutini_school_reports')!,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            return ListTile(
              title: Text(document.description!),
              onTap: () {
                BlocProvider.of<DocumentAttachmentBloc>(context).add(
                  GetDocumentAttachment(document: document),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!
                          .translate('sure_to_delete_it')!),
                      content: Text(AppLocalizations.of(context)!
                          .translate('the_file_will_be_deleted')!),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('cancel')!
                                .toUpperCase(),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('delete')!
                                .toUpperCase(),
                          ),
                          onPressed: () {
                            BlocProvider.of<DocumentAttachmentBloc>(context)
                                .add(DeleteDocumentAttachment(
                                    document: document));
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            );
          },
        )
      ],
    );
  }
}
