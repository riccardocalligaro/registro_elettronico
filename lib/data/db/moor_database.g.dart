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
  final String name;
  Professor({@required this.id, @required this.name});
  factory Professor.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Professor(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Professor.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Professor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  ProfessorsCompanion createCompanion(bool nullToAbsent) {
    return ProfessorsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Professor copyWith({String id, String name}) => Professor(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Professor(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Professor && other.id == this.id && other.name == this.name);
}

class ProfessorsCompanion extends UpdateCompanion<Professor> {
  final Value<String> id;
  final Value<String> name;
  const ProfessorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ProfessorsCompanion.insert({
    @required String id,
    @required String name,
  })  : id = Value(id),
        name = Value(name);
  ProfessorsCompanion copyWith({Value<String> id, Value<String> name}) {
    return ProfessorsCompanion(
      id: id ?? this.id,
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
  List<GeneratedColumn> get $columns => [id, name];
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
  ProfileDao _profileDao;
  ProfileDao get profileDao => _profileDao ??= ProfileDao(this as AppDatabase);
  LessonDao _lessonDao;
  LessonDao get lessonDao => _lessonDao ??= LessonDao(this as AppDatabase);
  SubjectDao _subjectDao;
  SubjectDao get subjectDao => _subjectDao ??= SubjectDao(this as AppDatabase);
  ProfessorDao _professorDao;
  ProfessorDao get professorDao =>
      _professorDao ??= ProfessorDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [profiles, lessons, subjects, professors];
}
