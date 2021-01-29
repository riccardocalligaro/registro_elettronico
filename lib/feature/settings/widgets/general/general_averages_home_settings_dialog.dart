// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:registro_elettronico/utils/global_utils.dart';

// class GeneralAveragesHomeSettings extends StatefulWidget {
//   final int period;
//   const GeneralAveragesHomeSettings({Key key, @required this.period})
//       : super(key: key);

//   @override
//   _GeneralAveragesHomeSettingsState createState() =>
//       _GeneralAveragesHomeSettingsState();
// }

// class _GeneralAveragesHomeSettingsState
//     extends State<GeneralAveragesHomeSettings> {
//   @override
//   void initState() {
//     BlocProvider.of<PeriodsBloc>(context).add(GetPeriods());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     int period = widget.period;
//     return Container(
//       width: double.maxFinite,
//       child: Column(
//         children: <Widget>[
//           RadioListTile(
//             title: Text(GlobalUtils.getPeriodName(period, context)),
//             value: -3,
//             groupValue: period,
//             onChanged: (value) {
//               setState(() {
//                 period = value;
//               });
//               //Navigator.pop(context, value);
//             },
//           ),
//           BlocBuilder<PeriodsBloc, PeriodsState>(
//             builder: (context, state) {
//               if (state is PeriodsLoaded) {
//                 final periods = state.periods;
//                 return Container(
//                   width: double.maxFinite,
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: periods.length,
//                     itemBuilder: (context, index) {
//                       return RadioListTile(
//                         title: Text(GlobalUtils.getPeriodName(
//                             periods[index].periodIndex, context)),
//                         value: periods[index].position,
//                         groupValue: period,
//                         onChanged: (value) {
//                           setState(() {
//                             period = value;
//                           });
//                           //Navigator.pop(context, value);
//                         },
//                       );
//                     },
//                   ),
//                 );
//               }
//               return Container();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
