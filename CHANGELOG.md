Version 0.0.7-dev.3

Added notifications, settings, bug fixes, show more events

* Added option to change school year (for different credits)

* Added show more events button in home page

* Fixed paddings

* Added school material notifications

* Fixed credits system bug

--- 

Version 0.0.7-dev.2

Bug fixes, changed home screen graph, ui minor fixes

* Fixed paddings in some lists

* Added numbers in home screen chart

* Fixed #39, inusfficienti subjects count

* Added more colors to subjects - Close #38

* Fixed severe bug for notifications

* Added some translations

* Added string manipolation try catch security

* Chaned agenda card paddings

---
Version 0.0.7-dev.1

Main new features:

* New timetable view, a grid that you can personalize as you like

* Create personalized events

Minor features and bug fixes:

* Now you can still go to the home screen if you get errors during the vital data download

* SharedPreferences instances with dependency injection

* Added no internet message in intro

* Fixed wrong objective message

* Fixed edit time event and day in new event

* Search in school material

* Fixed documents last update

---

Version 0.0.6-dev.2

* Closed #30 - Implemented custom events 

* Changed icon color in light mode to gray


---

Version 0.0.6-dev.1

Bug fixes, minor changes

* Changed 'average' font size in grades chart

* Fixed navigation errror after going to intro from
intro

* Added chart to stats

* Fixed duplicate agenda events

🛑 Aggiornamenti:

L'applicazione al momento come funzioni fondamentali é praticamente finita, per ora é sono solo miglioramenti, devo settare l'account di google play developers e a breve (max 1/2 settimane) sará pubblicata in modalitá preview / internal testing sul play store.

Prossimo obiettivi: 

🔹 Supporto widget nativi in Android, a causa del framework flutter che usiamo questo richiederá del tempo

🔹 Statistiche, statistiche e tante statistiche

🔹 Nuova pagina orario 



Se avete altri suggerimenti scrivetemi pure! @R1CCARD0

---

Version 0.0.5-dev.1

Bug fixes, minor changes

New features:

* Added share option to stats page

Bug fixes:

* Fixed absences graph bugs

* Fixed circular indicator in absences

* Changed input field text

* Changes to notifications, now when a user installs the
application the refresh status is set to 360 minutes

* Removed all injection to static mappers

* Converted all mappers to static

* Fixed minor paddings in lists

* The absence graph now shows also ritardi (previously
only ritardi brevi)

* Added gravemente insufficienti subjects count to
score calculation

* Fixed 'FlutterError' is not of type 'Exception' for FLogs
 master

---

Version 0.0.4-dev.1

New features:

* Added #16 - Stats section where you can see useful stats about grades and school

* Added about dialog where you can see the link to the github repo and the website

Fixes:

* Fixed #26 - the touch tip data in the week summary graph was showing 'absences'

* Fixed ascending / descending order in grades page

* Changed absence card color

* Fixed update loop in lessons

Other:

* Partially changed the intro page, removed the notifications dialog (didnt work in smaller devices)





---

Version 0.0.3-dev.1

New features:

* New navigation system

* Added translations

* Changed text in home screen

Fixes:

* Fixed the bug where the login error was not shown

* Fixed intro bugs

* When a user closes the application during the intro process now it keeps asking to download the 'vital' data

* Fixed gray screen when user has no periods


---

Version 0.0.2-dev.1

New features:

* New login page design

* New intro

* App with no internet now gives proper messages and doesen't delete items in the databse

* Better translations

* Added a chart to the home page with the events summary

* Changed navigation system (will be changed again in the future)

Fixed:

* Fixed #24 - Notification notices duplicates

* Fixed #20 - Back button for going to home page

* Fixed #18 - First day events duoplicates

* Fixed #21 - App bugs when no internet

* Fixed #19 - Timetable overflow issue

* Fixed #9 - Login strange behavios

---

Version 0.0.1-dev.1+hotfix.1

New features:

* Close #20 - Implemented back button

Fixed:

* Fixed #18 - Duplicated events in agenda fixed

* Fixed #11 - Fixed infinite loop agenda

* Fixed #10 - Removed 'false' 'true' flag in grade dialog

* Fixed #13 - Missing agenda placeholder

* Fixed #17 - Agenda download issue fixed.
There was a '/' in the name (bad nikla)

* Fixed #14 - the school reports and documents text
were missing due to errors in the json file

* Fixed cards inner padding in the home page (it was
having strange behaviors with long texts)

* Temporary fix for timetable, apparently sometimes
there is an unknown subject id 🤨

---
Version 0.0.1-dev.2

New feature:
* You can exclude a grade from the average 
* Notices and final grades notifications

Stability and bug fixes:
* Improved logging, if you notice bugs please report it (just go to settings > report a bug
* Changed refresh indicator and fixed refreshing when there are not enough elements in a list
* Fixed lot minor issues and bugs

