// import 'package:flutter/material.dart';

// class SelectRepeatNotificationDialog extends StatefulWidget {
//   final Duration repeat;

//   SelectRepeatNotificationDialog({
//     Key key,
//     this.repeat,
//   }) : super(key: key);

//   @override
//   _SelectRepeatNotificationDialogState createState() =>
//       _SelectRepeatNotificationDialogState();
// }

// class _SelectRepeatNotificationDialogState
//     extends State<SelectRepeatNotificationDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Seleziona ripetizione'),
//       content: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               RadioListTile(
//                 title: Text(
//                   'Non si ripete',
//                   style: TextStyle(fontSize: 13),
//                 ),
//                 value: Duration(milliseconds: 0),
//                 groupValue: widget.repeat,
//                 onChanged: (Duration duration) {
//                   Navigator.pop(context, duration);
//                 },
//               ),
//               RadioListTile(
//                 title: Text(
//                   'Ogni giorno',
//                   style: TextStyle(fontSize: 13),
//                 ),
//                 value: Duration(days: 1),
//                 groupValue: widget.repeat,
//                 onChanged: (Duration duration) {
//                   Navigator.pop(context, duration);
//                 },
//               ),
//               RadioListTile(
//                 title: Text(
//                   'Ogni 7 giorni',
//                   style: TextStyle(fontSize: 13),
//                 ),
//                 value: Duration(days: 7),
//                 groupValue: widget.repeat,
//                 onChanged: (Duration duration) {
//                   Navigator.pop(context, duration);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
