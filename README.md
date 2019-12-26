<h1 align="center">
    <img src="https://i.imgur.com/BCktmzl.png" alt="Registto elettronico"><br>
</h1>

## Table of contents

- [Overview of the project](#overview-of-the-project)
- [Group members](#developers)
- [Current state of the project](#current-state-of-the-project)
- [Project structure](#project-structure)
- [Descrizione in italiano](#descrizione-in-italiano)
- [Design](#design)
- [API Documentation](#classeviva-api-documentation)

|                         Home Page 1                         |                         Home Page 2                          |                           Lessons                           |
| :---------------------------------------------------------: | :----------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/bVkuG8Y.png" height="400px" > | <img src="https://i.imgur.com/B24gPrs.png"  height="400px" > | <img src="https://i.imgur.com/VzlGctu.png" height="400px" > |

|                       Lessons details                       |                         Last grades                         |                           Grades                            |
| :---------------------------------------------------------: | :---------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/Q4lZGyF.png" height="400px" > | <img src="https://i.imgur.com/Ne1KmZr.png" height="400px" > | <img src="https://i.imgur.com/kYjm6JG.png" height="400px" > |

|                           Agenda                            |                          Absences                           |                         Noticeboard                         |
| :---------------------------------------------------------: | :---------------------------------------------------------: | :---------------------------------------------------------: |
| <img src="https://i.imgur.com/SWp4dJ5.png" height="400px" > | <img src="https://i.imgur.com/JkVKOXK.png" height="400px" > | <img src="https://i.imgur.com/61uQrX9.png" height="400px" > |

If you want to try the app (still alpha and a lot to do) feel free to contact [me.](mailto:riccardocalligaro@gmail.com)

## Overview of the project

Flutter client for eletronic school register (Classeviva) management using clean architecture.

- Simple and beautiful
- Useful charts and stats about grades, absences, etc...
- Dark & Light theme (dark is just better)
- Notifications when there is a new event (new grade, new event, etc..)
- Data persistency
- 🌍 Multi language support (Italian & English) and localizaiton

Main technologies and libraries that I will use:

- 🔝 Flutter + Dart
- 📡 Retrofit + Dio for API requests
- 🧱 BLoC for state management
- 📚 Moor for data persistency
- 💉 Injector for dependency injection
- 🐠 Equatable for object comparison

Other libraries:

- [Fl_Chart](https://pub.dev/packages/fl_chart)
- [Table calendar](https://pub.dev/packages/table_calendar)
- [Work manager for notifications](https://pub.dev/packages/workmanager)

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

| Function           | State | Made by |  Design by  |
| ------------------ | :---: | :-----: | :---------: |
| Login              |  ✔️   |  R.C.   |    F.V.     |
| Home Page          |  ✔️   |  R.C.   | F.V + R.C.  |
| Lessons            |  ✔️   |  R.C.   |    R.C.     |
| Agenda             |  ✔️   |  R.C.   | F.V. + R.C. |
| Marks              |  ✔️   |  R.C.   |    R.C.     |
| Noticeboard        |  ✔️   |  R.C.   |    R.C.     |
| Absences           |  ✔️   |  R.C.   |    R.C.     |
| School material    |  ✔️   |  R.C.   |    R.C.     |
| Notes              |  ✔️   |  R.C.   |    R.C.     |
| Intitial slideshow |  ❌   |  R.C.   |      -      |
| Dark theme         |  ✔️   |  R.C.   |      -      |
| Settings           |   ¼   |  R.C.   |    R.C.     |

Additional features that will be implemented

| Function                | State | Made by | Design by |
| ----------------------- | :---: | :-----: | :-------: |
| Local grades and agenda |  ❌   |    -    |     -     |
| Timetable               |   ¼   |    -    |     -     |
| Notifications           |   ½   |    -    |     -     |
| Summary page            |  ❌   |    -    |     -     |

## Project structure

```
📦lib
 ┣ 📂component
 ┃ ┣ 📂notifications
 ┃ ┃ ┣ 📜local_notification.dart
 ┃ ┃ ┣ 📜local_notification_widget.dart
 ┃ ┃ ┗ 📜notification_service.dart
 ┃ ┣ 📜api_config.dart
 ┃ ┣ 📜app_injection.dart
 ┃ ┣ 📜bloc_delegate.dart
 ┃ ┣ 📜navigator.dart
 ┃ ┣ 📜routes.dart
 ┃ ┗ 📜simple_bloc_delegate.dart
 ┣ 📂data
 ┃ ┣ 📂db
 ┃ ┃ ┣ 📂dao
 ┃ ┃ ┃ ┣ 📜absence_dao.dart
 ┃ ┃ ┃ ┣ 📜absence_dao.g.dart
 ┃ ┃ ┃ ┣ 📜agenda_dao.dart
 ┃ ┃ ┃ ┣ 📜agenda_dao.g.dart
 ┃ ┃ ┃ ┣ 📜grade_dao.dart
 ┃ ┃ ┃ ┣ 📜grade_dao.g.dart
 ┃ ┃ ┃ ┣ 📜lesson_dao.dart
 ┃ ┃ ┃ ┣ 📜lesson_dao.g.dart
 ┃ ┃ ┃ ┣ 📜notice_dao.dart
 ┃ ┃ ┃ ┣ 📜notice_dao.g.dart
 ┃ ┃ ┃ ┣ 📜period_dao.dart
 ┃ ┃ ┃ ┣ 📜period_dao.g.dart
 ┃ ┃ ┃ ┣ 📜professor_dao.dart
 ┃ ┃ ┃ ┣ 📜professor_dao.g.dart
 ┃ ┃ ┃ ┣ 📜profile_dao.dart
 ┃ ┃ ┃ ┣ 📜profile_dao.g.dart
 ┃ ┃ ┃ ┣ 📜subject_dao.dart
 ┃ ┃ ┃ ┗ 📜subject_dao.g.dart
 ┃ ┃ ┣ 📂table
 ┃ ┃ ┃ ┣ 📜absence_table.dart
 ┃ ┃ ┃ ┣ 📜agenda_event_table.dart
 ┃ ┃ ┃ ┣ 📜attachment_table.dart
 ┃ ┃ ┃ ┣ 📜grade_table.dart
 ┃ ┃ ┃ ┣ 📜lesson_table.dart
 ┃ ┃ ┃ ┣ 📜notice_table.dart
 ┃ ┃ ┃ ┣ 📜period_table.dart
 ┃ ┃ ┃ ┣ 📜professor_table.dart
 ┃ ┃ ┃ ┣ 📜profile_table.dart
 ┃ ┃ ┃ ┗ 📜subject_table.dart
 ┃ ┃ ┣ 📜moor_database.dart
 ┃ ┃ ┗ 📜moor_database.g.dart
 ┃ ┣ 📂network
 ┃ ┃ ┣ 📂exception
 ┃ ┃ ┃ ┗ 📜server_exception.dart
 ┃ ┃ ┗ 📂service
 ┃ ┃ ┃ ┗ 📂api
 ┃ ┃ ┃ ┃ ┣ 📜dio_client.dart
 ┃ ┃ ┃ ┃ ┣ 📜spaggiari_client.dart
 ┃ ┃ ┃ ┃ ┗ 📜spaggiari_client.g.dart
 ┃ ┗ 📂repository
 ┃ ┃ ┣ 📂mapper
 ┃ ┃ ┃ ┣ 📜absence_mapper.dart
 ┃ ┃ ┃ ┣ 📜event_mapper.dart
 ┃ ┃ ┃ ┣ 📜grade_mapper.dart
 ┃ ┃ ┃ ┣ 📜lesson_mapper.dart
 ┃ ┃ ┃ ┣ 📜mappers_export.dart
 ┃ ┃ ┃ ┣ 📜notice_mapper.dart
 ┃ ┃ ┃ ┣ 📜period_mapper.dart
 ┃ ┃ ┃ ┣ 📜profile_mapper.dart
 ┃ ┃ ┃ ┗ 📜subject_mapper.dart
 ┃ ┃ ┣ 📜absences_repository_impl.dart
 ┃ ┃ ┣ 📜agenda_repository_impl.dart
 ┃ ┃ ┣ 📜grades_repository_impl.dart
 ┃ ┃ ┣ 📜lessons_repository_impl.dart
 ┃ ┃ ┣ 📜login_repository_impl.dart
 ┃ ┃ ┣ 📜notices_repository_impl.dart
 ┃ ┃ ┣ 📜periods_repository_impl.dart
 ┃ ┃ ┣ 📜professors_repository_impl.dart
 ┃ ┃ ┣ 📜profile_repository_impl.dart
 ┃ ┃ ┣ 📜repository_impl_export.dart
 ┃ ┃ ┗ 📜subjects_respository_impl.dart
 ┣ 📂domain
 ┃ ┣ 📂entity
 ┃ ┃ ┣ 📂api_requests
 ┃ ┃ ┃ ┗ 📜login_request.dart
 ┃ ┃ ┣ 📂api_responses
 ┃ ┃ ┃ ┣ 📜absences_response.dart
 ┃ ┃ ┃ ┣ 📜agenda_response.dart
 ┃ ┃ ┃ ┣ 📜grades_response.dart
 ┃ ┃ ┃ ┣ 📜lessons_response.dart
 ┃ ┃ ┃ ┣ 📜login_response.dart
 ┃ ┃ ┃ ┣ 📜noticeboard_read_response.dart
 ┃ ┃ ┃ ┣ 📜noticeboard_response.dart
 ┃ ┃ ┃ ┣ 📜periods_response.dart
 ┃ ┃ ┃ ┗ 📜subjects_response.dart
 ┃ ┃ ┣ 📜entities.dart
 ┃ ┃ ┣ 📜profile.dart
 ┃ ┃ ┗ 📜profile.g.dart
 ┃ ┗ 📂repository
 ┃ ┃ ┣ 📜absences_repository.dart
 ┃ ┃ ┣ 📜agenda_repository.dart
 ┃ ┃ ┣ 📜grades_repository.dart
 ┃ ┃ ┣ 📜lessons_repository.dart
 ┃ ┃ ┣ 📜login_repository.dart
 ┃ ┃ ┣ 📜notices_repository.dart
 ┃ ┃ ┣ 📜periods_repository.dart
 ┃ ┃ ┣ 📜professors_repository.dart
 ┃ ┃ ┣ 📜profile_repository.dart
 ┃ ┃ ┣ 📜repositories_export.dart
 ┃ ┃ ┗ 📜subjects_repository.dart
 ┣ 📂ui
 ┃ ┣ 📂bloc
 ┃ ┃ ┣ 📂absences
 ┃ ┃ ┃ ┣ 📜absences_bloc.dart
 ┃ ┃ ┃ ┣ 📜absences_event.dart
 ┃ ┃ ┃ ┣ 📜absences_state.dart
 ┃ ┃ ┃ ┗ 📜bloc.dart
 ┃ ┃ ┣ 📂agenda
 ┃ ┃ ┃ ┣ 📜agenda_bloc.dart
 ┃ ┃ ┃ ┣ 📜agenda_event.dart
 ┃ ┃ ┃ ┣ 📜agenda_state.dart
 ┃ ┃ ┃ ┗ 📜bloc.dart
 ┃ ┃ ┣ 📂auth
 ┃ ┃ ┃ ┣ 📜auth_bloc.dart
 ┃ ┃ ┃ ┣ 📜auth_event.dart
 ┃ ┃ ┃ ┣ 📜auth_state.dart
 ┃ ┃ ┃ ┗ 📜bloc.dart
 ┃ ┃ ┣ 📂grades
 ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📜grades_bloc.dart
 ┃ ┃ ┃ ┣ 📜grades_event.dart
 ┃ ┃ ┃ ┗ 📜grades_state.dart
 ┃ ┃ ┣ 📂lessons
 ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📜lessons_bloc.dart
 ┃ ┃ ┃ ┣ 📜lessons_event.dart
 ┃ ┃ ┃ ┗ 📜lessons_state.dart
 ┃ ┃ ┣ 📂notices
 ┃ ┃ ┃ ┣ 📂attachments
 ┃ ┃ ┃ ┃ ┣ 📜attachments_bloc.dart
 ┃ ┃ ┃ ┃ ┣ 📜attachments_event.dart
 ┃ ┃ ┃ ┃ ┣ 📜attachments_state.dart
 ┃ ┃ ┃ ┃ ┗ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📂attachment_download
 ┃ ┃ ┃ ┃ ┣ 📜attachment_download_bloc.dart
 ┃ ┃ ┃ ┃ ┣ 📜attachment_download_event.dart
 ┃ ┃ ┃ ┃ ┣ 📜attachment_download_state.dart
 ┃ ┃ ┃ ┃ ┗ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📜notices_bloc.dart
 ┃ ┃ ┃ ┣ 📜notices_event.dart
 ┃ ┃ ┃ ┗ 📜notices_state.dart
 ┃ ┃ ┣ 📂periods
 ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📜periods_bloc.dart
 ┃ ┃ ┃ ┣ 📜periods_event.dart
 ┃ ┃ ┃ ┗ 📜periods_state.dart
 ┃ ┃ ┗ 📂subjects
 ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┣ 📜subjects_bloc.dart
 ┃ ┃ ┃ ┣ 📜subjects_event.dart
 ┃ ┃ ┃ ┗ 📜subjects_state.dart
 ┃ ┣ 📂feature
 ┃ ┃ ┣ 📂absences
 ┃ ┃ ┃ ┣ 📂components
 ┃ ┃ ┃ ┃ ┣ 📜absences_chart_bars.dart
 ┃ ┃ ┃ ┃ ┣ 📜absences_chart_lines.dart
 ┃ ┃ ┃ ┃ ┗ 📜absence_card.dart
 ┃ ┃ ┃ ┗ 📜absences_page.dart
 ┃ ┃ ┣ 📂agenda
 ┃ ┃ ┃ ┗ 📜agenda_page.dart
 ┃ ┃ ┣ 📂grades
 ┃ ┃ ┃ ┣ 📂components
 ┃ ┃ ┃ ┃ ┣ 📜grades_chart.dart
 ┃ ┃ ┃ ┃ ┣ 📜grades_overall_stats.dart
 ┃ ┃ ┃ ┃ ┣ 📜grades_tab.dart
 ┃ ┃ ┃ ┃ ┗ 📜grade_subject_card.dart
 ┃ ┃ ┃ ┣ 📂subject_grades
 ┃ ┃ ┃ ┃ ┗ 📜subject_grades.dart
 ┃ ┃ ┃ ┗ 📜grades_page.dart
 ┃ ┃ ┣ 📂home
 ┃ ┃ ┃ ┣ 📂components
 ┃ ┃ ┃ ┃ ┣ 📜event_card.dart
 ┃ ┃ ┃ ┃ ┣ 📜lesson_card.dart
 ┃ ┃ ┃ ┃ ┗ 📜subjects_grid.dart
 ┃ ┃ ┃ ┗ 📜home_page.dart
 ┃ ┃ ┣ 📂lessons
 ┃ ┃ ┃ ┣ 📂components
 ┃ ┃ ┃ ┃ ┗ 📜subjects_list.dart
 ┃ ┃ ┃ ┣ 📜lessons_page.dart
 ┃ ┃ ┃ ┗ 📜lesson_details.dart
 ┃ ┃ ┣ 📂login
 ┃ ┃ ┃ ┗ 📜login_page.dart
 ┃ ┃ ┣ 📂noticeboard
 ┃ ┃ ┃ ┗ 📜noticeboard_page.dart
 ┃ ┃ ┣ 📂settings
 ┃ ┃ ┃ ┣ 📂components
 ┃ ┃ ┃ ┃ ┣ 📂customization
 ┃ ┃ ┃ ┃ ┃ ┗ 📜customization_settings.dart
 ┃ ┃ ┃ ┃ ┣ 📂general
 ┃ ┃ ┃ ┃ ┃ ┣ 📜general_averages_home_settings_dialog.dart
 ┃ ┃ ┃ ┃ ┃ ┣ 📜general_objective_settings_dialog.dart
 ┃ ┃ ┃ ┃ ┃ ┗ 📜general_settings.dart
 ┃ ┃ ┃ ┃ ┣ 📂notifications
 ┃ ┃ ┃ ┃ ┃ ┣ 📜notifications_interval_settings_dialog.dart
 ┃ ┃ ┃ ┃ ┃ ┗ 📜notifications_type_settings_dialog.dart
 ┃ ┃ ┃ ┃ ┗ 📜header_text.dart
 ┃ ┃ ┃ ┗ 📜settings_page.dart
 ┃ ┃ ┣ 📂splash_screen
 ┃ ┃ ┃ ┗ 📜splash_screen.dart
 ┃ ┃ ┣ 📂widgets
 ┃ ┃ ┃ ┣ 📜app_drawer.dart
 ┃ ┃ ┃ ┣ 📜cusotm_placeholder.dart
 ┃ ┃ ┃ ┣ 📜custom_app_bar.dart
 ┃ ┃ ┃ ┣ 📜grade_card.dart
 ┃ ┃ ┃ ┣ 📜grade_painter.dart
 ┃ ┃ ┃ ┗ 📜section_header.dart
 ┃ ┃ ┗ 📜pages.dart
 ┃ ┣ 📂global
 ┃ ┃ ┣ 📂localizations
 ┃ ┃ ┃ ┣ 📂bloc
 ┃ ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┃ ┣ 📜localizations_bloc.dart
 ┃ ┃ ┃ ┃ ┣ 📜localizations_event.dart
 ┃ ┃ ┃ ┃ ┗ 📜localizations_state.dart
 ┃ ┃ ┃ ┣ 📂ui
 ┃ ┃ ┃ ┃ ┗ 📜locale_bloc_builder.dart
 ┃ ┃ ┃ ┣ 📜app_localizations.dart
 ┃ ┃ ┃ ┗ 📜localizations_delegates.dart
 ┃ ┃ ┗ 📂theme
 ┃ ┃ ┃ ┣ 📂bloc
 ┃ ┃ ┃ ┃ ┣ 📜bloc.dart
 ┃ ┃ ┃ ┃ ┣ 📜theme_bloc.dart
 ┃ ┃ ┃ ┃ ┣ 📜theme_event.dart
 ┃ ┃ ┃ ┃ ┗ 📜theme_state.dart
 ┃ ┃ ┃ ┣ 📂theme_data
 ┃ ┃ ┃ ┃ ┣ 📜dark_theme.dart
 ┃ ┃ ┃ ┃ ┣ 📜default_theme.dart
 ┃ ┃ ┃ ┃ ┣ 📜light_theme.dart
 ┃ ┃ ┃ ┃ ┗ 📜text_styles.dart
 ┃ ┃ ┃ ┣ 📂ui
 ┃ ┃ ┃ ┃ ┣ 📜theme_bloc_builder.dart
 ┃ ┃ ┃ ┃ ┣ 📜theme_item.dart
 ┃ ┃ ┃ ┃ ┗ 📜theme_settings_page.dart
 ┃ ┃ ┃ ┗ 📜app_themes.dart
 ┃ ┗ 📜application.dart
 ┣ 📂utils
 ┃ ┣ 📂constants
 ┃ ┃ ┣ 📜drawer_constants.dart
 ┃ ┃ ┣ 📜preferences_constants.dart
 ┃ ┃ ┣ 📜registro_constants.dart
 ┃ ┃ ┣ 📜subjects_constants.dart
 ┃ ┃ ┗ 📜tabs_constants.dart
 ┃ ┣ 📂entity
 ┃ ┃ ┣ 📜datetime_interval.dart
 ┃ ┃ ┣ 📜overall_stats.dart
 ┃ ┃ ┗ 📜subject_averages.dart
 ┃ ┣ 📜color_utils.dart
 ┃ ┣ 📜date_utils.dart
 ┃ ┣ 📜global_utils.dart
 ┃ ┣ 📜grades_utils.dart
 ┃ ┣ 📜profile_utils.dart
 ┃ ┗ 📜string_utils.dart
 ┗ 📜main.dart
```

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
