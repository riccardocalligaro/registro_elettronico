import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeData materialThemeData;

  ThemeState({
    required this.materialThemeData,
  });

  @override
  List<Object> get props => [materialThemeData];
}
