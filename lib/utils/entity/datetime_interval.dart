import 'package:flutter/material.dart';

class DateTimeInterval {
  String begin;
  String end;

  DateTimeInterval({required this.begin, required this.end})
      : assert(begin != null && end != null);
}
