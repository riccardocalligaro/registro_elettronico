import 'package:flutter/material.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

import 'model/timetable_entry_presentation_model.dart';

/// A simple [Widget] for displaying a [BasicEvent].
class TimetableEventWidget extends StatelessWidget {
  const TimetableEventWidget(
    this.event, {
    Key key,
    this.onTap,
  })  : assert(event != null),
        super(key: key);

  /// The [BasicEvent] to be displayed.
  final TimetableEntryPresentationModel event;

  /// An optional [VoidCallback] that will be invoked when the user taps this
  /// widget.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      color: event.color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            GlobalUtils.reduceSubjectGridTitle(event.subjectName),
          ),
        ),
      ),
    );
  }
}
