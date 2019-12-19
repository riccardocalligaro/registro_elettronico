import 'package:meta/meta.dart';

@immutable
abstract class SubjectsEvent {}

class FetchSubjects extends SubjectsEvent {}

class GetSubjects extends SubjectsEvent {}
