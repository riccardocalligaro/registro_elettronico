import 'package:flutter/material.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class NoticeboardSection extends StatelessWidget {
  const NoticeboardSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildNoticeBoardSection(context);
  }

  /// Noticce board [section] that contains the text and the button
  Widget _buildNoticeBoardSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('notice_board'),
                style:
                    Theme.of(context).textTheme.headline.copyWith(fontSize: 14),
              ),
              Text(
                AppLocalizations.of(context).translate("discover_all_notice"),
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              )
            ],
          ),
          RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text(
              AppLocalizations.of(context).translate("view"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: () async {
              AppNavigator.instance.navToNoticeboard(context);
            },
          ),
        ],
      ),
    );
  }
}
