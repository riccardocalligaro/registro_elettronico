import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();
  @override
  List<Object> get props => [];
}

class LessonsIntial extends LessonsState {}

class LessonsLoadInProgress extends LessonsState {}

class LessonsLoadSuccess extends LessonsState {
  final List<Lesson> lessons;

  const LessonsLoadSuccess({
    @required this.lessons,
  });
}

// Updates

class LessonsUpdateLoadInProgress extends LessonsState {}

class LessonsUpdateLoadSuccess extends LessonsState {}

class LessonsLoadServerError extends LessonsState {
  final DioError serverError;
  const LessonsLoadServerError({@required this.serverError});

  @override
  List<Object> get props => [serverError];
}

class LessonsLoadError extends LessonsState {
  final String error;
  const LessonsLoadError({@required this.error});

  @override
  List<Object> get props => [error];
}
