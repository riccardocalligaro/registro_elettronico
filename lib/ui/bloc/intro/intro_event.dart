import 'package:meta/meta.dart';

@immutable
abstract class IntroEvent {}

class FetchAllData extends IntroEvent {}

class Reset extends IntroEvent {}