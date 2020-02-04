import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/component/notifications/local_notification.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/event_type.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/ui/feature/agenda/components/select_date_dialog.dart';
import 'package:registro_elettronico/ui/feature/agenda/components/select_notifications_time_alert.dart';
import 'package:registro_elettronico/ui/feature/agenda/components/select_subject_dialog.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

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

  Color _labelColor = null;
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _insertEventInDb();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
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
    final id = DateTime.now().millisecondsSinceEpoch.toSigned(32);

    final DateTime _date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _timeOfDay.hour,
      _timeOfDay.minute,
    );

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

    FLog.info(text: 'Added event');

    await RepositoryProvider.of<AgendaRepository>(context)
        .insertLocalEvent(event);

    final LocalNotification localNotification =
        LocalNotification(onSelectNotification);

    localNotification.scheduleNotification(
      title: AppLocalizations.of(context).translate('new_event'),
      message: _titleController.text,
      scheduledTime: _date,
      eventId: id,
    );

    Navigator.pop(context, _selectedDate);
  }

  Card _buildDescriptionCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.subject,
          color: GlobalUtils.isDark(context) ? Colors.white : Colors.grey[900],
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
                color: GlobalUtils.isDark(context)
                    ? Colors.white
                    : Colors.grey[900],
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
            InkWell(
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Row(
                    //  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.label,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(AppLocalizations.of(context).translate('label')),
                        ],
                      ),
                      ClipOval(
                        child: Container(
                          height: 20,
                          width: 20,
                          color: _labelColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.today),
                          SizedBox(
                            width: 30,
                          ),
                          Text(AppLocalizations.of(context).translate('date')),
                        ],
                      ),
                      Text(DateUtils.getNewEventDateMessage(
                        _selectedDate,
                        AppLocalizations.of(context).locale.toString(),
                        context,
                      )),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            AppLocalizations.of(context).translate('time'),
                          ),
                        ],
                      ),
                      Text(_timeOfDay.format(context)),
                    ],
                  ),
                ),
              ),
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
    AppNavigator.instance.navToAgenda(context);
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
      return GlobalUtils.isDark(context) ? Colors.white : Colors.grey[900];
    }
  }
}
