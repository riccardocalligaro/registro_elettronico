# Docs

## Utils for the API

Group lessons

```dart
static Map<Tuple2<int, String>, int> getGroupedLessonsMap(
    List<Lesson> lessons,
  ) {
    final Map<Tuple2<int, String>, int> lessonsMap = Map.fromIterable(
      lessons,
      key: (e) => Tuple2<int, String>(
        e.subjectId,
        e.lessonArg,
      ),
      value: (e) => lessons
          .where(
            (entry) =>
                entry.lessonArg == e.lessonArg &&
                entry.subjectId == e.subjectId &&
                entry.author == e.author,
          )
          .length,
    );
    return lessonsMap;
  }
```

Convert api date to a datetime object

```dart
/// The spaggiari API returns the date in the following
/// format: [20191112], this function converts this [string] into a [date]
static DateTime getDateFromApiString(String date) {
  final parts = date.split('-');
  return DateTime.utc(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}
```

Get all lessons

```dart
/// This returns the [max interval] to fetch all the lessons / grades
/// For example if it is november 2019 it fetches => sep 2019 to aug 2020
static DateTimeInterval getDateInerval() {
  final now = DateTime.now();
  int yearBegin = now.year;
  int yearEnd = now.year;
  // if we are before sempember we need to fetch from the last year
  if (now.month > DateTime.september) {
    yearEnd += 1;
  } else {
    yearBegin -= 1;
  }
  final DateTime beginDate = DateTime.utc(yearBegin, DateTime.september, 1);
  final DateTime endDate = DateTime.utc(yearEnd, DateTime.august, 31);
  final begin = convertDate(beginDate);
  final end = convertDate(endDate);
  return DateTimeInterval(begin: begin, end: end);
}
```

Get the student id from the ident (without checking `/cards`)

```dart
/// Classeviva in the request requires and id, that you can
/// obtain by removing the letters and keeping onyl the numbers
///  S6102171X -> 6102171
static String getIdFromIdent(String ident) {
  return ident.replaceAll(RegExp('[A-Za-z]'), '');
}
```

All the constants

```dart
static const SOSTEGNO = "SOST";
static const SOSTEGNO_FULL = "SOSTEGNO";
static const ORALE = "Orale";
static const SCRITTO = "Scritto/Grafico";
static const PRATICO = "Pratico";
// Absences reasons
static const ASSENZA = "ABA0";
static const USCITA = "ABU0";
static const RITARDO = "ABR0";
static const RITARDO_BREVE = "ABR1";
// Justify reason
static const HEALTH_REASON = "A";
static const HEALTH_CERTIFICATE_REASON = "AC";
static const FAMILY_REASON = "B";
// Constants for login
static const USERNAME_PASSWORD_NOT_MATCHING = 1;
// Notes
static const CLASSEVIVA_NOTE = 'NTCL';
static const RECALL = 'NTWN';
static const TEACHER_NOTE = 'NTTE';
static const DISCIPLINARY_NOTE = 'NTST';
```

---

## Classeviva Api documentation and explanation

The process:

- make a `POST` login request to `/auth/login`
- you get a token that will last for 3-4 hours
- now in every request you include in the headers `Z-Auth-Token` with the value of your token
- when the token will expire you make another request to `/auth/login`

For checking the token and require a new one we used **interceptors** (with Dio).

To get the scrutini I created another client that logins via web and saves the PHPSESSID

Base URL: `https://web.spaggiari.eu/rest/`

## Login

`POST v1/auth/login`

Body:

```json
{ "ident": "null", "pass": "user_pass", "uid": "user_id" }
```

You can omit the ident and just use the `uid` and `pas`
**BUT** when a parent has 2 accounts this is the response

```json
{
  "requestedAction": "https://web.spaggiari.eu/rest/v1/auth/login",
  "choices": [
    {
      "cid": "VEIT0007",
      "ident": "********",
      "name": "Genitore di CALLIGARO RICCARDO",
      "school": "ISTITUTO TECNICO INDUSTRIALE STATALE \" C. ZUCCANTE \" VENEZIA - MESTRE"
    },
    {
      "cid": "******",
      "ident": "***********",
      "name": "Genitore di ******* *******",
      "school": "SCHOOL NAME"
    }
  ],
  "message": "you must provide a value for the \"ident\" field of payload"
}
```

This is how I solved the issue in dart using functional programming

