import 'package:flutter/material.dart';
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
    if (millisecondsSinceEpoch == null) {
      message = 'Ultimo aggiornamento: Mai';
    } else {
      message =
          'Ultimo aggiornamento: ${GlobalUtils.getLastUpdateMessage(context, DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch))}';
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
