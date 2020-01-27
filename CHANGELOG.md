Version 0.0.4-dev.1

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

