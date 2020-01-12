<h1 align="center">
  <img src="https://i.imgur.com/BCktmzl.png" alt="Registto elettronico"><br>
</h1>

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/Zuccante-Web-App/Registro-elettronico?style=flat-square)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/Zuccante-Web-App/Registro-elettronico/master?style=flat-square)
[![HitCount](http://hits.dwyl.io/Zuccante-Web-App/Registro-elettronico.svg)](http://hits.dwyl.io/Zuccante-Web-App/Registro-elettronico)

<a href="https://www.mediafire.com/file/xrwlwz3dky9nf51/app-release.apk/file">Download Preview APK</a>

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />

## Table of contents

- [Overview of the project](#overview-of-the-project)
- [Screenshots](#screenshots)
- [Group members](#developers)
- [Current state of the project](#current-state-of-the-project)
- [Project structure](#project-structure)
- [Descrizione in italiano](#descrizione-in-italiano)
- [Design](#design)
- [API Documentation](#classeviva-api-documentation)

<<<<<<< HEAD
|                         Home Page 1                         |                         Home Page 2                          |                           Lessons                           |
|:-----------------------------------------------------------:|:------------------------------------------------------------:|:-----------------------------------------------------------:|
| <img src="https://i.imgur.com/bVkuG8Y.png" height="400px" > | <img src="https://i.imgur.com/B24gPrs.png"  height="400px" > | <img src="https://i.imgur.com/VzlGctu.png" height="400px" > |

|                       Lessons details                       |                         Last grades                         |                           Grades                            |
|:-----------------------------------------------------------:|:-----------------------------------------------------------:|:-----------------------------------------------------------:|
| <img src="https://i.imgur.com/Q4lZGyF.png" height="400px" > | <img src="https://i.imgur.com/Ne1KmZr.png" height="400px" > | <img src="https://i.imgur.com/kYjm6JG.png" height="400px" > |

|                           Agenda                            |                          Absences                           |                         Noticeboard                         |
|:-----------------------------------------------------------:|:-----------------------------------------------------------:|:-----------------------------------------------------------:|
| <img src="https://i.imgur.com/SWp4dJ5.png" height="400px" > | <img src="https://i.imgur.com/JkVKOXK.png" height="400px" > | <img src="https://i.imgur.com/61uQrX9.png" height="400px" > |

[![Preview](https://i.ibb.co/pbnPKdF/https-i-ytimg-com-vi-LVk-FTSKe-Rl-M-maxresdefault.jpg)](https://youtu.be/LVkFTSKeRlM "Preview")

If you want to try the app (still alpha and a lot to do) feel free to contact [me.](mailto:riccardocalligaro@gmail.com)

=======
>>>>>>> 8ee7c24cf105f2478d7f853e9d2628e614221039
## Overview of the project

Flutter client for eletronic school register (Classeviva) management using clean architecture.

- Simple and beautiful
- Useful charts and stats about grades, absences, etc...
- Dark & Light theme (dark is just better)
- Notifications when there is a new event (new grade, new event, etc..)
- Data persistency
- Multi language support (Italian & English) and localizaiton

Main technologies and libraries that I will use:

- 🔝 Flutter + Dart
- 📡 Retrofit + Dio for API requests
- 💡 BLoC for state management
- 📚 Moor for data persistency
- 💉 Injector for dependency injection
- 🐠 Equatable for object comparison

Other libraries:

- [Fl_Chart](https://pub.dev/packages/fl_chart)
- [Table calendar](https://pub.dev/packages/table_calendar)
- [Work manager for notifications](https://pub.dev/packages/workmanager)

## Screenshots

|                         Home Page 1                         |                         Home Page 2                          |                           Lessons                           |
| :---------------------------------------------------------: | :----------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/m2B8hol.png" height="400px" > | <img src="https://i.imgur.com/B24gPrs.png"  height="400px" > | <img src="https://i.imgur.com/EsPUVLn.png" height="400px" > |

|                       Lessons details                       |                         Last grades                         |                           Grades                            |
| :---------------------------------------------------------: | :---------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/Q4lZGyF.png" height="400px" > | <img src="https://i.imgur.com/Ne1KmZr.png" height="400px" > | <img src="https://i.imgur.com/fMW3LBf.png" height="400px" > |

|                           Agenda                            |                          Absences                           |                         Noticeboard                         |
| :---------------------------------------------------------: | :---------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/SWp4dJ5.png" height="400px" > | <img src="https://i.imgur.com/JkVKOXK.png" height="400px" > | <img src="https://i.imgur.com/61uQrX9.png" height="400px" > |

|                       Grades Details                        |                        Local Grades                         |                       School material                       |
| :---------------------------------------------------------: | :---------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/pUq2xJv.png" height="400px" > | <img src="https://i.imgur.com/wlRkic7.png" height="400px" > | <img src="https://i.imgur.com/OwQImuW.png" height="400px" > |

|                          Timetable                          |                          Settings                           |                            Menu                             |
| :---------------------------------------------------------: | :---------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/s1zhTEi.png" height="400px" > | <img src="https://i.imgur.com/ioz6Rxu.png" height="400px" > | <img src="https://i.imgur.com/pR1uaIB.png" height="400px" > |

[![Preview](https://i.ibb.co/pbnPKdF/https-i-ytimg-com-vi-LVk-FTSKe-Rl-M-maxresdefault.jpg)](https://youtu.be/LVkFTSKeRlM "Preview")

If you want to try the app (still alpha and a lot to do) feel free to contact [me.](mailto:riccardocalligaro@gmail.com)

## Developers:

| Name               |            Email            |                                       Role |
|--------------------|:---------------------------:|-------------------------------------------:|
| Riccardo Calligaro | riccardocalligaro@gmail.com | Project manager, app architecture, API, UI |
| Filippo Veggo      |   filippoveggo@gmail.com    |                                Design & UI |

## Other group members

These group members haven't developed the app but are learning flutter.

| Name            |           Email            |
|-----------------|:--------------------------:|
| Jacopo Ferian   |    jacopo893@gmail.com     |
| Samuele Zanella | samuelezanella02@gmail.com |

## Current state of the project

<<<<<<< HEAD
| Function           | State | Made by |  Design by  |
|--------------------|:-----:|:-------:|:-----------:|
| Login              |   ✔️   |  R.C.   |    F.V.     |
| Home Page          |   ✔️   |  R.C.   | F.V + R.C.  |
| Lessons            |   ✔️   |  R.C.   |    R.C.     |
| Agenda             |   ✔️   |  R.C.   | F.V. + R.C. |
| Marks              |   ✔️   |  R.C.   |    R.C.     |
| Noticeboard        |   ✔️   |  R.C.   |    R.C.     |
| Absences           |   ✔️   |  R.C.   |    R.C.     |
| School material    |   ✔️   |  R.C.   |    R.C.     |
| Notes              |   ✔️   |  R.C.   |    R.C.     |
| Intitial slideshow |   ✔️   |  R.C.   |      -      |
| Dark theme         |   ✔️   |  R.C.   |      -      |
| Settings           |   ¼   |  R.C.   |    R.C.     |
=======
| Function           | State | Made by |  Design by   |
| ------------------ | :---: | :-----: | :----------: |
| Login              |  ✔️   |  R. C.  |    F. V.     |
| Home Page          |  ✔️   |  R. C.  | F. V + R. C. |
| Lessons            |  ✔️   |  R. C.  |    R. C.     |
| Agenda             |  ✔️   |  R. C.  | F. V.+ R. C. |
| Grades             |  ✔️   |  R. C.  |    R. C.     |
| Noticeboard        |  ✔️   |  R. C.  |    R. C.     |
| Absences           |  ✔️   |  R. C.  |    R. C.     |
| School material    |  ✔️   |  R. C.  |    R. C.     |
| Notes              |  ✔️   |  R. C.  |    R. C.     |
| Intitial slideshow |  ✔️   |  R. C.  |    R. C.     |
| Dark theme         |  ✔️   |  R. C.  |    R. C.     |
| Settings           |  ✔️   |  R. C.  |    R. C.     |
>>>>>>> 8ee7c24cf105f2478d7f853e9d2628e614221039

Additional features that will be implemented

| Function                | State | Made by | Design by |
<<<<<<< HEAD
|-------------------------|:-----:|:-------:|:---------:|
| Local grades and agenda |   ½   |    -    |     -     |
| Timetable               |   ✔️   |    -    |     -     |
| Notifications           |   ✔️   |    -    |     -     |
| Summary page            |   ❌   |    -    |     -     |
=======
| ----------------------- | :---: | :-----: | :-------: |
| Local grades and agenda |   ½   |    -    |     -     |
| Timetable               |  ✔️   |  R. C.  |     -     |
| Notifications           |   ½   |  R. C.  |     -     |
| Summary page            |  ❌   |    -    |     -     |
>>>>>>> 8ee7c24cf105f2478d7f853e9d2628e614221039

## Project structure

- Clean architecture structure

<img src="https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?resize=556%2C707&ssl=1">

## Descrizione in italiano

- Semplice e funzionale
- Grafici utili sulle assenze, voti, etc...
- Dark & Light theme (dark è meglio)
- Notifiche quando ci sono nuovi eventi (nuovo voto, nuovo evento..)
- Persistenza dati
- Supporto multilingue (Italiano e inglese) e localizzazione

Tecnologie principali e librerie usate:

- 🔝 Flutter + Dart
- 📡 Retrofit + Dio per le richieste alle API
- 💡 BLoC per la gestione dello stato
- 📚 Moor per persistenza dati
- 💉 Injector per dependency injection
- 🐠 Equatable per comparazione oggetti

Altre librerie:

- [Fl_Chart](https://pub.dev/packages/fl_chart)
- [Table calendar](https://pub.dev/packages/table_calendar)
- [Work manager for notifications](https://pub.dev/packages/workmanager)

## Design

### Filippo Veggo & Riccardo Calligaro

<div align="center">
<div style="display: inline-flex; ">
<img src="https://i.imgur.com/kA3nnBG.png" height="400px" alt="the home page" style="float: left; margin-right: 10px;"/>
<img src="https://i.imgur.com/TW6aTcM.png" height="400px" alt="the home page" style="float: left; margin-right: 10px;"/>
<img src="https://i.imgur.com/rqPtEbl.png"height="400px" alt="the home page" style="float: left; margin-right: 10px; margin-bottom: 10px;"/>
</div>
<div style="display: inline-flex;">
<img src="https://i.imgur.com/nP5XXON.png"  height="400px" style="float: left; margin-right: 10px; margin-bottom: 10px;" />
<img src="https://i.imgur.com/5ZVDoBi.png"
height="400px" alt="the home page" height="400px"  style="float: left; margin-right: 10px;" />
<img src="https://i.imgur.com/nDsK6vw.png"
height="400px" alt="the home page" height="400px" style="margin-right: 10px;" />
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
This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.