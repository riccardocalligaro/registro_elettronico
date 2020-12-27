import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeData materialThemeData;
  final CupertinoThemeData cupertinoThemeData;

  ThemeState(
      {@required this.materialThemeData, @required this.cupertinoThemeData});

  @override
  List<Object> get props => [materialThemeData];
}
