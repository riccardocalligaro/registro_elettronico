// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LessonLocalModel extends DataClass
    implements Insertable<LessonLocalModel> {
  final int eventId;
  final DateTime date;
  final String code;
  final int position;
  final int duration;
  final String classe;
  final String author;
  final int subjectId;
  final String subjectCode;
  final String subjectDescription;
  final String lessonType;
  final String lessonArg;
  LessonLocalModel(
      {@required this.eventId,
      @required this.date,
      @required this.code,
      @required this.position,
      @required this.duration,
      @required this.classe,
      @required this.author,
      @required this.subjectId,
      @required this.subjectCode,
      @required this.subjectDescription,
      @required this.lessonType,
      @required this.lessonArg});
  factory LessonLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return LessonLocalModel(
      eventId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}event_id']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      code: stringType.mapFromDatabaseResponse(data['${effectivePrefix}code']),
      position:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}position']),
      duration:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}duration']),
      classe:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}classe']),
      author:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}author']),
      subjectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject_id']),
      subjectCode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_code']),
      subjectDescription: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}subject_description']),
      lessonType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}lesson_type']),
      lessonArg: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}lesson_arg']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || eventId != null) {
      map['event_id'] = Variable<int>(eventId);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<int>(position);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || classe != null) {
      map['classe'] = Variable<String>(classe);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || subjectCode != null) {
      map['subject_code'] = Variable<String>(subjectCode);
    }
    if (!nullToAbsent || subjectDescription != null) {
      map['subject_description'] = Variable<String>(subjectDescription);
    }
    if (!nullToAbsent || lessonType != null) {
      map['lesson_type'] = Variable<String>(lessonType);
    }
    if (!nullToAbsent || lessonArg != null) {
      map['lesson_arg'] = Variable<String>(lessonArg);
    }
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      eventId: eventId == null && nullToAbsent
          ? const Value.absent()
          : Value(eventId),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      classe:
          classe == null && nullToAbsent ? const Value.absent() : Value(classe),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      subjectCode: subjectCode == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectCode),
      subjectDescription: subjectDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectDescription),
      lessonType: lessonType == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonType),
      lessonArg: lessonArg == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonArg),
    );
  }

  factory LessonLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LessonLocalModel(
      eventId: serializer.fromJson<int>(json['eventId']),
      date: serializer.fromJson<DateTime>(json['date']),
      code: serializer.fromJson<String>(json['code']),
      position: serializer.fromJson<int>(json['position']),
      duration: serializer.fromJson<int>(json['duration']),
      classe: serializer.fromJson<String>(json['classe']),
      author: serializer.fromJson<String>(json['author']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      subjectCode: serializer.fromJson<String>(json['subjectCode']),
      subjectDescription:
          serializer.fromJson<String>(json['subjectDescription']),
      lessonType: serializer.fromJson<String>(json['lessonType']),
      lessonArg: serializer.fromJson<String>(json['lessonArg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<int>(eventId),
      'date': serializer.toJson<DateTime>(date),
      'code': serializer.toJson<String>(code),
      'position': serializer.toJson<int>(position),
      'duration': serializer.toJson<int>(duration),
      'classe': serializer.toJson<String>(classe),
      'author': serializer.toJson<String>(author),
      'subjectId': serializer.toJson<int>(subjectId),
      'subjectCode': serializer.toJson<String>(subjectCode),
      'subjectDescription': serializer.toJson<String>(subjectDescription),
      'lessonType': serializer.toJson<String>(lessonType),
      'lessonArg': serializer.toJson<String>(lessonArg),
    };
  }

  LessonLocalModel copyWith(
          {int eventId,
          DateTime date,
          String code,
          int position,
          int duration,
          String classe,
          String author,
          int subjectId,
          String subjectCode,
          String subjectDescription,
          String lessonType,
          String lessonArg}) =>
      LessonLocalModel(
        eventId: eventId ?? this.eventId,
        date: date ?? this.date,
        code: code ?? this.code,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        classe: classe ?? this.classe,
        author: author ?? this.author,
        subjectId: subjectId ?? this.subjectId,
        subjectCode: subjectCode ?? this.subjectCode,
        subjectDescription: subjectDescription ?? this.subjectDescription,
        lessonType: lessonType ?? this.lessonType,
        lessonArg: lessonArg ?? this.lessonArg,
      );
  @override
  String toString() {
    return (StringBuffer('LessonLocalModel(')
          ..write('eventId: $eventId, ')
          ..write('date: $date, ')
          ..write('code: $code, ')
          ..write('position: $position, ')
          ..write('duration: $duration, ')
          ..write('classe: $classe, ')
          ..write('author: $author, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectCode: $subjectCode, ')
          ..write('subjectDescription: $subjectDescription, ')
          ..write('lessonType: $lessonType, ')
          ..write('lessonArg: $lessonArg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      eventId.hashCode,
      $mrjc(
          date.hashCode,
          $mrjc(
              code.hashCode,
              $mrjc(
                  position.hashCode,
                  $mrjc(
                      duration.hashCode,
                      $mrjc(
                          classe.hashCode,
                          $mrjc(
                              author.hashCode,
                              $mrjc(
                                  subjectId.hashCode,
                                  $mrjc(
                                      subjectCode.hashCode,
                                      $mrjc(
                                          subjectDescription.hashCode,
                                          $mrjc(lessonType.hashCode,
                                              lessonArg.hashCode))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LessonLocalModel &&
          other.eventId == this.eventId &&
          other.date == this.date &&
          other.code == this.code &&
          other.position == this.position &&
          other.duration == this.duration &&
          other.classe == this.classe &&
          other.author == this.author &&
          other.subjectId == this.subjectId &&
          other.subjectCode == this.subjectCode &&
          other.subjectDescription == this.subjectDescription &&
          other.lessonType == this.lessonType &&
          other.lessonArg == this.lessonArg);
}

class LessonsCompanion extends UpdateCompanion<LessonLocalModel> {
  final Value<int> eventId;
  final Value<DateTime> date;
  final Value<String> code;
  final Value<int> position;
  final Value<int> duration;
  final Value<String> classe;
  final Value<String> author;
  final Value<int> subjectId;
  final Value<String> subjectCode;
  final Value<String> subjectDescription;
  final Value<String> lessonType;
  final Value<String> lessonArg;
  const LessonsCompanion({
    this.eventId = const Value.absent(),
    this.date = const Value.absent(),
    this.code = const Value.absent(),
    this.position = const Value.absent(),
    this.duration = const Value.absent(),
    this.classe = const Value.absent(),
    this.author = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.subjectCode = const Value.absent(),
    this.subjectDescription = const Value.absent(),
    this.lessonType = const Value.absent(),
    this.lessonArg = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.eventId = const Value.absent(),
    @required DateTime date,
    @required String code,
    @required int position,
    @required int duration,
    @required String classe,
    @required String author,
    @required int subjectId,
    @required String subjectCode,
    @required String subjectDescription,
    @required String lessonType,
    @required String lessonArg,
  })  : date = Value(date),
        code = Value(code),
        position = Value(position),
        duration = Value(duration),
        classe = Value(classe),
        author = Value(author),
        subjectId = Value(subjectId),
        subjectCode = Value(subjectCode),
        subjectDescription = Value(subjectDescription),
        lessonType = Value(lessonType),
        lessonArg = Value(lessonArg);
  static Insertable<LessonLocalModel> custom({
    Expression<int> eventId,
    Expression<DateTime> date,
    Expression<String> code,
    Expression<int> position,
    Expression<int> duration,
    Expression<String> classe,
    Expression<String> author,
    Expression<int> subjectId,
    Expression<String> subjectCode,
    Expression<String> subjectDescription,
    Expression<String> lessonType,
    Expression<String> lessonArg,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (date != null) 'date': date,
      if (code != null) 'code': code,
      if (position != null) 'position': position,
      if (duration != null) 'duration': duration,
      if (classe != null) 'classe': classe,
      if (author != null) 'author': author,
      if (subjectId != null) 'subject_id': subjectId,
      if (subjectCode != null) 'subject_code': subjectCode,
      if (subjectDescription != null) 'subject_description': subjectDescription,
      if (lessonType != null) 'lesson_type': lessonType,
      if (lessonArg != null) 'lesson_arg': lessonArg,
    });
  }

  LessonsCompanion copyWith(
      {Value<int> eventId,
      Value<DateTime> date,
      Value<String> code,
      Value<int> position,
      Value<int> duration,
      Value<String> classe,
      Value<String> author,
      Value<int> subjectId,
      Value<String> subjectCode,
      Value<String> subjectDescription,
      Value<String> lessonType,
      Value<String> lessonArg}) {
    return LessonsCompanion(
      eventId: eventId ?? this.eventId,
      date: date ?? this.date,
      code: code ?? this.code,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      classe: classe ?? this.classe,
      author: author ?? this.author,
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectDescription: subjectDescription ?? this.subjectDescription,
      lessonType: lessonType ?? this.lessonType,
      lessonArg: lessonArg ?? this.lessonArg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (classe.present) {
      map['classe'] = Variable<String>(classe.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (subjectCode.present) {
      map['subject_code'] = Variable<String>(subjectCode.value);
    }
    if (subjectDescription.present) {
      map['subject_description'] = Variable<String>(subjectDescription.value);
    }
    if (lessonType.present) {
      map['lesson_type'] = Variable<String>(lessonType.value);
    }
    if (lessonArg.present) {
      map['lesson_arg'] = Variable<String>(lessonArg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('date: $date, ')
          ..write('code: $code, ')
          ..write('position: $position, ')
          ..write('duration: $duration, ')
          ..write('classe: $classe, ')
          ..write('author: $author, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectCode: $subjectCode, ')
          ..write('subjectDescription: $subjectDescription, ')
          ..write('lessonType: $lessonType, ')
          ..write('lessonArg: $lessonArg')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons
    with TableInfo<$LessonsTable, LessonLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $LessonsTable(this._db, [this._alias]);
  final VerificationMeta _eventIdMeta = const VerificationMeta('eventId');
  GeneratedIntColumn _eventId;
  @override
  GeneratedIntColumn get eventId => _eventId ??= _constructEventId();
  GeneratedIntColumn _constructEventId() {
    return GeneratedIntColumn(
      'event_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _codeMeta = const VerificationMeta('code');
  GeneratedTextColumn _code;
  @override
  GeneratedTextColumn get code => _code ??= _constructCode();
  GeneratedTextColumn _constructCode() {
    return GeneratedTextColumn(
      'code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _positionMeta = const VerificationMeta('position');
  GeneratedIntColumn _position;
  @override
  GeneratedIntColumn get position => _position ??= _constructPosition();
  GeneratedIntColumn _constructPosition() {
    return GeneratedIntColumn(
      'position',
      $tableName,
      false,
    );
  }

  final VerificationMeta _durationMeta = const VerificationMeta('duration');
  GeneratedIntColumn _duration;
  @override
  GeneratedIntColumn get duration => _duration ??= _constructDuration();
  GeneratedIntColumn _constructDuration() {
    return GeneratedIntColumn(
      'duration',
      $tableName,
      false,
    );
  }

  final VerificationMeta _classeMeta = const VerificationMeta('classe');
  GeneratedTextColumn _classe;
  @override
  GeneratedTextColumn get classe => _classe ??= _constructClasse();
  GeneratedTextColumn _constructClasse() {
    return GeneratedTextColumn(
      'classe',
      $tableName,
      false,
    );
  }

  final VerificationMeta _authorMeta = const VerificationMeta('author');
  GeneratedTextColumn _author;
  @override
  GeneratedTextColumn get author => _author ??= _constructAuthor();
  GeneratedTextColumn _constructAuthor() {
    return GeneratedTextColumn(
      'author',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedIntColumn _subjectId;
  @override
  GeneratedIntColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedIntColumn _constructSubjectId() {
    return GeneratedIntColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectCodeMeta =
      const VerificationMeta('subjectCode');
  GeneratedTextColumn _subjectCode;
  @override
  GeneratedTextColumn get subjectCode =>
      _subjectCode ??= _constructSubjectCode();
  GeneratedTextColumn _constructSubjectCode() {
    return GeneratedTextColumn(
      'subject_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectDescriptionMeta =
      const VerificationMeta('subjectDescription');
  GeneratedTextColumn _subjectDescription;
  @override
  GeneratedTextColumn get subjectDescription =>
      _subjectDescription ??= _constructSubjectDescription();
  GeneratedTextColumn _constructSubjectDescription() {
    return GeneratedTextColumn(
      'subject_description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lessonTypeMeta = const VerificationMeta('lessonType');
  GeneratedTextColumn _lessonType;
  @override
  GeneratedTextColumn get lessonType => _lessonType ??= _constructLessonType();
  GeneratedTextColumn _constructLessonType() {
    return GeneratedTextColumn(
      'lesson_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lessonArgMeta = const VerificationMeta('lessonArg');
  GeneratedTextColumn _lessonArg;
  @override
  GeneratedTextColumn get lessonArg => _lessonArg ??= _constructLessonArg();
  GeneratedTextColumn _constructLessonArg() {
    return GeneratedTextColumn(
      'lesson_arg',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        eventId,
        date,
        code,
        position,
        duration,
        classe,
        author,
        subjectId,
        subjectCode,
        subjectDescription,
        lessonType,
        lessonArg
      ];
  @override
  $LessonsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'lessons';
  @override
  final String actualTableName = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<LessonLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id'], _eventIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code'], _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position'], _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration'], _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('classe')) {
      context.handle(_classeMeta,
          classe.isAcceptableOrUnknown(data['classe'], _classeMeta));
    } else if (isInserting) {
      context.missing(_classeMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author'], _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id'], _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('subject_code')) {
      context.handle(
          _subjectCodeMeta,
          subjectCode.isAcceptableOrUnknown(
              data['subject_code'], _subjectCodeMeta));
    } else if (isInserting) {
      context.missing(_subjectCodeMeta);
    }
    if (data.containsKey('subject_description')) {
      context.handle(
          _subjectDescriptionMeta,
          subjectDescription.isAcceptableOrUnknown(
              data['subject_description'], _subjectDescriptionMeta));
    } else if (isInserting) {
      context.missing(_subjectDescriptionMeta);
    }
    if (data.containsKey('lesson_type')) {
      context.handle(
          _lessonTypeMeta,
          lessonType.isAcceptableOrUnknown(
              data['lesson_type'], _lessonTypeMeta));
    } else if (isInserting) {
      context.missing(_lessonTypeMeta);
    }
    if (data.containsKey('lesson_arg')) {
      context.handle(_lessonArgMeta,
          lessonArg.isAcceptableOrUnknown(data['lesson_arg'], _lessonArgMeta));
    } else if (isInserting) {
      context.missing(_lessonArgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  LessonLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LessonLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(_db, alias);
  }
}

class SubjectLocalModel extends DataClass
    implements Insertable<SubjectLocalModel> {
  final int id;
  final String name;
  final int orderNumber;
  final String color;
  SubjectLocalModel(
      {@required this.id,
      @required this.name,
      @required this.orderNumber,
      @required this.color});
  factory SubjectLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return SubjectLocalModel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      orderNumber: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_number']),
      color:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || orderNumber != null) {
      map['order_number'] = Variable<int>(orderNumber);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      orderNumber: orderNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNumber),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory SubjectLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SubjectLocalModel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      orderNumber: serializer.fromJson<int>(json['orderNumber']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'orderNumber': serializer.toJson<int>(orderNumber),
      'color': serializer.toJson<String>(color),
    };
  }

  SubjectLocalModel copyWith(
          {int id, String name, int orderNumber, String color}) =>
      SubjectLocalModel(
        id: id ?? this.id,
        name: name ?? this.name,
        orderNumber: orderNumber ?? this.orderNumber,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('SubjectLocalModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(orderNumber.hashCode, color.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SubjectLocalModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.orderNumber == this.orderNumber &&
          other.color == this.color);
}

class SubjectsCompanion extends UpdateCompanion<SubjectLocalModel> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> orderNumber;
  final Value<String> color;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.color = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int orderNumber,
    @required String color,
  })  : name = Value(name),
        orderNumber = Value(orderNumber),
        color = Value(color);
  static Insertable<SubjectLocalModel> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> orderNumber,
    Expression<String> color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (orderNumber != null) 'order_number': orderNumber,
      if (color != null) 'color': color,
    });
  }

  SubjectsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> orderNumber,
      Value<String> color}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      orderNumber: orderNumber ?? this.orderNumber,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<int>(orderNumber.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects
    with TableInfo<$SubjectsTable, SubjectLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $SubjectsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _orderNumberMeta =
      const VerificationMeta('orderNumber');
  GeneratedIntColumn _orderNumber;
  @override
  GeneratedIntColumn get orderNumber =>
      _orderNumber ??= _constructOrderNumber();
  GeneratedIntColumn _constructOrderNumber() {
    return GeneratedIntColumn(
      'order_number',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedTextColumn _color;
  @override
  GeneratedTextColumn get color => _color ??= _constructColor();
  GeneratedTextColumn _constructColor() {
    return GeneratedTextColumn(
      'color',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, orderNumber, color];
  @override
  $SubjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'subjects';
  @override
  final String actualTableName = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_number')) {
      context.handle(
          _orderNumberMeta,
          orderNumber.isAcceptableOrUnknown(
              data['order_number'], _orderNumberMeta));
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SubjectLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(_db, alias);
  }
}

class ProfessorLocalModel extends DataClass
    implements Insertable<ProfessorLocalModel> {
  final String id;
  final int subjectId;
  final String name;
  ProfessorLocalModel(
      {@required this.id, @required this.subjectId, @required this.name});
  factory ProfessorLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return ProfessorLocalModel(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      subjectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  ProfessorsCompanion toCompanion(bool nullToAbsent) {
    return ProfessorsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory ProfessorLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProfessorLocalModel(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'name': serializer.toJson<String>(name),
    };
  }

  ProfessorLocalModel copyWith({String id, int subjectId, String name}) =>
      ProfessorLocalModel(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('ProfessorLocalModel(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(subjectId.hashCode, name.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ProfessorLocalModel &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.name == this.name);
}

class ProfessorsCompanion extends UpdateCompanion<ProfessorLocalModel> {
  final Value<String> id;
  final Value<int> subjectId;
  final Value<String> name;
  const ProfessorsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.name = const Value.absent(),
  });
  ProfessorsCompanion.insert({
    @required String id,
    @required int subjectId,
    @required String name,
  })  : id = Value(id),
        subjectId = Value(subjectId),
        name = Value(name);
  static Insertable<ProfessorLocalModel> custom({
    Expression<String> id,
    Expression<int> subjectId,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (name != null) 'name': name,
    });
  }

  ProfessorsCompanion copyWith(
      {Value<String> id, Value<int> subjectId, Value<String> name}) {
    return ProfessorsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfessorsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ProfessorsTable extends Professors
    with TableInfo<$ProfessorsTable, ProfessorLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProfessorsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedIntColumn _subjectId;
  @override
  GeneratedIntColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedIntColumn _constructSubjectId() {
    return GeneratedIntColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, subjectId, name];
  @override
  $ProfessorsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'professors';
  @override
  final String actualTableName = 'professors';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProfessorLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id'], _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfessorLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ProfessorLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProfessorsTable createAlias(String alias) {
    return $ProfessorsTable(_db, alias);
  }
}

class GradeLocalModel extends DataClass implements Insertable<GradeLocalModel> {
  final int subjectId;
  final String subjectDesc;
  final int evtId;
  final String evtCode;
  final DateTime eventDate;
  final double decimalValue;
  final String displayValue;
  final int displayPos;
  final String notesForFamily;
  final bool cancelled;
  final bool underlined;
  final int periodPos;
  final String periodDesc;
  final int componentPos;
  final String componentDesc;
  final int weightFactor;
  final int skillId;
  final int gradeMasterId;
  final bool localllyCancelled;
  final bool hasSeenIt;
  GradeLocalModel(
      {@required this.subjectId,
      @required this.subjectDesc,
      @required this.evtId,
      @required this.evtCode,
      @required this.eventDate,
      @required this.decimalValue,
      @required this.displayValue,
      @required this.displayPos,
      @required this.notesForFamily,
      @required this.cancelled,
      @required this.underlined,
      @required this.periodPos,
      @required this.periodDesc,
      @required this.componentPos,
      @required this.componentDesc,
      @required this.weightFactor,
      @required this.skillId,
      @required this.gradeMasterId,
      @required this.localllyCancelled,
      @required this.hasSeenIt});
  factory GradeLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return GradeLocalModel(
      subjectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject_id']),
      subjectDesc: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_desc']),
      evtId: intType.mapFromDatabaseResponse(data['${effectivePrefix}evt_id']),
      evtCode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}evt_code']),
      eventDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_date']),
      decimalValue: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}decimal_value']),
      displayValue: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}display_value']),
      displayPos: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}display_pos']),
      notesForFamily: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}notes_for_family']),
      cancelled:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}cancelled']),
      underlined: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}underlined']),
      periodPos:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}period_pos']),
      periodDesc: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}period_desc']),
      componentPos: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}component_pos']),
      componentDesc: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}component_desc']),
      weightFactor: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}weight_factor']),
      skillId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}skill_id']),
      gradeMasterId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}grade_master_id']),
      localllyCancelled: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}locallly_cancelled']),
      hasSeenIt: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}has_seen_it']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || subjectDesc != null) {
      map['subject_desc'] = Variable<String>(subjectDesc);
    }
    if (!nullToAbsent || evtId != null) {
      map['evt_id'] = Variable<int>(evtId);
    }
    if (!nullToAbsent || evtCode != null) {
      map['evt_code'] = Variable<String>(evtCode);
    }
    if (!nullToAbsent || eventDate != null) {
      map['event_date'] = Variable<DateTime>(eventDate);
    }
    if (!nullToAbsent || decimalValue != null) {
      map['decimal_value'] = Variable<double>(decimalValue);
    }
    if (!nullToAbsent || displayValue != null) {
      map['display_value'] = Variable<String>(displayValue);
    }
    if (!nullToAbsent || displayPos != null) {
      map['display_pos'] = Variable<int>(displayPos);
    }
    if (!nullToAbsent || notesForFamily != null) {
      map['notes_for_family'] = Variable<String>(notesForFamily);
    }
    if (!nullToAbsent || cancelled != null) {
      map['cancelled'] = Variable<bool>(cancelled);
    }
    if (!nullToAbsent || underlined != null) {
      map['underlined'] = Variable<bool>(underlined);
    }
    if (!nullToAbsent || periodPos != null) {
      map['period_pos'] = Variable<int>(periodPos);
    }
    if (!nullToAbsent || periodDesc != null) {
      map['period_desc'] = Variable<String>(periodDesc);
    }
    if (!nullToAbsent || componentPos != null) {
      map['component_pos'] = Variable<int>(componentPos);
    }
    if (!nullToAbsent || componentDesc != null) {
      map['component_desc'] = Variable<String>(componentDesc);
    }
    if (!nullToAbsent || weightFactor != null) {
      map['weight_factor'] = Variable<int>(weightFactor);
    }
    if (!nullToAbsent || skillId != null) {
      map['skill_id'] = Variable<int>(skillId);
    }
    if (!nullToAbsent || gradeMasterId != null) {
      map['grade_master_id'] = Variable<int>(gradeMasterId);
    }
    if (!nullToAbsent || localllyCancelled != null) {
      map['locallly_cancelled'] = Variable<bool>(localllyCancelled);
    }
    if (!nullToAbsent || hasSeenIt != null) {
      map['has_seen_it'] = Variable<bool>(hasSeenIt);
    }
    return map;
  }

  GradesCompanion toCompanion(bool nullToAbsent) {
    return GradesCompanion(
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      subjectDesc: subjectDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectDesc),
      evtId:
          evtId == null && nullToAbsent ? const Value.absent() : Value(evtId),
      evtCode: evtCode == null && nullToAbsent
          ? const Value.absent()
          : Value(evtCode),
      eventDate: eventDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eventDate),
      decimalValue: decimalValue == null && nullToAbsent
          ? const Value.absent()
          : Value(decimalValue),
      displayValue: displayValue == null && nullToAbsent
          ? const Value.absent()
          : Value(displayValue),
      displayPos: displayPos == null && nullToAbsent
          ? const Value.absent()
          : Value(displayPos),
      notesForFamily: notesForFamily == null && nullToAbsent
          ? const Value.absent()
          : Value(notesForFamily),
      cancelled: cancelled == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelled),
      underlined: underlined == null && nullToAbsent
          ? const Value.absent()
          : Value(underlined),
      periodPos: periodPos == null && nullToAbsent
          ? const Value.absent()
          : Value(periodPos),
      periodDesc: periodDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(periodDesc),
      componentPos: componentPos == null && nullToAbsent
          ? const Value.absent()
          : Value(componentPos),
      componentDesc: componentDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(componentDesc),
      weightFactor: weightFactor == null && nullToAbsent
          ? const Value.absent()
          : Value(weightFactor),
      skillId: skillId == null && nullToAbsent
          ? const Value.absent()
          : Value(skillId),
      gradeMasterId: gradeMasterId == null && nullToAbsent
          ? const Value.absent()
          : Value(gradeMasterId),
      localllyCancelled: localllyCancelled == null && nullToAbsent
          ? const Value.absent()
          : Value(localllyCancelled),
      hasSeenIt: hasSeenIt == null && nullToAbsent
          ? const Value.absent()
          : Value(hasSeenIt),
    );
  }

  factory GradeLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GradeLocalModel(
      subjectId: serializer.fromJson<int>(json['subjectId']),
      subjectDesc: serializer.fromJson<String>(json['subjectDesc']),
      evtId: serializer.fromJson<int>(json['evtId']),
      evtCode: serializer.fromJson<String>(json['evtCode']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      decimalValue: serializer.fromJson<double>(json['decimalValue']),
      displayValue: serializer.fromJson<String>(json['displayValue']),
      displayPos: serializer.fromJson<int>(json['displayPos']),
      notesForFamily: serializer.fromJson<String>(json['notesForFamily']),
      cancelled: serializer.fromJson<bool>(json['cancelled']),
      underlined: serializer.fromJson<bool>(json['underlined']),
      periodPos: serializer.fromJson<int>(json['periodPos']),
      periodDesc: serializer.fromJson<String>(json['periodDesc']),
      componentPos: serializer.fromJson<int>(json['componentPos']),
      componentDesc: serializer.fromJson<String>(json['componentDesc']),
      weightFactor: serializer.fromJson<int>(json['weightFactor']),
      skillId: serializer.fromJson<int>(json['skillId']),
      gradeMasterId: serializer.fromJson<int>(json['gradeMasterId']),
      localllyCancelled: serializer.fromJson<bool>(json['localllyCancelled']),
      hasSeenIt: serializer.fromJson<bool>(json['hasSeenIt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subjectId': serializer.toJson<int>(subjectId),
      'subjectDesc': serializer.toJson<String>(subjectDesc),
      'evtId': serializer.toJson<int>(evtId),
      'evtCode': serializer.toJson<String>(evtCode),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'decimalValue': serializer.toJson<double>(decimalValue),
      'displayValue': serializer.toJson<String>(displayValue),
      'displayPos': serializer.toJson<int>(displayPos),
      'notesForFamily': serializer.toJson<String>(notesForFamily),
      'cancelled': serializer.toJson<bool>(cancelled),
      'underlined': serializer.toJson<bool>(underlined),
      'periodPos': serializer.toJson<int>(periodPos),
      'periodDesc': serializer.toJson<String>(periodDesc),
      'componentPos': serializer.toJson<int>(componentPos),
      'componentDesc': serializer.toJson<String>(componentDesc),
      'weightFactor': serializer.toJson<int>(weightFactor),
      'skillId': serializer.toJson<int>(skillId),
      'gradeMasterId': serializer.toJson<int>(gradeMasterId),
      'localllyCancelled': serializer.toJson<bool>(localllyCancelled),
      'hasSeenIt': serializer.toJson<bool>(hasSeenIt),
    };
  }

  GradeLocalModel copyWith(
          {int subjectId,
          String subjectDesc,
          int evtId,
          String evtCode,
          DateTime eventDate,
          double decimalValue,
          String displayValue,
          int displayPos,
          String notesForFamily,
          bool cancelled,
          bool underlined,
          int periodPos,
          String periodDesc,
          int componentPos,
          String componentDesc,
          int weightFactor,
          int skillId,
          int gradeMasterId,
          bool localllyCancelled,
          bool hasSeenIt}) =>
      GradeLocalModel(
        subjectId: subjectId ?? this.subjectId,
        subjectDesc: subjectDesc ?? this.subjectDesc,
        evtId: evtId ?? this.evtId,
        evtCode: evtCode ?? this.evtCode,
        eventDate: eventDate ?? this.eventDate,
        decimalValue: decimalValue ?? this.decimalValue,
        displayValue: displayValue ?? this.displayValue,
        displayPos: displayPos ?? this.displayPos,
        notesForFamily: notesForFamily ?? this.notesForFamily,
        cancelled: cancelled ?? this.cancelled,
        underlined: underlined ?? this.underlined,
        periodPos: periodPos ?? this.periodPos,
        periodDesc: periodDesc ?? this.periodDesc,
        componentPos: componentPos ?? this.componentPos,
        componentDesc: componentDesc ?? this.componentDesc,
        weightFactor: weightFactor ?? this.weightFactor,
        skillId: skillId ?? this.skillId,
        gradeMasterId: gradeMasterId ?? this.gradeMasterId,
        localllyCancelled: localllyCancelled ?? this.localllyCancelled,
        hasSeenIt: hasSeenIt ?? this.hasSeenIt,
      );
  @override
  String toString() {
    return (StringBuffer('GradeLocalModel(')
          ..write('subjectId: $subjectId, ')
          ..write('subjectDesc: $subjectDesc, ')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('eventDate: $eventDate, ')
          ..write('decimalValue: $decimalValue, ')
          ..write('displayValue: $displayValue, ')
          ..write('displayPos: $displayPos, ')
          ..write('notesForFamily: $notesForFamily, ')
          ..write('cancelled: $cancelled, ')
          ..write('underlined: $underlined, ')
          ..write('periodPos: $periodPos, ')
          ..write('periodDesc: $periodDesc, ')
          ..write('componentPos: $componentPos, ')
          ..write('componentDesc: $componentDesc, ')
          ..write('weightFactor: $weightFactor, ')
          ..write('skillId: $skillId, ')
          ..write('gradeMasterId: $gradeMasterId, ')
          ..write('localllyCancelled: $localllyCancelled, ')
          ..write('hasSeenIt: $hasSeenIt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      subjectId.hashCode,
      $mrjc(
          subjectDesc.hashCode,
          $mrjc(
              evtId.hashCode,
              $mrjc(
                  evtCode.hashCode,
                  $mrjc(
                      eventDate.hashCode,
                      $mrjc(
                          decimalValue.hashCode,
                          $mrjc(
                              displayValue.hashCode,
                              $mrjc(
                                  displayPos.hashCode,
                                  $mrjc(
                                      notesForFamily.hashCode,
                                      $mrjc(
                                          cancelled.hashCode,
                                          $mrjc(
                                              underlined.hashCode,
                                              $mrjc(
                                                  periodPos.hashCode,
                                                  $mrjc(
                                                      periodDesc.hashCode,
                                                      $mrjc(
                                                          componentPos.hashCode,
                                                          $mrjc(
                                                              componentDesc
                                                                  .hashCode,
                                                              $mrjc(
                                                                  weightFactor
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      skillId
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          gradeMasterId
                                                                              .hashCode,
                                                                          $mrjc(
                                                                              localllyCancelled.hashCode,
                                                                              hasSeenIt.hashCode))))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is GradeLocalModel &&
          other.subjectId == this.subjectId &&
          other.subjectDesc == this.subjectDesc &&
          other.evtId == this.evtId &&
          other.evtCode == this.evtCode &&
          other.eventDate == this.eventDate &&
          other.decimalValue == this.decimalValue &&
          other.displayValue == this.displayValue &&
          other.displayPos == this.displayPos &&
          other.notesForFamily == this.notesForFamily &&
          other.cancelled == this.cancelled &&
          other.underlined == this.underlined &&
          other.periodPos == this.periodPos &&
          other.periodDesc == this.periodDesc &&
          other.componentPos == this.componentPos &&
          other.componentDesc == this.componentDesc &&
          other.weightFactor == this.weightFactor &&
          other.skillId == this.skillId &&
          other.gradeMasterId == this.gradeMasterId &&
          other.localllyCancelled == this.localllyCancelled &&
          other.hasSeenIt == this.hasSeenIt);
}

class GradesCompanion extends UpdateCompanion<GradeLocalModel> {
  final Value<int> subjectId;
  final Value<String> subjectDesc;
  final Value<int> evtId;
  final Value<String> evtCode;
  final Value<DateTime> eventDate;
  final Value<double> decimalValue;
  final Value<String> displayValue;
  final Value<int> displayPos;
  final Value<String> notesForFamily;
  final Value<bool> cancelled;
  final Value<bool> underlined;
  final Value<int> periodPos;
  final Value<String> periodDesc;
  final Value<int> componentPos;
  final Value<String> componentDesc;
  final Value<int> weightFactor;
  final Value<int> skillId;
  final Value<int> gradeMasterId;
  final Value<bool> localllyCancelled;
  final Value<bool> hasSeenIt;
  const GradesCompanion({
    this.subjectId = const Value.absent(),
    this.subjectDesc = const Value.absent(),
    this.evtId = const Value.absent(),
    this.evtCode = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.decimalValue = const Value.absent(),
    this.displayValue = const Value.absent(),
    this.displayPos = const Value.absent(),
    this.notesForFamily = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.underlined = const Value.absent(),
    this.periodPos = const Value.absent(),
    this.periodDesc = const Value.absent(),
    this.componentPos = const Value.absent(),
    this.componentDesc = const Value.absent(),
    this.weightFactor = const Value.absent(),
    this.skillId = const Value.absent(),
    this.gradeMasterId = const Value.absent(),
    this.localllyCancelled = const Value.absent(),
    this.hasSeenIt = const Value.absent(),
  });
  GradesCompanion.insert({
    @required int subjectId,
    @required String subjectDesc,
    this.evtId = const Value.absent(),
    @required String evtCode,
    @required DateTime eventDate,
    @required double decimalValue,
    @required String displayValue,
    @required int displayPos,
    @required String notesForFamily,
    @required bool cancelled,
    @required bool underlined,
    @required int periodPos,
    @required String periodDesc,
    @required int componentPos,
    @required String componentDesc,
    @required int weightFactor,
    @required int skillId,
    @required int gradeMasterId,
    @required bool localllyCancelled,
    this.hasSeenIt = const Value.absent(),
  })  : subjectId = Value(subjectId),
        subjectDesc = Value(subjectDesc),
        evtCode = Value(evtCode),
        eventDate = Value(eventDate),
        decimalValue = Value(decimalValue),
        displayValue = Value(displayValue),
        displayPos = Value(displayPos),
        notesForFamily = Value(notesForFamily),
        cancelled = Value(cancelled),
        underlined = Value(underlined),
        periodPos = Value(periodPos),
        periodDesc = Value(periodDesc),
        componentPos = Value(componentPos),
        componentDesc = Value(componentDesc),
        weightFactor = Value(weightFactor),
        skillId = Value(skillId),
        gradeMasterId = Value(gradeMasterId),
        localllyCancelled = Value(localllyCancelled);
  static Insertable<GradeLocalModel> custom({
    Expression<int> subjectId,
    Expression<String> subjectDesc,
    Expression<int> evtId,
    Expression<String> evtCode,
    Expression<DateTime> eventDate,
    Expression<double> decimalValue,
    Expression<String> displayValue,
    Expression<int> displayPos,
    Expression<String> notesForFamily,
    Expression<bool> cancelled,
    Expression<bool> underlined,
    Expression<int> periodPos,
    Expression<String> periodDesc,
    Expression<int> componentPos,
    Expression<String> componentDesc,
    Expression<int> weightFactor,
    Expression<int> skillId,
    Expression<int> gradeMasterId,
    Expression<bool> localllyCancelled,
    Expression<bool> hasSeenIt,
  }) {
    return RawValuesInsertable({
      if (subjectId != null) 'subject_id': subjectId,
      if (subjectDesc != null) 'subject_desc': subjectDesc,
      if (evtId != null) 'evt_id': evtId,
      if (evtCode != null) 'evt_code': evtCode,
      if (eventDate != null) 'event_date': eventDate,
      if (decimalValue != null) 'decimal_value': decimalValue,
      if (displayValue != null) 'display_value': displayValue,
      if (displayPos != null) 'display_pos': displayPos,
      if (notesForFamily != null) 'notes_for_family': notesForFamily,
      if (cancelled != null) 'cancelled': cancelled,
      if (underlined != null) 'underlined': underlined,
      if (periodPos != null) 'period_pos': periodPos,
      if (periodDesc != null) 'period_desc': periodDesc,
      if (componentPos != null) 'component_pos': componentPos,
      if (componentDesc != null) 'component_desc': componentDesc,
      if (weightFactor != null) 'weight_factor': weightFactor,
      if (skillId != null) 'skill_id': skillId,
      if (gradeMasterId != null) 'grade_master_id': gradeMasterId,
      if (localllyCancelled != null) 'locallly_cancelled': localllyCancelled,
      if (hasSeenIt != null) 'has_seen_it': hasSeenIt,
    });
  }

  GradesCompanion copyWith(
      {Value<int> subjectId,
      Value<String> subjectDesc,
      Value<int> evtId,
      Value<String> evtCode,
      Value<DateTime> eventDate,
      Value<double> decimalValue,
      Value<String> displayValue,
      Value<int> displayPos,
      Value<String> notesForFamily,
      Value<bool> cancelled,
      Value<bool> underlined,
      Value<int> periodPos,
      Value<String> periodDesc,
      Value<int> componentPos,
      Value<String> componentDesc,
      Value<int> weightFactor,
      Value<int> skillId,
      Value<int> gradeMasterId,
      Value<bool> localllyCancelled,
      Value<bool> hasSeenIt}) {
    return GradesCompanion(
      subjectId: subjectId ?? this.subjectId,
      subjectDesc: subjectDesc ?? this.subjectDesc,
      evtId: evtId ?? this.evtId,
      evtCode: evtCode ?? this.evtCode,
      eventDate: eventDate ?? this.eventDate,
      decimalValue: decimalValue ?? this.decimalValue,
      displayValue: displayValue ?? this.displayValue,
      displayPos: displayPos ?? this.displayPos,
      notesForFamily: notesForFamily ?? this.notesForFamily,
      cancelled: cancelled ?? this.cancelled,
      underlined: underlined ?? this.underlined,
      periodPos: periodPos ?? this.periodPos,
      periodDesc: periodDesc ?? this.periodDesc,
      componentPos: componentPos ?? this.componentPos,
      componentDesc: componentDesc ?? this.componentDesc,
      weightFactor: weightFactor ?? this.weightFactor,
      skillId: skillId ?? this.skillId,
      gradeMasterId: gradeMasterId ?? this.gradeMasterId,
      localllyCancelled: localllyCancelled ?? this.localllyCancelled,
      hasSeenIt: hasSeenIt ?? this.hasSeenIt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (subjectDesc.present) {
      map['subject_desc'] = Variable<String>(subjectDesc.value);
    }
    if (evtId.present) {
      map['evt_id'] = Variable<int>(evtId.value);
    }
    if (evtCode.present) {
      map['evt_code'] = Variable<String>(evtCode.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (decimalValue.present) {
      map['decimal_value'] = Variable<double>(decimalValue.value);
    }
    if (displayValue.present) {
      map['display_value'] = Variable<String>(displayValue.value);
    }
    if (displayPos.present) {
      map['display_pos'] = Variable<int>(displayPos.value);
    }
    if (notesForFamily.present) {
      map['notes_for_family'] = Variable<String>(notesForFamily.value);
    }
    if (cancelled.present) {
      map['cancelled'] = Variable<bool>(cancelled.value);
    }
    if (underlined.present) {
      map['underlined'] = Variable<bool>(underlined.value);
    }
    if (periodPos.present) {
      map['period_pos'] = Variable<int>(periodPos.value);
    }
    if (periodDesc.present) {
      map['period_desc'] = Variable<String>(periodDesc.value);
    }
    if (componentPos.present) {
      map['component_pos'] = Variable<int>(componentPos.value);
    }
    if (componentDesc.present) {
      map['component_desc'] = Variable<String>(componentDesc.value);
    }
    if (weightFactor.present) {
      map['weight_factor'] = Variable<int>(weightFactor.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<int>(skillId.value);
    }
    if (gradeMasterId.present) {
      map['grade_master_id'] = Variable<int>(gradeMasterId.value);
    }
    if (localllyCancelled.present) {
      map['locallly_cancelled'] = Variable<bool>(localllyCancelled.value);
    }
    if (hasSeenIt.present) {
      map['has_seen_it'] = Variable<bool>(hasSeenIt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GradesCompanion(')
          ..write('subjectId: $subjectId, ')
          ..write('subjectDesc: $subjectDesc, ')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('eventDate: $eventDate, ')
          ..write('decimalValue: $decimalValue, ')
          ..write('displayValue: $displayValue, ')
          ..write('displayPos: $displayPos, ')
          ..write('notesForFamily: $notesForFamily, ')
          ..write('cancelled: $cancelled, ')
          ..write('underlined: $underlined, ')
          ..write('periodPos: $periodPos, ')
          ..write('periodDesc: $periodDesc, ')
          ..write('componentPos: $componentPos, ')
          ..write('componentDesc: $componentDesc, ')
          ..write('weightFactor: $weightFactor, ')
          ..write('skillId: $skillId, ')
          ..write('gradeMasterId: $gradeMasterId, ')
          ..write('localllyCancelled: $localllyCancelled, ')
          ..write('hasSeenIt: $hasSeenIt')
          ..write(')'))
        .toString();
  }
}

class $GradesTable extends Grades
    with TableInfo<$GradesTable, GradeLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $GradesTable(this._db, [this._alias]);
  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedIntColumn _subjectId;
  @override
  GeneratedIntColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedIntColumn _constructSubjectId() {
    return GeneratedIntColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectDescMeta =
      const VerificationMeta('subjectDesc');
  GeneratedTextColumn _subjectDesc;
  @override
  GeneratedTextColumn get subjectDesc =>
      _subjectDesc ??= _constructSubjectDesc();
  GeneratedTextColumn _constructSubjectDesc() {
    return GeneratedTextColumn(
      'subject_desc',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtIdMeta = const VerificationMeta('evtId');
  GeneratedIntColumn _evtId;
  @override
  GeneratedIntColumn get evtId => _evtId ??= _constructEvtId();
  GeneratedIntColumn _constructEvtId() {
    return GeneratedIntColumn(
      'evt_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtCodeMeta = const VerificationMeta('evtCode');
  GeneratedTextColumn _evtCode;
  @override
  GeneratedTextColumn get evtCode => _evtCode ??= _constructEvtCode();
  GeneratedTextColumn _constructEvtCode() {
    return GeneratedTextColumn(
      'evt_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _eventDateMeta = const VerificationMeta('eventDate');
  GeneratedDateTimeColumn _eventDate;
  @override
  GeneratedDateTimeColumn get eventDate => _eventDate ??= _constructEventDate();
  GeneratedDateTimeColumn _constructEventDate() {
    return GeneratedDateTimeColumn(
      'event_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _decimalValueMeta =
      const VerificationMeta('decimalValue');
  GeneratedRealColumn _decimalValue;
  @override
  GeneratedRealColumn get decimalValue =>
      _decimalValue ??= _constructDecimalValue();
  GeneratedRealColumn _constructDecimalValue() {
    return GeneratedRealColumn(
      'decimal_value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _displayValueMeta =
      const VerificationMeta('displayValue');
  GeneratedTextColumn _displayValue;
  @override
  GeneratedTextColumn get displayValue =>
      _displayValue ??= _constructDisplayValue();
  GeneratedTextColumn _constructDisplayValue() {
    return GeneratedTextColumn(
      'display_value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _displayPosMeta = const VerificationMeta('displayPos');
  GeneratedIntColumn _displayPos;
  @override
  GeneratedIntColumn get displayPos => _displayPos ??= _constructDisplayPos();
  GeneratedIntColumn _constructDisplayPos() {
    return GeneratedIntColumn(
      'display_pos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _notesForFamilyMeta =
      const VerificationMeta('notesForFamily');
  GeneratedTextColumn _notesForFamily;
  @override
  GeneratedTextColumn get notesForFamily =>
      _notesForFamily ??= _constructNotesForFamily();
  GeneratedTextColumn _constructNotesForFamily() {
    return GeneratedTextColumn(
      'notes_for_family',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cancelledMeta = const VerificationMeta('cancelled');
  GeneratedBoolColumn _cancelled;
  @override
  GeneratedBoolColumn get cancelled => _cancelled ??= _constructCancelled();
  GeneratedBoolColumn _constructCancelled() {
    return GeneratedBoolColumn(
      'cancelled',
      $tableName,
      false,
    );
  }

  final VerificationMeta _underlinedMeta = const VerificationMeta('underlined');
  GeneratedBoolColumn _underlined;
  @override
  GeneratedBoolColumn get underlined => _underlined ??= _constructUnderlined();
  GeneratedBoolColumn _constructUnderlined() {
    return GeneratedBoolColumn(
      'underlined',
      $tableName,
      false,
    );
  }

  final VerificationMeta _periodPosMeta = const VerificationMeta('periodPos');
  GeneratedIntColumn _periodPos;
  @override
  GeneratedIntColumn get periodPos => _periodPos ??= _constructPeriodPos();
  GeneratedIntColumn _constructPeriodPos() {
    return GeneratedIntColumn(
      'period_pos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _periodDescMeta = const VerificationMeta('periodDesc');
  GeneratedTextColumn _periodDesc;
  @override
  GeneratedTextColumn get periodDesc => _periodDesc ??= _constructPeriodDesc();
  GeneratedTextColumn _constructPeriodDesc() {
    return GeneratedTextColumn(
      'period_desc',
      $tableName,
      false,
    );
  }

  final VerificationMeta _componentPosMeta =
      const VerificationMeta('componentPos');
  GeneratedIntColumn _componentPos;
  @override
  GeneratedIntColumn get componentPos =>
      _componentPos ??= _constructComponentPos();
  GeneratedIntColumn _constructComponentPos() {
    return GeneratedIntColumn(
      'component_pos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _componentDescMeta =
      const VerificationMeta('componentDesc');
  GeneratedTextColumn _componentDesc;
  @override
  GeneratedTextColumn get componentDesc =>
      _componentDesc ??= _constructComponentDesc();
  GeneratedTextColumn _constructComponentDesc() {
    return GeneratedTextColumn(
      'component_desc',
      $tableName,
      false,
    );
  }

  final VerificationMeta _weightFactorMeta =
      const VerificationMeta('weightFactor');
  GeneratedIntColumn _weightFactor;
  @override
  GeneratedIntColumn get weightFactor =>
      _weightFactor ??= _constructWeightFactor();
  GeneratedIntColumn _constructWeightFactor() {
    return GeneratedIntColumn(
      'weight_factor',
      $tableName,
      false,
    );
  }

  final VerificationMeta _skillIdMeta = const VerificationMeta('skillId');
  GeneratedIntColumn _skillId;
  @override
  GeneratedIntColumn get skillId => _skillId ??= _constructSkillId();
  GeneratedIntColumn _constructSkillId() {
    return GeneratedIntColumn(
      'skill_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _gradeMasterIdMeta =
      const VerificationMeta('gradeMasterId');
  GeneratedIntColumn _gradeMasterId;
  @override
  GeneratedIntColumn get gradeMasterId =>
      _gradeMasterId ??= _constructGradeMasterId();
  GeneratedIntColumn _constructGradeMasterId() {
    return GeneratedIntColumn(
      'grade_master_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _localllyCancelledMeta =
      const VerificationMeta('localllyCancelled');
  GeneratedBoolColumn _localllyCancelled;
  @override
  GeneratedBoolColumn get localllyCancelled =>
      _localllyCancelled ??= _constructLocalllyCancelled();
  GeneratedBoolColumn _constructLocalllyCancelled() {
    return GeneratedBoolColumn(
      'locallly_cancelled',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hasSeenItMeta = const VerificationMeta('hasSeenIt');
  GeneratedBoolColumn _hasSeenIt;
  @override
  GeneratedBoolColumn get hasSeenIt => _hasSeenIt ??= _constructHasSeenIt();
  GeneratedBoolColumn _constructHasSeenIt() {
    return GeneratedBoolColumn('has_seen_it', $tableName, false,
        defaultValue: const Constant(true));
  }

  @override
  List<GeneratedColumn> get $columns => [
        subjectId,
        subjectDesc,
        evtId,
        evtCode,
        eventDate,
        decimalValue,
        displayValue,
        displayPos,
        notesForFamily,
        cancelled,
        underlined,
        periodPos,
        periodDesc,
        componentPos,
        componentDesc,
        weightFactor,
        skillId,
        gradeMasterId,
        localllyCancelled,
        hasSeenIt
      ];
  @override
  $GradesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'grades';
  @override
  final String actualTableName = 'grades';
  @override
  VerificationContext validateIntegrity(Insertable<GradeLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id'], _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('subject_desc')) {
      context.handle(
          _subjectDescMeta,
          subjectDesc.isAcceptableOrUnknown(
              data['subject_desc'], _subjectDescMeta));
    } else if (isInserting) {
      context.missing(_subjectDescMeta);
    }
    if (data.containsKey('evt_id')) {
      context.handle(
          _evtIdMeta, evtId.isAcceptableOrUnknown(data['evt_id'], _evtIdMeta));
    }
    if (data.containsKey('evt_code')) {
      context.handle(_evtCodeMeta,
          evtCode.isAcceptableOrUnknown(data['evt_code'], _evtCodeMeta));
    } else if (isInserting) {
      context.missing(_evtCodeMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(_eventDateMeta,
          eventDate.isAcceptableOrUnknown(data['event_date'], _eventDateMeta));
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('decimal_value')) {
      context.handle(
          _decimalValueMeta,
          decimalValue.isAcceptableOrUnknown(
              data['decimal_value'], _decimalValueMeta));
    } else if (isInserting) {
      context.missing(_decimalValueMeta);
    }
    if (data.containsKey('display_value')) {
      context.handle(
          _displayValueMeta,
          displayValue.isAcceptableOrUnknown(
              data['display_value'], _displayValueMeta));
    } else if (isInserting) {
      context.missing(_displayValueMeta);
    }
    if (data.containsKey('display_pos')) {
      context.handle(
          _displayPosMeta,
          displayPos.isAcceptableOrUnknown(
              data['display_pos'], _displayPosMeta));
    } else if (isInserting) {
      context.missing(_displayPosMeta);
    }
    if (data.containsKey('notes_for_family')) {
      context.handle(
          _notesForFamilyMeta,
          notesForFamily.isAcceptableOrUnknown(
              data['notes_for_family'], _notesForFamilyMeta));
    } else if (isInserting) {
      context.missing(_notesForFamilyMeta);
    }
    if (data.containsKey('cancelled')) {
      context.handle(_cancelledMeta,
          cancelled.isAcceptableOrUnknown(data['cancelled'], _cancelledMeta));
    } else if (isInserting) {
      context.missing(_cancelledMeta);
    }
    if (data.containsKey('underlined')) {
      context.handle(
          _underlinedMeta,
          underlined.isAcceptableOrUnknown(
              data['underlined'], _underlinedMeta));
    } else if (isInserting) {
      context.missing(_underlinedMeta);
    }
    if (data.containsKey('period_pos')) {
      context.handle(_periodPosMeta,
          periodPos.isAcceptableOrUnknown(data['period_pos'], _periodPosMeta));
    } else if (isInserting) {
      context.missing(_periodPosMeta);
    }
    if (data.containsKey('period_desc')) {
      context.handle(
          _periodDescMeta,
          periodDesc.isAcceptableOrUnknown(
              data['period_desc'], _periodDescMeta));
    } else if (isInserting) {
      context.missing(_periodDescMeta);
    }
    if (data.containsKey('component_pos')) {
      context.handle(
          _componentPosMeta,
          componentPos.isAcceptableOrUnknown(
              data['component_pos'], _componentPosMeta));
    } else if (isInserting) {
      context.missing(_componentPosMeta);
    }
    if (data.containsKey('component_desc')) {
      context.handle(
          _componentDescMeta,
          componentDesc.isAcceptableOrUnknown(
              data['component_desc'], _componentDescMeta));
    } else if (isInserting) {
      context.missing(_componentDescMeta);
    }
    if (data.containsKey('weight_factor')) {
      context.handle(
          _weightFactorMeta,
          weightFactor.isAcceptableOrUnknown(
              data['weight_factor'], _weightFactorMeta));
    } else if (isInserting) {
      context.missing(_weightFactorMeta);
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id'], _skillIdMeta));
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('grade_master_id')) {
      context.handle(
          _gradeMasterIdMeta,
          gradeMasterId.isAcceptableOrUnknown(
              data['grade_master_id'], _gradeMasterIdMeta));
    } else if (isInserting) {
      context.missing(_gradeMasterIdMeta);
    }
    if (data.containsKey('locallly_cancelled')) {
      context.handle(
          _localllyCancelledMeta,
          localllyCancelled.isAcceptableOrUnknown(
              data['locallly_cancelled'], _localllyCancelledMeta));
    } else if (isInserting) {
      context.missing(_localllyCancelledMeta);
    }
    if (data.containsKey('has_seen_it')) {
      context.handle(_hasSeenItMeta,
          hasSeenIt.isAcceptableOrUnknown(data['has_seen_it'], _hasSeenItMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {evtId};
  @override
  GradeLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GradeLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $GradesTable createAlias(String alias) {
    return $GradesTable(_db, alias);
  }
}

class AgendaEventLocalModel extends DataClass
    implements Insertable<AgendaEventLocalModel> {
  final int evtId;
  final String evtCode;
  final DateTime begin;
  final DateTime end;
  final bool isFullDay;
  final String notes;
  final String authorName;
  final String classDesc;
  final int subjectId;
  final String subjectDesc;
  final bool isLocal;
  final String labelColor;
  final String title;
  AgendaEventLocalModel(
      {@required this.evtId,
      @required this.evtCode,
      @required this.begin,
      @required this.end,
      @required this.isFullDay,
      @required this.notes,
      @required this.authorName,
      @required this.classDesc,
      @required this.subjectId,
      @required this.subjectDesc,
      @required this.isLocal,
      @required this.labelColor,
      @required this.title});
  factory AgendaEventLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return AgendaEventLocalModel(
      evtId: intType.mapFromDatabaseResponse(data['${effectivePrefix}evt_id']),
      evtCode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}evt_code']),
      begin:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}begin']),
      end: dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
      isFullDay: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_full_day']),
      notes:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}notes']),
      authorName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}author_name']),
      classDesc: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}class_desc']),
      subjectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject_id']),
      subjectDesc: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_desc']),
      isLocal:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_local']),
      labelColor: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}label_color']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || evtId != null) {
      map['evt_id'] = Variable<int>(evtId);
    }
    if (!nullToAbsent || evtCode != null) {
      map['evt_code'] = Variable<String>(evtCode);
    }
    if (!nullToAbsent || begin != null) {
      map['begin'] = Variable<DateTime>(begin);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    if (!nullToAbsent || isFullDay != null) {
      map['is_full_day'] = Variable<bool>(isFullDay);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    if (!nullToAbsent || classDesc != null) {
      map['class_desc'] = Variable<String>(classDesc);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || subjectDesc != null) {
      map['subject_desc'] = Variable<String>(subjectDesc);
    }
    if (!nullToAbsent || isLocal != null) {
      map['is_local'] = Variable<bool>(isLocal);
    }
    if (!nullToAbsent || labelColor != null) {
      map['label_color'] = Variable<String>(labelColor);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  AgendaEventsTableCompanion toCompanion(bool nullToAbsent) {
    return AgendaEventsTableCompanion(
      evtId:
          evtId == null && nullToAbsent ? const Value.absent() : Value(evtId),
      evtCode: evtCode == null && nullToAbsent
          ? const Value.absent()
          : Value(evtCode),
      begin:
          begin == null && nullToAbsent ? const Value.absent() : Value(begin),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      isFullDay: isFullDay == null && nullToAbsent
          ? const Value.absent()
          : Value(isFullDay),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      classDesc: classDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(classDesc),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      subjectDesc: subjectDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectDesc),
      isLocal: isLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(isLocal),
      labelColor: labelColor == null && nullToAbsent
          ? const Value.absent()
          : Value(labelColor),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory AgendaEventLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AgendaEventLocalModel(
      evtId: serializer.fromJson<int>(json['evtId']),
      evtCode: serializer.fromJson<String>(json['evtCode']),
      begin: serializer.fromJson<DateTime>(json['begin']),
      end: serializer.fromJson<DateTime>(json['end']),
      isFullDay: serializer.fromJson<bool>(json['isFullDay']),
      notes: serializer.fromJson<String>(json['notes']),
      authorName: serializer.fromJson<String>(json['authorName']),
      classDesc: serializer.fromJson<String>(json['classDesc']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      subjectDesc: serializer.fromJson<String>(json['subjectDesc']),
      isLocal: serializer.fromJson<bool>(json['isLocal']),
      labelColor: serializer.fromJson<String>(json['labelColor']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'evtId': serializer.toJson<int>(evtId),
      'evtCode': serializer.toJson<String>(evtCode),
      'begin': serializer.toJson<DateTime>(begin),
      'end': serializer.toJson<DateTime>(end),
      'isFullDay': serializer.toJson<bool>(isFullDay),
      'notes': serializer.toJson<String>(notes),
      'authorName': serializer.toJson<String>(authorName),
      'classDesc': serializer.toJson<String>(classDesc),
      'subjectId': serializer.toJson<int>(subjectId),
      'subjectDesc': serializer.toJson<String>(subjectDesc),
      'isLocal': serializer.toJson<bool>(isLocal),
      'labelColor': serializer.toJson<String>(labelColor),
      'title': serializer.toJson<String>(title),
    };
  }

  AgendaEventLocalModel copyWith(
          {int evtId,
          String evtCode,
          DateTime begin,
          DateTime end,
          bool isFullDay,
          String notes,
          String authorName,
          String classDesc,
          int subjectId,
          String subjectDesc,
          bool isLocal,
          String labelColor,
          String title}) =>
      AgendaEventLocalModel(
        evtId: evtId ?? this.evtId,
        evtCode: evtCode ?? this.evtCode,
        begin: begin ?? this.begin,
        end: end ?? this.end,
        isFullDay: isFullDay ?? this.isFullDay,
        notes: notes ?? this.notes,
        authorName: authorName ?? this.authorName,
        classDesc: classDesc ?? this.classDesc,
        subjectId: subjectId ?? this.subjectId,
        subjectDesc: subjectDesc ?? this.subjectDesc,
        isLocal: isLocal ?? this.isLocal,
        labelColor: labelColor ?? this.labelColor,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('AgendaEventLocalModel(')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('begin: $begin, ')
          ..write('end: $end, ')
          ..write('isFullDay: $isFullDay, ')
          ..write('notes: $notes, ')
          ..write('authorName: $authorName, ')
          ..write('classDesc: $classDesc, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectDesc: $subjectDesc, ')
          ..write('isLocal: $isLocal, ')
          ..write('labelColor: $labelColor, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      evtId.hashCode,
      $mrjc(
          evtCode.hashCode,
          $mrjc(
              begin.hashCode,
              $mrjc(
                  end.hashCode,
                  $mrjc(
                      isFullDay.hashCode,
                      $mrjc(
                          notes.hashCode,
                          $mrjc(
                              authorName.hashCode,
                              $mrjc(
                                  classDesc.hashCode,
                                  $mrjc(
                                      subjectId.hashCode,
                                      $mrjc(
                                          subjectDesc.hashCode,
                                          $mrjc(
                                              isLocal.hashCode,
                                              $mrjc(labelColor.hashCode,
                                                  title.hashCode)))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AgendaEventLocalModel &&
          other.evtId == this.evtId &&
          other.evtCode == this.evtCode &&
          other.begin == this.begin &&
          other.end == this.end &&
          other.isFullDay == this.isFullDay &&
          other.notes == this.notes &&
          other.authorName == this.authorName &&
          other.classDesc == this.classDesc &&
          other.subjectId == this.subjectId &&
          other.subjectDesc == this.subjectDesc &&
          other.isLocal == this.isLocal &&
          other.labelColor == this.labelColor &&
          other.title == this.title);
}

class AgendaEventsTableCompanion
    extends UpdateCompanion<AgendaEventLocalModel> {
  final Value<int> evtId;
  final Value<String> evtCode;
  final Value<DateTime> begin;
  final Value<DateTime> end;
  final Value<bool> isFullDay;
  final Value<String> notes;
  final Value<String> authorName;
  final Value<String> classDesc;
  final Value<int> subjectId;
  final Value<String> subjectDesc;
  final Value<bool> isLocal;
  final Value<String> labelColor;
  final Value<String> title;
  const AgendaEventsTableCompanion({
    this.evtId = const Value.absent(),
    this.evtCode = const Value.absent(),
    this.begin = const Value.absent(),
    this.end = const Value.absent(),
    this.isFullDay = const Value.absent(),
    this.notes = const Value.absent(),
    this.authorName = const Value.absent(),
    this.classDesc = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.subjectDesc = const Value.absent(),
    this.isLocal = const Value.absent(),
    this.labelColor = const Value.absent(),
    this.title = const Value.absent(),
  });
  AgendaEventsTableCompanion.insert({
    this.evtId = const Value.absent(),
    @required String evtCode,
    @required DateTime begin,
    @required DateTime end,
    @required bool isFullDay,
    @required String notes,
    @required String authorName,
    @required String classDesc,
    @required int subjectId,
    @required String subjectDesc,
    @required bool isLocal,
    @required String labelColor,
    @required String title,
  })  : evtCode = Value(evtCode),
        begin = Value(begin),
        end = Value(end),
        isFullDay = Value(isFullDay),
        notes = Value(notes),
        authorName = Value(authorName),
        classDesc = Value(classDesc),
        subjectId = Value(subjectId),
        subjectDesc = Value(subjectDesc),
        isLocal = Value(isLocal),
        labelColor = Value(labelColor),
        title = Value(title);
  static Insertable<AgendaEventLocalModel> custom({
    Expression<int> evtId,
    Expression<String> evtCode,
    Expression<DateTime> begin,
    Expression<DateTime> end,
    Expression<bool> isFullDay,
    Expression<String> notes,
    Expression<String> authorName,
    Expression<String> classDesc,
    Expression<int> subjectId,
    Expression<String> subjectDesc,
    Expression<bool> isLocal,
    Expression<String> labelColor,
    Expression<String> title,
  }) {
    return RawValuesInsertable({
      if (evtId != null) 'evt_id': evtId,
      if (evtCode != null) 'evt_code': evtCode,
      if (begin != null) 'begin': begin,
      if (end != null) 'end': end,
      if (isFullDay != null) 'is_full_day': isFullDay,
      if (notes != null) 'notes': notes,
      if (authorName != null) 'author_name': authorName,
      if (classDesc != null) 'class_desc': classDesc,
      if (subjectId != null) 'subject_id': subjectId,
      if (subjectDesc != null) 'subject_desc': subjectDesc,
      if (isLocal != null) 'is_local': isLocal,
      if (labelColor != null) 'label_color': labelColor,
      if (title != null) 'title': title,
    });
  }

  AgendaEventsTableCompanion copyWith(
      {Value<int> evtId,
      Value<String> evtCode,
      Value<DateTime> begin,
      Value<DateTime> end,
      Value<bool> isFullDay,
      Value<String> notes,
      Value<String> authorName,
      Value<String> classDesc,
      Value<int> subjectId,
      Value<String> subjectDesc,
      Value<bool> isLocal,
      Value<String> labelColor,
      Value<String> title}) {
    return AgendaEventsTableCompanion(
      evtId: evtId ?? this.evtId,
      evtCode: evtCode ?? this.evtCode,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      isFullDay: isFullDay ?? this.isFullDay,
      notes: notes ?? this.notes,
      authorName: authorName ?? this.authorName,
      classDesc: classDesc ?? this.classDesc,
      subjectId: subjectId ?? this.subjectId,
      subjectDesc: subjectDesc ?? this.subjectDesc,
      isLocal: isLocal ?? this.isLocal,
      labelColor: labelColor ?? this.labelColor,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (evtId.present) {
      map['evt_id'] = Variable<int>(evtId.value);
    }
    if (evtCode.present) {
      map['evt_code'] = Variable<String>(evtCode.value);
    }
    if (begin.present) {
      map['begin'] = Variable<DateTime>(begin.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (isFullDay.present) {
      map['is_full_day'] = Variable<bool>(isFullDay.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (classDesc.present) {
      map['class_desc'] = Variable<String>(classDesc.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (subjectDesc.present) {
      map['subject_desc'] = Variable<String>(subjectDesc.value);
    }
    if (isLocal.present) {
      map['is_local'] = Variable<bool>(isLocal.value);
    }
    if (labelColor.present) {
      map['label_color'] = Variable<String>(labelColor.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgendaEventsTableCompanion(')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('begin: $begin, ')
          ..write('end: $end, ')
          ..write('isFullDay: $isFullDay, ')
          ..write('notes: $notes, ')
          ..write('authorName: $authorName, ')
          ..write('classDesc: $classDesc, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectDesc: $subjectDesc, ')
          ..write('isLocal: $isLocal, ')
          ..write('labelColor: $labelColor, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $AgendaEventsTableTable extends AgendaEventsTable
    with TableInfo<$AgendaEventsTableTable, AgendaEventLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $AgendaEventsTableTable(this._db, [this._alias]);
  final VerificationMeta _evtIdMeta = const VerificationMeta('evtId');
  GeneratedIntColumn _evtId;
  @override
  GeneratedIntColumn get evtId => _evtId ??= _constructEvtId();
  GeneratedIntColumn _constructEvtId() {
    return GeneratedIntColumn(
      'evt_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtCodeMeta = const VerificationMeta('evtCode');
  GeneratedTextColumn _evtCode;
  @override
  GeneratedTextColumn get evtCode => _evtCode ??= _constructEvtCode();
  GeneratedTextColumn _constructEvtCode() {
    return GeneratedTextColumn(
      'evt_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _beginMeta = const VerificationMeta('begin');
  GeneratedDateTimeColumn _begin;
  @override
  GeneratedDateTimeColumn get begin => _begin ??= _constructBegin();
  GeneratedDateTimeColumn _constructBegin() {
    return GeneratedDateTimeColumn(
      'begin',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endMeta = const VerificationMeta('end');
  GeneratedDateTimeColumn _end;
  @override
  GeneratedDateTimeColumn get end => _end ??= _constructEnd();
  GeneratedDateTimeColumn _constructEnd() {
    return GeneratedDateTimeColumn(
      'end',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isFullDayMeta = const VerificationMeta('isFullDay');
  GeneratedBoolColumn _isFullDay;
  @override
  GeneratedBoolColumn get isFullDay => _isFullDay ??= _constructIsFullDay();
  GeneratedBoolColumn _constructIsFullDay() {
    return GeneratedBoolColumn(
      'is_full_day',
      $tableName,
      false,
    );
  }

  final VerificationMeta _notesMeta = const VerificationMeta('notes');
  GeneratedTextColumn _notes;
  @override
  GeneratedTextColumn get notes => _notes ??= _constructNotes();
  GeneratedTextColumn _constructNotes() {
    return GeneratedTextColumn(
      'notes',
      $tableName,
      false,
    );
  }

  final VerificationMeta _authorNameMeta = const VerificationMeta('authorName');
  GeneratedTextColumn _authorName;
  @override
  GeneratedTextColumn get authorName => _authorName ??= _constructAuthorName();
  GeneratedTextColumn _constructAuthorName() {
    return GeneratedTextColumn(
      'author_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _classDescMeta = const VerificationMeta('classDesc');
  GeneratedTextColumn _classDesc;
  @override
  GeneratedTextColumn get classDesc => _classDesc ??= _constructClassDesc();
  GeneratedTextColumn _constructClassDesc() {
    return GeneratedTextColumn(
      'class_desc',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedIntColumn _subjectId;
  @override
  GeneratedIntColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedIntColumn _constructSubjectId() {
    return GeneratedIntColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectDescMeta =
      const VerificationMeta('subjectDesc');
  GeneratedTextColumn _subjectDesc;
  @override
  GeneratedTextColumn get subjectDesc =>
      _subjectDesc ??= _constructSubjectDesc();
  GeneratedTextColumn _constructSubjectDesc() {
    return GeneratedTextColumn(
      'subject_desc',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isLocalMeta = const VerificationMeta('isLocal');
  GeneratedBoolColumn _isLocal;
  @override
  GeneratedBoolColumn get isLocal => _isLocal ??= _constructIsLocal();
  GeneratedBoolColumn _constructIsLocal() {
    return GeneratedBoolColumn(
      'is_local',
      $tableName,
      false,
    );
  }

  final VerificationMeta _labelColorMeta = const VerificationMeta('labelColor');
  GeneratedTextColumn _labelColor;
  @override
  GeneratedTextColumn get labelColor => _labelColor ??= _constructLabelColor();
  GeneratedTextColumn _constructLabelColor() {
    return GeneratedTextColumn(
      'label_color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        evtId,
        evtCode,
        begin,
        end,
        isFullDay,
        notes,
        authorName,
        classDesc,
        subjectId,
        subjectDesc,
        isLocal,
        labelColor,
        title
      ];
  @override
  $AgendaEventsTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'agenda_events';
  @override
  final String actualTableName = 'agenda_events';
  @override
  VerificationContext validateIntegrity(
      Insertable<AgendaEventLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('evt_id')) {
      context.handle(
          _evtIdMeta, evtId.isAcceptableOrUnknown(data['evt_id'], _evtIdMeta));
    }
    if (data.containsKey('evt_code')) {
      context.handle(_evtCodeMeta,
          evtCode.isAcceptableOrUnknown(data['evt_code'], _evtCodeMeta));
    } else if (isInserting) {
      context.missing(_evtCodeMeta);
    }
    if (data.containsKey('begin')) {
      context.handle(
          _beginMeta, begin.isAcceptableOrUnknown(data['begin'], _beginMeta));
    } else if (isInserting) {
      context.missing(_beginMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end'], _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('is_full_day')) {
      context.handle(_isFullDayMeta,
          isFullDay.isAcceptableOrUnknown(data['is_full_day'], _isFullDayMeta));
    } else if (isInserting) {
      context.missing(_isFullDayMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes'], _notesMeta));
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _authorNameMeta,
          authorName.isAcceptableOrUnknown(
              data['author_name'], _authorNameMeta));
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('class_desc')) {
      context.handle(_classDescMeta,
          classDesc.isAcceptableOrUnknown(data['class_desc'], _classDescMeta));
    } else if (isInserting) {
      context.missing(_classDescMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id'], _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('subject_desc')) {
      context.handle(
          _subjectDescMeta,
          subjectDesc.isAcceptableOrUnknown(
              data['subject_desc'], _subjectDescMeta));
    } else if (isInserting) {
      context.missing(_subjectDescMeta);
    }
    if (data.containsKey('is_local')) {
      context.handle(_isLocalMeta,
          isLocal.isAcceptableOrUnknown(data['is_local'], _isLocalMeta));
    } else if (isInserting) {
      context.missing(_isLocalMeta);
    }
    if (data.containsKey('label_color')) {
      context.handle(
          _labelColorMeta,
          labelColor.isAcceptableOrUnknown(
              data['label_color'], _labelColorMeta));
    } else if (isInserting) {
      context.missing(_labelColorMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {evtId};
  @override
  AgendaEventLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AgendaEventLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AgendaEventsTableTable createAlias(String alias) {
    return $AgendaEventsTableTable(_db, alias);
  }
}

class Absence extends DataClass implements Insertable<Absence> {
  final int evtId;
  final String evtCode;
  final DateTime evtDate;
  final int evtHPos;
  final int evtValue;
  final bool isJustified;
  final String justifiedReasonCode;
  final String justifReasonDesc;
  Absence(
      {@required this.evtId,
      @required this.evtCode,
      @required this.evtDate,
      @required this.evtHPos,
      @required this.evtValue,
      @required this.isJustified,
      @required this.justifiedReasonCode,
      @required this.justifReasonDesc});
  factory Absence.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Absence(
      evtId: intType.mapFromDatabaseResponse(data['${effectivePrefix}evt_id']),
      evtCode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}evt_code']),
      evtDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}evt_date']),
      evtHPos:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}evt_h_pos']),
      evtValue:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}evt_value']),
      isJustified: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_justified']),
      justifiedReasonCode: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}justified_reason_code']),
      justifReasonDesc: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}justif_reason_desc']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || evtId != null) {
      map['evt_id'] = Variable<int>(evtId);
    }
    if (!nullToAbsent || evtCode != null) {
      map['evt_code'] = Variable<String>(evtCode);
    }
    if (!nullToAbsent || evtDate != null) {
      map['evt_date'] = Variable<DateTime>(evtDate);
    }
    if (!nullToAbsent || evtHPos != null) {
      map['evt_h_pos'] = Variable<int>(evtHPos);
    }
    if (!nullToAbsent || evtValue != null) {
      map['evt_value'] = Variable<int>(evtValue);
    }
    if (!nullToAbsent || isJustified != null) {
      map['is_justified'] = Variable<bool>(isJustified);
    }
    if (!nullToAbsent || justifiedReasonCode != null) {
      map['justified_reason_code'] = Variable<String>(justifiedReasonCode);
    }
    if (!nullToAbsent || justifReasonDesc != null) {
      map['justif_reason_desc'] = Variable<String>(justifReasonDesc);
    }
    return map;
  }

  AbsencesCompanion toCompanion(bool nullToAbsent) {
    return AbsencesCompanion(
      evtId:
          evtId == null && nullToAbsent ? const Value.absent() : Value(evtId),
      evtCode: evtCode == null && nullToAbsent
          ? const Value.absent()
          : Value(evtCode),
      evtDate: evtDate == null && nullToAbsent
          ? const Value.absent()
          : Value(evtDate),
      evtHPos: evtHPos == null && nullToAbsent
          ? const Value.absent()
          : Value(evtHPos),
      evtValue: evtValue == null && nullToAbsent
          ? const Value.absent()
          : Value(evtValue),
      isJustified: isJustified == null && nullToAbsent
          ? const Value.absent()
          : Value(isJustified),
      justifiedReasonCode: justifiedReasonCode == null && nullToAbsent
          ? const Value.absent()
          : Value(justifiedReasonCode),
      justifReasonDesc: justifReasonDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(justifReasonDesc),
    );
  }

  factory Absence.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Absence(
      evtId: serializer.fromJson<int>(json['evtId']),
      evtCode: serializer.fromJson<String>(json['evtCode']),
      evtDate: serializer.fromJson<DateTime>(json['evtDate']),
      evtHPos: serializer.fromJson<int>(json['evtHPos']),
      evtValue: serializer.fromJson<int>(json['evtValue']),
      isJustified: serializer.fromJson<bool>(json['isJustified']),
      justifiedReasonCode:
          serializer.fromJson<String>(json['justifiedReasonCode']),
      justifReasonDesc: serializer.fromJson<String>(json['justifReasonDesc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'evtId': serializer.toJson<int>(evtId),
      'evtCode': serializer.toJson<String>(evtCode),
      'evtDate': serializer.toJson<DateTime>(evtDate),
      'evtHPos': serializer.toJson<int>(evtHPos),
      'evtValue': serializer.toJson<int>(evtValue),
      'isJustified': serializer.toJson<bool>(isJustified),
      'justifiedReasonCode': serializer.toJson<String>(justifiedReasonCode),
      'justifReasonDesc': serializer.toJson<String>(justifReasonDesc),
    };
  }

  Absence copyWith(
          {int evtId,
          String evtCode,
          DateTime evtDate,
          int evtHPos,
          int evtValue,
          bool isJustified,
          String justifiedReasonCode,
          String justifReasonDesc}) =>
      Absence(
        evtId: evtId ?? this.evtId,
        evtCode: evtCode ?? this.evtCode,
        evtDate: evtDate ?? this.evtDate,
        evtHPos: evtHPos ?? this.evtHPos,
        evtValue: evtValue ?? this.evtValue,
        isJustified: isJustified ?? this.isJustified,
        justifiedReasonCode: justifiedReasonCode ?? this.justifiedReasonCode,
        justifReasonDesc: justifReasonDesc ?? this.justifReasonDesc,
      );
  @override
  String toString() {
    return (StringBuffer('Absence(')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('evtDate: $evtDate, ')
          ..write('evtHPos: $evtHPos, ')
          ..write('evtValue: $evtValue, ')
          ..write('isJustified: $isJustified, ')
          ..write('justifiedReasonCode: $justifiedReasonCode, ')
          ..write('justifReasonDesc: $justifReasonDesc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      evtId.hashCode,
      $mrjc(
          evtCode.hashCode,
          $mrjc(
              evtDate.hashCode,
              $mrjc(
                  evtHPos.hashCode,
                  $mrjc(
                      evtValue.hashCode,
                      $mrjc(
                          isJustified.hashCode,
                          $mrjc(justifiedReasonCode.hashCode,
                              justifReasonDesc.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Absence &&
          other.evtId == this.evtId &&
          other.evtCode == this.evtCode &&
          other.evtDate == this.evtDate &&
          other.evtHPos == this.evtHPos &&
          other.evtValue == this.evtValue &&
          other.isJustified == this.isJustified &&
          other.justifiedReasonCode == this.justifiedReasonCode &&
          other.justifReasonDesc == this.justifReasonDesc);
}

class AbsencesCompanion extends UpdateCompanion<Absence> {
  final Value<int> evtId;
  final Value<String> evtCode;
  final Value<DateTime> evtDate;
  final Value<int> evtHPos;
  final Value<int> evtValue;
  final Value<bool> isJustified;
  final Value<String> justifiedReasonCode;
  final Value<String> justifReasonDesc;
  const AbsencesCompanion({
    this.evtId = const Value.absent(),
    this.evtCode = const Value.absent(),
    this.evtDate = const Value.absent(),
    this.evtHPos = const Value.absent(),
    this.evtValue = const Value.absent(),
    this.isJustified = const Value.absent(),
    this.justifiedReasonCode = const Value.absent(),
    this.justifReasonDesc = const Value.absent(),
  });
  AbsencesCompanion.insert({
    this.evtId = const Value.absent(),
    @required String evtCode,
    @required DateTime evtDate,
    @required int evtHPos,
    @required int evtValue,
    @required bool isJustified,
    @required String justifiedReasonCode,
    @required String justifReasonDesc,
  })  : evtCode = Value(evtCode),
        evtDate = Value(evtDate),
        evtHPos = Value(evtHPos),
        evtValue = Value(evtValue),
        isJustified = Value(isJustified),
        justifiedReasonCode = Value(justifiedReasonCode),
        justifReasonDesc = Value(justifReasonDesc);
  static Insertable<Absence> custom({
    Expression<int> evtId,
    Expression<String> evtCode,
    Expression<DateTime> evtDate,
    Expression<int> evtHPos,
    Expression<int> evtValue,
    Expression<bool> isJustified,
    Expression<String> justifiedReasonCode,
    Expression<String> justifReasonDesc,
  }) {
    return RawValuesInsertable({
      if (evtId != null) 'evt_id': evtId,
      if (evtCode != null) 'evt_code': evtCode,
      if (evtDate != null) 'evt_date': evtDate,
      if (evtHPos != null) 'evt_h_pos': evtHPos,
      if (evtValue != null) 'evt_value': evtValue,
      if (isJustified != null) 'is_justified': isJustified,
      if (justifiedReasonCode != null)
        'justified_reason_code': justifiedReasonCode,
      if (justifReasonDesc != null) 'justif_reason_desc': justifReasonDesc,
    });
  }

  AbsencesCompanion copyWith(
      {Value<int> evtId,
      Value<String> evtCode,
      Value<DateTime> evtDate,
      Value<int> evtHPos,
      Value<int> evtValue,
      Value<bool> isJustified,
      Value<String> justifiedReasonCode,
      Value<String> justifReasonDesc}) {
    return AbsencesCompanion(
      evtId: evtId ?? this.evtId,
      evtCode: evtCode ?? this.evtCode,
      evtDate: evtDate ?? this.evtDate,
      evtHPos: evtHPos ?? this.evtHPos,
      evtValue: evtValue ?? this.evtValue,
      isJustified: isJustified ?? this.isJustified,
      justifiedReasonCode: justifiedReasonCode ?? this.justifiedReasonCode,
      justifReasonDesc: justifReasonDesc ?? this.justifReasonDesc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (evtId.present) {
      map['evt_id'] = Variable<int>(evtId.value);
    }
    if (evtCode.present) {
      map['evt_code'] = Variable<String>(evtCode.value);
    }
    if (evtDate.present) {
      map['evt_date'] = Variable<DateTime>(evtDate.value);
    }
    if (evtHPos.present) {
      map['evt_h_pos'] = Variable<int>(evtHPos.value);
    }
    if (evtValue.present) {
      map['evt_value'] = Variable<int>(evtValue.value);
    }
    if (isJustified.present) {
      map['is_justified'] = Variable<bool>(isJustified.value);
    }
    if (justifiedReasonCode.present) {
      map['justified_reason_code'] =
          Variable<String>(justifiedReasonCode.value);
    }
    if (justifReasonDesc.present) {
      map['justif_reason_desc'] = Variable<String>(justifReasonDesc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbsencesCompanion(')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('evtDate: $evtDate, ')
          ..write('evtHPos: $evtHPos, ')
          ..write('evtValue: $evtValue, ')
          ..write('isJustified: $isJustified, ')
          ..write('justifiedReasonCode: $justifiedReasonCode, ')
          ..write('justifReasonDesc: $justifReasonDesc')
          ..write(')'))
        .toString();
  }
}

class $AbsencesTable extends Absences with TableInfo<$AbsencesTable, Absence> {
  final GeneratedDatabase _db;
  final String _alias;
  $AbsencesTable(this._db, [this._alias]);
  final VerificationMeta _evtIdMeta = const VerificationMeta('evtId');
  GeneratedIntColumn _evtId;
  @override
  GeneratedIntColumn get evtId => _evtId ??= _constructEvtId();
  GeneratedIntColumn _constructEvtId() {
    return GeneratedIntColumn(
      'evt_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtCodeMeta = const VerificationMeta('evtCode');
  GeneratedTextColumn _evtCode;
  @override
  GeneratedTextColumn get evtCode => _evtCode ??= _constructEvtCode();
  GeneratedTextColumn _constructEvtCode() {
    return GeneratedTextColumn(
      'evt_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtDateMeta = const VerificationMeta('evtDate');
  GeneratedDateTimeColumn _evtDate;
  @override
  GeneratedDateTimeColumn get evtDate => _evtDate ??= _constructEvtDate();
  GeneratedDateTimeColumn _constructEvtDate() {
    return GeneratedDateTimeColumn(
      'evt_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtHPosMeta = const VerificationMeta('evtHPos');
  GeneratedIntColumn _evtHPos;
  @override
  GeneratedIntColumn get evtHPos => _evtHPos ??= _constructEvtHPos();
  GeneratedIntColumn _constructEvtHPos() {
    return GeneratedIntColumn(
      'evt_h_pos',
      $tableName,
      false,
    );
  }

  final VerificationMeta _evtValueMeta = const VerificationMeta('evtValue');
  GeneratedIntColumn _evtValue;
  @override
  GeneratedIntColumn get evtValue => _evtValue ??= _constructEvtValue();
  GeneratedIntColumn _constructEvtValue() {
    return GeneratedIntColumn(
      'evt_value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isJustifiedMeta =
      const VerificationMeta('isJustified');
  GeneratedBoolColumn _isJustified;
  @override
  GeneratedBoolColumn get isJustified =>
      _isJustified ??= _constructIsJustified();
  GeneratedBoolColumn _constructIsJustified() {
    return GeneratedBoolColumn(
      'is_justified',
      $tableName,
      false,
    );
  }

  final VerificationMeta _justifiedReasonCodeMeta =
      const VerificationMeta('justifiedReasonCode');
  GeneratedTextColumn _justifiedReasonCode;
  @override
  GeneratedTextColumn get justifiedReasonCode =>
      _justifiedReasonCode ??= _constructJustifiedReasonCode();
  GeneratedTextColumn _constructJustifiedReasonCode() {
    return GeneratedTextColumn(
      'justified_reason_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _justifReasonDescMeta =
      const VerificationMeta('justifReasonDesc');
  GeneratedTextColumn _justifReasonDesc;
  @override
  GeneratedTextColumn get justifReasonDesc =>
      _justifReasonDesc ??= _constructJustifReasonDesc();
  GeneratedTextColumn _constructJustifReasonDesc() {
    return GeneratedTextColumn(
      'justif_reason_desc',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        evtId,
        evtCode,
        evtDate,
        evtHPos,
        evtValue,
        isJustified,
        justifiedReasonCode,
        justifReasonDesc
      ];
  @override
  $AbsencesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'absences';
  @override
  final String actualTableName = 'absences';
  @override
  VerificationContext validateIntegrity(Insertable<Absence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('evt_id')) {
      context.handle(
          _evtIdMeta, evtId.isAcceptableOrUnknown(data['evt_id'], _evtIdMeta));
    }
    if (data.containsKey('evt_code')) {
      context.handle(_evtCodeMeta,
          evtCode.isAcceptableOrUnknown(data['evt_code'], _evtCodeMeta));
    } else if (isInserting) {
      context.missing(_evtCodeMeta);
    }
    if (data.containsKey('evt_date')) {
      context.handle(_evtDateMeta,
          evtDate.isAcceptableOrUnknown(data['evt_date'], _evtDateMeta));
    } else if (isInserting) {
      context.missing(_evtDateMeta);
    }
    if (data.containsKey('evt_h_pos')) {
      context.handle(_evtHPosMeta,
          evtHPos.isAcceptableOrUnknown(data['evt_h_pos'], _evtHPosMeta));
    } else if (isInserting) {
      context.missing(_evtHPosMeta);
    }
    if (data.containsKey('evt_value')) {
      context.handle(_evtValueMeta,
          evtValue.isAcceptableOrUnknown(data['evt_value'], _evtValueMeta));
    } else if (isInserting) {
      context.missing(_evtValueMeta);
    }
    if (data.containsKey('is_justified')) {
      context.handle(
          _isJustifiedMeta,
          isJustified.isAcceptableOrUnknown(
              data['is_justified'], _isJustifiedMeta));
    } else if (isInserting) {
      context.missing(_isJustifiedMeta);
    }
    if (data.containsKey('justified_reason_code')) {
      context.handle(
          _justifiedReasonCodeMeta,
          justifiedReasonCode.isAcceptableOrUnknown(
              data['justified_reason_code'], _justifiedReasonCodeMeta));
    } else if (isInserting) {
      context.missing(_justifiedReasonCodeMeta);
    }
    if (data.containsKey('justif_reason_desc')) {
      context.handle(
          _justifReasonDescMeta,
          justifReasonDesc.isAcceptableOrUnknown(
              data['justif_reason_desc'], _justifReasonDescMeta));
    } else if (isInserting) {
      context.missing(_justifReasonDescMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {evtId};
  @override
  Absence map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Absence.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AbsencesTable createAlias(String alias) {
    return $AbsencesTable(_db, alias);
  }
}

class PeriodLocalModel extends DataClass
    implements Insertable<PeriodLocalModel> {
  final String code;
  final int position;
  final String description;
  final bool isFinal;
  final DateTime start;
  final DateTime end;
  final String miurDivisionCode;
  final int periodIndex;
  PeriodLocalModel(
      {@required this.code,
      @required this.position,
      @required this.description,
      @required this.isFinal,
      @required this.start,
      @required this.end,
      @required this.miurDivisionCode,
      @required this.periodIndex});
  factory PeriodLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return PeriodLocalModel(
      code: stringType.mapFromDatabaseResponse(data['${effectivePrefix}code']),
      position:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}position']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      isFinal:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_final']),
      start:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      end: dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
      miurDivisionCode: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}miur_division_code']),
      periodIndex: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}period_index']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<int>(position);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || isFinal != null) {
      map['is_final'] = Variable<bool>(isFinal);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    if (!nullToAbsent || miurDivisionCode != null) {
      map['miur_division_code'] = Variable<String>(miurDivisionCode);
    }
    if (!nullToAbsent || periodIndex != null) {
      map['period_index'] = Variable<int>(periodIndex);
    }
    return map;
  }

  PeriodsCompanion toCompanion(bool nullToAbsent) {
    return PeriodsCompanion(
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isFinal: isFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(isFinal),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      miurDivisionCode: miurDivisionCode == null && nullToAbsent
          ? const Value.absent()
          : Value(miurDivisionCode),
      periodIndex: periodIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(periodIndex),
    );
  }

  factory PeriodLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PeriodLocalModel(
      code: serializer.fromJson<String>(json['code']),
      position: serializer.fromJson<int>(json['position']),
      description: serializer.fromJson<String>(json['description']),
      isFinal: serializer.fromJson<bool>(json['isFinal']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      miurDivisionCode: serializer.fromJson<String>(json['miurDivisionCode']),
      periodIndex: serializer.fromJson<int>(json['periodIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'position': serializer.toJson<int>(position),
      'description': serializer.toJson<String>(description),
      'isFinal': serializer.toJson<bool>(isFinal),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'miurDivisionCode': serializer.toJson<String>(miurDivisionCode),
      'periodIndex': serializer.toJson<int>(periodIndex),
    };
  }

  PeriodLocalModel copyWith(
          {String code,
          int position,
          String description,
          bool isFinal,
          DateTime start,
          DateTime end,
          String miurDivisionCode,
          int periodIndex}) =>
      PeriodLocalModel(
        code: code ?? this.code,
        position: position ?? this.position,
        description: description ?? this.description,
        isFinal: isFinal ?? this.isFinal,
        start: start ?? this.start,
        end: end ?? this.end,
        miurDivisionCode: miurDivisionCode ?? this.miurDivisionCode,
        periodIndex: periodIndex ?? this.periodIndex,
      );
  @override
  String toString() {
    return (StringBuffer('PeriodLocalModel(')
          ..write('code: $code, ')
          ..write('position: $position, ')
          ..write('description: $description, ')
          ..write('isFinal: $isFinal, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('miurDivisionCode: $miurDivisionCode, ')
          ..write('periodIndex: $periodIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      code.hashCode,
      $mrjc(
          position.hashCode,
          $mrjc(
              description.hashCode,
              $mrjc(
                  isFinal.hashCode,
                  $mrjc(
                      start.hashCode,
                      $mrjc(
                          end.hashCode,
                          $mrjc(miurDivisionCode.hashCode,
                              periodIndex.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PeriodLocalModel &&
          other.code == this.code &&
          other.position == this.position &&
          other.description == this.description &&
          other.isFinal == this.isFinal &&
          other.start == this.start &&
          other.end == this.end &&
          other.miurDivisionCode == this.miurDivisionCode &&
          other.periodIndex == this.periodIndex);
}

class PeriodsCompanion extends UpdateCompanion<PeriodLocalModel> {
  final Value<String> code;
  final Value<int> position;
  final Value<String> description;
  final Value<bool> isFinal;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<String> miurDivisionCode;
  final Value<int> periodIndex;
  const PeriodsCompanion({
    this.code = const Value.absent(),
    this.position = const Value.absent(),
    this.description = const Value.absent(),
    this.isFinal = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.miurDivisionCode = const Value.absent(),
    this.periodIndex = const Value.absent(),
  });
  PeriodsCompanion.insert({
    @required String code,
    @required int position,
    @required String description,
    @required bool isFinal,
    @required DateTime start,
    @required DateTime end,
    @required String miurDivisionCode,
    @required int periodIndex,
  })  : code = Value(code),
        position = Value(position),
        description = Value(description),
        isFinal = Value(isFinal),
        start = Value(start),
        end = Value(end),
        miurDivisionCode = Value(miurDivisionCode),
        periodIndex = Value(periodIndex);
  static Insertable<PeriodLocalModel> custom({
    Expression<String> code,
    Expression<int> position,
    Expression<String> description,
    Expression<bool> isFinal,
    Expression<DateTime> start,
    Expression<DateTime> end,
    Expression<String> miurDivisionCode,
    Expression<int> periodIndex,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (position != null) 'position': position,
      if (description != null) 'description': description,
      if (isFinal != null) 'is_final': isFinal,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (miurDivisionCode != null) 'miur_division_code': miurDivisionCode,
      if (periodIndex != null) 'period_index': periodIndex,
    });
  }

  PeriodsCompanion copyWith(
      {Value<String> code,
      Value<int> position,
      Value<String> description,
      Value<bool> isFinal,
      Value<DateTime> start,
      Value<DateTime> end,
      Value<String> miurDivisionCode,
      Value<int> periodIndex}) {
    return PeriodsCompanion(
      code: code ?? this.code,
      position: position ?? this.position,
      description: description ?? this.description,
      isFinal: isFinal ?? this.isFinal,
      start: start ?? this.start,
      end: end ?? this.end,
      miurDivisionCode: miurDivisionCode ?? this.miurDivisionCode,
      periodIndex: periodIndex ?? this.periodIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isFinal.present) {
      map['is_final'] = Variable<bool>(isFinal.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (miurDivisionCode.present) {
      map['miur_division_code'] = Variable<String>(miurDivisionCode.value);
    }
    if (periodIndex.present) {
      map['period_index'] = Variable<int>(periodIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodsCompanion(')
          ..write('code: $code, ')
          ..write('position: $position, ')
          ..write('description: $description, ')
          ..write('isFinal: $isFinal, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('miurDivisionCode: $miurDivisionCode, ')
          ..write('periodIndex: $periodIndex')
          ..write(')'))
        .toString();
  }
}

class $PeriodsTable extends Periods
    with TableInfo<$PeriodsTable, PeriodLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $PeriodsTable(this._db, [this._alias]);
  final VerificationMeta _codeMeta = const VerificationMeta('code');
  GeneratedTextColumn _code;
  @override
  GeneratedTextColumn get code => _code ??= _constructCode();
  GeneratedTextColumn _constructCode() {
    return GeneratedTextColumn(
      'code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _positionMeta = const VerificationMeta('position');
  GeneratedIntColumn _position;
  @override
  GeneratedIntColumn get position => _position ??= _constructPosition();
  GeneratedIntColumn _constructPosition() {
    return GeneratedIntColumn(
      'position',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isFinalMeta = const VerificationMeta('isFinal');
  GeneratedBoolColumn _isFinal;
  @override
  GeneratedBoolColumn get isFinal => _isFinal ??= _constructIsFinal();
  GeneratedBoolColumn _constructIsFinal() {
    return GeneratedBoolColumn(
      'is_final',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startMeta = const VerificationMeta('start');
  GeneratedDateTimeColumn _start;
  @override
  GeneratedDateTimeColumn get start => _start ??= _constructStart();
  GeneratedDateTimeColumn _constructStart() {
    return GeneratedDateTimeColumn(
      'start',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endMeta = const VerificationMeta('end');
  GeneratedDateTimeColumn _end;
  @override
  GeneratedDateTimeColumn get end => _end ??= _constructEnd();
  GeneratedDateTimeColumn _constructEnd() {
    return GeneratedDateTimeColumn(
      'end',
      $tableName,
      false,
    );
  }

  final VerificationMeta _miurDivisionCodeMeta =
      const VerificationMeta('miurDivisionCode');
  GeneratedTextColumn _miurDivisionCode;
  @override
  GeneratedTextColumn get miurDivisionCode =>
      _miurDivisionCode ??= _constructMiurDivisionCode();
  GeneratedTextColumn _constructMiurDivisionCode() {
    return GeneratedTextColumn(
      'miur_division_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _periodIndexMeta =
      const VerificationMeta('periodIndex');
  GeneratedIntColumn _periodIndex;
  @override
  GeneratedIntColumn get periodIndex =>
      _periodIndex ??= _constructPeriodIndex();
  GeneratedIntColumn _constructPeriodIndex() {
    return GeneratedIntColumn(
      'period_index',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        code,
        position,
        description,
        isFinal,
        start,
        end,
        miurDivisionCode,
        periodIndex
      ];
  @override
  $PeriodsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'periods';
  @override
  final String actualTableName = 'periods';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code'], _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position'], _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_final')) {
      context.handle(_isFinalMeta,
          isFinal.isAcceptableOrUnknown(data['is_final'], _isFinalMeta));
    } else if (isInserting) {
      context.missing(_isFinalMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start'], _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end'], _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('miur_division_code')) {
      context.handle(
          _miurDivisionCodeMeta,
          miurDivisionCode.isAcceptableOrUnknown(
              data['miur_division_code'], _miurDivisionCodeMeta));
    } else if (isInserting) {
      context.missing(_miurDivisionCodeMeta);
    }
    if (data.containsKey('period_index')) {
      context.handle(
          _periodIndexMeta,
          periodIndex.isAcceptableOrUnknown(
              data['period_index'], _periodIndexMeta));
    } else if (isInserting) {
      context.missing(_periodIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {start, end};
  @override
  PeriodLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PeriodLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PeriodsTable createAlias(String alias) {
    return $PeriodsTable(_db, alias);
  }
}

class NoticeLocalModel extends DataClass
    implements Insertable<NoticeLocalModel> {
  final int pubId;
  final DateTime pubDate;
  final bool readStatus;
  final String eventCode;
  final int contentId;
  final DateTime contentValidFrom;
  final DateTime contentValidTo;
  final bool contentValidInRange;
  final String contentStatus;
  final String contentTitle;
  final String contentCategory;
  final bool contentHasChanged;
  final bool contentHasAttach;
  final bool needJoin;
  final bool needReply;
  final bool needFile;
  NoticeLocalModel(
      {@required this.pubId,
      @required this.pubDate,
      @required this.readStatus,
      @required this.eventCode,
      @required this.contentId,
      @required this.contentValidFrom,
      @required this.contentValidTo,
      @required this.contentValidInRange,
      @required this.contentStatus,
      @required this.contentTitle,
      @required this.contentCategory,
      @required this.contentHasChanged,
      @required this.contentHasAttach,
      @required this.needJoin,
      @required this.needReply,
      @required this.needFile});
  factory NoticeLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    final stringType = db.typeSystem.forDartType<String>();
    return NoticeLocalModel(
      pubId: intType.mapFromDatabaseResponse(data['${effectivePrefix}pub_id']),
      pubDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}pub_date']),
      readStatus: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}read_status']),
      eventCode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_code']),
      contentId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}content_id']),
      contentValidFrom: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}content_valid_from']),
      contentValidTo: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}content_valid_to']),
      contentValidInRange: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}content_valid_in_range']),
      contentStatus: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}content_status']),
      contentTitle: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}content_title']),
      contentCategory: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}content_category']),
      contentHasChanged: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}content_has_changed']),
      contentHasAttach: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}content_has_attach']),
      needJoin:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}need_join']),
      needReply: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}need_reply']),
      needFile:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}need_file']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || pubId != null) {
      map['pub_id'] = Variable<int>(pubId);
    }
    if (!nullToAbsent || pubDate != null) {
      map['pub_date'] = Variable<DateTime>(pubDate);
    }
    if (!nullToAbsent || readStatus != null) {
      map['read_status'] = Variable<bool>(readStatus);
    }
    if (!nullToAbsent || eventCode != null) {
      map['event_code'] = Variable<String>(eventCode);
    }
    if (!nullToAbsent || contentId != null) {
      map['content_id'] = Variable<int>(contentId);
    }
    if (!nullToAbsent || contentValidFrom != null) {
      map['content_valid_from'] = Variable<DateTime>(contentValidFrom);
    }
    if (!nullToAbsent || contentValidTo != null) {
      map['content_valid_to'] = Variable<DateTime>(contentValidTo);
    }
    if (!nullToAbsent || contentValidInRange != null) {
      map['content_valid_in_range'] = Variable<bool>(contentValidInRange);
    }
    if (!nullToAbsent || contentStatus != null) {
      map['content_status'] = Variable<String>(contentStatus);
    }
    if (!nullToAbsent || contentTitle != null) {
      map['content_title'] = Variable<String>(contentTitle);
    }
    if (!nullToAbsent || contentCategory != null) {
      map['content_category'] = Variable<String>(contentCategory);
    }
    if (!nullToAbsent || contentHasChanged != null) {
      map['content_has_changed'] = Variable<bool>(contentHasChanged);
    }
    if (!nullToAbsent || contentHasAttach != null) {
      map['content_has_attach'] = Variable<bool>(contentHasAttach);
    }
    if (!nullToAbsent || needJoin != null) {
      map['need_join'] = Variable<bool>(needJoin);
    }
    if (!nullToAbsent || needReply != null) {
      map['need_reply'] = Variable<bool>(needReply);
    }
    if (!nullToAbsent || needFile != null) {
      map['need_file'] = Variable<bool>(needFile);
    }
    return map;
  }

  NoticesCompanion toCompanion(bool nullToAbsent) {
    return NoticesCompanion(
      pubId:
          pubId == null && nullToAbsent ? const Value.absent() : Value(pubId),
      pubDate: pubDate == null && nullToAbsent
          ? const Value.absent()
          : Value(pubDate),
      readStatus: readStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(readStatus),
      eventCode: eventCode == null && nullToAbsent
          ? const Value.absent()
          : Value(eventCode),
      contentId: contentId == null && nullToAbsent
          ? const Value.absent()
          : Value(contentId),
      contentValidFrom: contentValidFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(contentValidFrom),
      contentValidTo: contentValidTo == null && nullToAbsent
          ? const Value.absent()
          : Value(contentValidTo),
      contentValidInRange: contentValidInRange == null && nullToAbsent
          ? const Value.absent()
          : Value(contentValidInRange),
      contentStatus: contentStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(contentStatus),
      contentTitle: contentTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(contentTitle),
      contentCategory: contentCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(contentCategory),
      contentHasChanged: contentHasChanged == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHasChanged),
      contentHasAttach: contentHasAttach == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHasAttach),
      needJoin: needJoin == null && nullToAbsent
          ? const Value.absent()
          : Value(needJoin),
      needReply: needReply == null && nullToAbsent
          ? const Value.absent()
          : Value(needReply),
      needFile: needFile == null && nullToAbsent
          ? const Value.absent()
          : Value(needFile),
    );
  }

  factory NoticeLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NoticeLocalModel(
      pubId: serializer.fromJson<int>(json['pubId']),
      pubDate: serializer.fromJson<DateTime>(json['pubDate']),
      readStatus: serializer.fromJson<bool>(json['readStatus']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      contentId: serializer.fromJson<int>(json['contentId']),
      contentValidFrom: serializer.fromJson<DateTime>(json['contentValidFrom']),
      contentValidTo: serializer.fromJson<DateTime>(json['contentValidTo']),
      contentValidInRange:
          serializer.fromJson<bool>(json['contentValidInRange']),
      contentStatus: serializer.fromJson<String>(json['contentStatus']),
      contentTitle: serializer.fromJson<String>(json['contentTitle']),
      contentCategory: serializer.fromJson<String>(json['contentCategory']),
      contentHasChanged: serializer.fromJson<bool>(json['contentHasChanged']),
      contentHasAttach: serializer.fromJson<bool>(json['contentHasAttach']),
      needJoin: serializer.fromJson<bool>(json['needJoin']),
      needReply: serializer.fromJson<bool>(json['needReply']),
      needFile: serializer.fromJson<bool>(json['needFile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pubId': serializer.toJson<int>(pubId),
      'pubDate': serializer.toJson<DateTime>(pubDate),
      'readStatus': serializer.toJson<bool>(readStatus),
      'eventCode': serializer.toJson<String>(eventCode),
      'contentId': serializer.toJson<int>(contentId),
      'contentValidFrom': serializer.toJson<DateTime>(contentValidFrom),
      'contentValidTo': serializer.toJson<DateTime>(contentValidTo),
      'contentValidInRange': serializer.toJson<bool>(contentValidInRange),
      'contentStatus': serializer.toJson<String>(contentStatus),
      'contentTitle': serializer.toJson<String>(contentTitle),
      'contentCategory': serializer.toJson<String>(contentCategory),
      'contentHasChanged': serializer.toJson<bool>(contentHasChanged),
      'contentHasAttach': serializer.toJson<bool>(contentHasAttach),
      'needJoin': serializer.toJson<bool>(needJoin),
      'needReply': serializer.toJson<bool>(needReply),
      'needFile': serializer.toJson<bool>(needFile),
    };
  }

  NoticeLocalModel copyWith(
          {int pubId,
          DateTime pubDate,
          bool readStatus,
          String eventCode,
          int contentId,
          DateTime contentValidFrom,
          DateTime contentValidTo,
          bool contentValidInRange,
          String contentStatus,
          String contentTitle,
          String contentCategory,
          bool contentHasChanged,
          bool contentHasAttach,
          bool needJoin,
          bool needReply,
          bool needFile}) =>
      NoticeLocalModel(
        pubId: pubId ?? this.pubId,
        pubDate: pubDate ?? this.pubDate,
        readStatus: readStatus ?? this.readStatus,
        eventCode: eventCode ?? this.eventCode,
        contentId: contentId ?? this.contentId,
        contentValidFrom: contentValidFrom ?? this.contentValidFrom,
        contentValidTo: contentValidTo ?? this.contentValidTo,
        contentValidInRange: contentValidInRange ?? this.contentValidInRange,
        contentStatus: contentStatus ?? this.contentStatus,
        contentTitle: contentTitle ?? this.contentTitle,
        contentCategory: contentCategory ?? this.contentCategory,
        contentHasChanged: contentHasChanged ?? this.contentHasChanged,
        contentHasAttach: contentHasAttach ?? this.contentHasAttach,
        needJoin: needJoin ?? this.needJoin,
        needReply: needReply ?? this.needReply,
        needFile: needFile ?? this.needFile,
      );
  @override
  String toString() {
    return (StringBuffer('NoticeLocalModel(')
          ..write('pubId: $pubId, ')
          ..write('pubDate: $pubDate, ')
          ..write('readStatus: $readStatus, ')
          ..write('eventCode: $eventCode, ')
          ..write('contentId: $contentId, ')
          ..write('contentValidFrom: $contentValidFrom, ')
          ..write('contentValidTo: $contentValidTo, ')
          ..write('contentValidInRange: $contentValidInRange, ')
          ..write('contentStatus: $contentStatus, ')
          ..write('contentTitle: $contentTitle, ')
          ..write('contentCategory: $contentCategory, ')
          ..write('contentHasChanged: $contentHasChanged, ')
          ..write('contentHasAttach: $contentHasAttach, ')
          ..write('needJoin: $needJoin, ')
          ..write('needReply: $needReply, ')
          ..write('needFile: $needFile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      pubId.hashCode,
      $mrjc(
          pubDate.hashCode,
          $mrjc(
              readStatus.hashCode,
              $mrjc(
                  eventCode.hashCode,
                  $mrjc(
                      contentId.hashCode,
                      $mrjc(
                          contentValidFrom.hashCode,
                          $mrjc(
                              contentValidTo.hashCode,
                              $mrjc(
                                  contentValidInRange.hashCode,
                                  $mrjc(
                                      contentStatus.hashCode,
                                      $mrjc(
                                          contentTitle.hashCode,
                                          $mrjc(
                                              contentCategory.hashCode,
                                              $mrjc(
                                                  contentHasChanged.hashCode,
                                                  $mrjc(
                                                      contentHasAttach.hashCode,
                                                      $mrjc(
                                                          needJoin.hashCode,
                                                          $mrjc(
                                                              needReply
                                                                  .hashCode,
                                                              needFile
                                                                  .hashCode))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NoticeLocalModel &&
          other.pubId == this.pubId &&
          other.pubDate == this.pubDate &&
          other.readStatus == this.readStatus &&
          other.eventCode == this.eventCode &&
          other.contentId == this.contentId &&
          other.contentValidFrom == this.contentValidFrom &&
          other.contentValidTo == this.contentValidTo &&
          other.contentValidInRange == this.contentValidInRange &&
          other.contentStatus == this.contentStatus &&
          other.contentTitle == this.contentTitle &&
          other.contentCategory == this.contentCategory &&
          other.contentHasChanged == this.contentHasChanged &&
          other.contentHasAttach == this.contentHasAttach &&
          other.needJoin == this.needJoin &&
          other.needReply == this.needReply &&
          other.needFile == this.needFile);
}

class NoticesCompanion extends UpdateCompanion<NoticeLocalModel> {
  final Value<int> pubId;
  final Value<DateTime> pubDate;
  final Value<bool> readStatus;
  final Value<String> eventCode;
  final Value<int> contentId;
  final Value<DateTime> contentValidFrom;
  final Value<DateTime> contentValidTo;
  final Value<bool> contentValidInRange;
  final Value<String> contentStatus;
  final Value<String> contentTitle;
  final Value<String> contentCategory;
  final Value<bool> contentHasChanged;
  final Value<bool> contentHasAttach;
  final Value<bool> needJoin;
  final Value<bool> needReply;
  final Value<bool> needFile;
  const NoticesCompanion({
    this.pubId = const Value.absent(),
    this.pubDate = const Value.absent(),
    this.readStatus = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.contentId = const Value.absent(),
    this.contentValidFrom = const Value.absent(),
    this.contentValidTo = const Value.absent(),
    this.contentValidInRange = const Value.absent(),
    this.contentStatus = const Value.absent(),
    this.contentTitle = const Value.absent(),
    this.contentCategory = const Value.absent(),
    this.contentHasChanged = const Value.absent(),
    this.contentHasAttach = const Value.absent(),
    this.needJoin = const Value.absent(),
    this.needReply = const Value.absent(),
    this.needFile = const Value.absent(),
  });
  NoticesCompanion.insert({
    this.pubId = const Value.absent(),
    @required DateTime pubDate,
    @required bool readStatus,
    @required String eventCode,
    @required int contentId,
    @required DateTime contentValidFrom,
    @required DateTime contentValidTo,
    @required bool contentValidInRange,
    @required String contentStatus,
    @required String contentTitle,
    @required String contentCategory,
    @required bool contentHasChanged,
    @required bool contentHasAttach,
    @required bool needJoin,
    @required bool needReply,
    @required bool needFile,
  })  : pubDate = Value(pubDate),
        readStatus = Value(readStatus),
        eventCode = Value(eventCode),
        contentId = Value(contentId),
        contentValidFrom = Value(contentValidFrom),
        contentValidTo = Value(contentValidTo),
        contentValidInRange = Value(contentValidInRange),
        contentStatus = Value(contentStatus),
        contentTitle = Value(contentTitle),
        contentCategory = Value(contentCategory),
        contentHasChanged = Value(contentHasChanged),
        contentHasAttach = Value(contentHasAttach),
        needJoin = Value(needJoin),
        needReply = Value(needReply),
        needFile = Value(needFile);
  static Insertable<NoticeLocalModel> custom({
    Expression<int> pubId,
    Expression<DateTime> pubDate,
    Expression<bool> readStatus,
    Expression<String> eventCode,
    Expression<int> contentId,
    Expression<DateTime> contentValidFrom,
    Expression<DateTime> contentValidTo,
    Expression<bool> contentValidInRange,
    Expression<String> contentStatus,
    Expression<String> contentTitle,
    Expression<String> contentCategory,
    Expression<bool> contentHasChanged,
    Expression<bool> contentHasAttach,
    Expression<bool> needJoin,
    Expression<bool> needReply,
    Expression<bool> needFile,
  }) {
    return RawValuesInsertable({
      if (pubId != null) 'pub_id': pubId,
      if (pubDate != null) 'pub_date': pubDate,
      if (readStatus != null) 'read_status': readStatus,
      if (eventCode != null) 'event_code': eventCode,
      if (contentId != null) 'content_id': contentId,
      if (contentValidFrom != null) 'content_valid_from': contentValidFrom,
      if (contentValidTo != null) 'content_valid_to': contentValidTo,
      if (contentValidInRange != null)
        'content_valid_in_range': contentValidInRange,
      if (contentStatus != null) 'content_status': contentStatus,
      if (contentTitle != null) 'content_title': contentTitle,
      if (contentCategory != null) 'content_category': contentCategory,
      if (contentHasChanged != null) 'content_has_changed': contentHasChanged,
      if (contentHasAttach != null) 'content_has_attach': contentHasAttach,
      if (needJoin != null) 'need_join': needJoin,
      if (needReply != null) 'need_reply': needReply,
      if (needFile != null) 'need_file': needFile,
    });
  }

  NoticesCompanion copyWith(
      {Value<int> pubId,
      Value<DateTime> pubDate,
      Value<bool> readStatus,
      Value<String> eventCode,
      Value<int> contentId,
      Value<DateTime> contentValidFrom,
      Value<DateTime> contentValidTo,
      Value<bool> contentValidInRange,
      Value<String> contentStatus,
      Value<String> contentTitle,
      Value<String> contentCategory,
      Value<bool> contentHasChanged,
      Value<bool> contentHasAttach,
      Value<bool> needJoin,
      Value<bool> needReply,
      Value<bool> needFile}) {
    return NoticesCompanion(
      pubId: pubId ?? this.pubId,
      pubDate: pubDate ?? this.pubDate,
      readStatus: readStatus ?? this.readStatus,
      eventCode: eventCode ?? this.eventCode,
      contentId: contentId ?? this.contentId,
      contentValidFrom: contentValidFrom ?? this.contentValidFrom,
      contentValidTo: contentValidTo ?? this.contentValidTo,
      contentValidInRange: contentValidInRange ?? this.contentValidInRange,
      contentStatus: contentStatus ?? this.contentStatus,
      contentTitle: contentTitle ?? this.contentTitle,
      contentCategory: contentCategory ?? this.contentCategory,
      contentHasChanged: contentHasChanged ?? this.contentHasChanged,
      contentHasAttach: contentHasAttach ?? this.contentHasAttach,
      needJoin: needJoin ?? this.needJoin,
      needReply: needReply ?? this.needReply,
      needFile: needFile ?? this.needFile,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pubId.present) {
      map['pub_id'] = Variable<int>(pubId.value);
    }
    if (pubDate.present) {
      map['pub_date'] = Variable<DateTime>(pubDate.value);
    }
    if (readStatus.present) {
      map['read_status'] = Variable<bool>(readStatus.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<int>(contentId.value);
    }
    if (contentValidFrom.present) {
      map['content_valid_from'] = Variable<DateTime>(contentValidFrom.value);
    }
    if (contentValidTo.present) {
      map['content_valid_to'] = Variable<DateTime>(contentValidTo.value);
    }
    if (contentValidInRange.present) {
      map['content_valid_in_range'] = Variable<bool>(contentValidInRange.value);
    }
    if (contentStatus.present) {
      map['content_status'] = Variable<String>(contentStatus.value);
    }
    if (contentTitle.present) {
      map['content_title'] = Variable<String>(contentTitle.value);
    }
    if (contentCategory.present) {
      map['content_category'] = Variable<String>(contentCategory.value);
    }
    if (contentHasChanged.present) {
      map['content_has_changed'] = Variable<bool>(contentHasChanged.value);
    }
    if (contentHasAttach.present) {
      map['content_has_attach'] = Variable<bool>(contentHasAttach.value);
    }
    if (needJoin.present) {
      map['need_join'] = Variable<bool>(needJoin.value);
    }
    if (needReply.present) {
      map['need_reply'] = Variable<bool>(needReply.value);
    }
    if (needFile.present) {
      map['need_file'] = Variable<bool>(needFile.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoticesCompanion(')
          ..write('pubId: $pubId, ')
          ..write('pubDate: $pubDate, ')
          ..write('readStatus: $readStatus, ')
          ..write('eventCode: $eventCode, ')
          ..write('contentId: $contentId, ')
          ..write('contentValidFrom: $contentValidFrom, ')
          ..write('contentValidTo: $contentValidTo, ')
          ..write('contentValidInRange: $contentValidInRange, ')
          ..write('contentStatus: $contentStatus, ')
          ..write('contentTitle: $contentTitle, ')
          ..write('contentCategory: $contentCategory, ')
          ..write('contentHasChanged: $contentHasChanged, ')
          ..write('contentHasAttach: $contentHasAttach, ')
          ..write('needJoin: $needJoin, ')
          ..write('needReply: $needReply, ')
          ..write('needFile: $needFile')
          ..write(')'))
        .toString();
  }
}

class $NoticesTable extends Notices
    with TableInfo<$NoticesTable, NoticeLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $NoticesTable(this._db, [this._alias]);
  final VerificationMeta _pubIdMeta = const VerificationMeta('pubId');
  GeneratedIntColumn _pubId;
  @override
  GeneratedIntColumn get pubId => _pubId ??= _constructPubId();
  GeneratedIntColumn _constructPubId() {
    return GeneratedIntColumn(
      'pub_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pubDateMeta = const VerificationMeta('pubDate');
  GeneratedDateTimeColumn _pubDate;
  @override
  GeneratedDateTimeColumn get pubDate => _pubDate ??= _constructPubDate();
  GeneratedDateTimeColumn _constructPubDate() {
    return GeneratedDateTimeColumn(
      'pub_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _readStatusMeta = const VerificationMeta('readStatus');
  GeneratedBoolColumn _readStatus;
  @override
  GeneratedBoolColumn get readStatus => _readStatus ??= _constructReadStatus();
  GeneratedBoolColumn _constructReadStatus() {
    return GeneratedBoolColumn(
      'read_status',
      $tableName,
      false,
    );
  }

  final VerificationMeta _eventCodeMeta = const VerificationMeta('eventCode');
  GeneratedTextColumn _eventCode;
  @override
  GeneratedTextColumn get eventCode => _eventCode ??= _constructEventCode();
  GeneratedTextColumn _constructEventCode() {
    return GeneratedTextColumn(
      'event_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentIdMeta = const VerificationMeta('contentId');
  GeneratedIntColumn _contentId;
  @override
  GeneratedIntColumn get contentId => _contentId ??= _constructContentId();
  GeneratedIntColumn _constructContentId() {
    return GeneratedIntColumn(
      'content_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentValidFromMeta =
      const VerificationMeta('contentValidFrom');
  GeneratedDateTimeColumn _contentValidFrom;
  @override
  GeneratedDateTimeColumn get contentValidFrom =>
      _contentValidFrom ??= _constructContentValidFrom();
  GeneratedDateTimeColumn _constructContentValidFrom() {
    return GeneratedDateTimeColumn(
      'content_valid_from',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentValidToMeta =
      const VerificationMeta('contentValidTo');
  GeneratedDateTimeColumn _contentValidTo;
  @override
  GeneratedDateTimeColumn get contentValidTo =>
      _contentValidTo ??= _constructContentValidTo();
  GeneratedDateTimeColumn _constructContentValidTo() {
    return GeneratedDateTimeColumn(
      'content_valid_to',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentValidInRangeMeta =
      const VerificationMeta('contentValidInRange');
  GeneratedBoolColumn _contentValidInRange;
  @override
  GeneratedBoolColumn get contentValidInRange =>
      _contentValidInRange ??= _constructContentValidInRange();
  GeneratedBoolColumn _constructContentValidInRange() {
    return GeneratedBoolColumn(
      'content_valid_in_range',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentStatusMeta =
      const VerificationMeta('contentStatus');
  GeneratedTextColumn _contentStatus;
  @override
  GeneratedTextColumn get contentStatus =>
      _contentStatus ??= _constructContentStatus();
  GeneratedTextColumn _constructContentStatus() {
    return GeneratedTextColumn(
      'content_status',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentTitleMeta =
      const VerificationMeta('contentTitle');
  GeneratedTextColumn _contentTitle;
  @override
  GeneratedTextColumn get contentTitle =>
      _contentTitle ??= _constructContentTitle();
  GeneratedTextColumn _constructContentTitle() {
    return GeneratedTextColumn(
      'content_title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentCategoryMeta =
      const VerificationMeta('contentCategory');
  GeneratedTextColumn _contentCategory;
  @override
  GeneratedTextColumn get contentCategory =>
      _contentCategory ??= _constructContentCategory();
  GeneratedTextColumn _constructContentCategory() {
    return GeneratedTextColumn(
      'content_category',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentHasChangedMeta =
      const VerificationMeta('contentHasChanged');
  GeneratedBoolColumn _contentHasChanged;
  @override
  GeneratedBoolColumn get contentHasChanged =>
      _contentHasChanged ??= _constructContentHasChanged();
  GeneratedBoolColumn _constructContentHasChanged() {
    return GeneratedBoolColumn(
      'content_has_changed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentHasAttachMeta =
      const VerificationMeta('contentHasAttach');
  GeneratedBoolColumn _contentHasAttach;
  @override
  GeneratedBoolColumn get contentHasAttach =>
      _contentHasAttach ??= _constructContentHasAttach();
  GeneratedBoolColumn _constructContentHasAttach() {
    return GeneratedBoolColumn(
      'content_has_attach',
      $tableName,
      false,
    );
  }

  final VerificationMeta _needJoinMeta = const VerificationMeta('needJoin');
  GeneratedBoolColumn _needJoin;
  @override
  GeneratedBoolColumn get needJoin => _needJoin ??= _constructNeedJoin();
  GeneratedBoolColumn _constructNeedJoin() {
    return GeneratedBoolColumn(
      'need_join',
      $tableName,
      false,
    );
  }

  final VerificationMeta _needReplyMeta = const VerificationMeta('needReply');
  GeneratedBoolColumn _needReply;
  @override
  GeneratedBoolColumn get needReply => _needReply ??= _constructNeedReply();
  GeneratedBoolColumn _constructNeedReply() {
    return GeneratedBoolColumn(
      'need_reply',
      $tableName,
      false,
    );
  }

  final VerificationMeta _needFileMeta = const VerificationMeta('needFile');
  GeneratedBoolColumn _needFile;
  @override
  GeneratedBoolColumn get needFile => _needFile ??= _constructNeedFile();
  GeneratedBoolColumn _constructNeedFile() {
    return GeneratedBoolColumn(
      'need_file',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        pubId,
        pubDate,
        readStatus,
        eventCode,
        contentId,
        contentValidFrom,
        contentValidTo,
        contentValidInRange,
        contentStatus,
        contentTitle,
        contentCategory,
        contentHasChanged,
        contentHasAttach,
        needJoin,
        needReply,
        needFile
      ];
  @override
  $NoticesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notices';
  @override
  final String actualTableName = 'notices';
  @override
  VerificationContext validateIntegrity(Insertable<NoticeLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pub_id')) {
      context.handle(
          _pubIdMeta, pubId.isAcceptableOrUnknown(data['pub_id'], _pubIdMeta));
    }
    if (data.containsKey('pub_date')) {
      context.handle(_pubDateMeta,
          pubDate.isAcceptableOrUnknown(data['pub_date'], _pubDateMeta));
    } else if (isInserting) {
      context.missing(_pubDateMeta);
    }
    if (data.containsKey('read_status')) {
      context.handle(
          _readStatusMeta,
          readStatus.isAcceptableOrUnknown(
              data['read_status'], _readStatusMeta));
    } else if (isInserting) {
      context.missing(_readStatusMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code'], _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id'], _contentIdMeta));
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('content_valid_from')) {
      context.handle(
          _contentValidFromMeta,
          contentValidFrom.isAcceptableOrUnknown(
              data['content_valid_from'], _contentValidFromMeta));
    } else if (isInserting) {
      context.missing(_contentValidFromMeta);
    }
    if (data.containsKey('content_valid_to')) {
      context.handle(
          _contentValidToMeta,
          contentValidTo.isAcceptableOrUnknown(
              data['content_valid_to'], _contentValidToMeta));
    } else if (isInserting) {
      context.missing(_contentValidToMeta);
    }
    if (data.containsKey('content_valid_in_range')) {
      context.handle(
          _contentValidInRangeMeta,
          contentValidInRange.isAcceptableOrUnknown(
              data['content_valid_in_range'], _contentValidInRangeMeta));
    } else if (isInserting) {
      context.missing(_contentValidInRangeMeta);
    }
    if (data.containsKey('content_status')) {
      context.handle(
          _contentStatusMeta,
          contentStatus.isAcceptableOrUnknown(
              data['content_status'], _contentStatusMeta));
    } else if (isInserting) {
      context.missing(_contentStatusMeta);
    }
    if (data.containsKey('content_title')) {
      context.handle(
          _contentTitleMeta,
          contentTitle.isAcceptableOrUnknown(
              data['content_title'], _contentTitleMeta));
    } else if (isInserting) {
      context.missing(_contentTitleMeta);
    }
    if (data.containsKey('content_category')) {
      context.handle(
          _contentCategoryMeta,
          contentCategory.isAcceptableOrUnknown(
              data['content_category'], _contentCategoryMeta));
    } else if (isInserting) {
      context.missing(_contentCategoryMeta);
    }
    if (data.containsKey('content_has_changed')) {
      context.handle(
          _contentHasChangedMeta,
          contentHasChanged.isAcceptableOrUnknown(
              data['content_has_changed'], _contentHasChangedMeta));
    } else if (isInserting) {
      context.missing(_contentHasChangedMeta);
    }
    if (data.containsKey('content_has_attach')) {
      context.handle(
          _contentHasAttachMeta,
          contentHasAttach.isAcceptableOrUnknown(
              data['content_has_attach'], _contentHasAttachMeta));
    } else if (isInserting) {
      context.missing(_contentHasAttachMeta);
    }
    if (data.containsKey('need_join')) {
      context.handle(_needJoinMeta,
          needJoin.isAcceptableOrUnknown(data['need_join'], _needJoinMeta));
    } else if (isInserting) {
      context.missing(_needJoinMeta);
    }
    if (data.containsKey('need_reply')) {
      context.handle(_needReplyMeta,
          needReply.isAcceptableOrUnknown(data['need_reply'], _needReplyMeta));
    } else if (isInserting) {
      context.missing(_needReplyMeta);
    }
    if (data.containsKey('need_file')) {
      context.handle(_needFileMeta,
          needFile.isAcceptableOrUnknown(data['need_file'], _needFileMeta));
    } else if (isInserting) {
      context.missing(_needFileMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pubId};
  @override
  NoticeLocalModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NoticeLocalModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NoticesTable createAlias(String alias) {
    return $NoticesTable(_db, alias);
  }
}

class NoticeAttachmentLocalModel extends DataClass
    implements Insertable<NoticeAttachmentLocalModel> {
  final int id;
  final int pubId;
  final String fileName;
  final int attachNumber;
  NoticeAttachmentLocalModel(
      {@required this.id,
      @required this.pubId,
      @required this.fileName,
      @required this.attachNumber});
  factory NoticeAttachmentLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return NoticeAttachmentLocalModel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      pubId: intType.mapFromDatabaseResponse(data['${effectivePrefix}pub_id']),
      fileName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}file_name']),
      attachNumber: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}attach_number']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || pubId != null) {
      map['pub_id'] = Variable<int>(pubId);
    }
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || attachNumber != null) {
      map['attach_number'] = Variable<int>(attachNumber);
    }
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      pubId:
          pubId == null && nullToAbsent ? const Value.absent() : Value(pubId),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      attachNumber: attachNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(attachNumber),
    );
  }

  factory NoticeAttachmentLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NoticeAttachmentLocalModel(
      id: serializer.fromJson<int>(json['id']),
      pubId: serializer.fromJson<int>(json['pubId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      attachNumber: serializer.fromJson<int>(json['attachNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pubId': serializer.toJson<int>(pubId),
      'fileName': serializer.toJson<String>(fileName),
      'attachNumber': serializer.toJson<int>(attachNumber),
    };
  }

  NoticeAttachmentLocalModel copyWith(
          {int id, int pubId, String fileName, int attachNumber}) =>
      NoticeAttachmentLocalModel(
        id: id ?? this.id,
        pubId: pubId ?? this.pubId,
        fileName: fileName ?? this.fileName,
        attachNumber: attachNumber ?? this.attachNumber,
      );
  @override
  String toString() {
    return (StringBuffer('NoticeAttachmentLocalModel(')
          ..write('id: $id, ')
          ..write('pubId: $pubId, ')
          ..write('fileName: $fileName, ')
          ..write('attachNumber: $attachNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(pubId.hashCode, $mrjc(fileName.hashCode, attachNumber.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NoticeAttachmentLocalModel &&
          other.id == this.id &&
          other.pubId == this.pubId &&
          other.fileName == this.fileName &&
          other.attachNumber == this.attachNumber);
}

class AttachmentsCompanion extends UpdateCompanion<NoticeAttachmentLocalModel> {
  final Value<int> id;
  final Value<int> pubId;
  final Value<String> fileName;
  final Value<int> attachNumber;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.pubId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.attachNumber = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    @required int pubId,
    @required String fileName,
    @required int attachNumber,
  })  : pubId = Value(pubId),
        fileName = Value(fileName),
        attachNumber = Value(attachNumber);
  static Insertable<NoticeAttachmentLocalModel> custom({
    Expression<int> id,
    Expression<int> pubId,
    Expression<String> fileName,
    Expression<int> attachNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pubId != null) 'pub_id': pubId,
      if (fileName != null) 'file_name': fileName,
      if (attachNumber != null) 'attach_number': attachNumber,
    });
  }

  AttachmentsCompanion copyWith(
      {Value<int> id,
      Value<int> pubId,
      Value<String> fileName,
      Value<int> attachNumber}) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      pubId: pubId ?? this.pubId,
      fileName: fileName ?? this.fileName,
      attachNumber: attachNumber ?? this.attachNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pubId.present) {
      map['pub_id'] = Variable<int>(pubId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (attachNumber.present) {
      map['attach_number'] = Variable<int>(attachNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('pubId: $pubId, ')
          ..write('fileName: $fileName, ')
          ..write('attachNumber: $attachNumber')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, NoticeAttachmentLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $AttachmentsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _pubIdMeta = const VerificationMeta('pubId');
  GeneratedIntColumn _pubId;
  @override
  GeneratedIntColumn get pubId => _pubId ??= _constructPubId();
  GeneratedIntColumn _constructPubId() {
    return GeneratedIntColumn(
      'pub_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _fileNameMeta = const VerificationMeta('fileName');
  GeneratedTextColumn _fileName;
  @override
  GeneratedTextColumn get fileName => _fileName ??= _constructFileName();
  GeneratedTextColumn _constructFileName() {
    return GeneratedTextColumn(
      'file_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _attachNumberMeta =
      const VerificationMeta('attachNumber');
  GeneratedIntColumn _attachNumber;
  @override
  GeneratedIntColumn get attachNumber =>
      _attachNumber ??= _constructAttachNumber();
  GeneratedIntColumn _constructAttachNumber() {
    return GeneratedIntColumn(
      'attach_number',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, pubId, fileName, attachNumber];
  @override
  $AttachmentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'attachments';
  @override
  final String actualTableName = 'attachments';
  @override
  VerificationContext validateIntegrity(
      Insertable<NoticeAttachmentLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('pub_id')) {
      context.handle(
          _pubIdMeta, pubId.isAcceptableOrUnknown(data['pub_id'], _pubIdMeta));
    } else if (isInserting) {
      context.missing(_pubIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name'], _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('attach_number')) {
      context.handle(
          _attachNumberMeta,
          attachNumber.isAcceptableOrUnknown(
              data['attach_number'], _attachNumberMeta));
    } else if (isInserting) {
      context.missing(_attachNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoticeAttachmentLocalModel map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NoticeAttachmentLocalModel.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(_db, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String author;
  final DateTime date;
  final int id;
  final bool status;
  final String description;
  final String warning;
  final String type;
  Note(
      {@required this.author,
      @required this.date,
      @required this.id,
      @required this.status,
      @required this.description,
      @required this.warning,
      @required this.type});
  factory Note.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Note(
      author:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}author']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      status:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      warning:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}warning']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<bool>(status);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || warning != null) {
      map['warning'] = Variable<String>(warning);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      warning: warning == null && nullToAbsent
          ? const Value.absent()
          : Value(warning),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Note(
      author: serializer.fromJson<String>(json['author']),
      date: serializer.fromJson<DateTime>(json['date']),
      id: serializer.fromJson<int>(json['id']),
      status: serializer.fromJson<bool>(json['status']),
      description: serializer.fromJson<String>(json['description']),
      warning: serializer.fromJson<String>(json['warning']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'author': serializer.toJson<String>(author),
      'date': serializer.toJson<DateTime>(date),
      'id': serializer.toJson<int>(id),
      'status': serializer.toJson<bool>(status),
      'description': serializer.toJson<String>(description),
      'warning': serializer.toJson<String>(warning),
      'type': serializer.toJson<String>(type),
    };
  }

  Note copyWith(
          {String author,
          DateTime date,
          int id,
          bool status,
          String description,
          String warning,
          String type}) =>
      Note(
        author: author ?? this.author,
        date: date ?? this.date,
        id: id ?? this.id,
        status: status ?? this.status,
        description: description ?? this.description,
        warning: warning ?? this.warning,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('author: $author, ')
          ..write('date: $date, ')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('warning: $warning, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      author.hashCode,
      $mrjc(
          date.hashCode,
          $mrjc(
              id.hashCode,
              $mrjc(
                  status.hashCode,
                  $mrjc(description.hashCode,
                      $mrjc(warning.hashCode, type.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Note &&
          other.author == this.author &&
          other.date == this.date &&
          other.id == this.id &&
          other.status == this.status &&
          other.description == this.description &&
          other.warning == this.warning &&
          other.type == this.type);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> author;
  final Value<DateTime> date;
  final Value<int> id;
  final Value<bool> status;
  final Value<String> description;
  final Value<String> warning;
  final Value<String> type;
  const NotesCompanion({
    this.author = const Value.absent(),
    this.date = const Value.absent(),
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.warning = const Value.absent(),
    this.type = const Value.absent(),
  });
  NotesCompanion.insert({
    @required String author,
    @required DateTime date,
    this.id = const Value.absent(),
    @required bool status,
    @required String description,
    @required String warning,
    @required String type,
  })  : author = Value(author),
        date = Value(date),
        status = Value(status),
        description = Value(description),
        warning = Value(warning),
        type = Value(type);
  static Insertable<Note> custom({
    Expression<String> author,
    Expression<DateTime> date,
    Expression<int> id,
    Expression<bool> status,
    Expression<String> description,
    Expression<String> warning,
    Expression<String> type,
  }) {
    return RawValuesInsertable({
      if (author != null) 'author': author,
      if (date != null) 'date': date,
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (warning != null) 'warning': warning,
      if (type != null) 'type': type,
    });
  }

  NotesCompanion copyWith(
      {Value<String> author,
      Value<DateTime> date,
      Value<int> id,
      Value<bool> status,
      Value<String> description,
      Value<String> warning,
      Value<String> type}) {
    return NotesCompanion(
      author: author ?? this.author,
      date: date ?? this.date,
      id: id ?? this.id,
      status: status ?? this.status,
      description: description ?? this.description,
      warning: warning ?? this.warning,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (warning.present) {
      map['warning'] = Variable<String>(warning.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('author: $author, ')
          ..write('date: $date, ')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('warning: $warning, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesTable(this._db, [this._alias]);
  final VerificationMeta _authorMeta = const VerificationMeta('author');
  GeneratedTextColumn _author;
  @override
  GeneratedTextColumn get author => _author ??= _constructAuthor();
  GeneratedTextColumn _constructAuthor() {
    return GeneratedTextColumn(
      'author',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedBoolColumn _status;
  @override
  GeneratedBoolColumn get status => _status ??= _constructStatus();
  GeneratedBoolColumn _constructStatus() {
    return GeneratedBoolColumn(
      'status',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _warningMeta = const VerificationMeta('warning');
  GeneratedTextColumn _warning;
  @override
  GeneratedTextColumn get warning => _warning ??= _constructWarning();
  GeneratedTextColumn _constructWarning() {
    return GeneratedTextColumn(
      'warning',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [author, date, id, status, description, warning, type];
  @override
  $NotesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes';
  @override
  final String actualTableName = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author'], _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('warning')) {
      context.handle(_warningMeta,
          warning.isAcceptableOrUnknown(data['warning'], _warningMeta));
    } else if (isInserting) {
      context.missing(_warningMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Note.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }
}

class NotesAttachment extends DataClass implements Insertable<NotesAttachment> {
  final int id;
  final String type;
  final String description;
  NotesAttachment(
      {@required this.id, @required this.type, @required this.description});
  factory NotesAttachment.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return NotesAttachment(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  NotesAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return NotesAttachmentsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory NotesAttachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NotesAttachment(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
    };
  }

  NotesAttachment copyWith({int id, String type, String description}) =>
      NotesAttachment(
        id: id ?? this.id,
        type: type ?? this.type,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('NotesAttachment(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(type.hashCode, description.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NotesAttachment &&
          other.id == this.id &&
          other.type == this.type &&
          other.description == this.description);
}

class NotesAttachmentsCompanion extends UpdateCompanion<NotesAttachment> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> description;
  const NotesAttachmentsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
  });
  NotesAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    @required String type,
    @required String description,
  })  : type = Value(type),
        description = Value(description);
  static Insertable<NotesAttachment> custom({
    Expression<int> id,
    Expression<String> type,
    Expression<String> description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
    });
  }

  NotesAttachmentsCompanion copyWith(
      {Value<int> id, Value<String> type, Value<String> description}) {
    return NotesAttachmentsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $NotesAttachmentsTable extends NotesAttachments
    with TableInfo<$NotesAttachmentsTable, NotesAttachment> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesAttachmentsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, type, description];
  @override
  $NotesAttachmentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes_attachments';
  @override
  final String actualTableName = 'notes_attachments';
  @override
  VerificationContext validateIntegrity(Insertable<NotesAttachment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesAttachment map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NotesAttachment.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotesAttachmentsTable createAlias(String alias) {
    return $NotesAttachmentsTable(_db, alias);
  }
}

class DidacticsTeacher extends DataClass
    implements Insertable<DidacticsTeacher> {
  final String id;
  final String name;
  final String firstName;
  final String lastName;
  DidacticsTeacher(
      {@required this.id,
      @required this.name,
      @required this.firstName,
      @required this.lastName});
  factory DidacticsTeacher.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return DidacticsTeacher(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
      lastName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    return map;
  }

  DidacticsTeachersCompanion toCompanion(bool nullToAbsent) {
    return DidacticsTeachersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
    );
  }

  factory DidacticsTeacher.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DidacticsTeacher(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
    };
  }

  DidacticsTeacher copyWith(
          {String id, String name, String firstName, String lastName}) =>
      DidacticsTeacher(
        id: id ?? this.id,
        name: name ?? this.name,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );
  @override
  String toString() {
    return (StringBuffer('DidacticsTeacher(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(firstName.hashCode, lastName.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DidacticsTeacher &&
          other.id == this.id &&
          other.name == this.name &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName);
}

class DidacticsTeachersCompanion extends UpdateCompanion<DidacticsTeacher> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> firstName;
  final Value<String> lastName;
  const DidacticsTeachersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
  });
  DidacticsTeachersCompanion.insert({
    @required String id,
    @required String name,
    @required String firstName,
    @required String lastName,
  })  : id = Value(id),
        name = Value(name),
        firstName = Value(firstName),
        lastName = Value(lastName);
  static Insertable<DidacticsTeacher> custom({
    Expression<String> id,
    Expression<String> name,
    Expression<String> firstName,
    Expression<String> lastName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    });
  }

  DidacticsTeachersCompanion copyWith(
      {Value<String> id,
      Value<String> name,
      Value<String> firstName,
      Value<String> lastName}) {
    return DidacticsTeachersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DidacticsTeachersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName')
          ..write(')'))
        .toString();
  }
}

class $DidacticsTeachersTable extends DidacticsTeachers
    with TableInfo<$DidacticsTeachersTable, DidacticsTeacher> {
  final GeneratedDatabase _db;
  final String _alias;
  $DidacticsTeachersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _firstNameMeta = const VerificationMeta('firstName');
  GeneratedTextColumn _firstName;
  @override
  GeneratedTextColumn get firstName => _firstName ??= _constructFirstName();
  GeneratedTextColumn _constructFirstName() {
    return GeneratedTextColumn(
      'first_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastNameMeta = const VerificationMeta('lastName');
  GeneratedTextColumn _lastName;
  @override
  GeneratedTextColumn get lastName => _lastName ??= _constructLastName();
  GeneratedTextColumn _constructLastName() {
    return GeneratedTextColumn(
      'last_name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, firstName, lastName];
  @override
  $DidacticsTeachersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'didactics_teachers';
  @override
  final String actualTableName = 'didactics_teachers';
  @override
  VerificationContext validateIntegrity(Insertable<DidacticsTeacher> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name'], _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name'], _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DidacticsTeacher map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DidacticsTeacher.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DidacticsTeachersTable createAlias(String alias) {
    return $DidacticsTeachersTable(_db, alias);
  }
}

class DidacticsFolder extends DataClass implements Insertable<DidacticsFolder> {
  final String teacherId;
  final int id;
  final String name;
  final DateTime lastShare;
  DidacticsFolder(
      {@required this.teacherId,
      @required this.id,
      @required this.name,
      @required this.lastShare});
  factory DidacticsFolder.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return DidacticsFolder(
      teacherId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}teacher_id']),
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      lastShare: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_share']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<String>(teacherId);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || lastShare != null) {
      map['last_share'] = Variable<DateTime>(lastShare);
    }
    return map;
  }

  DidacticsFoldersCompanion toCompanion(bool nullToAbsent) {
    return DidacticsFoldersCompanion(
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      lastShare: lastShare == null && nullToAbsent
          ? const Value.absent()
          : Value(lastShare),
    );
  }

  factory DidacticsFolder.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DidacticsFolder(
      teacherId: serializer.fromJson<String>(json['teacherId']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastShare: serializer.fromJson<DateTime>(json['lastShare']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'teacherId': serializer.toJson<String>(teacherId),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lastShare': serializer.toJson<DateTime>(lastShare),
    };
  }

  DidacticsFolder copyWith(
          {String teacherId, int id, String name, DateTime lastShare}) =>
      DidacticsFolder(
        teacherId: teacherId ?? this.teacherId,
        id: id ?? this.id,
        name: name ?? this.name,
        lastShare: lastShare ?? this.lastShare,
      );
  @override
  String toString() {
    return (StringBuffer('DidacticsFolder(')
          ..write('teacherId: $teacherId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastShare: $lastShare')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(teacherId.hashCode,
      $mrjc(id.hashCode, $mrjc(name.hashCode, lastShare.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DidacticsFolder &&
          other.teacherId == this.teacherId &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastShare == this.lastShare);
}

class DidacticsFoldersCompanion extends UpdateCompanion<DidacticsFolder> {
  final Value<String> teacherId;
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> lastShare;
  const DidacticsFoldersCompanion({
    this.teacherId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastShare = const Value.absent(),
  });
  DidacticsFoldersCompanion.insert({
    @required String teacherId,
    this.id = const Value.absent(),
    @required String name,
    @required DateTime lastShare,
  })  : teacherId = Value(teacherId),
        name = Value(name),
        lastShare = Value(lastShare);
  static Insertable<DidacticsFolder> custom({
    Expression<String> teacherId,
    Expression<int> id,
    Expression<String> name,
    Expression<DateTime> lastShare,
  }) {
    return RawValuesInsertable({
      if (teacherId != null) 'teacher_id': teacherId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastShare != null) 'last_share': lastShare,
    });
  }

  DidacticsFoldersCompanion copyWith(
      {Value<String> teacherId,
      Value<int> id,
      Value<String> name,
      Value<DateTime> lastShare}) {
    return DidacticsFoldersCompanion(
      teacherId: teacherId ?? this.teacherId,
      id: id ?? this.id,
      name: name ?? this.name,
      lastShare: lastShare ?? this.lastShare,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastShare.present) {
      map['last_share'] = Variable<DateTime>(lastShare.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DidacticsFoldersCompanion(')
          ..write('teacherId: $teacherId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastShare: $lastShare')
          ..write(')'))
        .toString();
  }
}

class $DidacticsFoldersTable extends DidacticsFolders
    with TableInfo<$DidacticsFoldersTable, DidacticsFolder> {
  final GeneratedDatabase _db;
  final String _alias;
  $DidacticsFoldersTable(this._db, [this._alias]);
  final VerificationMeta _teacherIdMeta = const VerificationMeta('teacherId');
  GeneratedTextColumn _teacherId;
  @override
  GeneratedTextColumn get teacherId => _teacherId ??= _constructTeacherId();
  GeneratedTextColumn _constructTeacherId() {
    return GeneratedTextColumn(
      'teacher_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastShareMeta = const VerificationMeta('lastShare');
  GeneratedDateTimeColumn _lastShare;
  @override
  GeneratedDateTimeColumn get lastShare => _lastShare ??= _constructLastShare();
  GeneratedDateTimeColumn _constructLastShare() {
    return GeneratedDateTimeColumn(
      'last_share',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [teacherId, id, name, lastShare];
  @override
  $DidacticsFoldersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'didactics_folders';
  @override
  final String actualTableName = 'didactics_folders';
  @override
  VerificationContext validateIntegrity(Insertable<DidacticsFolder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id'], _teacherIdMeta));
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_share')) {
      context.handle(_lastShareMeta,
          lastShare.isAcceptableOrUnknown(data['last_share'], _lastShareMeta));
    } else if (isInserting) {
      context.missing(_lastShareMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DidacticsFolder map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DidacticsFolder.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DidacticsFoldersTable createAlias(String alias) {
    return $DidacticsFoldersTable(_db, alias);
  }
}

class DidacticsContent extends DataClass
    implements Insertable<DidacticsContent> {
  final int folderId;
  final int id;
  final String name;
  final int objectId;
  final String type;
  final DateTime date;
  DidacticsContent(
      {@required this.folderId,
      @required this.id,
      @required this.name,
      @required this.objectId,
      @required this.type,
      @required this.date});
  factory DidacticsContent.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return DidacticsContent(
      folderId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}folder_id']),
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      objectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}object_id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<int>(folderId);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || objectId != null) {
      map['object_id'] = Variable<int>(objectId);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  DidacticsContentsCompanion toCompanion(bool nullToAbsent) {
    return DidacticsContentsCompanion(
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      objectId: objectId == null && nullToAbsent
          ? const Value.absent()
          : Value(objectId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory DidacticsContent.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DidacticsContent(
      folderId: serializer.fromJson<int>(json['folderId']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      objectId: serializer.fromJson<int>(json['objectId']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'folderId': serializer.toJson<int>(folderId),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'objectId': serializer.toJson<int>(objectId),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  DidacticsContent copyWith(
          {int folderId,
          int id,
          String name,
          int objectId,
          String type,
          DateTime date}) =>
      DidacticsContent(
        folderId: folderId ?? this.folderId,
        id: id ?? this.id,
        name: name ?? this.name,
        objectId: objectId ?? this.objectId,
        type: type ?? this.type,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('DidacticsContent(')
          ..write('folderId: $folderId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('objectId: $objectId, ')
          ..write('type: $type, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      folderId.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(name.hashCode,
              $mrjc(objectId.hashCode, $mrjc(type.hashCode, date.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DidacticsContent &&
          other.folderId == this.folderId &&
          other.id == this.id &&
          other.name == this.name &&
          other.objectId == this.objectId &&
          other.type == this.type &&
          other.date == this.date);
}

class DidacticsContentsCompanion extends UpdateCompanion<DidacticsContent> {
  final Value<int> folderId;
  final Value<int> id;
  final Value<String> name;
  final Value<int> objectId;
  final Value<String> type;
  final Value<DateTime> date;
  const DidacticsContentsCompanion({
    this.folderId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.objectId = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
  });
  DidacticsContentsCompanion.insert({
    @required int folderId,
    this.id = const Value.absent(),
    @required String name,
    @required int objectId,
    @required String type,
    @required DateTime date,
  })  : folderId = Value(folderId),
        name = Value(name),
        objectId = Value(objectId),
        type = Value(type),
        date = Value(date);
  static Insertable<DidacticsContent> custom({
    Expression<int> folderId,
    Expression<int> id,
    Expression<String> name,
    Expression<int> objectId,
    Expression<String> type,
    Expression<DateTime> date,
  }) {
    return RawValuesInsertable({
      if (folderId != null) 'folder_id': folderId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (objectId != null) 'object_id': objectId,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
    });
  }

  DidacticsContentsCompanion copyWith(
      {Value<int> folderId,
      Value<int> id,
      Value<String> name,
      Value<int> objectId,
      Value<String> type,
      Value<DateTime> date}) {
    return DidacticsContentsCompanion(
      folderId: folderId ?? this.folderId,
      id: id ?? this.id,
      name: name ?? this.name,
      objectId: objectId ?? this.objectId,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DidacticsContentsCompanion(')
          ..write('folderId: $folderId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('objectId: $objectId, ')
          ..write('type: $type, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DidacticsContentsTable extends DidacticsContents
    with TableInfo<$DidacticsContentsTable, DidacticsContent> {
  final GeneratedDatabase _db;
  final String _alias;
  $DidacticsContentsTable(this._db, [this._alias]);
  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  GeneratedIntColumn _folderId;
  @override
  GeneratedIntColumn get folderId => _folderId ??= _constructFolderId();
  GeneratedIntColumn _constructFolderId() {
    return GeneratedIntColumn(
      'folder_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _objectIdMeta = const VerificationMeta('objectId');
  GeneratedIntColumn _objectId;
  @override
  GeneratedIntColumn get objectId => _objectId ??= _constructObjectId();
  GeneratedIntColumn _constructObjectId() {
    return GeneratedIntColumn(
      'object_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [folderId, id, name, objectId, type, date];
  @override
  $DidacticsContentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'didactics_contents';
  @override
  final String actualTableName = 'didactics_contents';
  @override
  VerificationContext validateIntegrity(Insertable<DidacticsContent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id'], _folderIdMeta));
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id'], _objectIdMeta));
    } else if (isInserting) {
      context.missing(_objectIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DidacticsContent map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DidacticsContent.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DidacticsContentsTable createAlias(String alias) {
    return $DidacticsContentsTable(_db, alias);
  }
}

class DidacticsDownloadedFile extends DataClass
    implements Insertable<DidacticsDownloadedFile> {
  final String name;
  final String path;
  final int contentId;
  DidacticsDownloadedFile(
      {@required this.name, @required this.path, @required this.contentId});
  factory DidacticsDownloadedFile.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return DidacticsDownloadedFile(
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
      contentId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}content_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || contentId != null) {
      map['content_id'] = Variable<int>(contentId);
    }
    return map;
  }

  DidacticsDownloadedFilesCompanion toCompanion(bool nullToAbsent) {
    return DidacticsDownloadedFilesCompanion(
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      contentId: contentId == null && nullToAbsent
          ? const Value.absent()
          : Value(contentId),
    );
  }

  factory DidacticsDownloadedFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DidacticsDownloadedFile(
      name: serializer.fromJson<String>(json['name']),
      path: serializer.fromJson<String>(json['path']),
      contentId: serializer.fromJson<int>(json['contentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'path': serializer.toJson<String>(path),
      'contentId': serializer.toJson<int>(contentId),
    };
  }

  DidacticsDownloadedFile copyWith({String name, String path, int contentId}) =>
      DidacticsDownloadedFile(
        name: name ?? this.name,
        path: path ?? this.path,
        contentId: contentId ?? this.contentId,
      );
  @override
  String toString() {
    return (StringBuffer('DidacticsDownloadedFile(')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('contentId: $contentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(name.hashCode, $mrjc(path.hashCode, contentId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DidacticsDownloadedFile &&
          other.name == this.name &&
          other.path == this.path &&
          other.contentId == this.contentId);
}

class DidacticsDownloadedFilesCompanion
    extends UpdateCompanion<DidacticsDownloadedFile> {
  final Value<String> name;
  final Value<String> path;
  final Value<int> contentId;
  const DidacticsDownloadedFilesCompanion({
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.contentId = const Value.absent(),
  });
  DidacticsDownloadedFilesCompanion.insert({
    @required String name,
    @required String path,
    this.contentId = const Value.absent(),
  })  : name = Value(name),
        path = Value(path);
  static Insertable<DidacticsDownloadedFile> custom({
    Expression<String> name,
    Expression<String> path,
    Expression<int> contentId,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (contentId != null) 'content_id': contentId,
    });
  }

  DidacticsDownloadedFilesCompanion copyWith(
      {Value<String> name, Value<String> path, Value<int> contentId}) {
    return DidacticsDownloadedFilesCompanion(
      name: name ?? this.name,
      path: path ?? this.path,
      contentId: contentId ?? this.contentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<int>(contentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DidacticsDownloadedFilesCompanion(')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('contentId: $contentId')
          ..write(')'))
        .toString();
  }
}

class $DidacticsDownloadedFilesTable extends DidacticsDownloadedFiles
    with TableInfo<$DidacticsDownloadedFilesTable, DidacticsDownloadedFile> {
  final GeneratedDatabase _db;
  final String _alias;
  $DidacticsDownloadedFilesTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedTextColumn _path;
  @override
  GeneratedTextColumn get path => _path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentIdMeta = const VerificationMeta('contentId');
  GeneratedIntColumn _contentId;
  @override
  GeneratedIntColumn get contentId => _contentId ??= _constructContentId();
  GeneratedIntColumn _constructContentId() {
    return GeneratedIntColumn(
      'content_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [name, path, contentId];
  @override
  $DidacticsDownloadedFilesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'didactics_downloaded_files';
  @override
  final String actualTableName = 'didactics_downloaded_files';
  @override
  VerificationContext validateIntegrity(
      Insertable<DidacticsDownloadedFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path'], _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id'], _contentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  DidacticsDownloadedFile map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DidacticsDownloadedFile.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DidacticsDownloadedFilesTable createAlias(String alias) {
    return $DidacticsDownloadedFilesTable(_db, alias);
  }
}

class LocalGrade extends DataClass implements Insertable<LocalGrade> {
  final int id;
  final int subjectId;
  final DateTime eventDate;
  final double decimalValue;
  final String displayValue;
  final bool cancelled;
  final bool underlined;
  final int periodPos;
  LocalGrade(
      {@required this.id,
      @required this.subjectId,
      @required this.eventDate,
      @required this.decimalValue,
      @required this.displayValue,
      @required this.cancelled,
      @required this.underlined,
      @required this.periodPos});
  factory LocalGrade.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return LocalGrade(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      subjectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject_id']),
      eventDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}event_date']),
      decimalValue: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}decimal_value']),
      displayValue: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}display_value']),
      cancelled:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}cancelled']),
      underlined: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}underlined']),
      periodPos:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}period_pos']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || eventDate != null) {
      map['event_date'] = Variable<DateTime>(eventDate);
    }
    if (!nullToAbsent || decimalValue != null) {
      map['decimal_value'] = Variable<double>(decimalValue);
    }
    if (!nullToAbsent || displayValue != null) {
      map['display_value'] = Variable<String>(displayValue);
    }
    if (!nullToAbsent || cancelled != null) {
      map['cancelled'] = Variable<bool>(cancelled);
    }
    if (!nullToAbsent || underlined != null) {
      map['underlined'] = Variable<bool>(underlined);
    }
    if (!nullToAbsent || periodPos != null) {
      map['period_pos'] = Variable<int>(periodPos);
    }
    return map;
  }

  LocalGradesCompanion toCompanion(bool nullToAbsent) {
    return LocalGradesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      eventDate: eventDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eventDate),
      decimalValue: decimalValue == null && nullToAbsent
          ? const Value.absent()
          : Value(decimalValue),
      displayValue: displayValue == null && nullToAbsent
          ? const Value.absent()
          : Value(displayValue),
      cancelled: cancelled == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelled),
      underlined: underlined == null && nullToAbsent
          ? const Value.absent()
          : Value(underlined),
      periodPos: periodPos == null && nullToAbsent
          ? const Value.absent()
          : Value(periodPos),
    );
  }

  factory LocalGrade.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalGrade(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      decimalValue: serializer.fromJson<double>(json['decimalValue']),
      displayValue: serializer.fromJson<String>(json['displayValue']),
      cancelled: serializer.fromJson<bool>(json['cancelled']),
      underlined: serializer.fromJson<bool>(json['underlined']),
      periodPos: serializer.fromJson<int>(json['periodPos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'decimalValue': serializer.toJson<double>(decimalValue),
      'displayValue': serializer.toJson<String>(displayValue),
      'cancelled': serializer.toJson<bool>(cancelled),
      'underlined': serializer.toJson<bool>(underlined),
      'periodPos': serializer.toJson<int>(periodPos),
    };
  }

  LocalGrade copyWith(
          {int id,
          int subjectId,
          DateTime eventDate,
          double decimalValue,
          String displayValue,
          bool cancelled,
          bool underlined,
          int periodPos}) =>
      LocalGrade(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        eventDate: eventDate ?? this.eventDate,
        decimalValue: decimalValue ?? this.decimalValue,
        displayValue: displayValue ?? this.displayValue,
        cancelled: cancelled ?? this.cancelled,
        underlined: underlined ?? this.underlined,
        periodPos: periodPos ?? this.periodPos,
      );
  @override
  String toString() {
    return (StringBuffer('LocalGrade(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('eventDate: $eventDate, ')
          ..write('decimalValue: $decimalValue, ')
          ..write('displayValue: $displayValue, ')
          ..write('cancelled: $cancelled, ')
          ..write('underlined: $underlined, ')
          ..write('periodPos: $periodPos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          subjectId.hashCode,
          $mrjc(
              eventDate.hashCode,
              $mrjc(
                  decimalValue.hashCode,
                  $mrjc(
                      displayValue.hashCode,
                      $mrjc(cancelled.hashCode,
                          $mrjc(underlined.hashCode, periodPos.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LocalGrade &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.eventDate == this.eventDate &&
          other.decimalValue == this.decimalValue &&
          other.displayValue == this.displayValue &&
          other.cancelled == this.cancelled &&
          other.underlined == this.underlined &&
          other.periodPos == this.periodPos);
}

class LocalGradesCompanion extends UpdateCompanion<LocalGrade> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<DateTime> eventDate;
  final Value<double> decimalValue;
  final Value<String> displayValue;
  final Value<bool> cancelled;
  final Value<bool> underlined;
  final Value<int> periodPos;
  const LocalGradesCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.decimalValue = const Value.absent(),
    this.displayValue = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.underlined = const Value.absent(),
    this.periodPos = const Value.absent(),
  });
  LocalGradesCompanion.insert({
    this.id = const Value.absent(),
    @required int subjectId,
    @required DateTime eventDate,
    @required double decimalValue,
    @required String displayValue,
    @required bool cancelled,
    @required bool underlined,
    @required int periodPos,
  })  : subjectId = Value(subjectId),
        eventDate = Value(eventDate),
        decimalValue = Value(decimalValue),
        displayValue = Value(displayValue),
        cancelled = Value(cancelled),
        underlined = Value(underlined),
        periodPos = Value(periodPos);
  static Insertable<LocalGrade> custom({
    Expression<int> id,
    Expression<int> subjectId,
    Expression<DateTime> eventDate,
    Expression<double> decimalValue,
    Expression<String> displayValue,
    Expression<bool> cancelled,
    Expression<bool> underlined,
    Expression<int> periodPos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (eventDate != null) 'event_date': eventDate,
      if (decimalValue != null) 'decimal_value': decimalValue,
      if (displayValue != null) 'display_value': displayValue,
      if (cancelled != null) 'cancelled': cancelled,
      if (underlined != null) 'underlined': underlined,
      if (periodPos != null) 'period_pos': periodPos,
    });
  }

  LocalGradesCompanion copyWith(
      {Value<int> id,
      Value<int> subjectId,
      Value<DateTime> eventDate,
      Value<double> decimalValue,
      Value<String> displayValue,
      Value<bool> cancelled,
      Value<bool> underlined,
      Value<int> periodPos}) {
    return LocalGradesCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      eventDate: eventDate ?? this.eventDate,
      decimalValue: decimalValue ?? this.decimalValue,
      displayValue: displayValue ?? this.displayValue,
      cancelled: cancelled ?? this.cancelled,
      underlined: underlined ?? this.underlined,
      periodPos: periodPos ?? this.periodPos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (decimalValue.present) {
      map['decimal_value'] = Variable<double>(decimalValue.value);
    }
    if (displayValue.present) {
      map['display_value'] = Variable<String>(displayValue.value);
    }
    if (cancelled.present) {
      map['cancelled'] = Variable<bool>(cancelled.value);
    }
    if (underlined.present) {
      map['underlined'] = Variable<bool>(underlined.value);
    }
    if (periodPos.present) {
      map['period_pos'] = Variable<int>(periodPos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalGradesCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('eventDate: $eventDate, ')
          ..write('decimalValue: $decimalValue, ')
          ..write('displayValue: $displayValue, ')
          ..write('cancelled: $cancelled, ')
          ..write('underlined: $underlined, ')
          ..write('periodPos: $periodPos')
          ..write(')'))
        .toString();
  }
}

class $LocalGradesTable extends LocalGrades
    with TableInfo<$LocalGradesTable, LocalGrade> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalGradesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedIntColumn _subjectId;
  @override
  GeneratedIntColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedIntColumn _constructSubjectId() {
    return GeneratedIntColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _eventDateMeta = const VerificationMeta('eventDate');
  GeneratedDateTimeColumn _eventDate;
  @override
  GeneratedDateTimeColumn get eventDate => _eventDate ??= _constructEventDate();
  GeneratedDateTimeColumn _constructEventDate() {
    return GeneratedDateTimeColumn(
      'event_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _decimalValueMeta =
      const VerificationMeta('decimalValue');
  GeneratedRealColumn _decimalValue;
  @override
  GeneratedRealColumn get decimalValue =>
      _decimalValue ??= _constructDecimalValue();
  GeneratedRealColumn _constructDecimalValue() {
    return GeneratedRealColumn(
      'decimal_value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _displayValueMeta =
      const VerificationMeta('displayValue');
  GeneratedTextColumn _displayValue;
  @override
  GeneratedTextColumn get displayValue =>
      _displayValue ??= _constructDisplayValue();
  GeneratedTextColumn _constructDisplayValue() {
    return GeneratedTextColumn(
      'display_value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cancelledMeta = const VerificationMeta('cancelled');
  GeneratedBoolColumn _cancelled;
  @override
  GeneratedBoolColumn get cancelled => _cancelled ??= _constructCancelled();
  GeneratedBoolColumn _constructCancelled() {
    return GeneratedBoolColumn(
      'cancelled',
      $tableName,
      false,
    );
  }

  final VerificationMeta _underlinedMeta = const VerificationMeta('underlined');
  GeneratedBoolColumn _underlined;
  @override
  GeneratedBoolColumn get underlined => _underlined ??= _constructUnderlined();
  GeneratedBoolColumn _constructUnderlined() {
    return GeneratedBoolColumn(
      'underlined',
      $tableName,
      false,
    );
  }

  final VerificationMeta _periodPosMeta = const VerificationMeta('periodPos');
  GeneratedIntColumn _periodPos;
  @override
  GeneratedIntColumn get periodPos => _periodPos ??= _constructPeriodPos();
  GeneratedIntColumn _constructPeriodPos() {
    return GeneratedIntColumn(
      'period_pos',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        subjectId,
        eventDate,
        decimalValue,
        displayValue,
        cancelled,
        underlined,
        periodPos
      ];
  @override
  $LocalGradesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_grades';
  @override
  final String actualTableName = 'local_grades';
  @override
  VerificationContext validateIntegrity(Insertable<LocalGrade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id'], _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(_eventDateMeta,
          eventDate.isAcceptableOrUnknown(data['event_date'], _eventDateMeta));
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('decimal_value')) {
      context.handle(
          _decimalValueMeta,
          decimalValue.isAcceptableOrUnknown(
              data['decimal_value'], _decimalValueMeta));
    } else if (isInserting) {
      context.missing(_decimalValueMeta);
    }
    if (data.containsKey('display_value')) {
      context.handle(
          _displayValueMeta,
          displayValue.isAcceptableOrUnknown(
              data['display_value'], _displayValueMeta));
    } else if (isInserting) {
      context.missing(_displayValueMeta);
    }
    if (data.containsKey('cancelled')) {
      context.handle(_cancelledMeta,
          cancelled.isAcceptableOrUnknown(data['cancelled'], _cancelledMeta));
    } else if (isInserting) {
      context.missing(_cancelledMeta);
    }
    if (data.containsKey('underlined')) {
      context.handle(
          _underlinedMeta,
          underlined.isAcceptableOrUnknown(
              data['underlined'], _underlinedMeta));
    } else if (isInserting) {
      context.missing(_underlinedMeta);
    }
    if (data.containsKey('period_pos')) {
      context.handle(_periodPosMeta,
          periodPos.isAcceptableOrUnknown(data['period_pos'], _periodPosMeta));
    } else if (isInserting) {
      context.missing(_periodPosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalGrade map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalGrade.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LocalGradesTable createAlias(String alias) {
    return $LocalGradesTable(_db, alias);
  }
}

class TimetableEntryLocalModel extends DataClass
    implements Insertable<TimetableEntryLocalModel> {
  final int id;
  final int start;
  final int end;
  final int dayOfWeek;
  final int subject;
  final String subjectName;
  TimetableEntryLocalModel(
      {this.id,
      @required this.start,
      @required this.end,
      @required this.dayOfWeek,
      @required this.subject,
      @required this.subjectName});
  factory TimetableEntryLocalModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return TimetableEntryLocalModel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      start: intType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      end: intType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
      dayOfWeek: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}day_of_week']),
      subject:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject']),
      subjectName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<int>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<int>(end);
    }
    if (!nullToAbsent || dayOfWeek != null) {
      map['day_of_week'] = Variable<int>(dayOfWeek);
    }
    if (!nullToAbsent || subject != null) {
      map['subject'] = Variable<int>(subject);
    }
    if (!nullToAbsent || subjectName != null) {
      map['subject_name'] = Variable<String>(subjectName);
    }
    return map;
  }

  TimetableEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimetableEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      dayOfWeek: dayOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfWeek),
      subject: subject == null && nullToAbsent
          ? const Value.absent()
          : Value(subject),
      subjectName: subjectName == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectName),
    );
  }

  factory TimetableEntryLocalModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TimetableEntryLocalModel(
      id: serializer.fromJson<int>(json['id']),
      start: serializer.fromJson<int>(json['start']),
      end: serializer.fromJson<int>(json['end']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      subject: serializer.fromJson<int>(json['subject']),
      subjectName: serializer.fromJson<String>(json['subjectName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'start': serializer.toJson<int>(start),
      'end': serializer.toJson<int>(end),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'subject': serializer.toJson<int>(subject),
      'subjectName': serializer.toJson<String>(subjectName),
    };
  }

  TimetableEntryLocalModel copyWith(
          {int id,
          int start,
          int end,
          int dayOfWeek,
          int subject,
          String subjectName}) =>
      TimetableEntryLocalModel(
        id: id ?? this.id,
        start: start ?? this.start,
        end: end ?? this.end,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        subject: subject ?? this.subject,
        subjectName: subjectName ?? this.subjectName,
      );
  @override
  String toString() {
    return (StringBuffer('TimetableEntryLocalModel(')
          ..write('id: $id, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('subject: $subject, ')
          ..write('subjectName: $subjectName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          start.hashCode,
          $mrjc(
              end.hashCode,
              $mrjc(dayOfWeek.hashCode,
                  $mrjc(subject.hashCode, subjectName.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TimetableEntryLocalModel &&
          other.id == this.id &&
          other.start == this.start &&
          other.end == this.end &&
          other.dayOfWeek == this.dayOfWeek &&
          other.subject == this.subject &&
          other.subjectName == this.subjectName);
}

class TimetableEntriesCompanion
    extends UpdateCompanion<TimetableEntryLocalModel> {
  final Value<int> id;
  final Value<int> start;
  final Value<int> end;
  final Value<int> dayOfWeek;
  final Value<int> subject;
  final Value<String> subjectName;
  const TimetableEntriesCompanion({
    this.id = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.subject = const Value.absent(),
    this.subjectName = const Value.absent(),
  });
  TimetableEntriesCompanion.insert({
    this.id = const Value.absent(),
    @required int start,
    @required int end,
    @required int dayOfWeek,
    @required int subject,
    @required String subjectName,
  })  : start = Value(start),
        end = Value(end),
        dayOfWeek = Value(dayOfWeek),
        subject = Value(subject),
        subjectName = Value(subjectName);
  static Insertable<TimetableEntryLocalModel> custom({
    Expression<int> id,
    Expression<int> start,
    Expression<int> end,
    Expression<int> dayOfWeek,
    Expression<int> subject,
    Expression<String> subjectName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (subject != null) 'subject': subject,
      if (subjectName != null) 'subject_name': subjectName,
    });
  }

  TimetableEntriesCompanion copyWith(
      {Value<int> id,
      Value<int> start,
      Value<int> end,
      Value<int> dayOfWeek,
      Value<int> subject,
      Value<String> subjectName}) {
    return TimetableEntriesCompanion(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      subject: subject ?? this.subject,
      subjectName: subjectName ?? this.subjectName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (start.present) {
      map['start'] = Variable<int>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<int>(end.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (subject.present) {
      map['subject'] = Variable<int>(subject.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableEntriesCompanion(')
          ..write('id: $id, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('subject: $subject, ')
          ..write('subjectName: $subjectName')
          ..write(')'))
        .toString();
  }
}

class $TimetableEntriesTable extends TimetableEntries
    with TableInfo<$TimetableEntriesTable, TimetableEntryLocalModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $TimetableEntriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, true,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _startMeta = const VerificationMeta('start');
  GeneratedIntColumn _start;
  @override
  GeneratedIntColumn get start => _start ??= _constructStart();
  GeneratedIntColumn _constructStart() {
    return GeneratedIntColumn(
      'start',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endMeta = const VerificationMeta('end');
  GeneratedIntColumn _end;
  @override
  GeneratedIntColumn get end => _end ??= _constructEnd();
  GeneratedIntColumn _constructEnd() {
    return GeneratedIntColumn(
      'end',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dayOfWeekMeta = const VerificationMeta('dayOfWeek');
  GeneratedIntColumn _dayOfWeek;
  @override
  GeneratedIntColumn get dayOfWeek => _dayOfWeek ??= _constructDayOfWeek();
  GeneratedIntColumn _constructDayOfWeek() {
    return GeneratedIntColumn(
      'day_of_week',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectMeta = const VerificationMeta('subject');
  GeneratedIntColumn _subject;
  @override
  GeneratedIntColumn get subject => _subject ??= _constructSubject();
  GeneratedIntColumn _constructSubject() {
    return GeneratedIntColumn(
      'subject',
      $tableName,
      false,
    );
  }

  final VerificationMeta _subjectNameMeta =
      const VerificationMeta('subjectName');
  GeneratedTextColumn _subjectName;
  @override
  GeneratedTextColumn get subjectName =>
      _subjectName ??= _constructSubjectName();
  GeneratedTextColumn _constructSubjectName() {
    return GeneratedTextColumn(
      'subject_name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, start, end, dayOfWeek, subject, subjectName];
  @override
  $TimetableEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'timetable_entries';
  @override
  final String actualTableName = 'timetable_entries';
  @override
  VerificationContext validateIntegrity(
      Insertable<TimetableEntryLocalModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start'], _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end'], _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(_dayOfWeekMeta,
          dayOfWeek.isAcceptableOrUnknown(data['day_of_week'], _dayOfWeekMeta));
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject'], _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('subject_name')) {
      context.handle(
          _subjectNameMeta,
          subjectName.isAcceptableOrUnknown(
              data['subject_name'], _subjectNameMeta));
    } else if (isInserting) {
      context.missing(_subjectNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableEntryLocalModel map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TimetableEntryLocalModel.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  $TimetableEntriesTable createAlias(String alias) {
    return $TimetableEntriesTable(_db, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final String hash;
  final String description;
  Document({@required this.hash, @required this.description});
  factory Document.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Document(
      hash: stringType.mapFromDatabaseResponse(data['${effectivePrefix}hash']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Document(
      hash: serializer.fromJson<String>(json['hash']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hash': serializer.toJson<String>(hash),
      'description': serializer.toJson<String>(description),
    };
  }

  Document copyWith({String hash, String description}) => Document(
        hash: hash ?? this.hash,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('hash: $hash, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(hash.hashCode, description.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Document &&
          other.hash == this.hash &&
          other.description == this.description);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> hash;
  final Value<String> description;
  const DocumentsCompanion({
    this.hash = const Value.absent(),
    this.description = const Value.absent(),
  });
  DocumentsCompanion.insert({
    @required String hash,
    @required String description,
  })  : hash = Value(hash),
        description = Value(description);
  static Insertable<Document> custom({
    Expression<String> hash,
    Expression<String> description,
  }) {
    return RawValuesInsertable({
      if (hash != null) 'hash': hash,
      if (description != null) 'description': description,
    });
  }

  DocumentsCompanion copyWith({Value<String> hash, Value<String> description}) {
    return DocumentsCompanion(
      hash: hash ?? this.hash,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('hash: $hash, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  final GeneratedDatabase _db;
  final String _alias;
  $DocumentsTable(this._db, [this._alias]);
  final VerificationMeta _hashMeta = const VerificationMeta('hash');
  GeneratedTextColumn _hash;
  @override
  GeneratedTextColumn get hash => _hash ??= _constructHash();
  GeneratedTextColumn _constructHash() {
    return GeneratedTextColumn(
      'hash',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [hash, description];
  @override
  $DocumentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'documents';
  @override
  final String actualTableName = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash'], _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hash};
  @override
  Document map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Document.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(_db, alias);
  }
}

class SchoolReport extends DataClass implements Insertable<SchoolReport> {
  final String description;
  final String confirmLink;
  final String viewLink;
  SchoolReport(
      {@required this.description,
      @required this.confirmLink,
      @required this.viewLink});
  factory SchoolReport.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return SchoolReport(
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      confirmLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}confirm_link']),
      viewLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}view_link']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || confirmLink != null) {
      map['confirm_link'] = Variable<String>(confirmLink);
    }
    if (!nullToAbsent || viewLink != null) {
      map['view_link'] = Variable<String>(viewLink);
    }
    return map;
  }

  SchoolReportsCompanion toCompanion(bool nullToAbsent) {
    return SchoolReportsCompanion(
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      confirmLink: confirmLink == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmLink),
      viewLink: viewLink == null && nullToAbsent
          ? const Value.absent()
          : Value(viewLink),
    );
  }

  factory SchoolReport.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SchoolReport(
      description: serializer.fromJson<String>(json['description']),
      confirmLink: serializer.fromJson<String>(json['confirmLink']),
      viewLink: serializer.fromJson<String>(json['viewLink']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'description': serializer.toJson<String>(description),
      'confirmLink': serializer.toJson<String>(confirmLink),
      'viewLink': serializer.toJson<String>(viewLink),
    };
  }

  SchoolReport copyWith(
          {String description, String confirmLink, String viewLink}) =>
      SchoolReport(
        description: description ?? this.description,
        confirmLink: confirmLink ?? this.confirmLink,
        viewLink: viewLink ?? this.viewLink,
      );
  @override
  String toString() {
    return (StringBuffer('SchoolReport(')
          ..write('description: $description, ')
          ..write('confirmLink: $confirmLink, ')
          ..write('viewLink: $viewLink')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      description.hashCode, $mrjc(confirmLink.hashCode, viewLink.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SchoolReport &&
          other.description == this.description &&
          other.confirmLink == this.confirmLink &&
          other.viewLink == this.viewLink);
}

class SchoolReportsCompanion extends UpdateCompanion<SchoolReport> {
  final Value<String> description;
  final Value<String> confirmLink;
  final Value<String> viewLink;
  const SchoolReportsCompanion({
    this.description = const Value.absent(),
    this.confirmLink = const Value.absent(),
    this.viewLink = const Value.absent(),
  });
  SchoolReportsCompanion.insert({
    @required String description,
    @required String confirmLink,
    @required String viewLink,
  })  : description = Value(description),
        confirmLink = Value(confirmLink),
        viewLink = Value(viewLink);
  static Insertable<SchoolReport> custom({
    Expression<String> description,
    Expression<String> confirmLink,
    Expression<String> viewLink,
  }) {
    return RawValuesInsertable({
      if (description != null) 'description': description,
      if (confirmLink != null) 'confirm_link': confirmLink,
      if (viewLink != null) 'view_link': viewLink,
    });
  }

  SchoolReportsCompanion copyWith(
      {Value<String> description,
      Value<String> confirmLink,
      Value<String> viewLink}) {
    return SchoolReportsCompanion(
      description: description ?? this.description,
      confirmLink: confirmLink ?? this.confirmLink,
      viewLink: viewLink ?? this.viewLink,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (confirmLink.present) {
      map['confirm_link'] = Variable<String>(confirmLink.value);
    }
    if (viewLink.present) {
      map['view_link'] = Variable<String>(viewLink.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolReportsCompanion(')
          ..write('description: $description, ')
          ..write('confirmLink: $confirmLink, ')
          ..write('viewLink: $viewLink')
          ..write(')'))
        .toString();
  }
}

class $SchoolReportsTable extends SchoolReports
    with TableInfo<$SchoolReportsTable, SchoolReport> {
  final GeneratedDatabase _db;
  final String _alias;
  $SchoolReportsTable(this._db, [this._alias]);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _confirmLinkMeta =
      const VerificationMeta('confirmLink');
  GeneratedTextColumn _confirmLink;
  @override
  GeneratedTextColumn get confirmLink =>
      _confirmLink ??= _constructConfirmLink();
  GeneratedTextColumn _constructConfirmLink() {
    return GeneratedTextColumn(
      'confirm_link',
      $tableName,
      false,
    );
  }

  final VerificationMeta _viewLinkMeta = const VerificationMeta('viewLink');
  GeneratedTextColumn _viewLink;
  @override
  GeneratedTextColumn get viewLink => _viewLink ??= _constructViewLink();
  GeneratedTextColumn _constructViewLink() {
    return GeneratedTextColumn(
      'view_link',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [description, confirmLink, viewLink];
  @override
  $SchoolReportsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'school_reports';
  @override
  final String actualTableName = 'school_reports';
  @override
  VerificationContext validateIntegrity(Insertable<SchoolReport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('confirm_link')) {
      context.handle(
          _confirmLinkMeta,
          confirmLink.isAcceptableOrUnknown(
              data['confirm_link'], _confirmLinkMeta));
    } else if (isInserting) {
      context.missing(_confirmLinkMeta);
    }
    if (data.containsKey('view_link')) {
      context.handle(_viewLinkMeta,
          viewLink.isAcceptableOrUnknown(data['view_link'], _viewLinkMeta));
    } else if (isInserting) {
      context.missing(_viewLinkMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {viewLink};
  @override
  SchoolReport map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SchoolReport.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SchoolReportsTable createAlias(String alias) {
    return $SchoolReportsTable(_db, alias);
  }
}

class DownloadedDocument extends DataClass
    implements Insertable<DownloadedDocument> {
  final String hash;
  final String path;
  final String filename;
  DownloadedDocument(
      {@required this.hash, @required this.path, @required this.filename});
  factory DownloadedDocument.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return DownloadedDocument(
      hash: stringType.mapFromDatabaseResponse(data['${effectivePrefix}hash']),
      path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
      filename: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}filename']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || filename != null) {
      map['filename'] = Variable<String>(filename);
    }
    return map;
  }

  DownloadedDocumentsCompanion toCompanion(bool nullToAbsent) {
    return DownloadedDocumentsCompanion(
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      filename: filename == null && nullToAbsent
          ? const Value.absent()
          : Value(filename),
    );
  }

  factory DownloadedDocument.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DownloadedDocument(
      hash: serializer.fromJson<String>(json['hash']),
      path: serializer.fromJson<String>(json['path']),
      filename: serializer.fromJson<String>(json['filename']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hash': serializer.toJson<String>(hash),
      'path': serializer.toJson<String>(path),
      'filename': serializer.toJson<String>(filename),
    };
  }

  DownloadedDocument copyWith({String hash, String path, String filename}) =>
      DownloadedDocument(
        hash: hash ?? this.hash,
        path: path ?? this.path,
        filename: filename ?? this.filename,
      );
  @override
  String toString() {
    return (StringBuffer('DownloadedDocument(')
          ..write('hash: $hash, ')
          ..write('path: $path, ')
          ..write('filename: $filename')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(hash.hashCode, $mrjc(path.hashCode, filename.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DownloadedDocument &&
          other.hash == this.hash &&
          other.path == this.path &&
          other.filename == this.filename);
}

class DownloadedDocumentsCompanion extends UpdateCompanion<DownloadedDocument> {
  final Value<String> hash;
  final Value<String> path;
  final Value<String> filename;
  const DownloadedDocumentsCompanion({
    this.hash = const Value.absent(),
    this.path = const Value.absent(),
    this.filename = const Value.absent(),
  });
  DownloadedDocumentsCompanion.insert({
    @required String hash,
    @required String path,
    @required String filename,
  })  : hash = Value(hash),
        path = Value(path),
        filename = Value(filename);
  static Insertable<DownloadedDocument> custom({
    Expression<String> hash,
    Expression<String> path,
    Expression<String> filename,
  }) {
    return RawValuesInsertable({
      if (hash != null) 'hash': hash,
      if (path != null) 'path': path,
      if (filename != null) 'filename': filename,
    });
  }

  DownloadedDocumentsCompanion copyWith(
      {Value<String> hash, Value<String> path, Value<String> filename}) {
    return DownloadedDocumentsCompanion(
      hash: hash ?? this.hash,
      path: path ?? this.path,
      filename: filename ?? this.filename,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedDocumentsCompanion(')
          ..write('hash: $hash, ')
          ..write('path: $path, ')
          ..write('filename: $filename')
          ..write(')'))
        .toString();
  }
}

class $DownloadedDocumentsTable extends DownloadedDocuments
    with TableInfo<$DownloadedDocumentsTable, DownloadedDocument> {
  final GeneratedDatabase _db;
  final String _alias;
  $DownloadedDocumentsTable(this._db, [this._alias]);
  final VerificationMeta _hashMeta = const VerificationMeta('hash');
  GeneratedTextColumn _hash;
  @override
  GeneratedTextColumn get hash => _hash ??= _constructHash();
  GeneratedTextColumn _constructHash() {
    return GeneratedTextColumn(
      'hash',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedTextColumn _path;
  @override
  GeneratedTextColumn get path => _path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _filenameMeta = const VerificationMeta('filename');
  GeneratedTextColumn _filename;
  @override
  GeneratedTextColumn get filename => _filename ??= _constructFilename();
  GeneratedTextColumn _constructFilename() {
    return GeneratedTextColumn(
      'filename',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [hash, path, filename];
  @override
  $DownloadedDocumentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'downloaded_documents';
  @override
  final String actualTableName = 'downloaded_documents';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadedDocument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash'], _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path'], _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(_filenameMeta,
          filename.isAcceptableOrUnknown(data['filename'], _filenameMeta));
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hash};
  @override
  DownloadedDocument map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DownloadedDocument.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $DownloadedDocumentsTable createAlias(String alias) {
    return $DownloadedDocumentsTable(_db, alias);
  }
}

abstract class _$SRDatabase extends GeneratedDatabase {
  _$SRDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LessonsTable _lessons;
  $LessonsTable get lessons => _lessons ??= $LessonsTable(this);
  $SubjectsTable _subjects;
  $SubjectsTable get subjects => _subjects ??= $SubjectsTable(this);
  $ProfessorsTable _professors;
  $ProfessorsTable get professors => _professors ??= $ProfessorsTable(this);
  $GradesTable _grades;
  $GradesTable get grades => _grades ??= $GradesTable(this);
  $AgendaEventsTableTable _agendaEventsTable;
  $AgendaEventsTableTable get agendaEventsTable =>
      _agendaEventsTable ??= $AgendaEventsTableTable(this);
  $AbsencesTable _absences;
  $AbsencesTable get absences => _absences ??= $AbsencesTable(this);
  $PeriodsTable _periods;
  $PeriodsTable get periods => _periods ??= $PeriodsTable(this);
  $NoticesTable _notices;
  $NoticesTable get notices => _notices ??= $NoticesTable(this);
  $AttachmentsTable _attachments;
  $AttachmentsTable get attachments => _attachments ??= $AttachmentsTable(this);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  $NotesAttachmentsTable _notesAttachments;
  $NotesAttachmentsTable get notesAttachments =>
      _notesAttachments ??= $NotesAttachmentsTable(this);
  $DidacticsTeachersTable _didacticsTeachers;
  $DidacticsTeachersTable get didacticsTeachers =>
      _didacticsTeachers ??= $DidacticsTeachersTable(this);
  $DidacticsFoldersTable _didacticsFolders;
  $DidacticsFoldersTable get didacticsFolders =>
      _didacticsFolders ??= $DidacticsFoldersTable(this);
  $DidacticsContentsTable _didacticsContents;
  $DidacticsContentsTable get didacticsContents =>
      _didacticsContents ??= $DidacticsContentsTable(this);
  $DidacticsDownloadedFilesTable _didacticsDownloadedFiles;
  $DidacticsDownloadedFilesTable get didacticsDownloadedFiles =>
      _didacticsDownloadedFiles ??= $DidacticsDownloadedFilesTable(this);
  $LocalGradesTable _localGrades;
  $LocalGradesTable get localGrades => _localGrades ??= $LocalGradesTable(this);
  $TimetableEntriesTable _timetableEntries;
  $TimetableEntriesTable get timetableEntries =>
      _timetableEntries ??= $TimetableEntriesTable(this);
  $DocumentsTable _documents;
  $DocumentsTable get documents => _documents ??= $DocumentsTable(this);
  $SchoolReportsTable _schoolReports;
  $SchoolReportsTable get schoolReports =>
      _schoolReports ??= $SchoolReportsTable(this);
  $DownloadedDocumentsTable _downloadedDocuments;
  $DownloadedDocumentsTable get downloadedDocuments =>
      _downloadedDocuments ??= $DownloadedDocumentsTable(this);
  AbsenceDao _absenceDao;
  AbsenceDao get absenceDao => _absenceDao ??= AbsenceDao(this as SRDatabase);
  NoteDao _noteDao;
  NoteDao get noteDao => _noteDao ??= NoteDao(this as SRDatabase);
  DidacticsDao _didacticsDao;
  DidacticsDao get didacticsDao =>
      _didacticsDao ??= DidacticsDao(this as SRDatabase);
  DocumentsDao _documentsDao;
  DocumentsDao get documentsDao =>
      _documentsDao ??= DocumentsDao(this as SRDatabase);
  GradesLocalDatasource _gradesLocalDatasource;
  GradesLocalDatasource get gradesLocalDatasource =>
      _gradesLocalDatasource ??= GradesLocalDatasource(this as SRDatabase);
  AgendaLocalDatasource _agendaLocalDatasource;
  AgendaLocalDatasource get agendaLocalDatasource =>
      _agendaLocalDatasource ??= AgendaLocalDatasource(this as SRDatabase);
  LessonsLocalDatasource _lessonsLocalDatasource;
  LessonsLocalDatasource get lessonsLocalDatasource =>
      _lessonsLocalDatasource ??= LessonsLocalDatasource(this as SRDatabase);
  SubjectsLocalDatasource _subjectsLocalDatasource;
  SubjectsLocalDatasource get subjectsLocalDatasource =>
      _subjectsLocalDatasource ??= SubjectsLocalDatasource(this as SRDatabase);
  ProfessorLocalDatasource _professorLocalDatasource;
  ProfessorLocalDatasource get professorLocalDatasource =>
      _professorLocalDatasource ??=
          ProfessorLocalDatasource(this as SRDatabase);
  PeriodsLocalDatasource _periodsLocalDatasource;
  PeriodsLocalDatasource get periodsLocalDatasource =>
      _periodsLocalDatasource ??= PeriodsLocalDatasource(this as SRDatabase);
  NoticeboardLocalDatasource _noticeboardLocalDatasource;
  NoticeboardLocalDatasource get noticeboardLocalDatasource =>
      _noticeboardLocalDatasource ??=
          NoticeboardLocalDatasource(this as SRDatabase);
  TimetableLocalDatasource _timetableLocalDatasource;
  TimetableLocalDatasource get timetableLocalDatasource =>
      _timetableLocalDatasource ??=
          TimetableLocalDatasource(this as SRDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        lessons,
        subjects,
        professors,
        grades,
        agendaEventsTable,
        absences,
        periods,
        notices,
        attachments,
        notes,
        notesAttachments,
        didacticsTeachers,
        didacticsFolders,
        didacticsContents,
        didacticsDownloadedFiles,
        localGrades,
        timetableEntries,
        documents,
        schoolReports,
        downloadedDocuments
      ];
}
