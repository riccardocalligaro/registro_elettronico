// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String studentId;
  final String ident;
  final String firstName;
  final String lastName;
  final String token;
  final DateTime release;
  final DateTime expire;
  final String passwordKey;
  Profile(
      {@required this.id,
      @required this.studentId,
      @required this.ident,
      @required this.firstName,
      @required this.lastName,
      @required this.token,
      @required this.release,
      @required this.expire,
      @required this.passwordKey});
  factory Profile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Profile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      studentId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}student_id']),
      ident:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}ident']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
      lastName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
      release: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}release']),
      expire: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}expire']),
      passwordKey: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password_key']),
    );
  }
  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      ident: serializer.fromJson<String>(json['ident']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      token: serializer.fromJson<String>(json['token']),
      release: serializer.fromJson<DateTime>(json['release']),
      expire: serializer.fromJson<DateTime>(json['expire']),
      passwordKey: serializer.fromJson<String>(json['passwordKey']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<String>(studentId),
      'ident': serializer.toJson<String>(ident),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'token': serializer.toJson<String>(token),
      'release': serializer.toJson<DateTime>(release),
      'expire': serializer.toJson<DateTime>(expire),
      'passwordKey': serializer.toJson<String>(passwordKey),
    };
  }

  @override
  ProfilesCompanion createCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
      ident:
          ident == null && nullToAbsent ? const Value.absent() : Value(ident),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      release: release == null && nullToAbsent
          ? const Value.absent()
          : Value(release),
      expire:
          expire == null && nullToAbsent ? const Value.absent() : Value(expire),
      passwordKey: passwordKey == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordKey),
    );
  }

  Profile copyWith(
          {int id,
          String studentId,
          String ident,
          String firstName,
          String lastName,
          String token,
          DateTime release,
          DateTime expire,
          String passwordKey}) =>
      Profile(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        ident: ident ?? this.ident,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        token: token ?? this.token,
        release: release ?? this.release,
        expire: expire ?? this.expire,
        passwordKey: passwordKey ?? this.passwordKey,
      );
  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('ident: $ident, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('token: $token, ')
          ..write('release: $release, ')
          ..write('expire: $expire, ')
          ..write('passwordKey: $passwordKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          studentId.hashCode,
          $mrjc(
              ident.hashCode,
              $mrjc(
                  firstName.hashCode,
                  $mrjc(
                      lastName.hashCode,
                      $mrjc(
                          token.hashCode,
                          $mrjc(
                              release.hashCode,
                              $mrjc(expire.hashCode,
                                  passwordKey.hashCode)))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.ident == this.ident &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.token == this.token &&
          other.release == this.release &&
          other.expire == this.expire &&
          other.passwordKey == this.passwordKey);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> studentId;
  final Value<String> ident;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> token;
  final Value<DateTime> release;
  final Value<DateTime> expire;
  final Value<String> passwordKey;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.ident = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.token = const Value.absent(),
    this.release = const Value.absent(),
    this.expire = const Value.absent(),
    this.passwordKey = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required String studentId,
    @required String ident,
    @required String firstName,
    @required String lastName,
    @required String token,
    @required DateTime release,
    @required DateTime expire,
    @required String passwordKey,
  })  : studentId = Value(studentId),
        ident = Value(ident),
        firstName = Value(firstName),
        lastName = Value(lastName),
        token = Value(token),
        release = Value(release),
        expire = Value(expire),
        passwordKey = Value(passwordKey);
  ProfilesCompanion copyWith(
      {Value<int> id,
      Value<String> studentId,
      Value<String> ident,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> token,
      Value<DateTime> release,
      Value<DateTime> expire,
      Value<String> passwordKey}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      ident: ident ?? this.ident,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      release: release ?? this.release,
      expire: expire ?? this.expire,
      passwordKey: passwordKey ?? this.passwordKey,
    );
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProfilesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _studentIdMeta = const VerificationMeta('studentId');
  GeneratedTextColumn _studentId;
  @override
  GeneratedTextColumn get studentId => _studentId ??= _constructStudentId();
  GeneratedTextColumn _constructStudentId() {
    return GeneratedTextColumn(
      'student_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _identMeta = const VerificationMeta('ident');
  GeneratedTextColumn _ident;
  @override
  GeneratedTextColumn get ident => _ident ??= _constructIdent();
  GeneratedTextColumn _constructIdent() {
    return GeneratedTextColumn(
      'ident',
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

  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  GeneratedTextColumn _token;
  @override
  GeneratedTextColumn get token => _token ??= _constructToken();
  GeneratedTextColumn _constructToken() {
    return GeneratedTextColumn(
      'token',
      $tableName,
      false,
    );
  }

  final VerificationMeta _releaseMeta = const VerificationMeta('release');
  GeneratedDateTimeColumn _release;
  @override
  GeneratedDateTimeColumn get release => _release ??= _constructRelease();
  GeneratedDateTimeColumn _constructRelease() {
    return GeneratedDateTimeColumn(
      'release',
      $tableName,
      false,
    );
  }

  final VerificationMeta _expireMeta = const VerificationMeta('expire');
  GeneratedDateTimeColumn _expire;
  @override
  GeneratedDateTimeColumn get expire => _expire ??= _constructExpire();
  GeneratedDateTimeColumn _constructExpire() {
    return GeneratedDateTimeColumn(
      'expire',
      $tableName,
      false,
    );
  }

  final VerificationMeta _passwordKeyMeta =
      const VerificationMeta('passwordKey');
  GeneratedTextColumn _passwordKey;
  @override
  GeneratedTextColumn get passwordKey =>
      _passwordKey ??= _constructPasswordKey();
  GeneratedTextColumn _constructPasswordKey() {
    return GeneratedTextColumn(
      'password_key',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        ident,
        firstName,
        lastName,
        token,
        release,
        expire,
        passwordKey
      ];
  @override
  $ProfilesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'profiles';
  @override
  final String actualTableName = 'profiles';
  @override
  VerificationContext validateIntegrity(ProfilesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.studentId.present) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableValue(d.studentId.value, _studentIdMeta));
    } else if (studentId.isRequired && isInserting) {
      context.missing(_studentIdMeta);
    }
    if (d.ident.present) {
      context.handle(
          _identMeta, ident.isAcceptableValue(d.ident.value, _identMeta));
    } else if (ident.isRequired && isInserting) {
      context.missing(_identMeta);
    }
    if (d.firstName.present) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableValue(d.firstName.value, _firstNameMeta));
    } else if (firstName.isRequired && isInserting) {
      context.missing(_firstNameMeta);
    }
    if (d.lastName.present) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableValue(d.lastName.value, _lastNameMeta));
    } else if (lastName.isRequired && isInserting) {
      context.missing(_lastNameMeta);
    }
    if (d.token.present) {
      context.handle(
          _tokenMeta, token.isAcceptableValue(d.token.value, _tokenMeta));
    } else if (token.isRequired && isInserting) {
      context.missing(_tokenMeta);
    }
    if (d.release.present) {
      context.handle(_releaseMeta,
          release.isAcceptableValue(d.release.value, _releaseMeta));
    } else if (release.isRequired && isInserting) {
      context.missing(_releaseMeta);
    }
    if (d.expire.present) {
      context.handle(
          _expireMeta, expire.isAcceptableValue(d.expire.value, _expireMeta));
    } else if (expire.isRequired && isInserting) {
      context.missing(_expireMeta);
    }
    if (d.passwordKey.present) {
      context.handle(_passwordKeyMeta,
          passwordKey.isAcceptableValue(d.passwordKey.value, _passwordKeyMeta));
    } else if (passwordKey.isRequired && isInserting) {
      context.missing(_passwordKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ident};
  @override
  Profile map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Profile.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ProfilesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.studentId.present) {
      map['student_id'] = Variable<String, StringType>(d.studentId.value);
    }
    if (d.ident.present) {
      map['ident'] = Variable<String, StringType>(d.ident.value);
    }
    if (d.firstName.present) {
      map['first_name'] = Variable<String, StringType>(d.firstName.value);
    }
    if (d.lastName.present) {
      map['last_name'] = Variable<String, StringType>(d.lastName.value);
    }
    if (d.token.present) {
      map['token'] = Variable<String, StringType>(d.token.value);
    }
    if (d.release.present) {
      map['release'] = Variable<DateTime, DateTimeType>(d.release.value);
    }
    if (d.expire.present) {
      map['expire'] = Variable<DateTime, DateTimeType>(d.expire.value);
    }
    if (d.passwordKey.present) {
      map['password_key'] = Variable<String, StringType>(d.passwordKey.value);
    }
    return map;
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(_db, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
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
  Lesson(
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
  factory Lesson.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return Lesson(
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
  factory Lesson.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Lesson(
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
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
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

  @override
  LessonsCompanion createCompanion(bool nullToAbsent) {
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

  Lesson copyWith(
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
      Lesson(
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
    return (StringBuffer('Lesson(')
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
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Lesson &&
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

class LessonsCompanion extends UpdateCompanion<Lesson> {
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
    @required int eventId,
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
  })  : eventId = Value(eventId),
        date = Value(date),
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
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
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
  VerificationContext validateIntegrity(LessonsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.eventId.present) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableValue(d.eventId.value, _eventIdMeta));
    } else if (eventId.isRequired && isInserting) {
      context.missing(_eventIdMeta);
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    } else if (date.isRequired && isInserting) {
      context.missing(_dateMeta);
    }
    if (d.code.present) {
      context.handle(
          _codeMeta, code.isAcceptableValue(d.code.value, _codeMeta));
    } else if (code.isRequired && isInserting) {
      context.missing(_codeMeta);
    }
    if (d.position.present) {
      context.handle(_positionMeta,
          position.isAcceptableValue(d.position.value, _positionMeta));
    } else if (position.isRequired && isInserting) {
      context.missing(_positionMeta);
    }
    if (d.duration.present) {
      context.handle(_durationMeta,
          duration.isAcceptableValue(d.duration.value, _durationMeta));
    } else if (duration.isRequired && isInserting) {
      context.missing(_durationMeta);
    }
    if (d.classe.present) {
      context.handle(
          _classeMeta, classe.isAcceptableValue(d.classe.value, _classeMeta));
    } else if (classe.isRequired && isInserting) {
      context.missing(_classeMeta);
    }
    if (d.author.present) {
      context.handle(
          _authorMeta, author.isAcceptableValue(d.author.value, _authorMeta));
    } else if (author.isRequired && isInserting) {
      context.missing(_authorMeta);
    }
    if (d.subjectId.present) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableValue(d.subjectId.value, _subjectIdMeta));
    } else if (subjectId.isRequired && isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (d.subjectCode.present) {
      context.handle(_subjectCodeMeta,
          subjectCode.isAcceptableValue(d.subjectCode.value, _subjectCodeMeta));
    } else if (subjectCode.isRequired && isInserting) {
      context.missing(_subjectCodeMeta);
    }
    if (d.subjectDescription.present) {
      context.handle(
          _subjectDescriptionMeta,
          subjectDescription.isAcceptableValue(
              d.subjectDescription.value, _subjectDescriptionMeta));
    } else if (subjectDescription.isRequired && isInserting) {
      context.missing(_subjectDescriptionMeta);
    }
    if (d.lessonType.present) {
      context.handle(_lessonTypeMeta,
          lessonType.isAcceptableValue(d.lessonType.value, _lessonTypeMeta));
    } else if (lessonType.isRequired && isInserting) {
      context.missing(_lessonTypeMeta);
    }
    if (d.lessonArg.present) {
      context.handle(_lessonArgMeta,
          lessonArg.isAcceptableValue(d.lessonArg.value, _lessonArgMeta));
    } else if (lessonArg.isRequired && isInserting) {
      context.missing(_lessonArgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  Lesson map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Lesson.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LessonsCompanion d) {
    final map = <String, Variable>{};
    if (d.eventId.present) {
      map['event_id'] = Variable<int, IntType>(d.eventId.value);
    }
    if (d.date.present) {
      map['date'] = Variable<DateTime, DateTimeType>(d.date.value);
    }
    if (d.code.present) {
      map['code'] = Variable<String, StringType>(d.code.value);
    }
    if (d.position.present) {
      map['position'] = Variable<int, IntType>(d.position.value);
    }
    if (d.duration.present) {
      map['duration'] = Variable<int, IntType>(d.duration.value);
    }
    if (d.classe.present) {
      map['classe'] = Variable<String, StringType>(d.classe.value);
    }
    if (d.author.present) {
      map['author'] = Variable<String, StringType>(d.author.value);
    }
    if (d.subjectId.present) {
      map['subject_id'] = Variable<int, IntType>(d.subjectId.value);
    }
    if (d.subjectCode.present) {
      map['subject_code'] = Variable<String, StringType>(d.subjectCode.value);
    }
    if (d.subjectDescription.present) {
      map['subject_description'] =
          Variable<String, StringType>(d.subjectDescription.value);
    }
    if (d.lessonType.present) {
      map['lesson_type'] = Variable<String, StringType>(d.lessonType.value);
    }
    if (d.lessonArg.present) {
      map['lesson_arg'] = Variable<String, StringType>(d.lessonArg.value);
    }
    return map;
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(_db, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String name;
  final int orderNumber;
  Subject({@required this.id, @required this.name, @required this.orderNumber});
  factory Subject.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Subject(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      orderNumber: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}order_number']),
    );
  }
  factory Subject.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      orderNumber: serializer.fromJson<int>(json['orderNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'orderNumber': serializer.toJson<int>(orderNumber),
    };
  }

  @override
  SubjectsCompanion createCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      orderNumber: orderNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNumber),
    );
  }

  Subject copyWith({int id, String name, int orderNumber}) => Subject(
        id: id ?? this.id,
        name: name ?? this.name,
        orderNumber: orderNumber ?? this.orderNumber,
      );
  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderNumber: $orderNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, orderNumber.hashCode)));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.orderNumber == this.orderNumber);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> orderNumber;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.orderNumber = const Value.absent(),
  });
  SubjectsCompanion.insert({
    @required int id,
    @required String name,
    @required int orderNumber,
  })  : id = Value(id),
        name = Value(name),
        orderNumber = Value(orderNumber);
  SubjectsCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> orderNumber}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
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

  @override
  List<GeneratedColumn> get $columns => [id, name, orderNumber];
  @override
  $SubjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'subjects';
  @override
  final String actualTableName = 'subjects';
  @override
  VerificationContext validateIntegrity(SubjectsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.orderNumber.present) {
      context.handle(_orderNumberMeta,
          orderNumber.isAcceptableValue(d.orderNumber.value, _orderNumberMeta));
    } else if (orderNumber.isRequired && isInserting) {
      context.missing(_orderNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Subject.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(SubjectsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.orderNumber.present) {
      map['order_number'] = Variable<int, IntType>(d.orderNumber.value);
    }
    return map;
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(_db, alias);
  }
}

