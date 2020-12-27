part of 'didactics_bloc.dart';

@immutable
abstract class DidacticsEvent {}

class UpdateDidactics extends DidacticsEvent {}

class GetDidactics extends DidacticsEvent {}
