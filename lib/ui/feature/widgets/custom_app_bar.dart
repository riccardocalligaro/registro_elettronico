import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // the title in the app bar
  final Widget title;
  // this is the state for opening and closing the drawer
  final GlobalKey<ScaffoldState> scaffoldKey;
  //  tab bar
  final TabBar tabBar;
  // Actions
  final List<Widget> actions;
  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.scaffoldKey,
    this.tabBar,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // We get the title from the constructor parameters
      title: title,

      // We want this AppBar to have no shadow
      elevation: 0.0,
      bottom: tabBar,
      // Open Drawer Button
      iconTheme: Theme.of(context).primaryIconTheme,
      textTheme: Theme.of(context).primaryTextTheme,
      leading: IconButton(
        // We want a black Icon
        icon: Icon(
          Icons.menu,
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