class Professor extends DataClass implements Insertable<Professor> {
  final String id;
  final int subjectId;
  final String name;
  Professor({@required this.id, @required this.subjectId, @required this.name});
  factory Professor.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return Professor(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      subjectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}subject_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Professor.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Professor(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  ProfessorsCompanion createCompanion(bool nullToAbsent) {
    return ProfessorsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Professor copyWith({String id, int subjectId, String name}) => Professor(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Professor(')
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
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Professor &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.name == this.name);
}

class ProfessorsCompanion extends UpdateCompanion<Professor> {
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
  ProfessorsCompanion copyWith(
      {Value<String> id, Value<int> subjectId, Value<String> name}) {
    return ProfessorsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
    );
  }
}

class $ProfessorsTable extends Professors
    with TableInfo<$ProfessorsTable, Professor> {
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
  VerificationContext validateIntegrity(ProfessorsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.subjectId.present) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableValue(d.subjectId.value, _subjectIdMeta));
    } else if (subjectId.isRequired && isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Professor map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Professor.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ProfessorsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.subjectId.present) {
      map['subject_id'] = Variable<int, IntType>(d.subjectId.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $ProfessorsTable createAlias(String alias) {
    return $ProfessorsTable(_db, alias);
  }
}

class Grade extends DataClass implements Insertable<Grade> {
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
  Grade(
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
      @required this.gradeMasterId});
  factory Grade.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Grade(
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
    );
  }
  factory Grade.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Grade(
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
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
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
    };
  }

  @override
  GradesCompanion createCompanion(bool nullToAbsent) {
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
    );
  }

  Grade copyWith(
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
          int gradeMasterId}) =>
      Grade(
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
      );
  @override
  String toString() {
    return (StringBuffer('Grade(')
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
          ..write('gradeMasterId: $gradeMasterId')
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
                                                                      gradeMasterId
                                                                          .hashCode))))))))))))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Grade &&
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
          other.gradeMasterId == this.gradeMasterId);
}

