import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextViewPage extends StatelessWidget {
  final String? text;
  const TextViewPage({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$text"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(text ?? ""),
        ),
      ),
    );
  }
}
