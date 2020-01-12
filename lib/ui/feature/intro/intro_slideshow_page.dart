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

    slides.add(_getNotificationsSwipetItem());
    slides.add(
      SwiperItem(
        centerWidget: IntroThemeChooser(),
        title: AppLocalizations.of(context).translate('theme'),
        dy: -110,
        description: '',
      ),
    );

    slides.add(
      SwiperItem(
        centerWidget: IntroDownloadLiquidCircle(),
        title: 'Download',
        dy: -90,
        description: AppLocalizations.of(context)
            .translate('download_slide_description'),
      ),
    );
    return slides;
  }

  SwiperItem _getNotificationsSwipetItem() {
    return SwiperItem(
      centerWidget: AlignPositioned(
        dy: 210,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            children: <Widget>[
              NotificationsSettingsDialog(),
            ],
          ),
        ),
      ),
      title: AppLocalizations.of(context).translate('notifications'),
      description: '',
    );
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
