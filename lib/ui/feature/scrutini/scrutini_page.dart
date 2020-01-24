import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:open_file/open_file.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/dao/document_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/documents/bloc.dart';
import 'package:registro_elettronico/ui/bloc/documents/document_attachment/bloc/bloc.dart';
import 'package:registro_elettronico/ui/bloc/token/bloc.dart';
import 'package:registro_elettronico/ui/feature/scrutini/web/spaggiari_web_view.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScrutiniPage extends StatefulWidget {
  const ScrutiniPage({Key key}) : super(key: key);

  @override
  _ScrutiniPageState createState() => _ScrutiniPageState();
}

class _ScrutiniPageState extends State<ScrutiniPage> {
  //GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _scrutiniLastUpdate;

  @override
  void initState() {
    BlocProvider.of<DocumentsBloc>(context).add(GetDocuments());

    restore();
    super.initState();
  }

  void restore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _scrutiniLastUpdate =
          sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_SCRUTINI);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //key: _drawerKey,
        appBar: AppBar(
          //scaffoldKey: _drawerKey,
          title: Text(AppLocalizations.of(context).translate('scrutini')),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                DocumentsDao documentsDao =
                    DocumentsDao(Injector.appInstance.getDependency());
                documentsDao.deeteAllDocuments();
                documentsDao.deeteAllDocuments();
              },
            )
          ],
        ),
        // drawer: AppDrawer(
        //   position: DrawerConstants.SCRUTINI,
        // ),
        bottomSheet: LastUpdateBottomSheet(
          millisecondsSinceEpoch: _scrutiniLastUpdate,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TokenBloc, TokenState>(
              listener: (context, state) {
                if (state is TokenLoadInProgress) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                              .translate('loading')),
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
                  Scaffold.of(context)..removeCurrentSnackBar();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SpaggiariWebView(
                        phpSessid: state.token,
                        url: state.schoolReport.viewLink,
                        appBarTitle: state.schoolReport.description,
                      ),
                    ),
                  );
                } else if (state is TokenLoadError) {
                  Scaffold.of(context)..removeCurrentSnackBar();

                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        AppLocalizations.of(context)
                            .translate('unexcepted_error_single'),
                      ),
                    ),
                  );
                } else if (state is TokenLoadNotConnected) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        AppNavigator.instance.getNetworkErrorSnackBar(context));
                }
              },
            ),
            BlocListener<DocumentAttachmentBloc, DocumentAttachmentState>(
              listener: (context, state) {
                if (state is DocumentLoadInProgress) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('loading'),
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
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(AppLocalizations.of(context)
                            .translate('document_not_available')),
                      ),
                    );
                } else if (state is DocumentLoadSuccess) {
                  FLog.info(text: state.path);
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
                          onPressed: () {
                            OpenFile.open(state.path);
                          },
                        ),
                      ),
                    );
                } else if (state is DocumentLoadedLocally) {
                  Scaffold.of(context)..removeCurrentSnackBar();
                  OpenFile.open(state.path);
                } else if (state is DocumentAttachmentDeleteSuccess) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(AppLocalizations.of(context)
                            .translate('deleted_success')),
                      ),
                    );
                } else if (state is DocumentAttachmentError) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(AppLocalizations.of(context)
                            .translate('error_emoji')),
                      ),
                    );
                } else if (state is DocumentLoadNotConnected) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        AppNavigator.instance.getNetworkErrorSnackBar(context));
                }
              },
              child: Container(),
            ),
            BlocListener<DocumentsBloc, DocumentsState>(
              listener: (context, state) {
                if (state is DocumentsUpdateLoadSuccess) {
                  setState(() {
                    _scrutiniLastUpdate = DateTime.now().millisecondsSinceEpoch;
                  });
                } else if (state is DocumentsLoadNotConnected) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        AppNavigator.instance.getNetworkErrorSnackBar(context));
                }
              },
            )
          ],
          child: BlocBuilder<DocumentsBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsLoadSuccess) {
                if (state.documents.length == 0 &&
                    state.documents.length == 0) {
                  return CustomPlaceHolder(
                    icon: Icons.import_contacts,
                    showUpdate: true,
                    text: AppLocalizations.of(context)
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
                  text: AppLocalizations.of(context)
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
    @required List<SchoolReport> schoolReports,
    @required List<Document> documents,
  }) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).translate('scrutini_documents'),
            style: TextStyle(color: Colors.red),
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
              title: Text(report.description),
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
            AppLocalizations.of(context).translate('scrutini_school_reports'),
            style: TextStyle(color: Colors.red),
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
              title: Text(document.description),
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
