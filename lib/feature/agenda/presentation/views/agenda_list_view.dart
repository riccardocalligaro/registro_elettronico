// import 'package:flutter/material.dart';
// import 'package:indexed_list_view/indexed_list_view.dart';
// import 'package:registro_elettronico/data/db/moor_database.dart';
// import 'package:registro_elettronico/utils/global_utils.dart';
// import 'package:registro_elettronico/utils/string_utils.dart';

// class AgendaListView extends StatefulWidget {
//   final List<AgendaEvent> events;

//   const AgendaListView({
//     Key key,
//     @required this.events,
//   }) : super(key: key);

//   @override
//   _AgendaListViewState createState() => _AgendaListViewState();
// }

// class _AgendaListViewState extends State<AgendaListView> {
//   IndexedScrollController _scrollController;

//   @override
//   void initState() {
//     int _index;
//     for (var i = 0; i < widget.events.length; i++) {
//       if (widget.events[i].begin.isAfter(DateTime.now())) {
//         _index = i;
//         break;
//       }
//     }

//     if (_index == null) _index = 0;

//     _scrollController = IndexedScrollController(initialIndex: _index);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildAgendaList(widget.events);
//   }

//   Widget _buildAgendaList(List<AgendaEvent> events) {
//     return IndexedListView.builder(
//       controller: _scrollController,
//       padding: EdgeInsets.all(8.0),
//       maxItemCount: events.length,
//       minItemCount: 0,

//       // itemCount: events.length,
//       itemBuilder: (context, index) {
//         return _buildEventCard(events[index], context);
//       },
//     );
//   }

//   Widget _buildEventCard(AgendaEvent e, BuildContext context) {
//     if (e.isLocal) {
//       return Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SizedBox(
//             width: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   '${e.title ?? ''}',
//                   style: TextStyle(fontSize: 15.0),
//                 ),
//                 SizedBox(
//                   height: 2.5,
//                 ),
//                 Text(
//                   '${e.notes ?? ''} - ${GlobalUtils.getEventDateMessage(context, e.begin)}',
//                   style: TextStyle(fontSize: 12.0),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 '${e.notes ?? ''}',
//                 style: TextStyle(fontSize: 15.0),
//               ),
//               SizedBox(
//                 height: 2.5,
//               ),
//               Text(
//                 '${StringUtils.titleCase(e.authorName)} - ${GlobalUtils.getEventDateMessage(context, e.begin)}',
//                 style: TextStyle(fontSize: 12.0),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
