import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppDialog extends StatelessWidget {
  final PackageInfo packageInfo;
  const AboutAppDialog({
    Key key,
    @required this.packageInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationIcon: Icon(Icons.school),
      applicationName: AppLocalizations.of(context).translate('app_name'),
      applicationVersion: packageInfo.version,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            final url = RegistroConstants.WEBSITE;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  text: AppLocalizations.of(context).translate('about_site'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            final url = RegistroConstants.GITHUB_REPOSITORY;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  text: AppLocalizations.of(context).translate('about_github'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
