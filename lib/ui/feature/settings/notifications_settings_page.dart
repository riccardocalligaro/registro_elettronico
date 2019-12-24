import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/feature/settings/components/header_text.dart';
import 'package:registro_elettronico/ui/feature/settings/settings_page.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettingsPage extends StatefulWidget {
  NotificationsSettingsPage({Key key}) : super(key: key);

  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _gradesNotifications = false;
  bool _agendaNotifications = false;
  bool _lessonsNotifications = false;
  bool _notesNotifications = false;
  bool _absencesNotifications = false;

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _gradesNotifications =
          (sharedPrefs.getBool(PrefsConstants.GRADES_NOTIFICATIONS) ?? false);
      _agendaNotifications =
          (sharedPrefs.getBool(PrefsConstants.AGENDA_NOTIFICATIONS) ?? false);
      _lessonsNotifications =
          (sharedPrefs.getBool(PrefsConstants.LESSONS_NOTIFICATIONS) ?? false);
      _notesNotifications =
          (sharedPrefs.getBool(PrefsConstants.NOTES_NOTIFICATIONS) ?? false);
      _absencesNotifications =
          (sharedPrefs.getBool(PrefsConstants.ABSENCES_NOTIFICATIONS) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _buildNotificationsSection(),
    );
  }

  Widget _buildNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderText(
            text: 'Choose what to notify',
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0.0),
            value: _agendaNotifications,
            title: Text('Grades'),
            onChanged: (value) {
              setState(() {
                _agendaNotifications = value;
              });
              save(PrefsConstants.GRADES_NOTIFICATIONS, value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0.0),
            value: _agendaNotifications,
            title: Text('Agenda'),
            onChanged: (value) {
              setState(() {
                _agendaNotifications = value;
              });
              save(PrefsConstants.AGENDA_NOTIFICATIONS, value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0.0),
            value: _lessonsNotifications,
            title: Text('Lessons'),
            onChanged: (value) {
              setState(() {
                _lessonsNotifications = value;
              });
              save(PrefsConstants.LESSONS_NOTIFICATIONS, value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0.0),
            value: _notesNotifications,
            title: Text('Notes'),
            onChanged: (value) {
              setState(() {
                _notesNotifications = value;
              });
              save(PrefsConstants.NOTES_NOTIFICATIONS, value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.all(0.0),
            value: _absencesNotifications,
            title: Text('Absences'),
            onChanged: (value) {
              setState(() {
                _absencesNotifications = value;
              });
              save(PrefsConstants.ABSENCES_NOTIFICATIONS, value);
            },
          ),
        ],
      ),
    );
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }
}
