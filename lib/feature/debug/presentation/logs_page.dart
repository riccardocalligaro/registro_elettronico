import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key key}) : super(key: key);

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  ScrollController _scrollController;
  bool _goDown = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Logger.clearLogs();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          _goDown ? Icons.expand_more : Icons.expand_less,
          color: Colors.white,
        ),
        onPressed: () {
          if (_goDown) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          } else {
            _scrollController.jumpTo(0);
          }
          setState(() {
            _goDown = !_goDown;
          });
        },
      ),
      body: FutureBuilder(
        future: getLogs(),
        builder: (context, snapshot) {
          final data = snapshot.data;

          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            controller: _scrollController,
            child: SelectableText(data),
          );
        },
      ),
    );
  }

  Future<String> getLogs() async {
    final file = await Logger.getLogsFile();
    String logs = file.readAsStringSync();
    logs += "\n\n\n\n\n\n";
    return logs;
  }
}
