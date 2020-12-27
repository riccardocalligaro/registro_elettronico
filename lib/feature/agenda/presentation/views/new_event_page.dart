import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/model/event_type.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/notification/local_notification.dart';
import 'package:registro_elettronico/core/presentation/widgets/app_drawer.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/agenda/presentation/widgets/select_date_dialog.dart';
import 'package:registro_elettronico/feature/agenda/presentation/widgets/select_notifications_time_alert.dart';
import 'package:registro_elettronico/feature/agenda/presentation/widgets/select_subject_dialog.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

import '../agenda_page.dart';

class NewEventPage extends StatefulWidget {
  final EventType eventType;
  final DateTime initialDate;

  NewEventPage({
    Key key,
    this.eventType,
    this.initialDate,
  }) : super(key: key);

  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Color _labelColor;
  DateTime _selectedDate;

  TimeOfDay _timeOfDay = TimeOfDay(hour: 9, minute: 0);
  // Duration _repeat = Duration(milliseconds: 0);

  Subject _selectedSubject;

  bool _notifyEvent = false;
  Duration _beforeNotify = Duration(minutes: 30);

  bool _missingSubject = false;

  @override
  void initState() {
    _selectedDate = widget.initialDate;
    if (DateUtils.areSameDay(_selectedDate, DateTime.now())) {
      final addedHour = DateTime.now().add(Duration(hours: 2));
      _timeOfDay = TimeOfDay(hour: addedHour.hour, minute: 0);
    }
    if (widget.eventType == EventType.test) {
      _labelColor = Colors.orange;
    } else if (widget.eventType == EventType.assigment) {
      _labelColor = Colors.blue;
    } else {
      _labelColor = Colors.green;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('new_event')),
        brightness: Theme.of(context).brightness,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              FLog.info(text: 'Pressed the check button');
              _insertEventInDb();
              FLog.info(text: 'Inserted the element, popping the navigator');
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            _buildTopCard(),
            widget.eventType != EventType.memo
                ? _buildSubjectCard()
                : Container(),
            _buildNotificationCard(),
            _buildDescriptionCard(),
          ],
        ),
      ),
    );
  }

  void _insertEventInDb() async {
    FLog.info(text: 'Inside the insert event button');

    final id = DateTime.now().millisecondsSinceEpoch.toSigned(32);

    FLog.info(text: 'Set new event id to $id');

    final DateTime _date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _timeOfDay.hour,
      _timeOfDay.minute,
    );

    FLog.info(text: 'Date of the new event $_date');

    AgendaEvent event;
    if (widget.eventType == EventType.memo) {
      event = AgendaEvent(
        subjectId: -1,
        isLocal: true,
        isFullDay: false,
        evtCode: "",
        begin: _date,
        end: _date,
        subjectDesc: '',
        authorName: "",
        classDesc: "",
        evtId: id,
        notes: _descriptionController.text,
        labelColor: _labelColor.value.toString(),
        title: _titleController.text,
      );
    } else {
      if (_selectedSubject != null) {
        event = AgendaEvent(
          subjectId: _selectedSubject.id,
          isLocal: true,
          isFullDay: false,
          evtCode: "",
          begin: _date,
          end: _date,
          subjectDesc: _selectedSubject.name,
          authorName: "",
          classDesc: "",
          evtId: id,
          notes: _descriptionController.text,
          labelColor: _labelColor.value.toString(),
          title: _titleController.text,
        );
      } else {
        setState(() {
          _missingSubject = true;
        });
        return;
      }
    }

    await RepositoryProvider.of<AgendaRepository>(context)
        .insertLocalEvent(event);

    Navigator.pop(context, _selectedDate);

    FLog.info(text: 'Added event');

    if (_notifyEvent) {
      FLog.info(text: 'Setting up notifications');

      final LocalNotification localNotification =
          LocalNotification(onSelectNotification);

      await localNotification.scheduleNotification(
        title: AppLocalizations.of(context).translate('new_event') ?? '',
        message: _titleController.text ?? '',
        scheduledTime: _date.subtract(_beforeNotify) ??
            DateTime.now().add(Duration(hours: 1)),
        eventId: id,
      );
    }
  }

  Card _buildDescriptionCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.subject,
        ),
        title: TextField(
          controller: _descriptionController,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context).translate('add_description'),
          ),
        ),
      ),
    );
  }

  Card _buildNotificationCard() {
    return Card(
      child: Column(
        children: <Widget>[
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(AppLocalizations.of(context).translate('notify_event')),
            value: _notifyEvent,
            onChanged: (bool value) {
              if (value != null) {
                setState(() {
                  _notifyEvent = value;
                });
              }
            },
          ),
          if (_notifyEvent)
            _buildNotifyOptions()
          else
            Opacity(
              opacity: 0.50,
              child: IgnorePointer(
                child: _buildNotifyOptions(),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildNotifyOptions() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.notifications_none,
              ),
              SizedBox(
                width: 30.0,
              ),
              Text(
                  DateUtils.getBeforeNotifyTimeMessage(_beforeNotify, context)),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SelectNotificationsTimeAlertDialog(
                beforeNotification: _beforeNotify,
              ),
            ).then((duration) {
              if (duration != null) {
                setState(() {
                  _beforeNotify = duration;
                });
              }
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(71, 8, 16, 16),
              child: Text(
                  AppLocalizations.of(context).translate('add_notification')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCard() {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.title,
              ),
              title: TextField(
                controller: _titleController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('add_title'),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _labelColor,
                          onColorChanged: (color) {
                            if (color != null) {
                              setState(() {
                                _labelColor = color;
                              });
                            }
                            Navigator.pop(context);
                          },
                          enableLabel: true,
                        ),
                      ),
                    );
                  },
                );
              },
              leading: Icon(
                Icons.label,
              ),
              title: Text(
                AppLocalizations.of(context).translate('label'),
              ),
              trailing: ClipOval(
                child: Container(
                  height: 20,
                  width: 20,
                  color: _labelColor,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.today),
              title: Text(AppLocalizations.of(context).translate('date')),
              trailing: Text(DateUtils.getNewEventDateMessage(
                _selectedDate,
                AppLocalizations.of(context).locale.toString(),
                context,
              )),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SelectDateDialog(),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text(
                AppLocalizations.of(context).translate('time'),
              ),
              trailing: Text(_timeOfDay.format(context)),
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: _timeOfDay,
                ).then((time) {
                  if (time != null) {
                    setState(() {
                      _timeOfDay = time;
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Card _buildSubjectCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.school,
          color: _getIconColorForMissingSubject(),
        ),
        title: Text(
          _selectedSubject != null
              ? _getReducedName(_selectedSubject.name)
              : AppLocalizations.of(context).translate('choose_subject'),
          style: TextStyle(
            color: _getColorForMissingSubject(),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SelectSubjectDialog(),
          ).then((value) {
            if (value != null) {
              setState(() {
                _missingSubject = false;
                _selectedSubject = value;
              });
            }
          });
        },
      ),
    );
  }

  String _getReducedName(String subjectName) {
    try {
      if (subjectName.length > 25) {
        return '${StringUtils.titleCase(subjectName.substring(0, 24))}...';
      } else {
        return StringUtils.titleCase(subjectName);
      }
    } catch (e) {
      return subjectName.toLowerCase();
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgendaPage()),
    );
  }

  Color _getColorForMissingSubject() {
    if (_missingSubject) {
      return Colors.red;
    } else {
      return GlobalUtils.isDark(context) ? Colors.white : Colors.black;
    }
  }

  Color _getIconColorForMissingSubject() {
    if (_missingSubject) {
      return Colors.red;
    } else {
      return null;
    }
  }
}
