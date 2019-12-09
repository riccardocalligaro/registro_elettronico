import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Briefing',
          ),
          _createDrawerItem(
            icon: Icons.library_books,
            text: 'Lessons',
          ),
          _createDrawerItem(
            icon: Icons.timeline,
            text: 'Grades',
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: 'Agenda',
          ),
          _createDrawerItem(
            icon: Icons.folder,
            text: 'Materiale didattico',
          ),
          _createDrawerItem(
            icon: Icons.assessment,
            text: 'Assenze',
          ),
          _createDrawerItem(
            icon: Icons.warning,
            text: 'Note',
          ),
          _createDrawerItem(
            icon: Icons.assignment,
            text: 'Comunicazioni',
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Impostazioni',
          ),
          _createDrawerItem(
            icon: Icons.share,
            text: 'Condividi',
          ),
           _createDrawerItem(
            icon: Icons.send,
            text: 'Contattaci',
          ),
         
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountEmail: Text("example@example.com"),
      accountName: Text("John Doe"),
      decoration: BoxDecoration(color: Theme.of(context).accentColor),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