class GradesCompanion extends UpdateCompanion<Grade> {
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
  });
  GradesCompanion.insert({
    @required int subjectId,
    @required String subjectDesc,
    @required int evtId,
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
  })  : subjectId = Value(subjectId),
        subjectDesc = Value(subjectDesc),
        evtId = Value(evtId),
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
        gradeMasterId = Value(gradeMasterId);
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
      Value<int> gradeMasterId}) {
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
    );
  }
}

class $GradesTable extends Grades with TableInfo<$GradesTable, Grade> {
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
        gradeMasterId
      ];
  @override
  $GradesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'grades';
  @override
  final String actualTableName = 'grades';
  @override
  VerificationContext validateIntegrity(GradesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.subjectId.present) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableValue(d.subjectId.value, _subjectIdMeta));
    } else if (subjectId.isRequired && isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (d.subjectDesc.present) {
      context.handle(_subjectDescMeta,
          subjectDesc.isAcceptableValue(d.subjectDesc.value, _subjectDescMeta));
    } else if (subjectDesc.isRequired && isInserting) {
      context.missing(_subjectDescMeta);
    }
    if (d.evtId.present) {
      context.handle(
          _evtIdMeta, evtId.isAcceptableValue(d.evtId.value, _evtIdMeta));
    } else if (evtId.isRequired && isInserting) {
      context.missing(_evtIdMeta);
    }
    if (d.evtCode.present) {
      context.handle(_evtCodeMeta,
          evtCode.isAcceptableValue(d.evtCode.value, _evtCodeMeta));
    } else if (evtCode.isRequired && isInserting) {
      context.missing(_evtCodeMeta);
    }
    if (d.eventDate.present) {
      context.handle(_eventDateMeta,
          eventDate.isAcceptableValue(d.eventDate.value, _eventDateMeta));
    } else if (eventDate.isRequired && isInserting) {
      context.missing(_eventDateMeta);
    }
    if (d.decimalValue.present) {
      context.handle(
          _decimalValueMeta,
          decimalValue.isAcceptableValue(
              d.decimalValue.value, _decimalValueMeta));
    } else if (decimalValue.isRequired && isInserting) {
      context.missing(_decimalValueMeta);
    }
    if (d.displayValue.present) {
      context.handle(
          _displayValueMeta,
          displayValue.isAcceptableValue(
              d.displayValue.value, _displayValueMeta));
    } else if (displayValue.isRequired && isInserting) {
      context.missing(_displayValueMeta);
    }
    if (d.displayPos.present) {
      context.handle(_displayPosMeta,
          displayPos.isAcceptableValue(d.displayPos.value, _displayPosMeta));
    } else if (displayPos.isRequired && isInserting) {
      context.missing(_displayPosMeta);
    }
    if (d.notesForFamily.present) {
      context.handle(
          _notesForFamilyMeta,
          notesForFamily.isAcceptableValue(
              d.notesForFamily.value, _notesForFamilyMeta));
    } else if (notesForFamily.isRequired && isInserting) {
      context.missing(_notesForFamilyMeta);
    }
    if (d.cancelled.present) {
      context.handle(_cancelledMeta,
          cancelled.isAcceptableValue(d.cancelled.value, _cancelledMeta));
    } else if (cancelled.isRequired && isInserting) {
      context.missing(_cancelledMeta);
    }
    if (d.underlined.present) {
      context.handle(_underlinedMeta,
          underlined.isAcceptableValue(d.underlined.value, _underlinedMeta));
    } else if (underlined.isRequired && isInserting) {
      context.missing(_underlinedMeta);
    }
    if (d.periodPos.present) {
      context.handle(_periodPosMeta,
          periodPos.isAcceptableValue(d.periodPos.value, _periodPosMeta));
    } else if (periodPos.isRequired && isInserting) {
      context.missing(_periodPosMeta);
    }
    if (d.periodDesc.present) {
      context.handle(_periodDescMeta,
          periodDesc.isAcceptableValue(d.periodDesc.value, _periodDescMeta));
    } else if (periodDesc.isRequired && isInserting) {
      context.missing(_periodDescMeta);
    }
    if (d.componentPos.present) {
      context.handle(
          _componentPosMeta,
          componentPos.isAcceptableValue(
              d.componentPos.value, _componentPosMeta));
    } else if (componentPos.isRequired && isInserting) {
      context.missing(_componentPosMeta);
    }
    if (d.componentDesc.present) {
      context.handle(
          _componentDescMeta,
          componentDesc.isAcceptableValue(
              d.componentDesc.value, _componentDescMeta));
    } else if (componentDesc.isRequired && isInserting) {
      context.missing(_componentDescMeta);
    }
    if (d.weightFactor.present) {
      context.handle(
          _weightFactorMeta,
          weightFactor.isAcceptableValue(
              d.weightFactor.value, _weightFactorMeta));
    } else if (weightFactor.isRequired && isInserting) {
      context.missing(_weightFactorMeta);
    }
    if (d.skillId.present) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableValue(d.skillId.value, _skillIdMeta));
    } else if (skillId.isRequired && isInserting) {
      context.missing(_skillIdMeta);
    }
    if (d.gradeMasterId.present) {
      context.handle(
          _gradeMasterIdMeta,
          gradeMasterId.isAcceptableValue(
              d.gradeMasterId.value, _gradeMasterIdMeta));
    } else if (gradeMasterId.isRequired && isInserting) {
      context.missing(_gradeMasterIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Grade map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Grade.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(GradesCompanion d) {
    final map = <String, Variable>{};
    if (d.subjectId.present) {
      map['subject_id'] = Variable<int, IntType>(d.subjectId.value);
    }
    if (d.subjectDesc.present) {
      map['subject_desc'] = Variable<String, StringType>(d.subjectDesc.value);
    }
    if (d.evtId.present) {
      map['evt_id'] = Variable<int, IntType>(d.evtId.value);
    }
    if (d.evtCode.present) {
      map['evt_code'] = Variable<String, StringType>(d.evtCode.value);
    }
    if (d.eventDate.present) {
      map['event_date'] = Variable<DateTime, DateTimeType>(d.eventDate.value);
    }
    if (d.decimalValue.present) {
      map['decimal_value'] = Variable<double, RealType>(d.decimalValue.value);
    }
    if (d.displayValue.present) {
      map['display_value'] = Variable<String, StringType>(d.displayValue.value);
    }
    if (d.displayPos.present) {
      map['display_pos'] = Variable<int, IntType>(d.displayPos.value);
    }
    if (d.notesForFamily.present) {
      map['notes_for_family'] =
          Variable<String, StringType>(d.notesForFamily.value);
    }
    if (d.cancelled.present) {
      map['cancelled'] = Variable<bool, BoolType>(d.cancelled.value);
    }
    if (d.underlined.present) {
      map['underlined'] = Variable<bool, BoolType>(d.underlined.value);
    }
    if (d.periodPos.present) {
      map['period_pos'] = Variable<int, IntType>(d.periodPos.value);
    }
    if (d.periodDesc.present) {
      map['period_desc'] = Variable<String, StringType>(d.periodDesc.value);
    }
    if (d.componentPos.present) {
      map['component_pos'] = Variable<int, IntType>(d.componentPos.value);
    }
    if (d.componentDesc.present) {
      map['component_desc'] =
          Variable<String, StringType>(d.componentDesc.value);
    }
    if (d.weightFactor.present) {
      map['weight_factor'] = Variable<int, IntType>(d.weightFactor.value);
    }
    if (d.skillId.present) {
      map['skill_id'] = Variable<int, IntType>(d.skillId.value);
    }
    if (d.gradeMasterId.present) {
      map['grade_master_id'] = Variable<int, IntType>(d.gradeMasterId.value);
    }
    return map;
  }

  @override
  $GradesTable createAlias(String alias) {
    return $GradesTable(_db, alias);
  }
}

class AgendaEvent extends DataClass implements Insertable<AgendaEvent> {
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
  AgendaEvent(
      {@required this.evtId,
      @required this.evtCode,
      @required this.begin,
      @required this.end,
      @required this.isFullDay,
      @required this.notes,
      @required this.authorName,
      @required this.classDesc,
      @required this.subjectId,
      @required this.subjectDesc});
  factory AgendaEvent.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return AgendaEvent(
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
    );
  }
  factory AgendaEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return AgendaEvent(
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
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
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
    };
  }

  @override
  AgendaEventsCompanion createCompanion(bool nullToAbsent) {
    return AgendaEventsCompanion(
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
    );
  }

  AgendaEvent copyWith(
          {int evtId,
          String evtCode,
          DateTime begin,
          DateTime end,
          bool isFullDay,
          String notes,
          String authorName,
          String classDesc,
          int subjectId,
          String subjectDesc}) =>
      AgendaEvent(
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
      );
  @override
  String toString() {
    return (StringBuffer('AgendaEvent(')
          ..write('evtId: $evtId, ')
          ..write('evtCode: $evtCode, ')
          ..write('begin: $begin, ')
          ..write('end: $end, ')
          ..write('isFullDay: $isFullDay, ')
          ..write('notes: $notes, ')
          ..write('authorName: $authorName, ')
          ..write('classDesc: $classDesc, ')
          ..write('subjectId: $subjectId, ')
          ..write('subjectDesc: $subjectDesc')
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
                                  $mrjc(subjectId.hashCode,
                                      subjectDesc.hashCode))))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is AgendaEvent &&
          other.evtId == this.evtId &&
          other.evtCode == this.evtCode &&
          other.begin == this.begin &&
          other.end == this.end &&
          other.isFullDay == this.isFullDay &&
          other.notes == this.notes &&
          other.authorName == this.authorName &&
          other.classDesc == this.classDesc &&
          other.subjectId == this.subjectId &&
          other.subjectDesc == this.subjectDesc);
}

