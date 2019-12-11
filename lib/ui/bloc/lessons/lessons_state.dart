import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/exception/server_exception.dart';

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
