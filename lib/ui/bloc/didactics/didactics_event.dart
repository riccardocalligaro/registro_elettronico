import 'package:equatable/equatable.dart';

abstract class DidacticsEvent extends Equatable {
  const DidacticsEvent();

  @override
  List<Object> get props => [];
}

class UpdateDidactics extends DidacticsEvent {}

class GetDidactics extends DidacticsEvent {}
