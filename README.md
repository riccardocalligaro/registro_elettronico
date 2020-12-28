<h1 align="center">
  <img src="https://i.imgur.com/BCktmzl.png" alt="Registto elettronico"><br>
  <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />

</h1>

<img src="https://i.imgur.com/j359Hse.jpg">

## Table of contents

- [Overview of the project](#overview-of-the-project)
- [Renders](#renders)
- [Group members](#developers)
- [Current state of the project](#current-state-of-the-project)
- [Project structure](#project-structure)
- [Descrizione in italiano](#descrizione-in-italiano)
- [Design](#design)

## Overview of the project

Flutter client for eletronic school register (Classeviva) management using clean architecture.

- Simple and beautiful
- Useful charts and stats about grades, absences, etc...
- Dark & Light theme (dark is just better)
- Notifications when there is a new event (new grade, new event, etc..)
- Data persistency
- Final grades
- Multi language support (Italian & English) and localizaiton

Main technologies and libraries that I will use:

- 🔝 Flutter + Dart
- 📡 Retrofit + Dio for API requests
- 💡 BLoC for state management
- 📚 Moor for data persistency
- 💉 Injector for dependency injection
- 🐠 Equatable for object comparison
- 🔗 Dartz for functional programming (only last features)
- ⚙️ Firebase + Crashlytics for analytics and tracking errors

Other libraries:

- [Fl_Chart](https://pub.dev/packages/fl_chart)
- [Table calendar](https://pub.dev/packages/table_calendar)
- [Work manager for notifications](https://pub.dev/packages/workmanager)

## Renders

<img src="https://i.imgur.com/34PxAn3.jpg" >

If you want to try the app (still alpha and a lot to do) feel free to contact [me.](mailto:riccardocalligaro@gmail.com)

## Developers:

| Name               |            Email            |                                       Role |
| ------------------ | :-------------------------: | -----------------------------------------: |
| Riccardo Calligaro | riccardocalligaro@gmail.com | Project manager, app architecture, API, UI |
| Filippo Veggo      |   filippoveggo@gmail.com    |                                Design & UI |

## Other group members

These group members haven't developed the app but are learning flutter.

| Name            |           Email            |
| --------------- | :------------------------: |
| Jacopo Ferian   |    jacopo893@gmail.com     |
| Samuele Zanella | samuelezanella02@gmail.com |

## Current state of the project

| Function           | State | Made by |  Design by   |
| ------------------ | :---: | :-----: | :----------: |
| Login              |  ✔️   |  R. C.  |    F. V.     |
| Home Page          |  ✔️   |  R. C.  | F. V + R. C. |
| Lessons            |  ✔️   |  R. C.  |    R. C.     |
| Agenda             |  ✔️   |  R. C.  | F. V.+ R. C. |
| Grades             |  ✔️   |  R. C.  | F. V.+ R. C. |
| Noticeboard        |  ✔️   |  R. C.  |    R. C.     |
| Absences           |  ✔️   |  R. C.  |    R. C.     |
| School material    |  ✔️   |  R. C.  | F. V.+ R. C. |
| Notes              |  ✔️   |  R. C.  |    R. C.     |
| Intitial slideshow |  ✔️   |  R. C.  |    R. C.     |
| Dark theme         |  ✔️   |  R. C.  |    R. C.     |
| Settings           |  ✔️   |  R. C.  |    R. C.     |

Additional features that will be implemented

| Function                | State | Made by | Design by |
| ----------------------- | :---: | :-----: | :-------: |
| Local grades and agenda |  ✔️   |  R. C.    |     -     |
| Timetable               |  ✔️   |  R. C.  |     -     |
| Notifications           |  ✔️   |  R. C.  |     -     |
| Summary page            |  ✔️   |  R. C.      |     -     |

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
- 🔗 Dartz per programmazione funzionale (solo ultime funzioni)
- ⚙️ Firebase + Crashlytics per analisi dati e fixare errori

Altre librerie:

- [Fl_Chart](https://pub.dev/packages/fl_chart)
- [Table calendar](https://pub.dev/packages/table_calendar)
- [Work manager for notifications](https://pub.dev/packages/workmanager)
- [FLogs for advanced logging](https://github.com/zubairehman/Flogs)

## Design

Filippo Veggo & Riccardo Calligaro

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