```dart
// Abstract class
@POST("/auth/login")
Future<Either<LoginResponse, ParentsLoginResponse>> loginUser(@Body(LoginRequest loginRequest);

// The implementation
@override
loginUser(loginRequest) async {
  ArgumentError.checkNotNull(loginRequest, 'loginRequest');
  const _extra = <String, dynamic>{};
  final queryParameters = <String, dynamic>{};
  final _data = <String, dynamic>{};
  _data.addAll(loginRequest.toJson() ?? <String, dynamic>{});
  final Response<Map<String, dynamic>> _result = await _dio.request(
      '/auth/login',
      queryParameters: queryParameters,
      options: RequestOptions(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
          baseUrl: baseUrl),
      data: _data);
  if (_result.statusCode == 200 &&
      _result.data.containsKey('requestedAction')) {
    return Right(ParentsLoginResponse.fromJson(_result.data));
  }
  return Left(LoginResponse.fromJson(_result.data));
}
```

In the business logic I've done something like this:

```dart
yield* responseProfile.fold(
  (loginReponse) async* {
    // We save the password
    await flutterSecureStorage.write(
        key: event.username, value: event.password);
    // Save the profile in database
    _saveProfileInDb(loginReponse, event.password);
    // We emit success to the ui and proceed
    yield SignInSuccess(ProfileMapper()
        .mapLoginResponseProfileToProfileEntity(loginReponse));
  }
  (parentsLoginResponse) async* {
    final ParentsLoginResponse parentsLoginResponse =
        responseProfile.getOrElse(null);
    // This shows a dialog where the user can choose which profile
    yield SignInParent(parentsLoginResponse);
  }
);
```

In the Sign in parent we let the user choose wich one of the profiles to choose and we make another login request now with the ident of the profile the user has chosen

**Response**

```json
{
  "ident": "**********",
  "firstName": "RICCARDO",
  "lastName": "",
  "token": "🤫",
  "release": "2019-12-20T13:14:23+02:00",
  "expire": "2019-12-20T13:14:23+02:00"
}
```

---

## Status

`GET v1/auth/status`

## Description

This endpoint provides the timestamp of the relase and expire date of the token, the remaining time in seconds and the user ID.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "status": {
    "expire": "2019-12-20T13:14:23+02:00",
    "release": "2019-12-20T11:44:23+02:00",
    "ident": "**********",
    "remains": 5238
  }
}
```

---

## Absenences

`GET v1/students/{studentId}/absences`

## Description

This endpoint provides the absences of a student.

## Required Header

- Z-Auth-Token: _token_

```dart
// Type of event
ASSENZA = "ABA0";
USCITA = "ABU0";
RITARDO = "ABR0";
RITARDO_BREVE = "ABR1";
// Reason
HEALTH_REASON = "A";
HEALTH_CERTIFICATE_REASON = "AC";
FAMILY_REASON = "B";
```

**Response**

```json
{
  "events": [
    {
      "evtId": 203239,
      "evtCode": "ABA0",
      "evtDate": "2019-09-16",
      "evtHPos": null,
      "evtValue": null,
      "isJustified": true,
      "justifReasonCode": "A",
      "justifReasonDesc": "Motivi di salute"
    }
  ]
}
```

---

## Subjects

`GET v1/students/{studentId}/subjects`

## Description

This endpoint provides the subjects of a student.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "subjects": [
    {
      "id": 215867,
      "description": "INFORMATICA",
      "order": 8,
      "teachers": [
        {
          "teacherId": "*",
          "teacherName": "* ALESSANDRO"
        },
        {
          "teacherId": "*",
          "teacherName": "* GIANCARLO"
        }
      ]
    }
  ]
}
```

---

## Didactics

`GET v1/students/{studentId}/ditactics`

## Description

This endpoint provides the didactic material of a student.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "teacherId": "*",
  "teacherName": "* DONATELLA",
  "teacherFirstName": "DONATELLA",
  "teacherLastName": "*",
  "folders": [
    {
      "folderId": 15639335,
      "folderName": "POWER POINT ILLUMINISMO",
      "lastShareDT": "2019-11-26T09:59:56+01:00",
      "contents": [
        {
          "contentId": 15639338,
          "contentName": "",
          "objectId": 9027409,
          "objectType": "file",
          "shareDT": "2019-11-26T09:59:56+01:00"
        }
      ]
    }
  ]
}
```

---

## Cards

`GET v1/students/{studentId}/cards`

## Description

This endpoint provides information about the user.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "cards": [
    {
      "ident": "REDACTED",
      "usrType": "S",
      "usrId": 999999,
      "miurSchoolCode": "VETF04000T",
      "miurDivisionCode": "VETF04000T",
      "firstName": "RICCARDO",
      "lastName": "CALLIGARO",
      "birthDate": "🤫",
      "fiscalCode": "🤫",
      "schCode": "VEIT0007",
      "schName": "ISTITUTO TECNICO INDUSTRIALE STATALE",
      "schDedication": "\" C. ZUCCANTE \"",
      "schCity": "VENEZIA - MESTRE",
      "schProv": "VE"
    }
  ]
}
```

