import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:registro_elettronico/ui/feature/intro/components/download_liquid_circle.dart';
import 'package:registro_elettronico/ui/feature/intro/components/intro_item.dart';
import 'package:registro_elettronico/ui/feature/intro/components/theme_chooser.dart';
import 'package:registro_elettronico/ui/feature/settings/components/notifications/notifications_type_settings_dialog.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSlideshowPage extends StatefulWidget {
  IntroSlideshowPage({Key key}) : super(key: key);

  @override
  _IntroSlideshowPageState createState() => _IntroSlideshowPageState();
}

class _IntroSlideshowPageState extends State<IntroSlideshowPage> {
  bool _firstPage = true;
  bool _notificationsActivated = false;
  bool upDirection;

  double height = 50;

  @override
  void initState() {
    super.initState();
    restore();
  }

  void restore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _notificationsActivated =
        sharedPreferences.getBool(PrefsConstants.NOTIFICATIONS) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final items = _getSwiperItems();
    return Scaffold(
      body: _firstPage
          ? _getFirstPage()
          : Swiper(
              loop: false,
              pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(color: Colors.grey[300]),
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return IntroItem(
                  title: items[index].title,
                  centerWidget: items[index].centerWidget,
                  description: items[index].description,
                  additionalWidgets: items[index].additionalWigets,
                  dy: items[index].dy,
                );
              },
            ),
    );
  }

  List<SwiperItem> _getSwiperItems() {
    List<SwiperItem> slides = [];
    // slides.add(
    //   SwiperItem(
    //     centerWidget: _getSwiperIconFromIconData(Icons.timeline),
    //     title: 'Stats',
    //     description:
    //         'You might wanna check the amazing graphs and stats we offer in the grades page',
    //   ),
    // );

    slides.add(_getNotificationsSwipetItem());
    slides.add(
      SwiperItem(
        centerWidget: IntroThemeChooser(),
        title: AppLocalizations.of(context).translate('theme'),
        dy: -110,
        description: '',
        //description: 'Set the application theme',
      ),
    );

    slides.add(
      SwiperItem(
        centerWidget: IntroDownloadLiquidCircle(),
        title: 'Download',
        dy: -90,
        description:
            'This is data is vital for the correct functioning of the application',
      ),
    );
    return slides;
  }

  SwiperItem _getNotificationsSwipetItem() {
    return SwiperItem(
        centerWidget: AlignPositioned(
          dy: 260,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: NotificationsSettingsDialog(),
          ),
        ),
        // centerWidget: Column(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: <Widget>[
        //     _getSwiperIconFromIconData(Icons.notifications),
        //   ],
        // ),
        title: AppLocalizations.of(context).translate('notifications'),
        // additionalWigets: [
        //   AlignPositioned(
        //     alignment: Alignment.topCenter,
        //     dy: 500,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //       child: Switch(
        //         activeColor: Colors.red,
        //         value: _notificationsActivated,
        //         onChanged: (value) async {
        //           setState(() {
        //             _notificationsActivated = !_notificationsActivated;
        //           });

        //           SharedPreferences sharedPreferences =
        //               await SharedPreferences.getInstance();
        //           sharedPreferences.setBool(
        //               PrefsConstants.NOTIFICATIONS, value);
        //         },
        //       ),
        //     ),
        //   ),
        // ],
        description: '');
    // description:
    //     'Press the switch to activate notifications, you can later set more preferences about when to check');
  }

  Widget _getFirstPage() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.school,
                color: Theme.of(context).accentColor,
                size: 142,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.navigate_next),
                onPressed: () {
                  setState(() {
                    _firstPage = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getSwiperIconFromIconData(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).accentColor,
      size: 142,
    );
  }
}

class SwiperItem {
  final String title;
  final Widget centerWidget;
  final String description;
  final double dy;
  final List<Widget> additionalWigets;

  const SwiperItem({
    @required this.title,
    @required this.centerWidget,
    @required this.description,
    this.dy,
    this.additionalWigets,
  });
}
