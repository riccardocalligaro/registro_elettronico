import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';

class GradesFailure extends StatelessWidget {
  final Failure failure;

  const GradesFailure({
    Key key,
    @required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('failure $failure');
  }
}
