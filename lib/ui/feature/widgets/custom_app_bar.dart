import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // the title in the app bar
  final String title;
  // this is the state for opening and closing the drawer
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar(
      {Key key, @required this.title, @required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // We get the title from the constructor parameters
      title: Text(
        // Black text
        title,
        style: TextStyle(color: Colors.black),
      ),
      // We want this AppBar to have no shadow
      elevation: 0.0,
      // White background color
      backgroundColor: Colors.white,

      // Open Drawer Button
      leading: IconButton(
        // We want a black Icon
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
