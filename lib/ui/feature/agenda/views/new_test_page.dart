import 'package:flutter/material.dart';

class NewTestPage extends StatefulWidget {
  NewTestPage({Key key}) : super(key: key);

  @override
  _NewTestPageState createState() => _NewTestPageState();
}

class _NewTestPageState extends State<NewTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New event'),
      ),
      // bottomSheet: InkWell(
      //   onTap: () {},
      //   child: Container(
      //     height: 50,
      //     child: Center(
      //       child: Text(
      //         'Aggiungi'.toUpperCase(),
      //         style: TextStyle(
      //           fontSize: 15,
      //           color: Colors.red,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Titolo',
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Row(
                            //  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.label),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Etichetta'),
                                ],
                              ),
                              ClipOval(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.today),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Data'),
                                ],
                              ),
                              Text('Today'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      // body: ListView(
      //   children: <Widget>[
      //     Container(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      //       //color: Colors.grey[800],
      //       child: TextField(
      //         scrollPadding: EdgeInsets.zero,
      //         maxLines: null,
      //         decoration: InputDecoration(
      //           contentPadding: EdgeInsets.zero,
      //           //border: InputBorder.none,
      //           hintText: 'Aggiungi un titolo',
      //           hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
      //         ),
      //       ),
      //     ),
      //     Container(
      //       //color: Colors.grey[800],
      //       child: Material(
      //         color: Colors.transparent,
      //         child: InkWell(
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) => SelectSubjectDialog(),
      //             );
      //           },
      //           child: Padding(
      //             padding: const EdgeInsets.symmetric(
      //               horizontal: 16.0,
      //               vertical: 16.0,
      //             ),
      //             child: Row(
      //               children: <Widget>[
      //                 Icon(Icons.school),
      //                 SizedBox(
      //                   width: 16,
      //                 ),
      //                 Text(
      //                   'Choose a subject',
      //                   style: TextStyle(
      //                     color: Colors.grey[300],
      //                     fontSize: 14,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     // SizedBox(
      //     //   height: 20,
      //     // ),
      //     Container(
      //       // color: Colors.grey[800],
      //       child: Material(
      //         color: Colors.transparent,
      //         child: InkWell(
      //           onTap: () {},
      //           child: Padding(
      //             padding: const EdgeInsets.symmetric(
      //               horizontal: 16.0,
      //               vertical: 16.0,
      //             ),
      //             child: Row(
      //               children: <Widget>[
      //                 Icon(Icons.calendar_today),
      //                 SizedBox(
      //                   width: 16,
      //                 ),
      //                 Text(
      //                   'Choose a date',
      //                   style: TextStyle(
      //                     color: Colors.grey[300],
      //                     fontSize: 14,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),

      //     Container(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      //       child: TextField(
      //         scrollPadding: EdgeInsets.zero,
      //         maxLines: null,
      //         decoration: InputDecoration(
      //           contentPadding: EdgeInsets.zero,
      //           hintText: 'Aggiungi una nota',
      //           hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Container(
      //         height: 50,
      //         child: FlatButton(
      //           child: Text('ADD'),
      //           onPressed: () {},
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