class AgendaEventsCompanion extends UpdateCompanion<AgendaEvent> {
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
  const AgendaEventsCompanion({
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
  });
  AgendaEventsCompanion.insert({
    @required int evtId,
    @required String evtCode,
    @required DateTime begin,
    @required DateTime end,
    @required bool isFullDay,
    @required String notes,
    @required String authorName,
    @required String classDesc,
    @required int subjectId,
    @required String subjectDesc,
  })  : evtId = Value(evtId),
        evtCode = Value(evtCode),
        begin = Value(begin),
        end = Value(end),
        isFullDay = Value(isFullDay),
        notes = Value(notes),
        authorName = Value(authorName),
        classDesc = Value(classDesc),
        subjectId = Value(subjectId),
        subjectDesc = Value(subjectDesc);
  AgendaEventsCompanion copyWith(
      {Value<int> evtId,
      Value<String> evtCode,
      Value<DateTime> begin,
      Value<DateTime> end,
      Value<bool> isFullDay,
      Value<String> notes,
      Value<String> authorName,
      Value<String> classDesc,
      Value<int> subjectId,
      Value<String> subjectDesc}) {
    return AgendaEventsCompanion(
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
    );
  }
}

class $AgendaEventsTable extends AgendaEvents
    with TableInfo<$AgendaEventsTable, AgendaEvent> {
  final GeneratedDatabase _db;
  final String _alias;
  $AgendaEventsTable(this._db, [this._alias]);
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
        subjectDesc
      ];
  @override
  $AgendaEventsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'agenda_events';
  @override
  final String actualTableName = 'agenda_events';
  @override
  VerificationContext validateIntegrity(AgendaEventsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.evtId.present) {
      context.handle(
          _evtIdMeta, evtId.isAcceptableValue(d.evtId.value, _evtIdMeta));
    } else if (evtId.isRequired && isInserting) {
      context.missing(_evtIdMeta);
    }
    if (d.evtCode.present) {
      context.handle(_evtCodeMeta,
          evtCode.isAcceptableValue(d.evtCode.value, _evtCodeMeta));
    } else if (evtCode.isRequired && isInserting) {
      context.missing(_evtCodeMeta);
    }
    if (d.begin.present) {
      context.handle(
          _beginMeta, begin.isAcceptableValue(d.begin.value, _beginMeta));
    } else if (begin.isRequired && isInserting) {
      context.missing(_beginMeta);
    }
    if (d.end.present) {
      context.handle(_endMeta, end.isAcceptableValue(d.end.value, _endMeta));
    } else if (end.isRequired && isInserting) {
      context.missing(_endMeta);
    }
    if (d.isFullDay.present) {
      context.handle(_isFullDayMeta,
          isFullDay.isAcceptableValue(d.isFullDay.value, _isFullDayMeta));
    } else if (isFullDay.isRequired && isInserting) {
      context.missing(_isFullDayMeta);
    }
    if (d.notes.present) {
      context.handle(
          _notesMeta, notes.isAcceptableValue(d.notes.value, _notesMeta));
    } else if (notes.isRequired && isInserting) {
      context.missing(_notesMeta);
    }
    if (d.authorName.present) {
      context.handle(_authorNameMeta,
          authorName.isAcceptableValue(d.authorName.value, _authorNameMeta));
    } else if (authorName.isRequired && isInserting) {
      context.missing(_authorNameMeta);
    }
    if (d.classDesc.present) {
      context.handle(_classDescMeta,
          classDesc.isAcceptableValue(d.classDesc.value, _classDescMeta));
    } else if (classDesc.isRequired && isInserting) {
      context.missing(_classDescMeta);
    }
    if (d.subjectId.present) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableValue(d.subjectId.value, _subjectIdMeta));
    } else if (subjectId.isRequired && isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (d.subjectDesc.present) {
      context.handle(_subjectDescMeta,
          subjectDesc.isAcceptableValue(d.subjectDesc.value, _subjectDescMeta));
    } else if (subjectDesc.isRequired && isInserting) {
      context.missing(_subjectDescMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  AgendaEvent map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AgendaEvent.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(AgendaEventsCompanion d) {
    final map = <String, Variable>{};
    if (d.evtId.present) {
      map['evt_id'] = Variable<int, IntType>(d.evtId.value);
    }
    if (d.evtCode.present) {
      map['evt_code'] = Variable<String, StringType>(d.evtCode.value);
    }
    if (d.begin.present) {
      map['begin'] = Variable<DateTime, DateTimeType>(d.begin.value);
    }
    if (d.end.present) {
      map['end'] = Variable<DateTime, DateTimeType>(d.end.value);
    }
    if (d.isFullDay.present) {
      map['is_full_day'] = Variable<bool, BoolType>(d.isFullDay.value);
    }
    if (d.notes.present) {
      map['notes'] = Variable<String, StringType>(d.notes.value);
    }
    if (d.authorName.present) {
      map['author_name'] = Variable<String, StringType>(d.authorName.value);
    }
    if (d.classDesc.present) {
      map['class_desc'] = Variable<String, StringType>(d.classDesc.value);
    }
    if (d.subjectId.present) {
      map['subject_id'] = Variable<int, IntType>(d.subjectId.value);
    }
    if (d.subjectDesc.present) {
      map['subject_desc'] = Variable<String, StringType>(d.subjectDesc.value);
    }
    return map;
  }

  @override
  $AgendaEventsTable createAlias(String alias) {
    return $AgendaEventsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProfilesTable _profiles;
  $ProfilesTable get profiles => _profiles ??= $ProfilesTable(this);
  $LessonsTable _lessons;
  $LessonsTable get lessons => _lessons ??= $LessonsTable(this);
  $SubjectsTable _subjects;
  $SubjectsTable get subjects => _subjects ??= $SubjectsTable(this);
  $ProfessorsTable _professors;
  $ProfessorsTable get professors => _professors ??= $ProfessorsTable(this);
  $GradesTable _grades;
  $GradesTable get grades => _grades ??= $GradesTable(this);
  $AgendaEventsTable _agendaEvents;
  $AgendaEventsTable get agendaEvents =>
      _agendaEvents ??= $AgendaEventsTable(this);
  ProfileDao _profileDao;
  ProfileDao get profileDao => _profileDao ??= ProfileDao(this as AppDatabase);
  LessonDao _lessonDao;
  LessonDao get lessonDao => _lessonDao ??= LessonDao(this as AppDatabase);
  SubjectDao _subjectDao;
  SubjectDao get subjectDao => _subjectDao ??= SubjectDao(this as AppDatabase);
  ProfessorDao _professorDao;
  ProfessorDao get professorDao =>
      _professorDao ??= ProfessorDao(this as AppDatabase);
  GradeDao _gradeDao;
  GradeDao get gradeDao => _gradeDao ??= GradeDao(this as AppDatabase);
  AgendaDao _agendaDao;
  AgendaDao get agendaDao => _agendaDao ??= AgendaDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables =>
      [profiles, lessons, subjects, professors, grades, agendaEvents];
}
