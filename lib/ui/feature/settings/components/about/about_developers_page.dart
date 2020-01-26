import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/feature/settings/components/header_text.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDevelopersPage extends StatelessWidget {
  const AboutDevelopersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(trans.translate('about_developers_title')),
      ),
      body: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: HeaderText(
                text: trans.translate('about_developers_title'),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                  "https://avatars3.githubusercontent.com/u/18463831?s=460&v=4",
                ),
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                  AppLocalizations.of(context).translate('riccardo_calligaro')),
              subtitle: Text(trans.translate('riccardo_calligaro_description')),
              trailing: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  var url = 'mailto:riccardocalligaro@gmail.com';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                  "https://avatars1.githubusercontent.com/u/33131807?s=460&v=4",
                ),
                backgroundColor: Colors.transparent,
              ),
              title:
                  Text(AppLocalizations.of(context).translate('filippo_veggo')),
              subtitle: Text(AppLocalizations.of(context).translate('design')),
              trailing: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  var url = 'mailto:filippoveggo@gmail.com';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: HeaderText(
                text: AppLocalizations.of(context).translate('thanks_to'),
              ),
            ),
            ListTile(
              title: Text('Jacopo Ferian, Samuele Zanella, Andrea Nocco'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: HeaderText(
                text: AppLocalizations.of(context).translate('the_application'),
              ),
            ),
            ListTile(
              title: Text(trans.translate('app_description')),
            ),
            ListTile(
              title: FlatButton(
                child: Text(trans.translate('view_source_code')),
                onPressed: () async {
                  const url =
                      'https://github.com/Zuccante-Web-App/Registro-elettronico';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
