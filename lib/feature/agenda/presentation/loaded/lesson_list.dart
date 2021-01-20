import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';

class LessonsList extends StatelessWidget {
  final List<LessonDomainModel> lessons;

  const LessonsList({
    Key key,
    @required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lessons == null || lessons.isEmpty) {
      return _EmptyList();
    }
    return Text(lessons.toString());
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: CustomPlaceHolder(
        icon: Icons.subject,
        text: 'Nessuna lezione',
        showUpdate: false,
      ),
    );
  }
}
