import 'package:equatable/equatable.dart';

abstract class GradesState extends Equatable {
  const GradesState();

  @override
  List<Object> get props => [];
}

class GradesInitial extends GradesState {}

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {}

class GradesError extends GradesState {
  final String message;

  GradesError(this.message);
}
