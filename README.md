<h1 align="center">
    <img src="https://i.imgur.com/BCktmzl.png" alt="Registto elettronico"><br>
</h1>

## Table of contents

- [Overview of the project](#overview-of-the-project)
- [Group members](#developers)
- [Current state of the project](#current-state-of-the-project)
- [Descrizione in italiano](#descrizione-in-italiano)
- [Design](#design)
- [API Documentation](#classeviva-api-documentation)

|                         Home Page 1                         |                         Home Page 2                          |                                                     Lessons |
| :---------------------------------------------------------: | :----------------------------------------------------------: | ----------------------------------------------------------: |
| <img src="https://i.imgur.com/7ZeM7zp.png" height="400px" > | <img src="https://i.imgur.com/7ZeM7zp.png"  height="400px" > | <img src="https://i.imgur.com/uufV7zm.png" height="400px" > |

If you want to try the app (still alpha and a lot to do) feel free to contact [me.](mailto:riccardocalligaro@gmail.com)

## Overview of the project

Flutter client for eletronic school register management using clean architecture(Classeviva).

Technologies and libraries that we will use:

- 🔝 Flutter + Dart
- 📡 Retrofit + Dio for API requests
- 🧱 BLoC for state management
- 📚 Moor for data persistency
- 💉 Injector for dependency injection
- 🐠 Equatable for object comparison
- 🔥 Flare for animations

## Developers:

| Name               |            Email            |                                       Role |
| ------------------ | :-------------------------: | -----------------------------------------: |
| Riccardo Calligaro | riccardocalligaro@gmail.com | Project manager, app architecture, API, UI |
| Jacopo Ferian      |     jacopo893@gmail.com     |                           Learning flutter |
| Filippo Veggo      |   filippoveggo@gmail.com    |                                Design & UI |
| Samuele Zanella    | samuelezanella02@gmail.com  |              Learning flutter + animations |

## Current state of the project

| Function           | State |
| ------------------ | :---: |
| Login              |  ✔️   |
| Home Page          |  ✔️   |
| Lessons            |  ✔️   |
| Marks              |  ❌   |
| Noticeboard        |  ❌   |
| Absences           |  ❌   |
| Intitial slideshow |  ❌   |
| Dark theme         |  ✔️   |
| Settings           |  ❌   |

## Descrizione in italiano

Client Flutter per la gestione dei dati del registro elettronico (ClasseViva).

Tecnologie e librerie che useremo:

- 🔝 Flutter + Dart
- 📡 Retrofit + Dio per richieste alle API
- 🧱 BLoC per la gestione dello stato
- 📚 Moor per persistenza dati
- 💉 Injector per dependency injection
- 🐠 Equatable per comparazione oggetto
- 🔥 Flare per animazioni

## Design

### Filippo Veggo & Riccardo Calligaro

<div align="center">

<div style="display: inline-flex;">
<img src="https://i.imgur.com/kA3nnBG.png"
     height="400px"
     alt="the home page"
     style="float: left; margin-right: 10px;" />

<img src="https://i.imgur.com/TW6aTcM.png"
     height="400px"
     alt="the home page"
     style="float: left; margin-right: 10px;" />

<img src="https://i.imgur.com/rqPtEbl.png"
    height="400px"
     alt="the home page"
     style="float: left; margin-right: 10px; margin-bottom: 10px;" /> </div>

<div style="display: inline-flex;">

<img src="https://i.imgur.com/nP5XXON.png"
    height="400px"
     alt="the home page"
     style="float: left; margin-right: 10px;" />

<img src="https://i.imgur.com/5ZVDoBi.png"
    height="400px"
     alt="the home page"
     style="float: left; margin-right: 10px;" />

<img src="https://i.imgur.com/nDsK6vw.png"
    height="400px"
     alt="the home page"
     style="margin-right: 10px;" />

</div>

</div>

---

## Classeviva Api documentation

## Login

`POST **v1/auth/login`

Body:

```json
{ "ident": "null", "pass": "user_pass", "uid": "user_id" }
```

**Response**

```json
{
  "ident": "**********",
  "firstName": "RICCARDO",
  "lastName": "CALLIGARO",
  "token": "🤫",
  "release": "2017-09-28T20:29:25+02:00",
  "expire": "2017-09-28T21:59:25+02:00"
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
    "expire": "2017-10-20T13:14:23+02:00",
    "release": "2017-10-20T11:44:23+02:00",
    "ident": "**********",
    "remains": 5238
  }
}
```

---

## Absenences

`GET v1/students/{studentId}/noticeboard`

## Description

This endpoint provides the absences of a student.

## Required Header

- Z-Auth-Token: _token_

**Response**

```json
{
  "pubId": 4359232,
  "pubDT": "2019-12-02T10:41:30+01:00",
  "readStatus": true,
  "evtCode": "CF",
  "cntId": 2359323,
  "cntValidFrom": "2019-12-02",
  "cntValidTo": "2020-08-31",
  "cntValidInRange": true,
  "cntStatus": "active",
  "cntTitle": "CIRC - 161  MOVE ALL'ESTERO - SCORRIMENTO GRADUATORIA STUDENTI",
  "cntCategory": "Circolare",
  "cntHasChanged": false,
  "cntHasAttach": true,
  "needJoin": false,
  "needReply": false,
  "needFile": false,
  "evento_id": "2359323",
  "attachments": [
    {
      "fileName": "Circolare N. 161 studenti selezionati Move all'estero PCTO - SCORRIMENTO GRADUATORIA.pdf",
      "attachNum": 1
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
          "teacherId": "A3175375",
          "teacherName": "CAZZIOLATO ALESSANDRO"
        },
        {
          "teacherId": "A3270031",
          "teacherName": "RONCHI GIANCARLO"
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
  "teacherId": "A3175419",
  "teacherName": "PANCIERA DONATELLA",
  "teacherFirstName": "DONATELLA",
  "teacherLastName": "PANCIERA",
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
      "usrId": 6102171,
      "miurSchoolCode": "VETF04000T",
      "miurDivisionCode": "VETF04000T",
      "firstName": "RICCARDO",
      "lastName": "CALLIGARO",
      "birthDate": "2002-05-11",
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
      "authorName": "CAPPELLAZZO DANIELE",
      "subjectId": 215880,
      "subjectCode": "",
      "subjectDesc": "SISTEMI E RETI",
      "lessonType": "Lezione",
      "lessonArg": "Discussione sulle verifiche u.s. Conclusione Cisco CCNA1 mod. 2: configurazione dispositivo di rete Cisco con IOS"
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
  "NTCL": [],
  "NTWN": [],
  "NTST": []
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
