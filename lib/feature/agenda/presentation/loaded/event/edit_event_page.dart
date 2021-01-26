import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:registro_elettronico/core/data/model/event_type.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/dialog/select_date_dialog.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/dialog/select_subject_dialog.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class EditEventPage extends StatefulWidget {
  final AgendaEventDomainModel event;
  final EventType type;

  EditEventPage({
    Key key,
    this.type,
    this.event,
  }) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  AgendaEventDomainModel event;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Color _labelColor;
  DateTime _selectedDate;

  String _initialSubject;
  SubjectDomainModel _selectedSubject;
  TimeOfDay _timeOfDay;
  // bool _notifyEvent = false;
  // Duration _beforeNotify = Duration(minutes: 30);

  bool _missingSubject = false;

  @override
  void initState() {
    _initialSubject = widget.event.subjectName;
    _selectedDate = widget.event.begin;

    _timeOfDay = TimeOfDay(
      hour: _selectedDate.hour,
      minute: _selectedDate.minute,
    );
    if (widget.type == EventType.test) {
      _labelColor = Colors.orange;
    } else if (widget.type == EventType.assigment) {
      _labelColor = Colors.blue;
    } else {
      _labelColor = Colors.green;
    }
    _descriptionController.text = widget.event.notes;
    _titleController.text = widget.event.title;
    _labelColor = Color(int.tryParse(widget.event.labelColor));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('edit_event')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _updateEventInDb();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildTopCard(),
            widget.type != EventType.memo ? _buildSubjectCard() : Container(),
            //_buildNotificationCard(),
            _buildDescriptionCard(),
          ],
        ),
      ),
    );
  }

  void _updateEventInDb() async {
    AgendaEventDomainModel event;
    final eventOriginal = widget.event;

    final DateTime _date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _timeOfDay.hour,
      _timeOfDay.minute,
    );

    if (widget.type == EventType.memo) {
      event = AgendaEventDomainModel(
        subjectId: -1,
        isLocal: true,
        isFullDay: false,
        code: "",
        begin: _date ?? eventOriginal.begin,
        end: _date ?? eventOriginal.begin,
        subjectName: _selectedSubject != null
            ? _selectedSubject.name
            : eventOriginal.subjectName,
        author: "",
        className: "",
        id: eventOriginal.id,
        notes: _descriptionController.text,
        labelColor: _labelColor.value.toString(),
        title: _titleController.text,
      );
    } else {
      event = AgendaEventDomainModel(
        subjectId: _selectedSubject != null
            ? _selectedSubject.id
            : eventOriginal.subjectId,
        isLocal: true,
        isFullDay: false,
        code: '',
        begin: _date ?? eventOriginal.begin,
        end: _date ?? eventOriginal.begin,
        subjectName: _selectedSubject != null
            ? _selectedSubject.name
            : eventOriginal.subjectName,
        author: '',
        className: '',
        id: eventOriginal.id,
        notes: _descriptionController.text,
        labelColor: _labelColor.value.toString(),
        title: _titleController.text,
      );
    }

    Logger.info('Updated events');

    final AgendaRepository agendaRepository = sl();
    await agendaRepository.updateEvent(event: event);

    Navigator.pop(context, _date ?? eventOriginal.begin);
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

  Card _buildTopCard() {
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
              leading: Icon(Icons.label),
              title: Text(AppLocalizations.of(context).translate('label')),
              trailing: ClipOval(
                child: Container(
                  height: 20,
                  width: 20,
                  color: _labelColor,
                ),
              ),
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
            ),
            ListTile(
              leading: Icon(Icons.today),
              title: Text(AppLocalizations.of(context).translate('date')),
              trailing: Text(
                DateUtils.getNewEventDateMessage(_selectedDate,
                    AppLocalizations.of(context).locale.toString(), context),
              ),
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
              title: Text(AppLocalizations.of(context).translate('time')),
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
            )
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
              : _getReducedName(_initialSubject),
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
      return null;
    }
  }
}
