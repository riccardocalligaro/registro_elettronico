<h1 align="center">
  <img src="https://i.imgur.com/BCktmzl.png" alt="Registto elettronico"><br>

<a href='https://play.google.com/store/apps/details?id=com.riccardocalligaro.registro_elettronico&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img height="100px" alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>

</h1>

Mobile application for electronic school register (Classeviva) that I developed during highschool from december of 2019 to january of 2021. The app is currently on the [Play Store](https://play.google.com/store/apps/details?id=com.riccardocalligaro.registro_elettronico) and has more than 20 000 downloads and 5 000 daily active users.

The app is currently in maintenance mode and I'm not adding new features, I'm just fixing major bugs and issues.

The code still uses flutter 1.22.6 (no null safety) and many libaries have been updated with breaking changes, so to build it you need to use a old version from 2021 with oudated pubs. Upgrading all the codebase (~35 000 lines) to null safety and the latest flutter version is a lot of work and currently I don't have time for it. If anybody wants to help me free to contact me.

## Run the project

To run the project you need to use flutter version `1.22.6`, I highly suggest to use [fvm](https://fvm.app/) so you can have multiple flutter versions installed on your machine and use the older version just for this project.

After installing fvm run `fvm install 1.22.6` and then `fvm use 1.22.6` to use it.

Then you can run `fvm flutter pub get` to install all the dependencies and you are ready to go.

Android builds fine but iOS doesn't because of a problem with some outdated google packages and the `Protobuf` library in Swift, I'm working on it.

## Contribute

Any help or contribution is highly appreciated, if you want to contribute to the project you can open a PR or contact me on [Telegram](https://t.me/R1CCARD0).

As I said before right now I don't have a lot of free time for other personal projects so the development of this app is currently on hold, but I'm still fixing major bugs and issues.

It would be ideal to have someone who takes lead in the rewrite of the app to null safety and the latest flutter version. I started some work on branch `3.0` but I didn't have time to finish it.

## Main features of the app

- ability to view entire school year statistics;
- ability to add custom events;
- multi-account
- always keep an eye on your school activity with the many graphs offered by the app;
- edit grades and notes to find out how your average varies with the "add/remove grade" feature;
- view the trend of your average and grades over time for each subject;
- share agenda events with whomever you want via any messaging app;
- easily navigate through the various sections of the app with its simple and intuitive interface;
- compare and share your Student Score with your friends and see who is the best!
- neatly check your classes held at school in the "Lessons" section
- check your absences and tardies
- stay informed about school circulars thanks to the "Bulletin Board" section
- customize your application by choosing the theme to use between light and dark;
- access teaching materials from wherever you are from the "Teaching Materials" section

## Technologies and libraries used

- 🔝 Flutter + Dart
- 📡 Dio for http
- 💡 BLoC for state management
- 📚 Moor for data persistency
- 💉 GetIt for dependency injection
- 🔗 Dartz for functional programming

## Project structure

<img src="https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?resize=556%2C707&ssl=1">
