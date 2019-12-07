// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String ident;
  final String firstName;
  final String lastName;
  final String token;
  final DateTime release;
  final DateTime expire;
  Profile(
      {@required this.id,
      @required this.ident,
      @required this.firstName,
      @required this.lastName,
      @required this.token,
      @required this.release,
      @required this.expire});
  factory Profile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Profile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
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
    );
  }
  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      ident: serializer.fromJson<String>(json['ident']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      token: serializer.fromJson<String>(json['token']),
      release: serializer.fromJson<DateTime>(json['release']),
      expire: serializer.fromJson<DateTime>(json['expire']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'ident': serializer.toJson<String>(ident),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'token': serializer.toJson<String>(token),
      'release': serializer.toJson<DateTime>(release),
      'expire': serializer.toJson<DateTime>(expire),
    };
  }

  @override
  ProfilesCompanion createCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
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
    );
  }

  Profile copyWith(
          {int id,
          String ident,
          String firstName,
          String lastName,
          String token,
          DateTime release,
          DateTime expire}) =>
      Profile(
        id: id ?? this.id,
        ident: ident ?? this.ident,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        token: token ?? this.token,
        release: release ?? this.release,
        expire: expire ?? this.expire,
      );
  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('ident: $ident, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('token: $token, ')
          ..write('release: $release, ')
          ..write('expire: $expire')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          ident.hashCode,
          $mrjc(
              firstName.hashCode,
              $mrjc(
                  lastName.hashCode,
                  $mrjc(token.hashCode,
                      $mrjc(release.hashCode, expire.hashCode)))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.ident == this.ident &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.token == this.token &&
          other.release == this.release &&
          other.expire == this.expire);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> ident;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> token;
  final Value<DateTime> release;
  final Value<DateTime> expire;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.ident = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.token = const Value.absent(),
    this.release = const Value.absent(),
    this.expire = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required String ident,
    @required String firstName,
    @required String lastName,
    @required String token,
    @required DateTime release,
    @required DateTime expire,
  })  : ident = Value(ident),
        firstName = Value(firstName),
        lastName = Value(lastName),
        token = Value(token),
        release = Value(release),
        expire = Value(expire);
  ProfilesCompanion copyWith(
      {Value<int> id,
      Value<String> ident,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> token,
      Value<DateTime> release,
      Value<DateTime> expire}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      ident: ident ?? this.ident,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      release: release ?? this.release,
      expire: expire ?? this.expire,
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

  @override
  List<GeneratedColumn> get $columns =>
      [id, ident, firstName, lastName, token, release, expire];
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
    return map;
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProfilesTable _profiles;
  $ProfilesTable get profiles => _profiles ??= $ProfilesTable(this);
  ProfileDao _profileDao;
  ProfileDao get profileDao => _profileDao ??= ProfileDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [profiles];
}
