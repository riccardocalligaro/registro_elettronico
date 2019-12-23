import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();

  @override
  List<Object> get props => [];
}

class LessonsNotLoaded extends LessonsState {}

class LessonsLoading extends LessonsState {}

class LessonsError extends LessonsState {
  final DioError error;

  LessonsError(this.error);
}

class LessonsLoaded extends LessonsState {}
