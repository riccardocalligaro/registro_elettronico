import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class TimetableCard extends StatelessWidget {
  final TimetableEntry timetableEntry;
  final String subject;
  final Color color;
  final GestureTapCallback onTap;

  const TimetableCard({
    Key key,
    this.timetableEntry,
    this.subject,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(4.0),
              width: 80.0,
              height: 100.0,
              child: timetableEntry != null
                  ? Text(subject != null
                      ? subject.length > 20
                          ? StringUtils.titleCase(
                              GlobalUtils.reduceSubjectTitle(subject))
                          : StringUtils.titleCase(subject)
                      : '', style: TextStyle(color: Colors.white),)
                  : Icon(Icons.add),
            ),
          ),
          color: Colors.transparent,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
          color: color,
        ),
      ),
    );
  }
}
