// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String userName;
  final String name;
  final String classe;
  final String token;
  final DateTime expire;
  final String ident;
  Profile(
      {@required this.id,
      @required this.userName,
      @required this.name,
      @required this.classe,
      @required this.token,
      @required this.expire,
      @required this.ident});
  factory Profile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Profile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}user_name']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      classe:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}classe']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
      expire: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}expire']),
      ident:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}ident']),
    );
  }
  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      name: serializer.fromJson<String>(json['name']),
      classe: serializer.fromJson<String>(json['classe']),
      token: serializer.fromJson<String>(json['token']),
      expire: serializer.fromJson<DateTime>(json['expire']),
      ident: serializer.fromJson<String>(json['ident']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'name': serializer.toJson<String>(name),
      'classe': serializer.toJson<String>(classe),
      'token': serializer.toJson<String>(token),
      'expire': serializer.toJson<DateTime>(expire),
      'ident': serializer.toJson<String>(ident),
    };
  }

  @override
  ProfilesCompanion createCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      classe:
          classe == null && nullToAbsent ? const Value.absent() : Value(classe),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      expire:
          expire == null && nullToAbsent ? const Value.absent() : Value(expire),
      ident:
          ident == null && nullToAbsent ? const Value.absent() : Value(ident),
    );
  }

  Profile copyWith(
          {int id,
          String userName,
          String name,
          String classe,
          String token,
          DateTime expire,
          String ident}) =>
      Profile(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        name: name ?? this.name,
        classe: classe ?? this.classe,
        token: token ?? this.token,
        expire: expire ?? this.expire,
        ident: ident ?? this.ident,
      );
  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('name: $name, ')
          ..write('classe: $classe, ')
          ..write('token: $token, ')
          ..write('expire: $expire, ')
          ..write('ident: $ident')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userName.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  classe.hashCode,
                  $mrjc(token.hashCode,
                      $mrjc(expire.hashCode, ident.hashCode)))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.name == this.name &&
          other.classe == this.classe &&
          other.token == this.token &&
          other.expire == this.expire &&
          other.ident == this.ident);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> name;
  final Value<String> classe;
  final Value<String> token;
  final Value<DateTime> expire;
  final Value<String> ident;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.name = const Value.absent(),
    this.classe = const Value.absent(),
    this.token = const Value.absent(),
    this.expire = const Value.absent(),
    this.ident = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required String userName,
    @required String name,
    @required String classe,
    @required String token,
    @required DateTime expire,
    @required String ident,
  })  : userName = Value(userName),
        name = Value(name),
        classe = Value(classe),
        token = Value(token),
        expire = Value(expire),
        ident = Value(ident);
  ProfilesCompanion copyWith(
      {Value<int> id,
      Value<String> userName,
      Value<String> name,
      Value<String> classe,
      Value<String> token,
      Value<DateTime> expire,
      Value<String> ident}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      classe: classe ?? this.classe,
      token: token ?? this.token,
      expire: expire ?? this.expire,
      ident: ident ?? this.ident,
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

  final VerificationMeta _userNameMeta = const VerificationMeta('userName');
  GeneratedTextColumn _userName;
  @override
  GeneratedTextColumn get userName => _userName ??= _constructUserName();
  GeneratedTextColumn _constructUserName() {
    return GeneratedTextColumn('user_name', $tableName, false,
        $customConstraints: 'UNIQUE');
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

  @override
  List<GeneratedColumn> get $columns =>
      [id, userName, name, classe, token, expire, ident];
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
    if (d.userName.present) {
      context.handle(_userNameMeta,
          userName.isAcceptableValue(d.userName.value, _userNameMeta));
    } else if (userName.isRequired && isInserting) {
      context.missing(_userNameMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.classe.present) {
      context.handle(
          _classeMeta, classe.isAcceptableValue(d.classe.value, _classeMeta));
    } else if (classe.isRequired && isInserting) {
      context.missing(_classeMeta);
    }
    if (d.token.present) {
      context.handle(
          _tokenMeta, token.isAcceptableValue(d.token.value, _tokenMeta));
    } else if (token.isRequired && isInserting) {
      context.missing(_tokenMeta);
    }
    if (d.expire.present) {
      context.handle(
          _expireMeta, expire.isAcceptableValue(d.expire.value, _expireMeta));
    } else if (expire.isRequired && isInserting) {
      context.missing(_expireMeta);
    }
    if (d.ident.present) {
      context.handle(
          _identMeta, ident.isAcceptableValue(d.ident.value, _identMeta));
    } else if (ident.isRequired && isInserting) {
      context.missing(_identMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, userName};
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
    if (d.userName.present) {
      map['user_name'] = Variable<String, StringType>(d.userName.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.classe.present) {
      map['classe'] = Variable<String, StringType>(d.classe.value);
    }
    if (d.token.present) {
      map['token'] = Variable<String, StringType>(d.token.value);
    }
    if (d.expire.present) {
      map['expire'] = Variable<DateTime, DateTimeType>(d.expire.value);
    }
    if (d.ident.present) {
      map['ident'] = Variable<String, StringType>(d.ident.value);
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
