import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';

class SRFailureView extends StatelessWidget {
  final Failure failure;

  const SRFailureView({
    Key key,
    @required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPlaceHolder(
        icon: Icons.error,
        text: failure.localizedDescription(context),
        showUpdate: false,
      ),
    );
  }
}