---

## Calendar

`GET v1/students/{studentId}/calendar/all`

## Description

This endpoint provides information about the calendar (1 year from july).

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "calendar": [
    {
      "dayDate": "2019-07-01",
      "dayOfWeek": 2,
      "dayStatus": "HD"
    },
    ... so on
    {
      "dayDate": "2020-07-31",
      "dayOfWeek": 3,
      "dayStatus": "HD"
    }
  ]
}
```

---

## Grades

`GET v1/students/{studentId}/grades`

## Description

This endpoint provides user's grades.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "grades": [
    {
      "subjectId": 215867,
      "subjectCode": "",
      "subjectDesc": "INFORMATICA",
      "evtId": 760893,
      "evtCode": "GRV0",
      "evtDate": "2019-10-30",
      "decimalValue": 9,
      "displayValue": "9",
      "displaPos": 1,
      "notesForFamily": "Esposizione di Bootstrap (front-end framework).",
      "color": "green",
      "canceled": false,
      "underlined": false,
      "periodPos": 1,
      "periodDesc": "Periodo (trimestre)",
      "componentPos": 2,
      "componentDesc": "Orale",
      "weightFactor": 1,
      "skillId": 0,
      "gradeMasterId": 0,
      "skillDesc": null,
      "skillCode": null,
      "skillMasterId": 0,
      "oldskillId": 0,
      "oldskillDesc": ""
    }
  ]
}
```

---

## Lessons

`GET v1/students/{studentId}/lessons/today`
`GET v1/students/{studentId}/lessons/begin/end`

## Description

This endpoint provides user's today lessons.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "lessons": [
    {
      "evtId": 6752184,
      "evtDate": "2019-12-04",
      "evtCode": "LSF0",
      "evtHPos": 1,
      "evtDuration": 1,
      "classDesc": "4IA INFORMATICA",
      "authorName": "* DANIELE",
      "subjectId": 215880,
      "subjectCode": "",
      "subjectDesc": "SISTEMI E RETI",
      "lessonType": "Lezione",
      "lessonArg": "Discussione sulle verifiche u.s. Conclusione Cisco CCNA1"
    }
  ]
}
```

---

## Notes

`GET v1/students/{studentId}/notes/all`

## Description

This endpoint provides user's notes.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "NTTE": [],
  "NTCL": [
    {
      "evtId": 8331568,
      "evtText": "prova per app \"Registro di classe\"",
      "evtDate": "2020-01-07",
      "authorName": "* ALESSANDRO",
      "readStatus": true
    }
  ],
  "NTWN": [],
  "NTST": []
}
```

To read the content

`POST v1/students/{studentId}/notes/{type}/read/{note}`

so for example for this note we do

```json
{
  "event": {
    "evtCode": "NTCL",
    "evtId": 8331568,
    "evtText": "prova per app \"Registro di classe\""
  }
}
```

---

## Periods

`GET v1/students/{studentId}/periods`

## Description

This endpoint provides user's periods.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "periods": [
    {
      "periodCode": "Q1",
      "periodPos": 1,
      "periodDesc": "Periodo (trimestre)",
      "isFinal": false,
      "dateStart": "2019-09-01",
      "dateEnd": "2019-12-21",
      "miurDivisionCode": null
    },
    {
      "periodCode": "Q3",
      "periodPos": 3,
      "periodDesc": "Periodo (pentamestre)",
      "isFinal": true,
      "dateStart": "2019-12-22",
      "dateEnd": "2020-06-06",
      "miurDivisionCode": null
    }
  ]
}
```

---

## Schoolbooks

`GET v1/students/{studentId}/schoolbooks`

## Description

This endpoint provides user's school books.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
    "schoolbooks": [
        {
            "courseId": 205,
            "courseDesc": "INFORMATICA",
            "books": [
                {
                    "bookId": 32380,
                    "isbnCode": "9780194706322",
                    "title": "GRAMMAR SPECTRUM GOLD: MISTO SPEC S/C",
                    "subheading": "BK S/C + MDB2.0 + ESPANSIONE ONLINE",
                    "volume": "U",
                    "author": "AA VV",
                    "publisher": "OXFORD UNIVERSITY PRESS",
                    "subjectDesc": "INGLESE GRAMMATICA",
                    "price": 29.1,
                    "toBuy": false,
                    "newAdoption": false,
                    "alreadyOwned": true,
                    "alreadyInUse": true,
                    "recommended": false,
                    "recommendedFor": null,
                    "coverUrl": null,
                    "publisherUnlockCode": ""
                }
    ]
}
```
