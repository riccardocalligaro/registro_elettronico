import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

import 'components/content_card.dart';
import 'components/theme_content_card.dart';

class IntroSlideshowPage extends StatefulWidget {
  IntroSlideshowPage({Key key}) : super(key: key);

  @override
  _IntroSlideshowPageState createState() => _IntroSlideshowPageState();
}

/// The [intro] the user sees when the login finishes
class _IntroSlideshowPageState extends State<IntroSlideshowPage> {
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return Scaffold(
      body: Builder(
        builder: (context) => LiquidSwipe(
          fullTransitionValue: 300,
          enableLoop: false,
          pages: <Container>[
            Container(
              child: ContentCard(
                index: 0,
                title: trans.translate('slide_1_title'),
                subtitle: trans.translate('slide_1_subtitle'),
                centerWidget: Icon(
                  Icons.school,
                  color: Colors.red,
                  size: 150,
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.white,
              ),
            ),
            Container(
              child: ContentCard(
                index: 1,
                title: trans.translate('slide_2_title'),
                subtitle: trans.translate('slide_2_subtitle'),
                centerWidget: Icon(
                  Icons.insert_chart,
                  color: Colors.white,
                  size: 150,
                ),
                backgroundColor: Colors.red,
                textColor: Colors.white,
              ),
            ),
            Container(
              child: ContentCard(
                index: 2,
                title: trans.translate('slide_3_title'),
                subtitle: trans.translate('slide_3_subtitle'),
                centerWidget: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 150,
                ),
                backgroundColor: Colors.indigo,
                textColor: Colors.white,
              ),
            ),
            Container(
              child: ContentCard(
                index: 3,
                title: 'Da studenti',
                subtitle: 'Siamo un gruppo di pochi studenti.\nLe donazioni ci aiutano a mantenere l\'app.',
                centerWidget: Icon(
                  Icons.group,
                  color: Colors.white,
                  size: 150,
                ),
                backgroundColor: Colors.purple,
                textColor: Colors.white,
              ),
            ),
            Container(
              child: ThemeContentCard(
                title: trans.translate('slide_4_title'),
                subtitle: trans.translate('slide_4_subtitle'),
                index: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
