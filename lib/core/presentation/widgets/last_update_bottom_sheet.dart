import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class LastUpdateBottomSheet extends StatelessWidget {
  final int millisecondsSinceEpoch;

  const LastUpdateBottomSheet({
    Key key,
    @required this.millisecondsSinceEpoch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    AppLocalizations trans = AppLocalizations.of(context);

    if (millisecondsSinceEpoch == null) {
      message =
          '${trans.translate('last_update')}: ${trans.translate('never')}';
    } else {
      message =
          '${trans.translate('last_update')}: ${GlobalUtils.getLastUpdateMessage(context, DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch))}';
    }
    return Container(
      // height: 20,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: Theme.of(context).brightness == Brightness.dark
              ? BorderSide(color: Colors.grey[800])
              : BorderSide(color: Colors.grey[100]),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
