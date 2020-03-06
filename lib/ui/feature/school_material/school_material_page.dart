import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:open_file/open_file.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/didactics/bloc.dart';
import 'package:registro_elettronico/ui/bloc/didactics/didactics_attachments/bloc.dart';
import 'package:registro_elettronico/ui/feature/school_material/text_view_page.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolMaterialPage extends StatefulWidget {
  const SchoolMaterialPage({Key key}) : super(key: key);

  @override
  _SchoolMaterialPageState createState() => _SchoolMaterialPageState();
}

class _SchoolMaterialPageState extends State<SchoolMaterialPage> {
  int _schoolMaterialLastUpdate;

  // Search box
  final TextEditingController _filter = TextEditingController();

  String _searchText = "";

  // List<DidacticsContent> content = List();

  // List<DidacticsContent> filteredContent = List();

  Icon _searchIcon = Icon(Icons.search);

  Widget _appBarTitle;

  bool _showResearch = false;

  _SchoolMaterialPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _showResearch = false;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          _showResearch = true;
        });
      }
    });
  }

  @override
  void initState() {
    restore();

    BlocProvider.of<DidacticsBloc>(context).add(GetDidactics());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appBarTitle =
        Text(AppLocalizations.of(context).translate('school_material'));
    super.didChangeDependencies();
  }

  void restore() async {
    SharedPreferences sharedPreferences = Injector.appInstance.getDependency();

    setState(() {
      _schoolMaterialLastUpdate =
          sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_SCHOOL_MATERIAL);
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "${AppLocalizations.of(context).translate('search')}...",
            border: InputBorder.none,
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle =
            Text(AppLocalizations.of(context).translate('school_material'));
        //filteredNames = names;
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: _appBarTitle,
        brightness: Theme.of(context).brightness,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              _searchPressed();
            },
          )
        ],
      ),
      bottomSheet: LastUpdateBottomSheet(
        millisecondsSinceEpoch: _schoolMaterialLastUpdate,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DidacticsBloc, DidacticsState>(
            listener: (context, state) {
              if (state is DidacticsErrorNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    AppNavigator.instance.getNetworkErrorSnackBar(context),
                  );
              }
              if (state is DidacticsUpdateLoaded) {
                setState(() {
                  _schoolMaterialLastUpdate =
                      DateTime.now().millisecondsSinceEpoch;
                });
              }
            },
          ),
          BlocListener<DidacticsAttachmentsBloc, DidacticsAttachmentsState>(
            listener: (context, state) async {
              if (state is DidacticsAttachmentsErrorNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    AppNavigator.instance.getNetworkErrorSnackBar(context),
                  );
              }
              if (state is DidacticsAttachmentsLoading) {
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
                      duration: Duration(minutes: 10),
                    ),
                  );
              }

              if (state is DidacticsAttachmentsFileLoaded) {
                OpenFile.open(state.path);
                Scaffold.of(context)..removeCurrentSnackBar();
              }

              if (state is DidacticsAttachmentsURLLoaded) {
                final url = state.url;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
                Scaffold.of(context)..removeCurrentSnackBar();
              }

              if (state is DidacticsAttachmentsTextLoaded) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TextViewPage(
                    text: state.text,
                  ),
                ));
                Scaffold.of(context)..removeCurrentSnackBar();
              }
              //if(state is DidacticsAttachments)
            },
          ),
        ],
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
          return _buildList(
            teachers: state.teachers,
            folders: state.folders,
            contents: state.contents,
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
    List<DidacticsFolder> foldersResult;
    if (_showResearch) {
      foldersResult = folders
          .where(
              (f) => f.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    } else {
      foldersResult = folders;
    }

    if (teachers.length > 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: CustomRefresher(
          onRefresh: _refreshDidactics,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: teachers.length,
            itemBuilder: (ctx, index) {
              final teacher = teachers[index];
              final List<DidacticsFolder> foldersList = foldersResult
                  .where((folder) => folder.teacherId == teacher.id)
                  .toList();

              if (foldersList.length > 0) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        teacher.name,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    // ListTile(
                    //   title: Text(
                    //     GlobalUtils.getMockupName().toUpperCase(),
                    //     style: TextStyle(color: Colors.red),
                    //   ),
                    // ),
                    _buildFolderList(foldersList, contents)
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
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
      padding: EdgeInsets.zero,
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
              title: Text(_getFolderText(folders[index].name)),
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

  String _getFolderText(String text) {
    if (text.length > 0)
      return text;
    else
      return AppLocalizations.of(context).translate('no_name');
  }

  Widget _buildContentsList(List<DidacticsContent> contents) {
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
          title: FutureBuilder(
            future: _getContentText(content),
            initialData: '',
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(snapshot.data);
            },
          ),
          onTap: () async {
            /// Opens the [attachment]
            BlocProvider.of<DidacticsAttachmentsBloc>(context).add(
              GetAttachment(content: content),
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
                        BlocProvider.of<DidacticsAttachmentsBloc>(context)
                            .add(DeleteAttachment(content: content));
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
    );
  }

  Future<String> _getContentText(DidacticsContent content) async {
    if (content.name.length > 0) {
      return content.name;
    }

    return AppLocalizations.of(context).translate('no_name');
  }

  Future<void> _refreshDidactics() async {
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
